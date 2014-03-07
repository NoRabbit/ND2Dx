package com.rabbitframework.tween.properties.displayobject.transform
{
	import flash.display.DisplayObject;
	import com.rabbitframework.tween.RabbitTween;
	import com.rabbitframework.tween.RabbitTweenMax;
	import com.rabbitframework.tween.properties.PropertyBase;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDoTransformBase extends PropertyBase
	{
		public var currentStartValue:Object = {};
		public var defaultStartValue:Object = {};
		public var defaultEndValue:Object = {};
		
		public var displayObject:DisplayObject;
		
		//protected var transformProperties:Array = ["alpha", "angle", "blurX", "blurY", "color", "distance", "hideObject", "inner", "knockout", "quality", "strength", "highlightAlpha", "highlightColor", "shadowAlpha", "shadowColor", "type", "matrix", "bias", "clamp", "divisor", "matrixX", "matrixY", "preserveAlpha", "componentX", "componentY", "mapBitmap", "mapPoint", "mode", "scaleX", "scaleY", "alphas", "colors", "ratios"];
		
		// if $startValue == null, then you should take the current property value
		public function PropertyDoTransformBase(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
			
			displayObject = target as DisplayObject;
		}
		
		// PUBLIC FUNCTIONS
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			// start value ?
			if ( startValue == null )
			{
				// no, create one
				startValue = { };
				
				RabbitTween.copyProperties(currentStartValue, startValue);
				RabbitTween.copyProperties(defaultStartValue, startValue, true);
			}
			
			// set default values to unspecified properties
			RabbitTween.copyProperties(defaultStartValue, startValue, false);
			RabbitTween.copyProperties(defaultEndValue, endValue, false);
			
			// copy unspecified values of start to end and vice versa
			RabbitTween.copyProperties(startValue, endValue, false);
			RabbitTween.copyProperties(endValue, startValue, false);
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			
		}
		
		/**
		 * Remove property
		 */
		override public function removeProperty():void
		{
			
		}
		
	}
	
}