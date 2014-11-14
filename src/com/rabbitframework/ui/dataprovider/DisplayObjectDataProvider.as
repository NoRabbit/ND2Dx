package com.rabbitframework.ui.dataprovider 
{
	import com.rabbitframework.ui.styles.UIStyles;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DisplayObjectDataProvider extends DataProviderBase
	{
		
		public function DisplayObjectDataProvider() 
		{
			
		}
		
		override public function getLabel(dataSource:Object):String 
		{
			var displayObject:DisplayObject = dataSource as DisplayObject;
			
			if ( displayObject )
			{
				return displayObject.name;
			}
			
			return "";
		}
		
		override public function getIcon(dataSource:Object):BitmapData 
		{
			return UIStyles.getBitmapDataForClassName("FileIconBmp");
		}
		
		override public function getItemAt(dataSource:Object, index:uint):* 
		{
			return null;
		}
		
		override public function getItemIndex(dataSource:Object, dataSourceToFind:Object):int 
		{
			return -1;
		}
		
		override public function addItem(dataSource:Object, dataSourceToAdd:Object):void 
		{
			
		}
		
		override public function addItemAt(dataSource:Object, dataSourceToAdd:Object, index:int):void 
		{
			
		}
		
		override public function removeItem(dataSource:Object, dataSourceToRemove:Object):void 
		{
			
		}
		
		override public function getNumChildren(dataSource:Object):uint 
		{
			return 0;
		}
	}

}