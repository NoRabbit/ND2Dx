package com.rabbitframework.animator.system 
{
	import com.rabbitframework.easing.Elastic;
	import com.rabbitframework.easing.Linear;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RASystemObjectPropertyKey 
	{
		public var parent:RASystemObjectProperty;
		
		public var time:Number;
		public var value:Number;
		public var ease:Function = Linear.easeNone;
		//public var ease:Function = Elastic.easeInOut;
		
		public var prev:RASystemObjectPropertyKey;
		public var next:RASystemObjectPropertyKey;
		
		public function RASystemObjectPropertyKey() 
		{
			
		}
		
		public function toString():String
		{
			return "[" + time + ", " + value + "]";
		}
		
		public function getXMLData():XML
		{
			var xml:XML  = 
			<key>
				<time>{time}</time>
				<value>{value}</value>
				<ease>{ease}</ease>
			</key>;
			
			return xml;
		}
		
		public function setXMLData(xml:XML):void
		{
			//trace(this, "setXMLData", xml);
			time = xml.time;
			value = xml.value;
			//time = xml.time;
		}
		
		public function dispose():void
		{
			prev = next = null;
			ease = null;
		}
	}

}