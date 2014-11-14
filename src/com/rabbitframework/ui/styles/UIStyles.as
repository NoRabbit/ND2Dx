package com.rabbitframework.ui.styles 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.BevelFilter;
	import flash.filters.BitmapFilterType;
	import flash.filters.DropShadowFilter;
	import flash.geom.ColorTransform;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIStyles 
	{
		public static var colorTransform:ColorTransform = new ColorTransform();
		public static var dBitmapDataForClassName:Dictionary = new Dictionary();
		
		public static function setDoubleBevelEffect(displayObject:DisplayObject):void
		{
			var filters:Array = [];
			filters.push(new BevelFilter(1, 90, 0x000000, 0.35, 0x000000, 0.5, 1, 1, 1, 1, BitmapFilterType.INNER, false));
			filters.push(new BevelFilter(2, 270, 0xffffff, 0.27, 0x000000, 0.36, 3, 3, 1, 1, BitmapFilterType.OUTER, false));
			displayObject.filters = filters;
		}
		
		public static function getSelectHighlightColorTransform():ColorTransform
		{
			colorTransform.blueMultiplier = 1.25;
			colorTransform.greenMultiplier = 1.25;
			return colorTransform;
		}
		
		public static function getHighlightColorTransform():ColorTransform
		{
			colorTransform.blueMultiplier = 1.65;
			colorTransform.greenMultiplier = 1.65;
			return colorTransform;
		}
		
		public static function getIdentityColorTransform():ColorTransform
		{
			colorTransform.alphaMultiplier = colorTransform.redMultiplier = colorTransform.blueMultiplier = colorTransform.greenMultiplier = 1.0;
			colorTransform.alphaOffset = colorTransform.redOffset = colorTransform.blueOffset = colorTransform.greenOffset = 0.0;
			return colorTransform;
		}
		
		public static function setPanelDropShadowFilter(displayObject:DisplayObject):void
		{
			var filters:Array = [];
			filters.push(new DropShadowFilter(0, 0, 0x000000, 0.5, 16, 16, 1, 3));
			displayObject.filters = filters;
		}
		
		public static function setButtonMenuDropShadowFilter(displayObject:DisplayObject):void
		{
			var filters:Array = [];
			filters.push(new DropShadowFilter(0, 0, 0x000000, 0.75, 24, 24, 1, 3));
			displayObject.filters = filters;
		}
		
		public static function getBitmapDataForClassName(className:String):BitmapData
		{
			var bmpData:BitmapData = dBitmapDataForClassName[className] as BitmapData;
			
			if ( !bmpData )
			{
				var classObject:Class = getDefinitionByName(className) as Class;
				bmpData = new classObject(0, 0);
				dBitmapDataForClassName[className] = bmpData;
			}
			
			return bmpData;
		}
	}

}