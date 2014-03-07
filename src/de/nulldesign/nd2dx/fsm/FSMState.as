package de.nulldesign.nd2dx.fsm 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSMState 
	{
		public var fsm:FSM;
		
		public var name:String;
		
		public var numActions:int = 0;
		public var normalActionsList:FSMStateActionList;
		public var noStepActionsList:FSMStateActionList;
		
		public var stateForEvent:Object = { };
		
		public function FSMState(name:String = "") 
		{
			normalActionsList = new FSMStateActionList(this);
			noStepActionsList = new FSMStateActionList(this);
			
			this.name = name;
		}
		
		public function activate():void
		{
			var action:FSMStateAction;
			
			// no step actions type
			for (action = noStepActionsList.actionFirst; action; action = action.next)
			{
				action.activate();
			}
			
			// normal actions type
			for (action = normalActionsList.actionFirst; action; action = action.next)
			{
				action.activate();
			}
		}
		
		public function step(elapsed:Number):void
		{
			// only normal actions type
			for (var action:FSMStateAction = normalActionsList.actionFirst; action; action = action.next)
			{
				action.step(elapsed);
			}
		}
		
		public function deactivate():void
		{
			var action:FSMStateAction;
			
			// no step actions type
			for (action = noStepActionsList.actionFirst; action; action = action.next)
			{
				action.deactivate();
			}
			
			// normal actions type
			for (action = normalActionsList.actionFirst; action; action = action.next)
			{
				action.deactivate();
			}
		}
		
		public function addAction(action:FSMStateAction):FSMStateAction
		{
			if ( action.type == FSMStateAction.ACTION_TYPE_NORMAL )
			{
				normalActionsList.addAction(action);
			}
			else if ( action.type == FSMStateAction.ACTION_TYPE_NO_STEP )
			{
				noStepActionsList.addAction(action);
			}
			
			numActions++;
			
			return action;
		}

		public function removeAction(action:FSMStateAction):void
		{
			if ( action.type == FSMStateAction.ACTION_TYPE_NORMAL )
			{
				normalActionsList.removeAction(action);
			}
			else if ( action.type == FSMStateAction.ACTION_TYPE_NO_STEP )
			{
				noStepActionsList.removeAction(action);
			}
			
			numActions--;
		}
		
		public function registerStateForEventName(eventName:String, state:FSMState):void
		{
			stateForEvent[eventName] = state;
		}
		
		public function unregisterStateForEventName(eventName:String, state:FSMState):void
		{
			stateForEvent[eventName] = state;
		}
		
		public function getStateForEventName(eventName:String):FSMState
		{
			return stateForEvent[eventName] as FSMState;
		}
		
		public function dispose():void
		{
			var action:FSMStateAction;
			
			// no step actions type
			for (action = noStepActionsList.actionFirst; action; action = action.next)
			{
				action.dispose();
			}
			
			// normal actions type
			for (action = normalActionsList.actionFirst; action; action = action.next)
			{
				action.dispose();
			}
			
			normalActionsList.dispose();
			noStepActionsList.dispose();
			
			normalActionsList = null;
			noStepActionsList = null;
			fsm = null;
			name = "";
			numActions = 0;
			stateForEvent = null;
		}
	}

}