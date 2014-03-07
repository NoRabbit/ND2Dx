package de.nulldesign.nd2dx.fsm 
{
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSMStateAction 
	{
		public static const ACTION_TYPE_NORMAL:int = 0;
		public static const ACTION_TYPE_NO_STEP:int = 1;
		
		public static const ACTION_ON_ACTIVATE:int = 0;
		public static const ACTION_ON_DEACTIVATE:int = 1;
		
		public var fsmManager:FSMManager = FSMManager.getInstance();
		
		public var state:FSMState;
		
		public var next:FSMStateAction;
		public var prev:FSMStateAction;
		
		private var _type:int = ACTION_TYPE_NORMAL;
		public var actionOn:int = ACTION_ON_ACTIVATE;
		
		private var delayedEventTimeOutId:uint = 0;
		
		public function FSMStateAction() 
		{
			
		}
		
		public function activate():void
		{
			onActivate();
		}
		
		public function onActivate():void
		{
			
		}
		
		public function step(elapsed:Number):void
		{
			
		}
		
		public function deactivate(fireOnDeactivate:Boolean = true):void
		{
			if( fireOnDeactivate ) onDeactivate();
			clearDelayedEventTimeOut();
		}
		
		public function onDeactivate():void
		{
			
		}
		
		public function dispatchEvent(event:FSMEvent, delay:Number = 0.0):void
		{
			if ( !state ) return;
			if ( !state.fsm ) return;
			
			if ( delay > 0.0 )
			{
				delayedEventTimeOutId = setTimeout(dispatchEvent, delay * 1000, event, 0.0);
			}
			else
			{
				fsmManager.dispatchEvent(event, this);
			}
		}
		
		public function dispose():void
		{
			state = null;
			next = null;
			prev = null;
			clearDelayedEventTimeOut();
		}
		
		public function clearDelayedEventTimeOut():void
		{
			if ( delayedEventTimeOutId > 0 ) clearTimeout(delayedEventTimeOutId);
			delayedEventTimeOutId = 0;
		}
		
		public function get type():int 
		{
			return _type;
		}
		
		public function set type(value:int):void 
		{
			if ( _type == value ) return;
			
			_type = value;
			
			if ( state )
			{
				state.removeAction(this);
				state.addAction(this);
			}
		}
	}

}