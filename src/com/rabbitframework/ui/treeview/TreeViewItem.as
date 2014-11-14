package com.rabbitframework.ui.treeview 
{
	import adobe.utils.CustomActions;
	import com.rabbitframework.ui.button.Button;
	import com.rabbitframework.ui.dataprovider.DataProviderBase;
	import com.rabbitframework.ui.dataprovider.DataProviderManager;
	import com.rabbitframework.ui.groups.Group;
	import com.rabbitframework.ui.icon.Icon;
	import com.rabbitframework.ui.label.Label;
	import com.rabbitframework.ui.states.DataSourceState;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.UIBase;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TreeViewItem extends Group
	{
		public var treeView:TreeView;
		
		public var bgSelected:Sprite;
		public var arrow:Icon = new Icon();
		public var deleteIcon:Icon = new Icon();
		public var icon:Icon = new Icon();
		public var label:Label = new Label();
		
		private var _selected:Boolean = false;
		private var _preSelected:Boolean = false;
		
		public var dataSourceIndex:int = -1;
		public var dataSourceParent:Object = null;
		
		public function TreeViewItem() 
		{
			selected = false;
			
			_isHorizontal = true;
			_spaceSize = 2.0;
			
			bgSelected.mouseEnabled = bgSelected.buttonMode = bgSelected.useHandCursor = true;
			arrow.mouseEnabled = arrow.buttonMode = arrow.useHandCursor = true;
			deleteIcon.mouseEnabled = deleteIcon.buttonMode = deleteIcon.useHandCursor = true;
			icon.mouseEnabled = icon.mouseChildren = false;
			label.mouseEnabled = label.mouseChildren = false;
			
			arrow.setSize(16, 16);
			deleteIcon.dataSource = UIStyles.getBitmapDataForClassName("bullet_delete.png");
			deleteIcon.setSize(16, 16);
			icon.setSize(16, 16);
		}
		
		override public function init():void 
		{
			selected = false;
			preSelected = false;
			dataSourceIndex = -1;
			dataSourceParent = null;
			eManager.add(arrow, MouseEvent.MOUSE_DOWN, arrow_mouseDownHandler, eGroup);
			eManager.add(deleteIcon, MouseEvent.CLICK, deleteIcon_clickHandler, eGroup);
			eManager.add(bgSelected, MouseEvent.MOUSE_DOWN, bgSelected_mouseDownHandler, eGroup);
			eManager.add(bgSelected, MouseEvent.MOUSE_UP, bgSelected_mouseUpHandler, eGroup);
		}
		
		private function deleteIcon_clickHandler(e:MouseEvent):void 
		{
			if ( !dataSourceParent || dataSourceIndex < 0 ) return;
			var dataSourceParentProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(dataSourceParent);
			dataSourceParentProvider.removeItemAt(dataSourceParent, dataSourceIndex);
			treeView.draw();
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			_dataSource = null;
			treeView = null;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			_dataSource = null;
			treeView = null;
			bgSelected = null;
			arrow.dispose();
			icon.dispose();
			label.dispose();
		}
		
		private function arrow_mouseDownHandler(e:String):void 
		{
			var dataSourceState:DataSourceState = treeView.dataSourceStateHolder.getState(_dataSource);
			
			if ( !dataSourceState )
			{
				treeView.dataSourceStateHolder.setState(_dataSource, DataSourceState.STATE_OPEN);
			}
			else
			{
				treeView.dataSourceStateHolder.removeState(_dataSource);
			}
			
			treeView.drawItems();
		}
		
		private function bgSelected_mouseDownHandler(e:MouseEvent):void 
		{
			treeView.setPreSelectedDataSource(_dataSource, dataSourceIndex, dataSourceParent);
		}
		
		private function bgSelected_mouseUpHandler(e:MouseEvent):void 
		{
			if ( dataSource && treeView.preSelectedDataSource == dataSource )
			{
				treeView.setPreSelectedDataSource(null);
				var ds:Object = dataSource;
				treeView.setSelectedDataSource(dataSource, dataSourceIndex, dataSourceParent);
				treeView.onSelect.dispatch(ds);
			}
			else
			{
				treeView.setPreSelectedDataSource(null);
			}
		}
		
		override public function draw():void 
		{
			bgSelected.width = uiWidth;
			bgSelected.height = uiHeight;
			positionContent();
			super.draw();
			
			uiWidth = bgSelected.width;
			uiHeight = bgSelected.height;
		}
		
		public function positionContent():void
		{
			removeAllItems(false);
			
			if ( !_dataSource )
			{
				return;
			}
			
			var dataProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(_dataSource);
			
			if ( treeView.showTree && dataProvider.getNumChildren(_dataSource) > 0 )
			{
				addItem(arrow, false);
				
				var dataSourceState:DataSourceState = treeView.dataSourceStateHolder.getState(_dataSource);
				
				if ( dataSourceState && dataSourceState.state == DataSourceState.STATE_OPEN )
				{
					arrow.dataSource = UIStyles.getBitmapDataForClassName("bullet_toggle_minus.png");
				}
				else
				{
					arrow.dataSource = UIStyles.getBitmapDataForClassName("bullet_toggle_plus.png");
				}
			}
			
			if ( treeView.allowDeleteItem )
			{
				addItem(deleteIcon, false);
			}
			
			var iconBmpData:BitmapData = dataProvider.getIcon(_dataSource);
			
			if ( iconBmpData )
			{
				addItem(icon, false);
				icon.dataSource = iconBmpData;
			}
			
			addItem(label, false);
			label.dataSource = dataProvider.getLabel(_dataSource);
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
				bgSelected.alpha = 1.0;
			}
			else
			{
				bgSelected.alpha = 0.0;
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
				bgSelected.alpha = 0.5;
			}
			else
			{
				bgSelected.alpha = 0.0;
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