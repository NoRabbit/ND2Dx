package com.rabbitframework.tween.properties.filters 
{
	import flash.filters.BevelFilter;
	import com.rabbitframework.tween.properties.specials.PropertyHexColor;
	import com.rabbitframework.tween.RabbitTween;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyBevelFilter extends PropertyFilterBase
	{
		public var startFilter:BevelFilter;
		public var endFilter:BevelFilter;
		public var currentFilter:BevelFilter;
		
		public var startAngle:Number = 0.0;
		public var changeAngle:Number;
		public var endAngle:Number = 0.0;
		
		public var changeBlurX:Number;
		public var changeBlurY:Number;
		public var changeHighlightAlpha:Number;
		public var changeHighlightColor:Number;
		public var changeShadowAlpha:Number;
		public var changeShadowColor:Number;
		public var changeDistance:Number;
		public var changeStrength:Number;
		public var changeQuality:int;
		
		public var hexHighlightColorProperty:PropertyHexColor = null;
		public var hexShadowColorProperty:PropertyHexColor = null;
		
		// if $startValue == null, then you should take the current property value
		public function PropertyBevelFilter(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			// set default start values in case of...
			defaultStartValue.strength = 0.0;
			defaultEndValue.strength = 1.0;
			
			super.init();
			
			if ( !bAreFiltersCreated )
			{
				bAreFiltersCreated = true;
				
				startFilter = new BevelFilter();
				endFilter = new BevelFilter();
				
				// check if we already have a starting filter
				if ( filterToStartWith )
				{
					currentFilter = filterToStartWith as BevelFilter;
					bIsFilterAlreadyApplied = true;
				}
				else
				{
					currentFilter = new BevelFilter();
				}
			}
			
			RabbitTween.copyProperties(startValue, currentFilter);
			RabbitTween.copyProperties(startValue, startFilter);
			RabbitTween.copyProperties(endValue, endFilter);
			
			if ( startFilter.highlightColor != endFilter.highlightColor )
			{
				hexHighlightColorProperty = new PropertyHexColor(currentFilter, "highlightColor", startFilter.highlightColor, endFilter.highlightColor);
				hexHighlightColorProperty.init();
			}
			
			if ( startFilter.shadowColor != endFilter.shadowColor )
			{
				hexShadowColorProperty = new PropertyHexColor(currentFilter, "shadowColor", startFilter.shadowColor, endFilter.shadowColor);
				hexShadowColorProperty.init();
			}
			
			if ( "angle" in startValue ) startAngle = startValue["angle"];
			if ( "angle" in endValue ) endAngle = endValue["angle"];
			
			changeAngle = endAngle - startAngle;
			changeBlurX = endFilter.blurX - startFilter.blurX;
			changeBlurY = endFilter.blurY - startFilter.blurY;
			changeHighlightAlpha = endFilter.highlightAlpha - startFilter.highlightAlpha;
			changeHighlightColor = endFilter.highlightColor - startFilter.highlightColor;
			changeShadowAlpha = endFilter.shadowAlpha - startFilter.shadowAlpha;
			changeShadowColor = endFilter.shadowColor - startFilter.shadowColor;
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
			currentFilter.angle = startFilter.angle + changeAngle * factor;
			currentFilter.blurX = startFilter.blurX + changeBlurX * factor;
			currentFilter.blurY = startFilter.blurY + changeBlurY * factor;
			currentFilter.highlightAlpha = startFilter.highlightAlpha + changeHighlightAlpha * factor;
			currentFilter.highlightColor = startFilter.highlightColor + changeHighlightColor * factor;
			currentFilter.shadowAlpha = startFilter.shadowAlpha + changeShadowAlpha * factor;
			currentFilter.shadowColor = startFilter.shadowColor + changeShadowColor * factor;
			currentFilter.distance = startFilter.distance + changeDistance * factor;
			currentFilter.strength = startFilter.strength + changeStrength * factor;
			currentFilter.quality = startFilter.quality + changeQuality * factor;
			
			if ( hexHighlightColorProperty ) hexHighlightColorProperty.update(factor);
			if ( hexShadowColorProperty ) hexShadowColorProperty.update(factor);
			
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