package com.rabbitframework.managers.assets 
{
	import com.rabbitframework.debug.RabbitDebug;
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.utils.FileUtils;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class AssetUrlLoader extends Asset
	{
		public var loader:URLLoader;
		
		public function AssetUrlLoader() 
		{
			
		}
		
		override public function load():void 
		{
			if ( _status == STATUS_COMPLETE )
			{
				dispatchEvent( new AssetEvent(this, null, AssetEvent.COMPLETE) );
				return;
			}
			
			if ( _status == STATUS_LOADING ) return;
			
			if ( loader )
			{
				removeLoaderEvents();
				
				try
				{
					loader.close();
				}
				catch (e:*)
				{
					
				}
			}
			
			urlRequest = new URLRequest(_url);
			urlRequest.method = _method;
			
			if ( _preventCache && !FileUtils.isLocal(_url) )
			{
				variables.preventCache = _preventCacheId
				RabbitDebug.log("not local:", _url, "variables.preventCache", variables.preventCache);
			}
			
			if ( _variables )
			{
				urlRequest.data = _variables;
			}
			
			loader = new URLLoader(urlRequest);
			loader.dataFormat = _dataFormat;
			
			addLoaderEvents();
			
			status = Asset.STATUS_LOADING;
			
			loader.load(urlRequest);
			
			timerTimeOut.reset();
			timerTimeOut.start();
		}
		
		override public function close():void 
		{
			if ( loader )
			{
				try
				{
					loader.close();
				}
				catch (e:*)
				{
					
				}
			}
			
			if ( status == Asset.STATUS_LOADING || status == Asset.STATUS_ERROR )
			{
				status = Asset.STATUS_IDLE;
			}
			
			dispatchEvent( new AssetEvent(this, null, AssetEvent.CLOSE) );
		}
		
		override public function addLoaderEvents():void 
		{
			if ( !loader ) return;
			
			eManager.add(loader, Event.OPEN, loader_openHandler, eventGroup);
			eManager.add(loader, ProgressEvent.PROGRESS, loader_progressHandler, eventGroup);
			eManager.add(loader, Event.COMPLETE, loader_completeHandler, eventGroup);
			eManager.add(loader, HTTPStatusEvent.HTTP_STATUS, loader_httpHandler, eventGroup);
			eManager.add(loader, IOErrorEvent.IO_ERROR, loader_IOErrorHandler, eventGroup);
			eManager.add(loader, SecurityErrorEvent.SECURITY_ERROR, loader_securityErrorHandler, eventGroup);
		}
		
		override public function removeLoaderEvents():void 
		{
			if ( !loader ) return;
			
			eManager.removeAllFromDispatcher(loader);
		}
		
		override public function getContent():*
		{
			if ( loader )
			{
				return loader.data;
			}
			
			return null;
		}
		
		override public function dispose():void 
		{
			if ( loader )
			{
				try
				{
					loader.close();
				}
				catch (e:*)
				{
					
				}
			}
			
			loader = null;
			
			super.dispose();
		}
	}
	
}