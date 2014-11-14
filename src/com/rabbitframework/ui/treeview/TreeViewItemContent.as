package com.rabbitframework.ui.treeview 
{
	import com.rabbitframework.ui.dataprovider.DataProviderBase;
	import com.rabbitframework.ui.states.DataSourceState;
	import com.rabbitframework.ui.UIBase;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TreeViewItemContent extends UIBase
	{
		public var treeView:TreeView;
		
		public var arrow:Sprite;
		public var icon:Sprite;
		public var txt:TextField;
		
		private var bmp:Bitmap;
		
		public function TreeViewItemContent() 
		{
			mouseEnabled = false;
			txt.mouseEnabled = false;
			icon.mouseEnabled = false;
			
			arrow.mouseEnabled = arrow.buttonMode = arrow.useHandCursor = true;
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
			
			var dataProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(_dataSource);
			
			if ( !dataProvider ) return;
			
			var currentX:Number = 0.0;
			
			if ( treeView.showTree && dataProvider.getNumChildren(_dataSource) > 0 )
			{
				currentX += 8.0;
				arrow.visible = true;
				arrow.x = currentX;
				currentX += 12.0;
				
				var dataSourceState:DataSourceState = treeView.dataSourceStateHolder.getState(_dataSource);
				
				if ( dataSourceState && dataSourceState.state == DataSourceState.STATE_OPEN )
				{
					arrow.rotation = 90;
				}
				else
				{
					arrow.rotation = 0;
				}
			}
			else
			{
				arrow.visible = false;
			}
			
			var iconBmpData:BitmapData = dataProvider.getIcon(_dataSource);
			
			if ( iconBmpData )
			{
				if ( !bmp )
				{
					bmp = new Bitmap();
					icon.addChild(bmp);
					bmp.x = -8.0;
					bmp.y = -8.0;
				}
				
				bmp.bitmapData = iconBmpData;
				bmp.width = 16.0;
				bmp.height = 16.0;
				bmp.smoothing = true;
				
				icon.visible = true;
				icon.cacheAsBitmap = true;
				
				currentX += 8.0;
				icon.x = currentX;
				currentX += 12.0;
			}
			else
			{
				icon.visible = false;
			}
			
			txt.x = currentX;
			txt.text = dataProvider.getLabel(_dataSource);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			arrow = null;
			txt = null;
		}
	}

}