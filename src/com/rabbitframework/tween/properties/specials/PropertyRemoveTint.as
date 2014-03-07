package com.rabbitframework.tween.properties.specials 
{
	import flash.display.DisplayObject;
	import flash.geom.ColorTransform;
	import com.rabbitframework.tween.properties.PropertyBase;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyRemoveTint extends PropertyBase
	{
		public var startColorTransform:ColorTransform;
		public var endColorTransform:ColorTransform;
		public var currentColorTransform:ColorTransform;
		
		public var changeRedMultiplier:Number;
		public var changeGreenMultiplier:Number;
		public var changeBlueMultiplier:Number;
		public var changeAlphaMultiplier:Number;
		public var changeRedOffset:Number;
		public var changeGreenOffset:Number;
		public var changeBlueOffset:Number;
		public var changeAlphaOffset:Number;
		
		private var displayObject:DisplayObject;
		
		public function PropertyRemoveTint(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			displayObject = target as DisplayObject;
			
			startColorTransform = displayObject.transform.colorTransform;
			
			if ( startValue is Number ) startColorTransform.color = uint(startValue);
			
			endColorTransform = new ColorTransform();
			
			changeRedMultiplier = endColorTransform.redMultiplier - startColorTransform.redMultiplier;
			changeGreenMultiplier = endColorTransform.greenMultiplier - startColorTransform.greenMultiplier;
			changeBlueMultiplier = endColorTransform.blueMultiplier - startColorTransform.blueMultiplier;
			//changeAlphaMultiplier = endColorTransform.alphaMultiplier - startColorTransform.alphaMultiplier;
			changeRedOffset = endColorTransform.redOffset - startColorTransform.redOffset;
			changeGreenOffset = endColorTransform.greenOffset - startColorTransform.greenOffset;
			changeBlueOffset = endColorTransform.blueOffset - startColorTransform.blueOffset;
			//changeAlphaOffset = endColorTransform.alphaOffset - startColorTransform.alphaOffset;
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			currentColorTransform = displayObject.transform.colorTransform;
			
			currentColorTransform.redMultiplier = startColorTransform.redMultiplier + changeRedMultiplier * factor;
			currentColorTransform.greenMultiplier = startColorTransform.greenMultiplier + changeGreenMultiplier * factor;
			currentColorTransform.blueMultiplier = startColorTransform.blueMultiplier + changeBlueMultiplier * factor;
			//currentColorTransform.alphaMultiplier = startColorTransform.alphaMultiplier + changeAlphaMultiplier * factor;
			currentColorTransform.redOffset = startColorTransform.redOffset + changeRedOffset * factor;
			currentColorTransform.greenOffset = startColorTransform.greenOffset + changeGreenOffset * factor;
			currentColorTransform.blueOffset = startColorTransform.blueOffset + changeBlueOffset * factor;
			//currentColorTransform.alphaOffset = startColorTransform.alphaOffset + changeAlphaOffset * factor;
			
			displayObject.transform.colorTransform = currentColorTransform;
		}
		
	}
	
}