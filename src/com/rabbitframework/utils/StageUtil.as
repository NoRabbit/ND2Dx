package com.rabbitframework.utils 
{
	import com.rabbitframework.events.StageEvent;
	import com.rabbitframework.managers.events.EventsManager;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.system.Capabilities;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class StageUtil 
	{
		static private var _stage:Stage = null;
		
		static public function get stage():Stage { return _stage; }
		
		static public function set stage(value:Stage):void 
		{
			if ( _stage != null ) return;
			_stage = value;
			EventsManager.getInstance().dispatchEvent( new Event(StageEvent.EVENT_STAGE_INIT) );
		}
		
		static public function isLocal():Boolean
		{
			if ( _stage )
			{
				if ( _stage.loaderInfo.url.indexOf("file:") >= 0 ) return true;
			}
			
			switch(Capabilities.playerType)
			{
				case "ActiveX":
				case "PlugIn":
				{
					return false;
				}
				
				default:
				{
					return true;
				}
			}
			
			return false;
		}
	}

}