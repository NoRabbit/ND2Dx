package com.rabbitframework.ui.dataprovider 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapDataProvider extends DataProviderBase
	{
		
		public function BitmapDataProvider() 
		{
			
		}
		
		override public function getLabel(dataSource:Object):String 
		{
			return dataSource as String;
		}
		
		override public function getIcon(dataSource:Object):BitmapData 
		{
			if ( dataSource is BitmapData ) return dataSource as BitmapData;
			
			return null;
		}
	}

}