package com.rabbitframework.tween.properties 
{
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyNumber extends PropertyBase
	{
		public var start:Number;
		public var change:Number;
		
		public function PropertyNumber(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			if ( startValue == null ) startValue = target[property];
			if ( endValue == null ) endValue = startValue;
			
			start = startValue as Number;
			change = Number(endValue) - start;
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			target[property] = start + change * factor;
		}
	}
	
}