package de.nulldesign.nd2dx.fsm.actions 
{
	import de.nulldesign.nd2dx.components.ComponentBase;
	import de.nulldesign.nd2dx.fsm.FSMStateAction;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DeactivateComponentAction extends FSMStateAction
	{
		public var component:ComponentBase;
		
		public function DeactivateComponentAction(component:ComponentBase = null, actionOn:int = FSMStateAction.ACTION_ON_ACTIVATE) 
		{
			type = ACTION_TYPE_NO_STEP;
			this.component = component;
			this.actionOn = actionOn;
		}
		
		override public function onActivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_ACTIVATE && component ) component.isActive = false;
		}
		
		override public function onDeactivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_DEACTIVATE && component ) component.isActive = false;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			component = null;
		}
	}

}