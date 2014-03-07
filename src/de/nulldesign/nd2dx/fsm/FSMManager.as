package de.nulldesign.nd2dx.fsm 
{
	import de.nulldesign.nd2dx.display.Node2D;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class FSMManager 
	{
		private static var instance:FSMManager = new FSMManager();
		
		public function FSMManager() 
		{
			if ( instance ) throw new Error( "FSMManager can only be accessed through FSMManager.getInstance()" );
		}
		
		public static function getInstance():FSMManager 
		{
			return instance;
		}
		
		
		public var vFSMs:Vector.<FSM> = new Vector.<FSM>();
		
		public function addFSMToActiveList(fsm:FSM):void
		{
			if ( vFSMs.indexOf(fsm) < 0 ) vFSMs.push(fsm);
		}
		
		public function removeFSMFromActiveList(fsm:FSM):void
		{
			var index:int = vFSMs.indexOf(fsm);
			if ( index >= 0 ) vFSMs.splice(index, 1);
		}
		
		public function dispatchEvent(event:FSMEvent, action:FSMStateAction):void
		{
			event.action = action;
			
			if ( event.type == FSMEvent.EVENT_TYPE_STATE )
			{
				var state:FSMState = action.state.getStateForEventName(event.name);
				if ( state ) action.state.fsm.setActiveState(state);
			}
			else if ( event.type == FSMEvent.EVENT_TYPE_FSM )
			{
				action.state.fsm.setActiveStateByEventName(event.name);
			}
			else if ( event.type == FSMEvent.EVENT_TYPE_ALL_FSMS_IN_NODE )
			{
				dispatchEventToAllActiveFSMsInNode(event, action.state.fsm.node);
			}
			else if ( event.type == FSMEvent.EVENT_TYPE_GLOBAL )
			{
				dispatchEventToAllActiveFSMs(event);
			}
		}
		
		public function dispatchEventToAllActiveFSMs(event:FSMEvent):void
		{
			var i:int = 0;
			var n:int = vFSMs.length;
			
			for (; i < n; i++) 
			{
				vFSMs[i].setActiveStateByEventName(event.name);
			}
		}
		
		public function dispatchEventToAllActiveFSMsInNode(event:FSMEvent, node:Node2D):void
		{
			var i:int = 0;
			var n:int = vFSMs.length;
			var fsm:FSM;
			
			for (; i < n; i++) 
			{
				fsm = vFSMs[i];
				if( fsm.node == node ) fsm.setActiveStateByEventName(event.name);
			}
		}
	}
	
}