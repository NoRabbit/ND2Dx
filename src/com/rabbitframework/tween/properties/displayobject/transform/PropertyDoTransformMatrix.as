package com.rabbitframework.tween.properties.displayobject.transform 
{
	import flash.geom.Matrix;
	import com.rabbitframework.tween.RabbitTween;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2009.
	 */
	public class PropertyDoTransformMatrix extends PropertyDoTransformBase
	{
		public var matrix:Matrix;
		
		// if $startValue == null, then you should take the current property value
		public function PropertyDoTransformMatrix(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			// get current matrix
			matrix = displayObject.transform.matrix;
			
			// set default start values in case of...
			
			// set current start values in case of...
			RabbitTween.copyProperties(matrix, currentStartValue);
			
			super.init();
			
			
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