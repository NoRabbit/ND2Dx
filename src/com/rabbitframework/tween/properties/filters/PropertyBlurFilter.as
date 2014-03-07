package com.rabbitframework.tween.properties.filters
{
	import flash.display.DisplayObject;
	import flash.filters.BlurFilter;
	import com.rabbitframework.managers.filters.FiltersManager;
	import com.rabbitframework.tween.RabbitTween;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyBlurFilter extends PropertyFilterBase
	{
		public var startFilter:BlurFilter;
		public var endFilter:BlurFilter;
		public var currentFilter:BlurFilter;
		
		public var changeBlurX:Number;
		public var changeBlurY:Number;
		public var changeQuality:int;
		
		// if $startValue == null, then you should take the current property value
		public function PropertyBlurFilter(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			// set default start values in case of...
			defaultStartValue.blurX = 0.0;
			defaultStartValue.blurY = 0.0;
			
			super.init();
			
			if ( !bAreFiltersCreated )
			{
				bAreFiltersCreated = true;
				startFilter = new BlurFilter();
				endFilter = new BlurFilter();
				
				// check if we already have a filter
				if ( filterToStartWith != null )
				{
					currentFilter = filterToStartWith as BlurFilter;
					bIsFilterAlreadyApplied = true;
				}
				else
				{
					currentFilter = new BlurFilter();
				}
			}
			
			RabbitTween.copyProperties(startValue, currentFilter);
			RabbitTween.copyProperties(startValue, startFilter);
			RabbitTween.copyProperties(endValue, endFilter);
			
			changeBlurX = endFilter.blurX - startFilter.blurX;
			changeBlurY = endFilter.blurY - startFilter.blurY;
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
			currentFilter.quality = startFilter.quality + changeQuality * factor;
			
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