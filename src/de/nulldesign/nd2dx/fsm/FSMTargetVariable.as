package de.nulldesign.nd2dx.fsm 
{
	import de.nulldesign.nd2dx.utils.FSMTargetUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSMTargetVariable implements IFSMVariable
	{
		public var target:Object;
		public var variableName:String = "";
		private var targetObject:Object;
		
		public function FSMTargetVariable(target:Object, variableName:String) 
		{
			this.target = target;
			this.variableName = variableName;
		}
		
		public function getValue(action:FSMStateAction):* 
		{
			if ( !targetObject ) targetObject = FSMTargetUtil.getTargetObject(target, action);
			
			if ( targetObject ) return targetObject[propertyName];
			
			return null;
		}
		
	}

}