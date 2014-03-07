package com.rabbitframework.tween.properties.displayobject 
{
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDoWidth extends PropertyDoBase
	{
		
		public function PropertyDoWidth(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			displayObject.width = start + change * factor;
		}
	}
	
}