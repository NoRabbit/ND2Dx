package com.rabbitframework.tween.properties 
{
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyBoolean extends PropertyBase
	{
		public var start:Boolean;
		public var end:Boolean;
		
		public function PropertyBoolean(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			// start
			var o:Object = startValue;
			var key:String;
			
			for (key in o) 
			{
				property = key;
				startValue = o[key];
				break;
			}
			
			// end
			o = endValue;
			
			for (key in o) 
			{
				property = key;
				endValue = o[key];
				break;
			}
			
			//trace("PropertyBoolean", property, startValue, endValue);
			
			if ( startValue == null ) startValue = target[property];
			if ( endValue == null ) endValue = startValue;
			
			start = startValue as Boolean;
			end = endValue as Boolean;
			
			target[property] = start;
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			if ( factor >= 1.0 )
			{
				//trace("PropertyBoolean setting", property, "of", target, "to", end);
				target[property] = end;
			}
		}
	}
	
}