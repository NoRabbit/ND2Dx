package de.nulldesign.nd2dx.signals 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class MouseSignal 
	{
		public var target:Node2D;
		public var currentTarget:Node2D;
		public var type:String;
		public var event:MouseEvent;
		
		public var stopPropagation:Boolean = false;
		
		public function MouseSignal() 
		{
			
		}
		
	}

}