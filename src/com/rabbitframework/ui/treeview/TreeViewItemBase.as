package com.rabbitframework.ui.treeview 
{
	import com.rabbitframework.ui.layout.UIHorizontalLayout;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TreeViewItemBase extends UIContainer
	{
		public var treeView:TreeView;
		
		public var bg:Sprite;
		
		private var _selected:Boolean = false;
		private var _preSelected:Boolean = false;
		
		public var dataSourceIndex:int = -1;
		public var dataSourceParent:Object = null;
		
		public function TreeViewItemBase() 
		{
			bg.mouseEnabled = bg.buttonMode = bg.useHandCursor = true;
		}
		
		override public function init():void 
		{
			_layout = UIHorizontalLayout.reference;
			
			_itemSpace = 2.0;
			_selected = false;
			_preSelected = false;
			_horizontalAlign = UIBase.HORIZONTAL_ALIGN_CENTER;
			_verticalAlign = UIBase.VERTICAL_ALIGN_MIDDLE;
			
			dataSourceIndex = -1;
			dataSourceParent = null;
			
			eManager.add(bg, MouseEvent.MOUSE_DOWN, bg_mouseDownHandler, eGroup);
			eManager.add(bg, MouseEvent.MOUSE_UP, bg_mouseUpHandler, eGroup);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			_dataSource = null;
			_selected = false;
			_preSelected = false;
			dataSourceIndex = -1;
			dataSourceParent = null;
			treeView = null;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			_dataSource = null;
			_selected = false;
			_preSelected = false;
			dataSourceIndex = -1;
			dataSourceParent = null;
			treeView = null;
		}
		
		private function bg_mouseDownHandler(e:MouseEvent):void 
		{
			treeView.setPreSelectedDataSource(_dataSource, dataSourceIndex, dataSourceParent);
		}
		
		private function bg_mouseUpHandler(e:MouseEvent):void 
		{
			if ( dataSource && treeView.preSelectedDataSource == dataSource )
			{
				treeView.setPreSelectedDataSource(null);
				var ds:Object = dataSource;
				treeView.setSelectedDataSource(dataSource, dataSourceIndex, dataSourceParent);
				treeView.onSelect.dispatchData(ds);
			}
			else
			{
				treeView.setPreSelectedDataSource(null);
			}
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = uiHeight;
			super.draw();
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			
			if ( _selected )
			{
				bg.alpha = 1.0;
			}
			else
			{
				bg.alpha = 0.0;
			}
		}
		
		public function get preSelected():Boolean 
		{
			return _preSelected;
		}
		
		public function set preSelected(value:Boolean):void 
		{
			_preSelected = value;
			
			if ( _preSelected )
			{
				bg.alpha = 0.5;
			}
			else
			{
				bg.alpha = 0.0;
			}
		}
		
		override public function get dataSource():Object 
		{
			return _dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			_dataSource = value;
		}
	}

}