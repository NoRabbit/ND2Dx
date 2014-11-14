package de.nulldesign.nd2dx.signals {
	/**
	 * ...
	 * @author Thomas John
	 */
	public class SignalListener 
	{
		public var prev:SignalListener;
		public var next:SignalListener;
		
		public var callback:Function;
		public var once:Boolean = false;
		
		public function SignalListener(callback:Function, once:Boolean = false) 
		{
			this.callback = callback;
			this.once = once;
		}
		
	}

}