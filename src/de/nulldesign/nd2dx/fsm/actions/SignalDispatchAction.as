package de.nulldesign.nd2dx.fsm.actions 
{
	import de.nulldesign.nd2dx.fsm.FSMStateAction;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class SignalDispatchAction extends FSMStateAction
	{
		public var signal:Signal;
		public var args:String;
		
		public function SignalDispatchAction(signal:Signal = null, args:String = "", actionOn:int = FSMStateAction.ACTION_ON_ACTIVATE) 
		{
			type = ACTION_TYPE_NO_STEP;
			
			this.signal = signal;
			this.args = args;
			this.actionOn = actionOn;
		}
		
		override public function onActivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_ACTIVATE )
			{
				dispatchSignal();
			}
		}
		
		override public function onDeactivate():void 
		{
			if ( actionOn == FSMStateAction.ACTION_ON_DEACTIVATE )
			{
				dispatchSignal();
			}
		}
		
		private function dispatchSignal():void
		{
			if ( signal )
			{
				if ( args.length > 0 )
				{
					var a:Array = args.split(",");
					if ( a.length <= 0 ) a.push(args);
					signal.dispatch(a);
				}
				else
				{
					signal.dispatch();
				}
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			signal = null;
			args = "";
		}
	}

}