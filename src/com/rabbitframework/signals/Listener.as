package com.rabbitframework.signals 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Listener 
	{
		public var prev:Listener;
		public var next:Listener;
		
		public var callback:Function;
		public var once:Boolean = false;
		
		public function Listener(callback:Function, once:Boolean = false) 
		{
			this.callback = callback;
			this.once = once;
		}
		
	}

}