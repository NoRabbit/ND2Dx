package com.rabbitframework.net 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.navigateToURL;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Thomas John (thomas.john@open-design.be) www.open-design.be
	 */
	public class SendVars extends EventDispatcher
	{
		public var request:URLRequest;
		public var loader:URLLoader;
		public var dataToSend:URLVariables;
		public var dataFormat:String = URLLoaderDataFormat.TEXT;
		
		public var url:String;
		
		public function SendVars($url:String, method:String=URLRequestMethod.GET, dataFormat:String = URLLoaderDataFormat.TEXT ) 
		{
			url = $url;
			request = new URLRequest(url);
			dataToSend = new URLVariables();
			request.method = method;
			this.dataFormat = dataFormat;
		}
		
		public function addData(name:String, data:String):void
		{
			dataToSend[name] = data;
		}
		
		public function navigateToUrl(window:String="_self"):void
		{
			request.data = dataToSend;
			navigateToURL(request, window);
		}
		
		public function sendAndLoadData():void
		{
			request.data = dataToSend;
			
			loader = new URLLoader(request);
			
			loader.dataFormat = dataFormat;
			
			loader.addEventListener( Event.OPEN, dataOpen );
			loader.addEventListener( ProgressEvent.PROGRESS, dataProgress );
			loader.addEventListener( Event.COMPLETE, dataComplete );
			loader.addEventListener( HTTPStatusEvent.HTTP_STATUS, dataHttp );
			loader.addEventListener( IOErrorEvent.IO_ERROR, dataIOError );
			loader.addEventListener( SecurityErrorEvent.SECURITY_ERROR, dataSecurityError );
			
			loader.load(request);
		}
		
		// when file is opened
		private function dataOpen(e:Event):void
		{
			
		}
		
		// when file is downloading
        private function dataProgress(e:ProgressEvent):void
		{
			
		}
		
		// when file is downloaded
		private function dataComplete(e:Event):void
		{
			dispatchComplete();
		}
		
		// when a HTTP status is received
		private function dataHttp(e:HTTPStatusEvent):void
		{
			
		}
		
		// when In Out error occurs
        private function dataIOError(e:IOErrorEvent):void
		{
			dispatchError();
		}
		
		// when access security error occurs
		private function dataSecurityError(e:SecurityErrorEvent):void
		{
			dispatchError();
		}
		
		private function dispatchError():void
		{
			//Debug.log("SendVars data error");
			dispatchEvent( new Event(Event.CANCEL) );
		}
		
		private function dispatchComplete():void
		{
			//Debug.log("SendVars data complete: " + loader.data);
			dispatchEvent( new Event(Event.COMPLETE) );
		}
	}
	
}