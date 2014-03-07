package com.rabbitframework.tween.properties.displayobject 
{
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDoAutoAlpha extends PropertyDoBase
	{
		
		public function PropertyDoAutoAlpha(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
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