package com.rabbitframework.tween.properties.specials 
{
	import flash.display.DisplayObject;
	import com.rabbitframework.tween.properties.PropertyBase;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyAutoAlpha extends PropertyBase
	{
		public var start:Number;
		public var change:Number;
		
		public function PropertyAutoAlpha(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			if ( startValue == null ) startValue = target["alpha"];
			if ( endValue == null ) endValue = startValue;
			
			start = startValue as Number;
			change = Number(endValue) - start;
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			var displayObject:DisplayObject = target as DisplayObject;
			
			displayObject.alpha = start + change * factor;
			
			if ( displayObject.alpha <= 0.0 && displayObject.visible)
			{
				displayObject.visible = false;
			}
			else if ( displayObject.alpha > 0.0 && !displayObject.visible )
			{
				displayObject.visible = true;
			}
		}
	}
	
}