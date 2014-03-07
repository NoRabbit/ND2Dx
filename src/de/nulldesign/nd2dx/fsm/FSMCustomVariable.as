package de.nulldesign.nd2dx.fsm 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSMCustomVariable implements IFSMVariable
	{
		private var customVariableName:String;
		
		public function FSMCustomVariable(customVariableName:String) 
		{
			this.customVariableName = customVariableName;
		}
		
		public function getValue(action:FSMStateAction):* 
		{
			return action.state.fsm.getCustomVariable(customVariableName);
		}
		
	}

}