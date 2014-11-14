package com.rabbitframework.managers.assets 
{
	import com.rabbitframework.debug.RabbitDebug;
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.events.EventsManager;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class AssetGroup extends AssetCore implements IAssetGroup
	{
		protected var eManager:EventsManager = EventsManager.getInstance();
		public var eventGroup:String = "";
		
		public var aChildren:Array = [];
		
		protected var _currentLoadingAsset:IAssetCore;
		protected var _maxSimultaneousLoadingAssets:int = 1;
		
		public function AssetGroup() 
		{
			eventGroup = eManager.getUniqueGroupId();
		}
		
		override public function load():void 
		{
			RabbitDebug.log(this, "load", _status, aChildren.length);
			
			if ( _status == Asset.STATUS_COMPLETE || aChildren.length <= 0 )
			{
				dispatchEvent( new AssetEvent(null, this, AssetEvent.GROUP_COMPLETE) );
				return;
			}
			
			if ( _status == Asset.STATUS_LOADING ) return;
			
			status = Asset.STATUS_LOADING;
			
			loadNextAssets();
		}
		
		override public function close():void
		{
			var i:int = 0;
			var n:int = aChildren.length;
			var child:AssetCore;
			
			for (i = 0; i < n; i++) 
			{
				child = aChildren[i] as AssetCore;
				child.close();
			}
			
			status = Asset.STATUS_IDLE;
			
			dispatchEvent( new AssetEvent(null, this, AssetEvent.CLOSE) );
		}
		
		public function loadNextAssets():void
		{
			var i:int = 0;
			var n:int = aChildren.length;
			
			for (i = 0; i < n; i++) 
			{
				if ( !loadNextAsset() ) break;
			}
		}
		
		public function loadNextAsset():Boolean
		{
			if ( totalIdleAssets > 0 && _maxSimultaneousLoadingAssets > totalLoadingAssets )
			{
				// take first in list
				var i:int = 0;
				var n:int = aChildren.length;
				var child:AssetCore;
				
				for (i = 0; i < n; i++) 
				{
					child = aChildren[i] as AssetCore;
					
					if ( child.status == Asset.STATUS_IDLE )
					{
						loadAsset(child);
						return true;
					}
				}
			}
			
			return false;
		}
		
		public function loadAsset(asset:IAssetCore, suspendCurrentLoadingAsset:Boolean = false):void
		{
			if ( _currentLoadingAsset && suspendCurrentLoadingAsset )
			{
				_currentLoadingAsset.close();
			}
			
			_currentLoadingAsset = asset;
			
			asset.load();
		}
		
		public function addChild(child:IAssetCore):void
		{
			//if ( !aChildren ) aChildren = [];
			
			// check if already exists in array
			if ( aChildren.indexOf(child) >= 0 ) return;
			
			aChildren.push(child);
			
			addChildEvents(child);
			
			// add this group to group list of child
			child.addGroup(this);
		}
		
		public function removeChild(child:IAssetCore):void
		{
			if ( aChildren.length <= 0 ) return;
			
			// check if already exists in that group
			var index:int = aChildren.indexOf(child);
			if ( index < 0 ) return;
			
			aChildren.splice(index, 1);
			
			removeChildEvents(child);
			
			// remove this group to group list of child
			child.removeGroup(this);
		}
		
		public function addChildEvents(child:IAssetCore):void
		{
			eManager.add(AssetCore(child), AssetEvent.OPEN, child_openHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.CLOSE, child_closeHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.PROGRESS, child_progressHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.COMPLETE, child_completeHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.HTTP_STATUS, child_httpHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.INIT, child_initHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.UNLOAD, child_unloadHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.IO_ERROR, child_IOErrorHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.SECURITY_ERROR, child_securityErrorHandler, eventGroup);
			eManager.add(AssetCore(child), AssetEvent.TIMEOUT_ERROR, child_timeOutErrorHandler, eventGroup);
		}
		
		public function removeChildEvents(child:IAssetCore):void
		{
			eManager.remove(AssetCore(child), AssetEvent.OPEN, child_openHandler);
			eManager.remove(AssetCore(child), AssetEvent.CLOSE, child_closeHandler);
			eManager.remove(AssetCore(child), AssetEvent.PROGRESS, child_progressHandler);
			eManager.remove(AssetCore(child), AssetEvent.COMPLETE, child_completeHandler);
			eManager.remove(AssetCore(child), AssetEvent.HTTP_STATUS, child_httpHandler);
			eManager.remove(AssetCore(child), AssetEvent.INIT, child_initHandler);
			eManager.remove(AssetCore(child), AssetEvent.UNLOAD, child_unloadHandler);
			eManager.remove(AssetCore(child), AssetEvent.IO_ERROR, child_IOErrorHandler);
			eManager.remove(AssetCore(child), AssetEvent.SECURITY_ERROR, child_securityErrorHandler);
			eManager.remove(AssetCore(child), AssetEvent.TIMEOUT_ERROR, child_timeOutErrorHandler);
			eManager.remove(AssetCore(child), AssetEvent.ERROR, child_errorHandler);
			
		}
		
		public function manageComplete():void
		{
			if ( totalCompletedAssets == totalAssets )
			{
				status = Asset.STATUS_COMPLETE;
				
				// dispatch complete event
				dispatchEvent(new AssetEvent(null, this, AssetEvent.GROUP_COMPLETE, false, false));
			}
			else
			{
				if( status == Asset.STATUS_LOADING ) loadNextAssets();
			}
		}
		
		override public function dispose():void 
		{
			var i:int = 0;
			var n:int = aChildren.length;
			var child:AssetCore;
			
			for (i = 0; i < n; i++) 
			{
				child = aChildren[i] as AssetCore;
				child.dispose();
				removeChildEvents(child);
			}
			
			aChildren.splice(0);
			
			super.dispose();
		}
		
		/**
		 * EVENTS HANDLERS
		 */
		
		protected function child_openHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
		}
		
		protected function child_closeHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
		}
		
        protected function child_progressHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
			dispatchEvent( new AssetEvent(null, this, AssetEvent.GROUP_PROGRESS) );
        }
		
		protected function child_completeHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
			
			manageComplete();
        }
		
		protected function child_httpHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
        }
		
		protected function child_initHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
        }
		
		protected function child_unloadHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
        }
		
        protected function child_IOErrorHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
        }
		
		protected function child_securityErrorHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
        }
		
		protected function child_timeOutErrorHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
		}
		
		private function child_errorHandler(e:AssetEvent):void
		{
			dispatchEvent( e );
			
			// check to see if it is retrying
			if ( e.asset && e.asset.retriesCount < e.asset.maxRetries )
			{
				// yes... let it be
			}
			else
			{
				// no, treat it as it was complete, can't do anything about it, load next one
				manageComplete();
			}
		}
		
		override public function get bytesLoaded():int
		{
			if ( aChildren.length <= 0 ) return 0;
			
			var i:int = 0;
			var n:int = aChildren.length;
			var child:AssetCore;
			
			var res:int = 0;
			
			for (i = 0; i < n; i++) 
			{
				child = aChildren[i] as AssetCore;
				res += child.bytesLoaded;
			}
			
			return res;
		}
		
		override public function get bytesTotal():int
		{
			if ( aChildren.length <= 0 ) return 0;
			
			var i:int = 0;
			var n:int = aChildren.length;
			var child:AssetCore;
			
			var res:int = 0;
			
			for (i = 0; i < n; i++) 
			{
				child = aChildren[i] as AssetCore;
				res += child.bytesTotal;
			}
			
			return res;
		}
		
		public function get currentLoadingAsset():IAssetCore { return _currentLoadingAsset; }
		
		public function get totalAssets():int
		{
			return aChildren.length;
		}
		
		public function get totalLoadingAssets():int
		{
			var i:int = 0;
			var n:int = aChildren.length;
			var child:AssetCore;
			
			var res:int = 0;
			
			for (i = 0; i < n; i++) 
			{
				child = aChildren[i] as AssetCore;
				if ( child.status == Asset.STATUS_LOADING ) res++;
			}
			
			return res;
		}
		
		public function get totalCompletedAssets():int
		{
			var i:int = 0;
			var n:int = aChildren.length;
			var child:AssetCore;
			
			var res:int = 0;
			
			for (i = 0; i < n; i++) 
			{
				child = aChildren[i] as AssetCore;
				if ( child.status == Asset.STATUS_COMPLETE || child.status == Asset.STATUS_ERROR ) res++;
			}
			
			return res;
		}
		
		public function get totalIdleAssets():int
		{
			var i:int = 0;
			var n:int = aChildren.length;
			var child:AssetCore;
			
			var res:int = 0;
			
			for (i = 0; i < n; i++) 
			{
				child = aChildren[i] as AssetCore;
				if ( child.status == Asset.STATUS_IDLE ) res++;
			}
			
			return res;
		}
		
		public function get maxSimultaneousLoadingAssets():int { return _maxSimultaneousLoadingAssets; }
		
		public function set maxSimultaneousLoadingAssets(value:int):void 
		{
			_maxSimultaneousLoadingAssets = value;
		}
		
		
		
	}
	
}