package com.rabbitframework.ui.button 
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
	public class ButtonMenu extends ButtonContainer
	{
		public var treeView:TreeView;
		
		private var _isOpen:Boolean;
		
		public var onSelect:Signal = new Signal();
		
		public function ButtonMenu() 
		{
			
		}
		
		override public function init():void 
		{
			super.init();
			
			minUIWidth = 50.0;
			minUIHeight = 20.0;
			
			uiHeight = 20.0;
			
			_paddingTop = 2.0;
			_paddingBottom = 2.0;
			_paddingLeft = 8.0;
			_paddingRight = 8.0;
			
			_horizontalAlign = UIBase.HORIZONTAL_ALIGN_CENTER;
			_verticalAlign = UIBase.VERTICAL_ALIGN_MIDDLE;
			
			_itemSpace = 4.0;
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
			
			if ( treeView )
			{
				treeView.filters = [];
				poolManager.releaseObject(treeView);
				treeView = null;
			}
			
			
			onSelect.removeAll();
			dataSource = null;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			if ( treeView )
			{
				treeView.filters = [];
				poolManager.releaseObject(treeView);
				treeView = null;
			}
			
			onSelect.removeAll();
			dataSource = null;
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
				
				treeView.setSize(uiWidth, 132);
				
				treeView.dataSource = _dataSource;
				
				treeView.onSelect.add(treeView_onSelectHandler);
				
				UIStyles.setButtonMenuDropShadowFilter(treeView);
				
				eManager.add(stage, MouseEvent.MOUSE_DOWN, stage_mouseDownHandlerForOpening, [eGroup, eGroup + ".stageForOpening"]);
			}
			else
			{
				eManager.removeAllFromGroup(eGroup + ".stageForOpening");
				
				bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
				
				if ( treeView )
				{
					treeView.filters = [];
					poolManager.releaseObject(treeView);
					treeView = null;
				}
				
			}
		}
		
		private function treeView_onSelectHandler(dataSource:Object):void 
		{
			isOpen = false;
			onSelect.dispatchData(dataSource);
		}
		
		private function stage_mouseDownHandlerForOpening(e:MouseEvent):void 
		{
			if ( DisplayObjectUtils.isChildOf(e.target as DisplayObject, this) == false && DisplayObjectUtils.isChildOf(e.target as DisplayObject, treeView) == false ) isOpen = false;
		}
	}

}