package com.rabbitframework.managers.languages 
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class LanguagesLabelByFrame extends MovieClip
	{
		public var lgManager:LanguagesManager = LanguagesManager.getInstance();
		
		public function LanguagesLabelByFrame() 
		{
			mouseEnabled = mouseChildren = false;
			lgManager.addEventListener(Event.CHANGE, onLgChangeHandler);
			onLgChangeHandler(null);
		}
		
		private function onLgChangeHandler(e:Event):void 
		{
			var frame:int = lgManager.getFrame();
			
			if ( frame > totalFrames ) frame = totalFrames;
			if ( frame < 1 ) frame = 1;
			
			gotoAndStop(frame);
		}
	}
	
}