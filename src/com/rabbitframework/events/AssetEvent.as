package com.rabbitframework.events 
{
	import com.rabbitframework.managers.assets.Asset;
	import com.rabbitframework.managers.assets.AssetGroup;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class AssetEvent extends Event
	{
		// static events
		public static const OPEN:String = "com.rabbitframework.events.AssetEvent.Open";
		public static const CLOSE:String = "com.rabbitframework.events.AssetEvent.Close";
		public static const PROGRESS:String = "com.rabbitframework.events.AssetEvent.Progress";
		public static const GROUP_PROGRESS:String = "com.rabbitframework.events.AssetEvent.GroupProgress";
		public static const COMPLETE:String = "com.rabbitframework.events.AssetEvent.Complete";
		public static const GROUP_COMPLETE:String = "com.rabbitframework.events.AssetEvent.GroupComplete";
		public static const INIT:String = "com.rabbitframework.events.AssetEvent.Init";
		public static const UNLOAD:String = "com.rabbitframework.events.AssetEvent.Unload";
		public static const HTTP_STATUS:String = "com.rabbitframework.events.AssetEvent.HTTPStatus";
		public static const IO_ERROR:String = "com.rabbitframework.events.AssetEvent.IOError";
		public static const SECURITY_ERROR:String = "com.rabbitframework.events.AssetEvent.SecurityError";
		public static const TIMEOUT_ERROR:String = "com.rabbitframework.events.AssetEvent.TimeOutError";
		public static const ERROR:String = "com.rabbitframework.events.AssetEvent.Error";
		
		// asset if an asset is dispatching the event
		public var asset:Asset = null;
		
		// group if a group is dispatching the event
		public var group:AssetGroup = null;
		
		public function AssetEvent(asset:Asset, group:AssetGroup, type:String, bubbles:Boolean = false, cancelable:Boolean = false) 
		{
			super(type, bubbles, cancelable);
			this.asset = asset;
			this.group = group;
		}
		
		override public function clone():Event
		{
			return new AssetEvent(asset, group, type, bubbles, cancelable);
		}
	}
	
}