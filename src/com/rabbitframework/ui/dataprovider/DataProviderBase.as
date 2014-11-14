package com.rabbitframework.ui.dataprovider 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DataProviderBase 
	{
		public function DataProviderBase() 
		{
			
		}
		
		public function getLabel(dataSource:Object):String
		{
			return "";
		}
		
		public function getIcon(dataSource:Object):BitmapData
		{
			return null;
		}
		
		public function getItemAt(dataSource:Object, index:uint):*
		{
			return null;
		}
		
		public function getItemIndex(dataSource:Object, dataSourceToFind:Object):int
		{
			return -1;
		}
		
		public function addItem(dataSource:Object, dataSourceToAdd:Object):void
		{
			
		}
		
		public function addItemAt(dataSource:Object, dataSourceToAdd:Object, index:int):void
		{
			
		}
		
		public function removeItem(dataSource:Object, dataSourceToRemove:Object):void
		{
			
		}
		
		public function removeItemAt(dataSource:Object, index:int):void
		{
			
		}
		
		public function getNumChildren(dataSource:Object):uint
		{
			return 0;
		}
		
		public function canContainChildren(dataSource:Object):Boolean
		{
			return false;
		}
		
		public function getParent(dataSource:Object):Object
		{
			return null;
		}
	}

}