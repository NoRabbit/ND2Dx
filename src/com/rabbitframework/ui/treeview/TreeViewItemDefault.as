package com.rabbitframework.ui.treeview 
{
	import com.rabbitframework.ui.dataprovider.DataProviderBase;
	import com.rabbitframework.ui.icon.Icon;
	import com.rabbitframework.ui.label.Label;
	import com.rabbitframework.ui.states.DataSourceState;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.UIBase;
	import flash.display.BitmapData;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TreeViewItemDefault extends TreeViewItemBase
	{
		public var arrow:Icon = new Icon();
		public var deleteIcon:Icon = new Icon();
		public var icon:Icon = new Icon();
		public var label:Label = new Label();
		
		public function TreeViewItemDefault() 
		{
			arrow.mouseEnabled = arrow.buttonMode = arrow.useHandCursor = true;
			deleteIcon.mouseEnabled = deleteIcon.buttonMode = deleteIcon.useHandCursor = true;
			icon.mouseEnabled = icon.mouseChildren = false;
			label.mouseEnabled = label.mouseChildren = false;
			
			arrow.setSize(16, 16);
			deleteIcon.dataSource = UIStyles.getBitmapDataForClassName("bullet_delete.png");
			deleteIcon.setSize(16, 16);
			icon.setSize(16, 16);
			label.setSize("100%", "100%");
		}
		
		override public function init():void 
		{
			super.init();
			eManager.add(arrow, MouseEvent.MOUSE_DOWN, arrow_mouseDownHandler, eGroup);
			eManager.add(deleteIcon, MouseEvent.CLICK, deleteIcon_clickHandler, eGroup);
		}
		
		override public function disposeForPool():void 
		{
			removeItem(arrow, false);
			removeItem(deleteIcon, false);
			removeItem(icon, false);
			removeItem(label, false);
			
			super.disposeForPool();
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
		
		private function deleteIcon_clickHandler(e:MouseEvent):void 
		{
			if ( !dataSourceParent || dataSourceIndex < 0 ) return;
			var dataSourceParentProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(dataSourceParent);
			dataSourceParentProvider.removeItemAt(dataSourceParent, dataSourceIndex);
			treeView.draw();
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
			
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
	}

}