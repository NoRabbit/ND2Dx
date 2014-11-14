package com.rabbitframework.managers.assets 
{
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.utils.FileUtils;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class AssetLoader extends Asset
	{
		public var loader:Loader;
		public var loaderContext:LoaderContext;
		
		
		public function AssetLoader() 
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
				
				loader.unload();
				
				try
				{
					loader.close();
				}
				catch (e:*)
				{
					
				}
			}
			
			loader = new Loader();
			
			addLoaderEvents();
			
			urlRequest = new URLRequest(_url);
			urlRequest.method = _method;
			
			if ( _preventCache && !FileUtils.isLocal(_url) )
			{
				variables.preventCache = _preventCacheId;
			}
			
			if ( _variables )
			{
				urlRequest.data = _variables;
			}
			
			status = Asset.STATUS_LOADING;
			
			loader.load(urlRequest, loaderContext);
			
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
			
			eManager.add(loader.contentLoaderInfo, Event.OPEN, loader_openHandler, eventGroup);
			eManager.add(loader.contentLoaderInfo, ProgressEvent.PROGRESS, loader_progressHandler, eventGroup);
			eManager.add(loader.contentLoaderInfo, Event.COMPLETE, loader_completeHandler, eventGroup);
			eManager.add(loader.contentLoaderInfo, HTTPStatusEvent.HTTP_STATUS, loader_httpHandler, eventGroup);
			eManager.add(loader.contentLoaderInfo, IOErrorEvent.IO_ERROR, loader_IOErrorHandler, eventGroup);
			eManager.add(loader.contentLoaderInfo, Event.INIT, loader_initHandler, eventGroup);
			eManager.add(loader.contentLoaderInfo, Event.UNLOAD, loader_unloadHandler, eventGroup);
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
				return loader.content;
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
				
				loader.unload();
			}
			
			loader = null;
			
			super.dispose();
		}
	}
	
}