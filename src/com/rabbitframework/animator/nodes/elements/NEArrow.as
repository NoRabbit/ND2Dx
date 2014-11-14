package com.rabbitframework.animator.nodes.elements 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class NEArrow extends NodeElementSprite
	{
		public var arrow:Sprite;
		
		private var _open:Boolean = true;
		
		public function NEArrow() 
		{
			mouseEnabled = buttonMode = useHandCursor = true;
			elementWidth = 24;
			open = false;
		}
		
		public function get open():Boolean 
		{
			return _open;
		}
		
		public function set open(value:Boolean):void 
		{
			_open = value;
			
			if ( _open )
			{
				arrow.rotation = 90.0;
			}
			else
			{
				arrow.rotation = 0.0;
			}
		}
	}

}