package com.rabbitframework.animator.panels.objectstimeline 
{
	import com.rabbitframework.animator.managers.AnimatorManager;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TimelineCursor extends Sprite
	{
		public var animatorManager:AnimatorManager = AnimatorManager.getInstance();
		
		private var _currentTime:Number = 0.0;
		
		public function TimelineCursor() 
		{
			mouseEnabled = useHandCursor = buttonMode = true;
		}
		
		public function get currentTime():Number 
		{
			return _currentTime;
		}
		
		public function set currentTime(value:Number):void 
		{
			if ( value < 0 ) value = 0;
			if ( value == _currentTime ) return;
			_currentTime = value;
			animatorManager.onCursorTimeChange.dispatch(_currentTime);
		}
		
	}

}