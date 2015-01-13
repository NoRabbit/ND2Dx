package com.rabbitframework.ui.combobox 
{
	import com.rabbitframework.managers.pool.PoolManager;
	import com.rabbitframework.signals.Signal;
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
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ComboBox extends ButtonContainer
	{
		public var treeView:TreeView;
		
		private var _isOpen:Boolean;
		private var _selectedDataSource:Object;
		
		public var onSelect:Signal = new Signal();
		
		public var icon:Icon = new Icon();
		public var label:Label = new Label();
		public var arrow:Icon = new Icon();
		
		public function ComboBox() 
		{
			arrow.dataSource = BitmapDataUtils.getBitmapDataFromClassName("ArrowDown");
			arrow.setSize(16, 16);
		}
		
		override public function init():void 
		{
			super.init();
			
			minUIWidth = 50.0;
			minUIHeight = 20.0;
			
			uiHeight = 20.0;
			
			_paddingBottom = 2.0;
			_paddingLeft = 8.0;
			_paddingRight = 8.0;
			_paddingTop = 2.0;
			_itemSpace = 4.0;
			
			_horizontalAlign = UIBase.HORIZONTAL_ALIGN_CENTER;
			_verticalAlign = UIBase.VERTICAL_ALIGN_MIDDLE;
			
			draw();
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
			removeItem(icon, false);
			removeItem(label, false);
			removeItem(arrow, false);
			
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
		
		public function get selectedDataSource():Object 
		{
			return _selectedDataSource;
		}
		
		public function set selectedDataSource(value:Object):void 
		{
			if ( _selectedDataSource == value ) return;
			
			_selectedDataSource = value;
			
			removeAllItems(false);
			
			if ( !_selectedDataSource ) return;
			
			var dataProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(_selectedDataSource);
			
			if ( dataProvider )
			{
				var iconBmpData:BitmapData = dataProvider.getIcon(_selectedDataSource);
				
				if ( iconBmpData )
				{
					addItem(icon, false);
					icon.dataSource = iconBmpData;
					icon.setSize(16, 16);
				}
				
				addItem(label, false);
				label.dataSource = _selectedDataSource;
				label.setSize("100%");
				
				addItem(arrow, false);
			}
			
			draw();
			
			onSelect.dispatchData(value);
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