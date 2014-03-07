package com.rabbitframework.tween.properties.specials 
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import com.rabbitframework.tween.properties.PropertyBase;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyHexColor extends PropertyBase
	{
		public var startColor:uint;
		public var endColor:uint;
		
		public var startRed:Number;
		public var startGreen:Number;
		public var startBlue:Number;
		public var changeRed:Number;
		public var changeGreen:Number;
		public var changeBlue:Number;
		
		public function PropertyHexColor(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			if ( startValue is Number )
			{
				startColor = uint(startValue);
			}
			else
			{
				startColor = 0x000000;
			}
			
			endColor = uint(endValue);
			
			startRed = startColor >> 16;
			startGreen = (startColor >> 8) & 0xff;
			startBlue = startColor & 0xff;
			
			changeRed = (endColor >> 16) - startRed;
			changeGreen = ((endColor >> 8) & 0xff) - startGreen;
			changeBlue = (endColor & 0xff) - startBlue;
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			target[property] = ((startRed + (factor * changeRed)) << 16 | (startGreen + (factor * changeGreen)) << 8 | (startBlue + (factor * changeBlue)));
		}
		
	}
	
}