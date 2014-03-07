package com.rabbitframework.tween.properties.displayobject 
{
	import flash.display.DisplayObject;
	import com.rabbitframework.tween.properties.PropertyBase;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDoBase extends PropertyBase
	{
		public var start:Number;
		public var change:Number;
		
		public var displayObject:DisplayObject;
		
		public function PropertyDoBase(target:Object, property:String, startValue:Object, endValue:Object) 
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
			
			displayObject = target as DisplayObject;
			
			start = startValue as Number;
			change = Number(endValue) - start;
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			
		}
	}
	
}