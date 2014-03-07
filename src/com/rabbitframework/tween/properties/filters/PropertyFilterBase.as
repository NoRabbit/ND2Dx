package com.rabbitframework.tween.properties.filters
{
	import flash.display.DisplayObject;
	import flash.filters.BitmapFilter;
	import com.rabbitframework.managers.filters.FiltersManager;
	import com.rabbitframework.tween.RabbitTween;
	import com.rabbitframework.tween.RabbitTweenMax;
	import com.rabbitframework.tween.properties.PropertyBase;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyFilterBase extends PropertyBase
	{
		protected var filtersManager:FiltersManager = FiltersManager.getInstance();
		
		public var defaultStartValue:Object = {};
		public var defaultEndValue:Object = {};
		
		// take over the first filter of same type found
		public var overwrite:int = RabbitTweenMax.FILTERS_OVERWRITE_SPECIFIED_INDEX_OF_SAME_TYPE;
		public var overwriteIndex:int = 0;
		
		public var displayObject:DisplayObject;
		
		public var bAreFiltersCreated:Boolean = false;
		public var bIsFilterAlreadyApplied:Boolean = false;
		
		protected var filterToStartWith:BitmapFilter = null;
		
		protected var filtersProperties:Array = ["alpha", "angle", "blurX", "blurY", "color", "distance", "hideObject", "inner", "knockout", "quality", "strength", "highlightAlpha", "highlightColor", "shadowAlpha", "shadowColor", "type", "matrix", "bias", "clamp", "divisor", "matrixX", "matrixY", "preserveAlpha", "componentX", "componentY", "mapBitmap", "mapPoint", "mode", "scaleX", "scaleY", "alphas", "colors", "ratios"];
		
		// if $startValue == null, then you should take the current property value
		public function PropertyFilterBase(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		// PUBLIC FUNCTIONS
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			displayObject = target as DisplayObject;
			
			// overwrite filters ?
			if ( "overwrite" in endValue ) overwrite = endValue.overwrite;
			if ( "overwriteIndex" in endValue ) overwriteIndex = endValue.overwriteIndex;
			
			// remove on complete ?
			if ( "removeOnComplete" in endValue )
			{
				if( endValue["removeOnComplete"] == true ) bRemoveOnComplete = true;
			}
			
			// do we need to overwrite any filter ?
			if ( overwrite == RabbitTweenMax.FILTERS_OVERWRITE_ALL )
			{
				// ok, just remove all filters from this display object
				filtersManager.removeAllFilters(displayObject);
			}
			else if ( overwrite == RabbitTweenMax.FILTERS_OVERWRITE_ALL_OF_SAME_TYPE )
			{
				// ok, just remove all filters of same kind from this display object
				filtersManager.removeAllFiltersOfType(displayObject, property);
			}
			else if ( overwrite == RabbitTweenMax.FILTERS_OVERWRITE_SPECIFIED_INDEX_OF_SAME_TYPE )
			{
				// ok, get first filter of this type and set it as our current filter
				var a:Array = filtersManager.getAllFiltersOfType(displayObject, property);
				
				if ( a.length > overwriteIndex )
				{
					filterToStartWith = a[overwriteIndex] as BitmapFilter;
				}
			}
			
			// start value ?
			if ( startValue == null )
			{
				// no, create one
				startValue = { };
				
				// no filter to start with ?
				if ( filterToStartWith == null )
				{
					// no copy end values to start values and copy default start values on top of it
					RabbitTween.copyProperties(endValue, startValue);
					RabbitTween.copyProperties(defaultStartValue, startValue, true);
				}
				else
				{
					// copy properties in filtersProperties from filterToStartWith to startValue
					RabbitTween.copySpecifiedProperties(filterToStartWith, startValue, filtersProperties);
				}
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