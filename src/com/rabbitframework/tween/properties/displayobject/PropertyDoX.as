package com.rabbitframework.tween.properties.displayobject 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDoX extends PropertyDoBase
	{
		
		public function PropertyDoX(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			displayObject.x = start + change * factor;
		}
	}
	
}