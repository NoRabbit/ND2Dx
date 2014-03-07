package com.rabbitframework.events 
{
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Thomas John (thomas.john@open-design.be) www.open-design.be
	 */
	public class DataObjectEvent extends Event
	{
		public var data:String;
		public var object:Object;
		
		public function DataObjectEvent(type:String, $data:String, $object:Object, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			data = $data
			object = $object;
		}
		
		override public function clone():Event
		{
			return new DataObjectEvent(super.type, data, object, super.bubbles, super.cancelable);
		}
		
	}
	
}