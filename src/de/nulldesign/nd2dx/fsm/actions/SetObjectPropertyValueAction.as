package de.nulldesign.nd2dx.fsm.actions 
{
	import de.nulldesign.nd2dx.fsm.FSMStateAction;
	import de.nulldesign.nd2dx.utils.FSMTargetUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class SetObjectPropertyValueAction extends FSMStateAction
	{
		public var target:Object;
		public var propertyName:String = "";
		public var value:Object;
		
		public function SetObjectPropertyValueAction(target:Object = null, propertyName:String = "", value:Object = null, actionOn:int = FSMStateAction.ACTION_ON_ACTIVATE) 
		{
			type = ACTION_TYPE_NO_STEP;
			
			this.target = target;
			this.propertyName = propertyName;
			this.value = value;
			this.actionOn = actionOn;
		}
		
		override public function onActivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_ACTIVATE ) setObjectPropertyValue();
		}
		
		override public function onDeactivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_DEACTIVATE ) setObjectPropertyValue();
		}
		
		private function setObjectPropertyValue():void
		{
			if ( target )
			{
				var targetObject:Object = FSMTargetUtil.getTargetObject(target, this);
				targetObject[propertyName] = value;
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			target = null;
			propertyName = "";
			value = null;
		}
	}

}