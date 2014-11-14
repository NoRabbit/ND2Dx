package com.rabbitframework.animator.nodes.elements 
{
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class NEEye extends NodeElementMovieClip
	{
		protected var _open:Boolean = true;
		
		public function NEEye() 
		{
			elementWidth = 24.0;
			open = true;
			
			mouseChildren = mouseEnabled = buttonMode = useHandCursor = true;
			addEventListener(MouseEvent.CLICK, click_handler);
		}
		
		private function click_handler(e:MouseEvent):void 
		{
			if ( open )
			{
				open = false;
			}
			else
			{
				open = true;
			}
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
				gotoAndStop(1);
			}
			else
			{
				gotoAndStop(2);
			}
		}
	}

}