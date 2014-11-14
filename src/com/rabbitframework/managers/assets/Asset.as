package com.rabbitframework.managers.assets 
{
	import com.rabbitframework.debug.RabbitDebug;
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.events.EventsManager;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class Asset extends AssetCore implements IAsset
	{
		public static const STATUS_IDLE:int = 0;
		public static const STATUS_LOADING:int = 1;
		public static const STATUS_COMPLETE:int = 2;
		public static const STATUS_ERROR:int = -1;
		
		protected var eManager:EventsManager = EventsManager.getInstance();
		public var eventGroup:String = "";
		
		protected var _url:String;
		protected var _httpStatus:int;
		
		// time out & retries
		public var timerTimeOut:Timer = new Timer(3000);
		
		protected var _retriesCount:int = 0;
		protected var _maxRetries:int = 0;
		
		public var startTime:int;
		public var endTime:int;
		
		public var urlRequest:URLRequest;
		public var urlVariables:URLVariables;
		
		protected var _method:String = URLRequestMethod.GET;
		protected var _dataFormat:String = URLLoaderDataFormat.TEXT;
		protected var _variables:URLVariables;
		
		public function Asset() 
		{
			eventGroup = eManager.getUniqueGroupId();
			
			eManager.add(timerTimeOut, TimerEvent.TIMER, timerTimeOut_timerHandler, eventGroup);
		}
		
		public function init(id:String, url:String, autoStartLoad:Boolean = false, maxRetries:int = 3, timeOutDelay:int = 10000):void
		{
			//RabbitDebug.log(this, "init", id, url);
			this.id = id;
			this.url = url;
			this.maxRetries = maxRetries;
			this.timeOutDelay = timeOutDelay;
			
			if ( autoStartLoad ) load();
		}
		
		override public function toString():String 
		{
			return "[object Asset] {" + id + ", " + url + ", " + aGroups + "}";
		}
		
		public function addLoaderEvents():void
		{
			
		}
		
		public function removeLoaderEvents():void
		{
			
		}
		
		public function getContent():*
		{
			
		}
		
		override public function dispose():void 
		{
			eManager.removeAllFromGroup(eventGroup);
			super.dispose();
		}
		
		/**
		 * EVENTS HANDLERS
		 */
		
		protected function loader_openHandler(e:Event):void
		{
			//RabbitDebug.log(this, "loader_openHandler", e);
			startTime = getTimer();
			
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.OPEN, e.bubbles, e.cancelable) );
		}
		
        protected function loader_progressHandler(e:ProgressEvent):void
		{
			//RabbitDebug.log(this, "loader_progressHandler", e);
			timerTimeOut.stop();
			
			endTime = getTimer();
			
			if ( e.bytesTotal > 0 ) _bytesTotal = e.bytesTotal;
			_bytesLoaded = e.bytesLoaded;
			
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.PROGRESS, e.bubbles, e.cancelable) );
        }
		
		protected function loader_completeHandler(e:Event):void
		{
			//RabbitDebug.log(this, "loader_completeHandler", e);
			timerTimeOut.stop();
			
			endTime = getTimer();
			
			status = STATUS_COMPLETE;
			
			removeLoaderEvents();
			
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.COMPLETE, e.bubbles, e.cancelable) );
        }
		
		protected function loader_httpHandler(e:HTTPStatusEvent):void
		{
			//RabbitDebug.log(this, "loader_httpHandler", e);
			_httpStatus = e.status;
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.HTTP_STATUS, e.bubbles, e.cancelable) );
        }
		
		protected function loader_initHandler(e:Event):void
		{
			//RabbitDebug.log(this, "loader_initHandler", e);
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.INIT, e.bubbles, e.cancelable) );
        }
		
		protected function loader_unloadHandler(e:Event):void
		{
			//RabbitDebug.log(this, "loader_unloadHandler", e);
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.UNLOAD, e.bubbles, e.cancelable) );
        }
		
        protected function loader_IOErrorHandler(e:IOErrorEvent):void
		{
			//RabbitDebug.log(this, "loader_IOErrorHandler", e);
			manageErrors();
			
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.IO_ERROR, e.bubbles, e.cancelable) );
        }
		
		protected function loader_securityErrorHandler(e:SecurityErrorEvent):void
		{
			//RabbitDebug.log(this, "loader_securityErrorHandler", e);
			manageErrors();
			
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.SECURITY_ERROR, e.bubbles, e.cancelable) );
        }
		
		protected function timerTimeOut_timerHandler(e:TimerEvent):void
		{
			//RabbitDebug.log(this, "timerTimeOut_timerHandler", e);
			manageErrors();
			
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.TIMEOUT_ERROR, e.bubbles, e.cancelable) );
		}
		
		private function manageErrors():void
		{
			timerTimeOut.stop();
			
			endTime = getTimer();
			
			status = STATUS_ERROR;
			
			dispatchEvent( new AssetEvent(this, null,  AssetEvent.ERROR) );
			
			if ( _retriesCount < _maxRetries )
			{
				_retriesCount ++;
				load();
			}
			else
			{
				removeLoaderEvents();
			}
		}
		
		public function get retriesCount():int { return _retriesCount; }
		
		public function set retriesCount(value:int):void 
		{
			_retriesCount = value;
		}
		
		public function get maxRetries():int { return _maxRetries; }
		
		public function set maxRetries(value:int):void 
		{
			_maxRetries = value;
		}
		
		public function get timeOutDelay():Number { return timerTimeOut.delay; }
		
		public function set timeOutDelay(value:Number):void 
		{
			timerTimeOut.delay = value;
		}
		
		public function get url():String { return _url; }
		
		public function set url(value:String):void 
		{
			_url = value;
		}
		
		public function get transferSpeed():Number
		{
			if ( _bytesLoaded <= 0 ) return 0;
			if ( endTime <= startTime ) return 0;
			
			return _bytesLoaded / ((endTime - startTime) * 0.001);
		}
		
		public function get httpStatus():int { return _httpStatus; }
		
		public function get method():String { return _method; }
		
		public function set method(value:String):void 
		{
			_method = value;
		}
		
		public function get dataFormat():String { return _dataFormat; }
		
		public function set dataFormat(value:String):void 
		{
			_dataFormat = value;
		}
		
		public function get variables():URLVariables 
		{
			if ( !_variables ) _variables = new URLVariables();
			return _variables;
		}
		
		public function set variables(value:URLVariables):void 
		{
			_variables = value;
		}
		
		
	}
	
}