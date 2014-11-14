package com.rabbitframework.animator.style 
{
	import com.rabbitframework.animator.nodes.elements.INodeElement;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAStyle 
	{
		public static var OBJECTS_PANEL_WIDTH:Number = 160.0;
		public static var TIMELINE_PANEL_X:Number = 160.0;
		public static var TIMELINE_PANEL_WIDTH:Number = 160.0;
		
		public static const NODE_MIN_WIDTH:Number = 160.0;
		public static const NODE_MIN_HEIGHT:Number = 16.0;
		public static const NODE_CHILD_OFFSET_X:Number = 24.0 + 2.0;
		
		public static const GROUP_COLOR_WIDTH:Number = 4.0;
		
		public static const ELEMENT_MIN_WIDTH:Number = 1.0;
		public static const ELEMENT_INPUT_VALUE_MIN_WIDTH:Number = 56.0;
		
		public static const element_space_left:Number = 4.0;
		public static const element_space_x:Number = 10.0;
		public static const element_offset_x:Number = 24.0 + 2.0;
		public static const separatorEnd_distanceFromEnd:Number = 64.0 + 16 + 2.0;
		public static const separatorEnd2_distanceFromEnd:Number = 16.0 + 2.0;
		
		
		public static const aGroupColors:Array = [0x1f92c3, 0x87a86e, 0xd4b373, 0xc7626e, 0xc96a4c, 0xac9868, 0x6c7a62];
		public static var currentIndexGroupColor:int = -1;
		
		public static function getGroupColor():uint
		{
			currentIndexGroupColor ++;
			if ( currentIndexGroupColor >= aGroupColors.length ) currentIndexGroupColor = 0;
			
			return aGroupColors[currentIndexGroupColor];
		}
		
		public static function drawLeftElements(v:Vector.<INodeElement>, currentElementX:Number, availableWidth:Number):Number
		{
			var i:int = 0;
			var n:int = v.length;
			var element:INodeElement;
			var usedWidth:Number = 0.0;
			var notFixedElementCount:int = 0;
			
			// first pass to get total width of fixed elements
			for (; i < n; i++) 
			{
				element = v[i];
				
				if ( element.fixed )
				{
					usedWidth += element.elementWidth;
					
				}
				else
				{
					notFixedElementCount++;
				}
				
			}
			
			if ( notFixedElementCount > 0 )
			{
				availableWidth = availableWidth - usedWidth;
				availableWidth = availableWidth / notFixedElementCount;
			}
			
			i = 0;
			
			// second pass to position elements
			for (; i < n; i++) 
			{
				element = v[i];
				(element as DisplayObject).x = currentElementX;
				
				if ( !element.fixed )
				{
					element.elementWidth = availableWidth;
				}
				
				currentElementX += element.elementWidth;
			}
			
			return currentElementX;
		}
	}

}