package com.rabbitframework.tween.properties.displayobject 
{
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDoY extends PropertyDoBase
	{
		
		public function PropertyDoY(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			displayObject.y = start + change * factor;
		}
	}
	
}