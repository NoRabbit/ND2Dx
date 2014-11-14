package com.rabbitframework.signals 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RabbitSignal 
	{
		public var listenerFirst:Listener;
		public var listenerLast:Listener;
		
		public var dListenerForCallback:Dictionary = new Dictionary();
		
		public function RabbitSignal() 
		{
			
		}
		
		public function add(callback:Function, once:Boolean = false):Listener
		{
			var listener:Listener = dListenerForCallback[callback] as Listener;
			
			if ( listener ) return listener;
			
			listener = new Listener(callback, once);
			
			if ( listenerLast )
			{
				listenerLast.next = listener;
				listener.prev = listenerLast;
				listenerLast = listener;
			}
			else
			{
				listenerFirst = listenerLast = listener;
			}
			
			dListenerForCallback[callback] = listener;
			
			return listener;
		}
		
		public function remove(callback:Function):void
		{
			var listener:Listener = dListenerForCallback[callback] as Listener;
			
			if ( listener ) removeListener(listener);
		}
		
		public function removeListener(listener:Listener):void
		{
			if ( listener.prev ) listener.prev.next = listener.next;
			if ( listener.next ) listener.next.prev = listener.prev;
			
			if ( listener == listenerFirst )
			{
				listenerFirst = listener.next;
			}
			
			if ( listener == listenerLast )
			{
				listenerLast = listener.prev;
			}
			
			listener.next = null;
			listener.prev = null;
			
			delete dListenerForCallback[listener.callback];
		}
		
		public function dispatch():void
		{
			for (var listener:Listener = listenerFirst; listener; listener = listener.next)
			{
				listener.callback();
				
				// remove previous listener if it's once (we do this so we can stay in the loop while removing listeners from it)
				if ( listener.prev && listener.prev.once ) removeListener(listener.prev);
			}
			
			// remove last listener if it's once
			if ( listenerLast && listenerLast.once ) removeListener(listenerLast);
		}
		
		public function dispatchData(...args):void
		{
			for (var listener:Listener = listenerFirst; listener; listener = listener.next)
			{
				var length:int = args.length;
				
				if ( length == 1 )
				{
					listener.callback(args[0]);
				}
				else if ( length == 2 )
				{
					listener.callback(args[0], args[1]);
				}
				else if ( length == 3 )
				{
					listener.callback(args[0], args[1], args[2]);
				}
				else if ( length == 4 )
				{
					listener.callback(args[0], args[1], args[2], args[3]);
				}
				else if ( length == 5 )
				{
					listener.callback(args[0], args[1], args[2], args[3], args[4]);
				}
				else
				{
					listener.callback.apply(this, args);
				}
				
				// remove previous listener if it's once (we do this so we can stay in the loop while removing listeners from it)
				if ( listener.prev && listener.prev.once ) removeListener(listener.prev);
			}
			
			// remove last listener if it's once
			if ( listenerLast && listenerLast.once ) removeListener(listenerLast);
		}
	}

}