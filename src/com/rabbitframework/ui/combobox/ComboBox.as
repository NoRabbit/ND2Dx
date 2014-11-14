package com.rabbitframework.ui.combobox 
{
	import com.rabbitframework.managers.pool.PoolManager;
	import com.rabbitframework.ui.button.ButtonContainer;
	import com.rabbitframework.ui.dataprovider.DataProviderBase;
	import com.rabbitframework.ui.icon.Icon;
	import com.rabbitframework.ui.label.Label;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.treeview.TreeView;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.utils.BitmapDataUtils;
	import com.rabbitframework.utils.DisplayObjectUtils;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ComboBox extends ButtonContainer
	{
		public var poolManager:PoolManager = PoolManager.getInstance();
		public var treeView:TreeView;
		
		private var _isOpen:Boolean;
		private var _selectedDataSource:Object;
		
		public var onSelect:Signal = new Signal(Object);
		
		public function ComboBox() 
		{
			minUIWidth = 50.0;
			minUIHeight = 20.0;
		}
		
		override public function init():void 
		{
			super.init();
			
			drawItems();
		}
		
		override protected function onMouseDownHandler(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			if ( _isOpen )
			{
				isOpen = false;
			}
			else
			{
				isOpen = true;
			}
		}
		
		override protected function onMouseUpHandler(e:MouseEvent):void 
		{
			
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			
			if ( treeView ) poolManager.releaseObject(treeView);
			treeView = null;
			
			onSelect.removeAll();
			selectedDataSource = null;
			dataSource = null;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			if ( treeView ) poolManager.releaseObject(treeView);
			treeView = null;
			
			onSelect.removeAll();
			selectedDataSource = null;
			dataSource = null;
		}
		
		override public function draw():void 
		{
			super.draw();
		}
		
		public function drawItems():void
		{
			while ( vItems.length > 0 )
			{
				poolManager.releaseObject(removeItemAt(0, false));
			}
			
			if ( _selectedDataSource )
			{
				var dataProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(_selectedDataSource);
				
				if ( dataProvider )
				{
					var iconBmpData:BitmapData = dataProvider.getIcon(_selectedDataSource);
					
					if ( iconBmpData )
					{
						var icon:Icon = poolManager.getObject(Icon) as Icon;
						addItem(icon, false);
						icon.dataSource = iconBmpData;
						icon.setSize(16, 16);
					}
					
					var label:Label = poolManager.getObject(Label) as Label;
					addItem(label, false);
					label.dataSource = _selectedDataSource;
					label.setSize("100%");
					
					var arrow:Icon = poolManager.getObject(Icon) as Icon;
					addItem(arrow, false);
					arrow.dataSource = BitmapDataUtils.getBitmapDataFromClassName("ArrowDown");
					arrow.setSize(16, 16);
				}
			}
			
			draw();
		}
		
		public function get selectedDataSource():Object 
		{
			return _selectedDataSource;
		}
		
		public function set selectedDataSource(value:Object):void 
		{
			_selectedDataSource = value;
			
			drawItems();
			
			onSelect.dispatch(value);
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
		}
		
		public function get isOpen():Boolean 
		{
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void 
		{
			if ( _isOpen == value ) return;
			
			_isOpen = value;
			
			if ( _isOpen )
			{
				bg.getChildAt(0).transform.colorTransform = UIStyles.getHighlightColorTransform();
				
				var p:Point = new Point(0, uiHeight + 4.0);
				p = localToGlobal(p);
				
				treeView = poolManager.getObject(TreeView) as TreeView;
				stage.addChild(treeView);
				
				treeView.x = p.x;
				treeView.y = p.y;
				treeView.visible = true;
				treeView.isEditable = false;
				treeView.isItemDraggable = false;
				
				treeView.setSize(uiWidth, 200);
				
				//trace(uiWidth, uiWidthPrct);
				
				treeView.dataSource = _dataSource;
				
				if ( _selectedDataSource ) treeView.setSelectedDataSource(_selectedDataSource);
				
				treeView.onSelect.add(treeView_onSelectHandler);
				
				eManager.add(stage, MouseEvent.MOUSE_DOWN, stage_mouseDownHandlerForOpening, [eGroup, eGroup + ".stageForOpening"]);
			}
			else
			{
				eManager.removeAllFromGroup(eGroup + ".stageForOpening");
				
				bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
				
				if ( treeView )
				{
					poolManager.releaseObject(treeView);
					treeView = null;
				}
				
			}
		}
		
		private function treeView_onSelectHandler(dataSource:Object):void 
		{
			selectedDataSource = dataSource;
			isOpen = false;
		}
		
		private function stage_mouseDownHandlerForOpening(e:MouseEvent):void 
		{
			if ( DisplayObjectUtils.isChildOf(e.target as DisplayObject, this) == false && DisplayObjectUtils.isChildOf(e.target as DisplayObject, treeView) == false ) isOpen = false;
		}
	}

}