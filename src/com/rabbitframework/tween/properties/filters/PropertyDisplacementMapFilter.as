package com.rabbitframework.tween.properties.filters
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.filters.DisplacementMapFilter;
	import flash.geom.Point;
	import com.rabbitframework.managers.filters.FiltersManager;
	import com.rabbitframework.tween.properties.specials.PropertyHexColor;
	import com.rabbitframework.tween.RabbitTween;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyDisplacementMapFilter extends PropertyFilterBase
	{
		public var startFilter:DisplacementMapFilter;
		public var endFilter:DisplacementMapFilter;
		public var currentFilter:DisplacementMapFilter;
		
		public var changeScaleX:Number;
		public var changeScaleY:Number;
		public var changeComponentX:uint;
		public var changeComponentY:uint;
		public var changeColor:uint;
		public var changeAlpha:Number;
		public var bChangeMapBitmap:Boolean = false;
		public var changeMapBitmap:Array = [];
		public var currentMapBitmapIndex:int = -1;
		public var changeMapPoint:Point = new Point();
		public var startMapPoint:Point = new Point();
		public var endMapPoint:Point = new Point();
		public var currentMapPoint:Point = new Point();
		
		public var hexColorProperty:PropertyHexColor = null;
		
		// if $startValue == null, then you should take the current property value
		public function PropertyDisplacementMapFilter(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			// set default start values in case of...
			defaultStartValue.alpha = 1.0;
			defaultStartValue.scaleX = 1.0;
			defaultStartValue.scaleY = 1.0;
			super.init();
			
			// check for mapBitmap property
			if ( endValue["mapBitmap"] is Array )
			{
				// it's an array, it's ok
				changeMapBitmap = endValue["mapBitmap"] as Array;
				
				// something ?
				if ( changeMapBitmap.length > 0 )
				{
					// change mapBitmap over time
					bChangeMapBitmap = true;
				}
				
				// remove this property from start and end value so it doesn't get applied the normal way
				delete startValue["mapBitmap"];
				delete endValue["mapBitmap"];
			}
			
			
			
			if ( !bAreFiltersCreated )
			{
				bAreFiltersCreated = true;
				startFilter = new DisplacementMapFilter();
				endFilter = new DisplacementMapFilter();
				
				// check if we already have a filter
				if ( filterToStartWith != null )
				{
					currentFilter = filterToStartWith as DisplacementMapFilter;
					bIsFilterAlreadyApplied = true;
				}
				else
				{
					currentFilter = new DisplacementMapFilter();
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
			
			if ( "mapPoint" in startValue ) startMapPoint = startValue["mapPoint"];
			if ( "mapPoint" in endValue ) endMapPoint = endValue["mapPoint"];
		
			changeAlpha = endFilter.alpha - startFilter.alpha;
			changeScaleX = endFilter.scaleX - startFilter.scaleX;
			changeScaleY = endFilter.scaleY - startFilter.scaleY;
			changeComponentX = endFilter.componentX - startFilter.componentX;
			changeComponentY = endFilter.componentY - startFilter.componentY;
			changeMapPoint.x = endMapPoint.x - startMapPoint.x;
			changeMapPoint.y = endMapPoint.y - startMapPoint.y;
			
			// do we need to apply a mapBitmap from an array ?
			if ( bChangeMapBitmap ) 
			{
				// yes, set it's first element
				currentFilter.mapBitmap = changeMapBitmap[0];
				currentMapBitmapIndex = 0;
			}
			
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
			currentFilter.alpha = startFilter.alpha + changeAlpha * factor;
			currentFilter.scaleX = startFilter.scaleX + changeScaleX * factor;
			currentFilter.scaleY = startFilter.scaleY + changeScaleY * factor;
			currentFilter.componentX = startFilter.componentX + changeComponentX * factor;
			currentFilter.componentY = startFilter.componentY + changeComponentY * factor;
			currentMapPoint.x = startMapPoint.x + changeMapPoint.x * factor;
			currentMapPoint.y = startMapPoint.y + changeMapPoint.y * factor;
			currentFilter.mapPoint = currentMapPoint;
			
			if ( hexColorProperty ) hexColorProperty.update(factor);
			
			if ( bChangeMapBitmap ) 
			{
				currentMapBitmapIndex++;
				if ( currentMapBitmapIndex >= changeMapBitmap.length ) currentMapBitmapIndex = 0;
				currentFilter.mapBitmap = changeMapBitmap[currentMapBitmapIndex];
			}
			
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