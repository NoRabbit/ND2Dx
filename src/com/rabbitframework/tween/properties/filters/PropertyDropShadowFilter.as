package com.rabbitframework.tween.properties.filters
{
	import flash.filters.DropShadowFilter;
	import com.rabbitframework.tween.properties.specials.PropertyHexColor;
	import com.rabbitframework.tween.RabbitTween;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDropShadowFilter extends PropertyFilterBase
	{
		public var startFilter:DropShadowFilter;
		public var endFilter:DropShadowFilter;
		public var currentFilter:DropShadowFilter;
		
		public var startAngle:Number = 0.0;
		public var changeAngle:Number;
		public var endAngle:Number = 0.0;
		
		public var changeBlurX:Number;
		public var changeBlurY:Number;
		public var changeAlpha:Number;
		public var changeColor:Number;
		public var changeDistance:Number;
		public var changeStrength:Number;
		public var changeQuality:int;
		
		public var hexColorProperty:PropertyHexColor = null;
		
		// if $startValue == null, then you should take the current property value
		public function PropertyDropShadowFilter(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			// set default start values in case of...
			defaultStartValue.alpha = 0.0;
			defaultEndValue.alpha = 1.0;
			
			super.init();
			
			if ( !bAreFiltersCreated )
			{
				bAreFiltersCreated = true;
				
				startFilter = new DropShadowFilter();
				endFilter = new DropShadowFilter();
				
				// check if we already have a starting filter
				if ( filterToStartWith )
				{
					currentFilter = filterToStartWith as DropShadowFilter;
					bIsFilterAlreadyApplied = true;
				}
				else
				{
					currentFilter = new DropShadowFilter();
				}
			}
			
			RabbitTween.copyProperties(startValue, currentFilter);
			RabbitTween.copyProperties(startValue, startFilter);
			RabbitTween.copyProperties(endValue, endFilter);
			
			if ( startFilter.color != endFilter.color )
			{
				hexColorProperty = new PropertyHexColor(currentFilter, "color", startFilter.color, endFilter.color);
				hexColorProperty.init();
			}
			
			if ( "angle" in startValue ) startAngle = startValue["angle"];
			if ( "angle" in endValue ) endAngle = endValue["angle"];
			
			changeAngle = endAngle - startAngle;
			
			changeBlurX = endFilter.blurX - startFilter.blurX;
			changeBlurY = endFilter.blurY - startFilter.blurY;
			changeAlpha = endFilter.alpha - startFilter.alpha;
			changeDistance = endFilter.distance - startFilter.distance;
			changeStrength = endFilter.strength - startFilter.strength;
			changeQuality = endFilter.quality - startFilter.quality;
			
			if ( !bIsFilterAlreadyApplied )
			{
				bIsFilterAlreadyApplied = true;
				filtersManager.add(displayObject, currentFilter);
			}
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			currentFilter.blurX = startFilter.blurX + changeBlurX * factor;
			currentFilter.blurY = startFilter.blurY + changeBlurY * factor;
			currentFilter.alpha = startFilter.alpha + changeAlpha * factor;
			currentFilter.angle = startFilter.angle + changeAngle * factor;
			currentFilter.distance = startFilter.distance + changeDistance * factor;
			currentFilter.strength = startFilter.strength + changeStrength * factor;
			currentFilter.quality = startFilter.quality + changeQuality * factor;
			
			if ( hexColorProperty ) hexColorProperty.update(factor);
			
			filtersManager.update(displayObject);
		}
		
		/**
		 * Remove property
		 */
		override public function removeProperty():void
		{
			filtersManager.remove(displayObject, currentFilter);
		}
		
	}
	
}