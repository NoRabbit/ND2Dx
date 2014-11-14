package com.rabbitframework.animator.ui 
{
	import com.rabbitframework.animator.system.RASystemObjectPropertyKey;
	import flash.display.MovieClip;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TimelineKey extends MovieClip
	{
		public var systemKey:RASystemObjectPropertyKey;
		private var _selected:Boolean = false;
		
		public function TimelineKey() 
		{
			mouseEnabled = useHandCursor = buttonMode = true;
			gotoAndStop(1);
		}
		
		public function setSystemKey(systemKey:RASystemObjectPropertyKey):void
		{
			this.systemKey = systemKey;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if ( _selected == value ) return;
			
			_selected = value;
			
			if ( _selected )
			{
				gotoAndStop(2);
			}
			else
			{
				gotoAndStop(1);
			}
		}
		
		public function dispose():void
		{
			this.systemKey = null;
			selected = false;
		}
		
	}

}