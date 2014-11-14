package com.rabbitframework.animator.nodes.elements 
{
	import com.rabbitframework.animator.style.RAStyle;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class NodeElementMovieClip extends MovieClip implements INodeElement
	{
		protected var _elementWidth:Number = RAStyle.ELEMENT_MIN_WIDTH;
		protected var _fixed:Boolean = true;
		
		public function NodeElementMovieClip() 
		{
			mouseEnabled = buttonMode = useHandCursor = true;
		}
		
		public function set fixed(value:Boolean):void 
		{
			_fixed = value;
		}
		
		public function get fixed():Boolean 
		{
			return _fixed;
		}
		
		public function set elementWidth(value:Number):void 
		{
			_elementWidth = value;
			if ( _elementWidth < RAStyle.ELEMENT_MIN_WIDTH ) _elementWidth = RAStyle.ELEMENT_MIN_WIDTH;
		}
		
		public function get elementWidth():Number 
		{
			return _elementWidth;
		}
	}

}