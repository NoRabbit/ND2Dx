package com.rabbitframework.signals
{
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
			getSignal(type, true).add(callback, once);
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
			
			if ( signal )
			{
				if ( args.length )
				{
					signal.dispatchData.apply(this, args);
				}
				else
				{
					signal.dispatch();
				}
			}
		}
		
		public function getSignal(type:String, createIfNeeded:Boolean = false):Signal
		{
			var signal:Signal = dSignalForType[type] as Signal;
			
			if ( !signal && createIfNeeded )
			{
				dSignalForType[type] = signal = new Signal();
			}
			
			return signal;
		}
	}

}