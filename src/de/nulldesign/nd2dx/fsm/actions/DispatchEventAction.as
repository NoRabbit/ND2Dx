package de.nulldesign.nd2dx.fsm.actions 
{
	import de.nulldesign.nd2dx.fsm.FSMStateAction;
	import de.nulldesign.nd2dx.fsm.FSMEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DispatchEventAction extends FSMStateAction
	{
		public var sendEvent:FSMEvent;
		public var delay:Number = 0.0;
		
		public function DispatchEventAction(sendEvent:FSMEvent = null, actionOn:int = FSMStateAction.ACTION_ON_ACTIVATE, delay:Number = 0.0) 
		{
			type = ACTION_TYPE_NO_STEP;
			
			this.sendEvent = sendEvent;
			this.actionOn = actionOn;
			this.delay = delay;
		}
		
		override public function onActivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_ACTIVATE && sendEvent )
			{
				dispatchEvent(sendEvent, delay);
			}
		}
		
		override public function onDeactivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_DEACTIVATE && sendEvent )
			{
				dispatchEvent(sendEvent, delay);
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			sendEvent = null;
		}
	}

}