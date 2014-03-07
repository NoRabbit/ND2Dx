package com.rabbitframework.tween.properties.displayobject 
{
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDoRotation extends PropertyDoBase
	{
		
		public function PropertyDoRotation(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			displayObject.rotation = start + change * factor;
		}
	}
	
}