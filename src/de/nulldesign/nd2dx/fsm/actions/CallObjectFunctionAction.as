package de.nulldesign.nd2dx.fsm.actions 
{
	import de.nulldesign.nd2dx.fsm.FSMStateAction;
	import de.nulldesign.nd2dx.fsm.IFSMVariable;
	import de.nulldesign.nd2dx.utils.FSMTargetUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class CallObjectFunctionAction extends FSMStateAction
	{
		public var target:Object;
		public var functionName:String;
		public var args:Array;
		
		public function CallObjectFunctionAction(target:Object = null, functionName:String = "", args:Array = null, actionOn:int = FSMStateAction.ACTION_ON_ACTIVATE) 
		{
			type = ACTION_TYPE_NO_STEP;
			
			this.target = target;
			this.functionName = functionName;
			this.args = args;
			this.actionOn = actionOn;
		}
		
		override public function onActivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_ACTIVATE ) callFunction();
		}
		
		override public function onDeactivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_DEACTIVATE ) callFunction();
		}
		
		private function callFunction():void
		{
			var targetObject:Object = FSMTargetUtil.getTargetObject(target, this);
			var f:Function = targetObject[functionName] as Function;
			
			if ( f )
			{
				var a:Array;
				
				if ( args )
				{
					a = [];
					
					var i:int = 0;
					var n:int = args.length;
					var o:Object;
					
					for (; i < n; i++) 
					{
						o = args[i];
						
						if ( o is IFSMVariable )
						{
							var fsmVariable:IFSMVariable = o as IFSMVariable;
							a.push(fsmVariable.getValue(this));
						}
						else
						{
							a.push(o);
						}
					}
				}
				
				f.apply(null, a);
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			target = null;
			functionName = "";
			args = null;
		}
	}

}