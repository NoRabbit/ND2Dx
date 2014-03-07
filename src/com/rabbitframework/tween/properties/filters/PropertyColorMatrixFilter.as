package com.rabbitframework.tween.properties.filters
{
	import com.rabbitframework.utils.DebugUtils;
	import flash.display.DisplayObject;
	import flash.filters.ColorMatrixFilter;
	import com.rabbitframework.managers.filters.FiltersManager;
	import com.rabbitframework.tween.RabbitTween;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * 
	 * Some parts of this class (matrices and colors manipulations) are directly taken from the ColorMatrix class from Mario Klingemann
	 * @author Mario Klingemann http://www.quasimondo.com
	 * 
	 */
	public class PropertyColorMatrixFilter extends PropertyFilterBase
	{
		// (from ColorMatrix class: Mario Klingemann)
		//
		// RGB to Luminance conversion constants as found on
		// Charles A. Poynton's colorspace-faq:
		// http://www.faqs.org/faqs/graphics/colorspace-faq/
		
		private static const LUMA_R:Number = 0.212671;
		private static const LUMA_G:Number = 0.71516;
        private static const LUMA_B:Number = 0.072169;
		
		
		// There seem different standards for converting RGB
		// values to Luminance. This is the one by Paul Haeberli:
		
		//private static const LUMA_R:Number = 0.3086;
		//private static const LUMA_G:Number = 0.6094;
		//private static const LUMA_B:Number = 0.0820;
		
		private static const RAD:Number = Math.PI / 180;
		
		
		
		
		
		public var startFilter:ColorMatrixFilter;
		public var endFilter:ColorMatrixFilter;
		public var currentFilter:ColorMatrixFilter;
		
		public var changeMatrix:Array = [];
		public var currentMatrix:Array = [];
		
		// if $startValue == null, then you should take the current property value
		public function PropertyColorMatrixFilter(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			// set default start values in case of...
			defaultStartValue.matrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
			defaultStartValue.hue = 0.0;
			
			changeMatrix.matrix = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
			
			super.init();
			
			if ( !bAreFiltersCreated )
			{
				bAreFiltersCreated = true;
				startFilter = new ColorMatrixFilter();
				endFilter = new ColorMatrixFilter();
				
				// check if we already have a filter
				if ( filterToStartWith != null )
				{
					currentFilter = filterToStartWith as ColorMatrixFilter;
					bIsFilterAlreadyApplied = true;
				}
				else
				{
					currentFilter = new ColorMatrixFilter();
				}
			}
			
			RabbitTween.copyProperties(startValue, currentFilter);
			RabbitTween.copyProperties(startValue, startFilter);
			RabbitTween.copyProperties(endValue, endFilter);
			
			//trace("MatrixFilter tween init debug:");
			//trace("startValue", DebugUtils.dump(startValue));
			//trace("endValue", DebugUtils.dump(endValue));
			
			// aplly hue
			startFilter.matrix = adjustHue(startFilter.matrix, startValue.hue);
			endFilter.matrix = adjustHue(endFilter.matrix, endValue.hue);
			
			changeMatrix[0] = endFilter.matrix[0] - startFilter.matrix[0];
			changeMatrix[1] = endFilter.matrix[1] - startFilter.matrix[1];
			changeMatrix[2] = endFilter.matrix[2] - startFilter.matrix[2];
			changeMatrix[3] = endFilter.matrix[3] - startFilter.matrix[3];
			changeMatrix[4] = endFilter.matrix[4] - startFilter.matrix[4];
			
			changeMatrix[5] = endFilter.matrix[5] - startFilter.matrix[5];
			changeMatrix[6] = endFilter.matrix[6] - startFilter.matrix[6];
			changeMatrix[7] = endFilter.matrix[7] - startFilter.matrix[7];
			changeMatrix[8] = endFilter.matrix[8] - startFilter.matrix[8];
			changeMatrix[9] = endFilter.matrix[9] - startFilter.matrix[9];
			
			changeMatrix[10] = endFilter.matrix[10] - startFilter.matrix[10];
			changeMatrix[11] = endFilter.matrix[11] - startFilter.matrix[11];
			changeMatrix[12] = endFilter.matrix[12] - startFilter.matrix[12];
			changeMatrix[13] = endFilter.matrix[13] - startFilter.matrix[13];
			changeMatrix[14] = endFilter.matrix[14] - startFilter.matrix[14];
			
			changeMatrix[15] = endFilter.matrix[15] - startFilter.matrix[15];
			changeMatrix[16] = endFilter.matrix[16] - startFilter.matrix[16];
			changeMatrix[17] = endFilter.matrix[17] - startFilter.matrix[17];
			changeMatrix[18] = endFilter.matrix[18] - startFilter.matrix[18];
			changeMatrix[19] = endFilter.matrix[19] - startFilter.matrix[19];
			
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
			currentMatrix[0] = startFilter.matrix[0] + changeMatrix[0] * factor;
			currentMatrix[1] = startFilter.matrix[1] + changeMatrix[1] * factor;
			currentMatrix[2] = startFilter.matrix[2] + changeMatrix[2] * factor;
			currentMatrix[3] = startFilter.matrix[3] + changeMatrix[3] * factor;
			currentMatrix[4] = startFilter.matrix[4] + changeMatrix[4] * factor;
			
			currentMatrix[5] = startFilter.matrix[5] + changeMatrix[5] * factor;
			currentMatrix[6] = startFilter.matrix[6] + changeMatrix[6] * factor;
			currentMatrix[7] = startFilter.matrix[7] + changeMatrix[7] * factor;
			currentMatrix[8] = startFilter.matrix[8] + changeMatrix[8] * factor;
			currentMatrix[9] = startFilter.matrix[9] + changeMatrix[9] * factor;
			
			currentMatrix[10] = startFilter.matrix[10] + changeMatrix[10] * factor;
			currentMatrix[11] = startFilter.matrix[11] + changeMatrix[11] * factor;
			currentMatrix[12] = startFilter.matrix[12] + changeMatrix[12] * factor;
			currentMatrix[13] = startFilter.matrix[13] + changeMatrix[13] * factor;
			currentMatrix[14] = startFilter.matrix[14] + changeMatrix[14] * factor;
			
			currentMatrix[15] = startFilter.matrix[15] + changeMatrix[15] * factor;
			currentMatrix[16] = startFilter.matrix[16] + changeMatrix[16] * factor;
			currentMatrix[17] = startFilter.matrix[17] + changeMatrix[17] * factor;
			currentMatrix[18] = startFilter.matrix[18] + changeMatrix[18] * factor;
			currentMatrix[19] = startFilter.matrix[19] + changeMatrix[19] * factor;
			
			currentFilter.matrix = currentMatrix;
			
			filtersManager.update(displayObject);
		}
		
		/**
		 * Remove property
		 */
		override public function removeProperty():void
		{
			filtersManager.remove(displayObject, currentFilter);
		}
		
		/**
		 * Adjust hue (from ColorMatrix class: Mario Klingemann, modified by Thomas John)
		 */
		private static function adjustHue(mat1:Array, degrees:Number = 0):Array
        {
			if ( isNaN(degrees) ) return mat1;
			
            degrees *= RAD;
            var cos:Number = Math.cos(degrees);
            var sin:Number = Math.sin(degrees);
            return concat(mat1, [((LUMA_R + (cos * (1 - LUMA_R))) + (sin * -(LUMA_R))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * -(LUMA_G))), ((LUMA_B + (cos * -(LUMA_B))) + (sin * (1 - LUMA_B))), 0, 0, 
            		((LUMA_R + (cos * -(LUMA_R))) + (sin * 0.143)), ((LUMA_G + (cos * (1 - LUMA_G))) + (sin * 0.14)), ((LUMA_B + (cos * -(LUMA_B))) + (sin * -0.283)), 0, 0, 
            		((LUMA_R + (cos * -(LUMA_R))) + (sin * -((1 - LUMA_R)))), ((LUMA_G + (cos * -(LUMA_G))) + (sin * LUMA_G)), ((LUMA_B + (cos * (1 - LUMA_B))) + (sin * LUMA_B)), 0, 0, 
            		0, 0, 0, 1, 0]);
        }
		
		/**
		 * Concatenates two matrices (from ColorMatrix class: Mario Klingemann, modified by Thomas John)
		 */
		private static function concat(mat1:Array, mat2:Array):Array
		{
			var temp:Array = [];
			var i:int = 0;
			var x:int, y:int;
			for (y = 0; y < 4; y++ )
			{
				for (x = 0; x < 5; x++ )
				{
					temp[ int( i + x) ] =  Number(mat2[i  ])      * Number(mat1[x]) + 
								   		   Number(mat2[int(i+1)]) * Number(mat1[int(x +  5)]) + 
								   		   Number(mat2[int(i+2)]) * Number(mat1[int(x + 10)]) + 
								   		   Number(mat2[int(i+3)]) * Number(mat1[int(x + 15)]) +
								   		   (x == 4 ? Number(mat2[int(i+4)]) : 0);
				}
				i+=5;
			}
			
			return temp;
		}
	}
	
}