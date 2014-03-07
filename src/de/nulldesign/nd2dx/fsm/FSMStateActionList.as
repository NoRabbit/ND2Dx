package de.nulldesign.nd2dx.fsm 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSMStateActionList 
	{
		public var state:FSMState;
		
		public var numActions:int = 0;
		public var actionFirst:FSMStateAction;
		public var actionLast:FSMStateAction;
		
		public function FSMStateActionList(state:FSMState) 
		{
			this.state = state;
		}
		
		protected function unlinkAction(action:FSMStateAction):void
		{
			if (action.prev)
			{
				action.prev.next = action.next;
			}
			else
			{
				actionFirst = action.next;
			}
			
			if (action.next)
			{
				action.next.prev = action.prev;
			}
			else
			{
				actionLast = action.prev;
			}
			
			action.prev = null;
			action.next = null;
		}
		
		public function addAction(action:FSMStateAction):FSMStateAction
		{
			if ( action.state == state ) return action;
			
			if (action.state) action.state.removeAction(action);
			
			action.state = state;
			
			if (actionLast)
			{
				action.prev = actionLast;
				actionLast.next = action;
				actionLast = action;
			}
			else
			{
				actionFirst = action;
				actionLast = action;
			}
			
			numActions++;
			
			return action;
		}

		public function removeAction(action:FSMStateAction):void
		{
			if (action.state != state) return;
			
			unlinkAction(action);
			
			action.state = null;
			
			numActions--;
		}
		
		public function dispose():void
		{
			state = null;
			actionFirst = null;
			actionLast = null;
			numActions = 0;
		}
	}

}