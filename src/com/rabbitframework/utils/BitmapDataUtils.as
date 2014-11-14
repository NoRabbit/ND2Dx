package com.rabbitframework.utils 
{
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapDataUtils 
	{
		public static var dBitmapDataForClassName:Dictionary = new Dictionary();
		
		public static function getBitmapDataFromClassName(className:String):BitmapData
		{
			var bitmapData:BitmapData = dBitmapDataForClassName[className] as BitmapData;
			
			if ( !bitmapData )
			{
				var classObject:Class = getDefinitionByName(className) as Class;
				bitmapData = new classObject() as BitmapData;
				dBitmapDataForClassName[className] = bitmapData;
			}
			
			return bitmapData;
		}
	}

}