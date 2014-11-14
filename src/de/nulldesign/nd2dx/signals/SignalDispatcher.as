package de.nulldesign.nd2dx.signals {
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class SignalDispatcher
	{
		public var dSignalForType:Dictionary = new Dictionary(true);
		
		public function SignalDispatcher() 
		{
			
		}
		
		public function addSignalListener(type:String, callback:Function, once:Boolean = false):void 
		{
			getSignal(type).add(callback, once);
		}
		
		public function removeSignalListener(type:String, callback:Function):void 
		{
			var signal:Signal = dSignalForType[type] as Signal;
			
			if ( signal )
			{
				signal.remove(callback);
				
				if( signal.numListeners <= 0 ) delete dSignalForType[type];
			}
		}
		
		public function removeAllSignalListeners():void
		{
			dSignalForType = new Dictionary();
		}
		
		public function dispatchSignal(type:String, ...args):void 
		{
			var signal:Signal = dSignalForType[type] as Signal;
			
			if ( signal ) signal.dispatchData.apply(this, args);
		}
		
		public function getSignal(type:String):Signal
		{
			var signal:Signal = dSignalForType[type] as Signal;
			
			if ( !signal )
			{
				dSignalForType[type] = signal = new Signal();
			}
			
			return signal;
		}
	}

}