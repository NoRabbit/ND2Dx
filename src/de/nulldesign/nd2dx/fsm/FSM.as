package de.nulldesign.nd2dx.fsm 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSM 
	{
		public static const ON_ACTIVATE:String = "ON_ACTIVATE";
		public static const ON_DEACTIVATE:String = "ON_DEACTIVATE";
		
		public var fsmManager:FSMManager = FSMManager.getInstance();
		
		public var vStates:Vector.<FSMState> = new Vector.<FSMState>();
		
		public var activeState:FSMState;
		
		public var node:Node2D;
		
		public var dEventsToStates:Dictionary = new Dictionary();
		
		public var stateForEvent:Object = { };
		
		private var customData:Object = { };
		
		public function FSM() 
		{
			
		}
		
		public function addState(state:FSMState):void
		{
			if ( vStates.indexOf(state) >= 0 ) return;
			
			if ( state.fsm ) state.fsm.removeState(state);
			
			state.fsm = this;
			
			vStates.push(state);
		}

		public function removeState(state:FSMState):void
		{
			if (state.fsm != this) return;
			
			var index:int = vStates.indexOf(state);
			if ( index < 0 ) return;
			
			state.fsm = null;
			vStates.splice(index, 1);
		}
		
		public function setActiveState(state:FSMState):void
		{
			if ( activeState ) activeState.deactivate();
			activeState = state;
			if ( activeState ) activeState.activate();
		}
		
		public function setActiveStateByName(name:String):void
		{
			var state:FSMState = getStateByName(name);
			if ( state ) setActiveState(state);
		}
		
		public function getStateByName(name:String):FSMState
		{
			var i:int = 0;
			var n:int = vStates.length;
			
			for (; i < n; i++) 
			{
				if ( vStates[i].name == name ) return vStates[i];
			}
			
			return null;
		}
		
		public function setActiveStateByEventName(eventName:String, setNullIfStateNotFound:Boolean = false):void
		{
			var state:FSMState = getStateForEventName(eventName);
			
			if ( state || setNullIfStateNotFound )
			{
				setActiveState(state);
			}
		}
		
		public function registerStateForEventName(eventName:String, state:FSMState):void
		{
			stateForEvent[eventName] = state;
		}
		
		public function unregisterStateForEventName(eventName:String):void
		{
			delete stateForEvent[eventName];
		}
		
		public function getStateForEventName(eventName:String):FSMState
		{
			return stateForEvent[eventName] as FSMState;
		}
		
		public function setCustomVariable(key:String, value:*):*
		{
			customData[key] = value;
		}
		
		public function getCustomVariable(key:String):*
		{
			if ( customData[key] == undefined ) return null;
			return customData[key];
		}
		
		public function activate(force:Boolean = false):void
		{
			if ( activeState && !force ) return;
			
			fsmManager.addFSMToActiveList(this);
			
			// get state to activate (the one linked to the ON_ACTIVATE event)
			setActiveStateByEventName(ON_ACTIVATE);
		}
		
		public function deactivate():void
		{
			// get state to activate (the one linked to the ON_DEACTIVATE event)
			// onActivate will only be fired for that state
			setActiveStateByEventName(ON_DEACTIVATE);
			
			fsmManager.removeFSMFromActiveList(this);
			
			// then set no active state
			setActiveState(null);
		}
		
		public function step(elapsed:Number):void
		{
			if ( activeState ) activeState.step(elapsed);
		}
		
		public function dispose():void
		{
			var i:int = 0;
			var n:int = vStates.length;
			
			for (; i < n; i++) 
			{
				vStates[i].dispose();
			}
			
			if ( vStates.length ) vStates.splice(0, vStates.length);
			activeState = null;
			
			fsmManager.removeFSMFromActiveList(this);
			
			fsmManager = null;
			node = null;
			stateForEvent = null;
			customData = null;
			dEventsToStates = null;
		}
	}

}