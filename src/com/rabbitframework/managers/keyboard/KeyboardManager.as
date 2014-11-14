package com.rabbitframework.managers.keyboard 
{
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import com.rabbitframework.managers.events.EventsManager;
	
	/**
	 * Singleton class
	 * @author Thomas John (thomas.john@open-design.be) www.open-design.be
	 */
	public class KeyboardManager extends EventDispatcher
	{
		// our unique instance of this class
		private static var instance:KeyboardManager = new KeyboardManager();
		
		private var eManager:EventsManager = EventsManager.getInstance();
		
		private var stage:Stage;
		private var oKeysDown:Object;
		private var aKeysDown:Array;
		
		/**
		 * Constructor : check if an instance already exists and if it does throw an error
		 */
		public function KeyboardManager() 
		{
			if ( instance ) throw new Error( "KeyboardManager can only be accessed through KeyboardManager.getInstance()" );
			// init
			
		}
		
		/**
		 * Get unique instance of this singleton class
		 * @return					<KeyboardManager> Instance of this class
		 */
		public static function getInstance():KeyboardManager{
			return instance;
		}
		
		public function init(stage:Stage):void
		{
			if ( this.stage ) return;
			this.stage = stage;
			oKeysDown = new Object();
			aKeysDown = new Array();
			
			eManager.add(stage, KeyboardEvent.KEY_DOWN, stage_keyDownHandler, ["KeyboardManager"]);
			eManager.add(stage, KeyboardEvent.KEY_UP, stage_keyUpHandler, ["KeyboardManager"]);
		}
		
		private function stage_keyDownHandler(e:KeyboardEvent):void
		{
			if ( oKeysDown[e.keyCode] )
			{
				return;
			}
			
			oKeysDown[e.keyCode] = true;
			aKeysDown.push(e.keyCode);
			
			dispatchEvent( e );
		}
		
		private function stage_keyUpHandler(e:KeyboardEvent):void
		{
			if ( !oKeysDown[e.keyCode] )
			{
				return;
			}
			
			oKeysDown[e.keyCode] = false;
			aKeysDown.splice(aKeysDown.indexOf(e.keyCode), 1);
			
			dispatchEvent( e );
		}
		
		public function resume():void
		{
			eManager.resumeAllFromGroup("KeyboardManager");
		}
		
		public function suspend():void
		{
			eManager.suspendAllFromGroup("KeyboardManager");
		}
		
		public function isKeyDown(keyCode:int):Boolean
		{
			return oKeysDown[keyCode];
		}
		
		public function getLastKeyDown():int
		{
			if ( aKeysDown.length > 0 )
			{
				return aKeysDown[aKeysDown.length - 1];
			}
			else
			{
				return -1;
			}
		}
		
	}
	
}