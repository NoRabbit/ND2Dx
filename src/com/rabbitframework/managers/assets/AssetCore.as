package com.rabbitframework.managers.assets 
{
	import com.rabbitframework.utils.StringUtils;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class AssetCore extends EventDispatcher implements IAssetCore
	{
		protected var _id:String;
		protected var _status:int = Asset.STATUS_IDLE;
		
		protected var _bytesLoaded:int = 0;
		protected var _bytesTotal:int = 0;
		
		protected var _preventCache:Boolean;
		protected var _preventCacheId:String;
		
		// groups
		public var aGroups:Array;
		
		// destroyed
		protected var _disposed:Boolean = false;
		
		
		public function AssetCore() 
		{
			
		}
		
		public function load():void
		{
			
		}
		
		public function close():void
		{
			
		}
		
		public function addGroup(group:IAssetGroup):void
		{
			if ( !aGroups ) aGroups = new Array();
			
			// check if already exists in that group
			if ( aGroups.indexOf(group) >= 0 ) return;
			
			aGroups.push(group);
		}
		
		public function removeGroup(group:IAssetGroup):void
		{
			if ( !aGroups ) return;
			
			// check if already exists in that group
			var index:int = aGroups.indexOf(group);
			if ( index < 0 ) return;
			
			aGroups.splice(index, 1);
		}
		
		public function isInGroupId(groupId:String):Boolean
		{
			if ( !aGroups ) return false;
			
			var i:int = 0;
			var n:int = aGroups.length;
			var group:IAssetGroup;
			
			for (i = 0; i < n; i++) 
			{
				group = aGroups[i] as IAssetGroup;
				if ( group.id == groupId ) return true;
			}
			
			return false;
		}
		
		public function dispose():void
		{
			if( aGroups ) aGroups.splice(0);
			
			_disposed = true;
		}
		
		public function get id():String { return _id; }
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get bytesLoaded():int { return _bytesLoaded; }
		
		public function get bytesTotal():int { return _bytesTotal; }
		
		public function set bytesTotal(value:int):void 
		{
			_bytesTotal = value;
		}
		
		public function get percentLoaded():Number
		{
			if ( bytesTotal <= 0 ) return 0.0;
			if ( bytesLoaded <= 0 ) return 0.0;
			
			var prct:Number = bytesLoaded / bytesTotal;
			if ( prct < 0 ) prct = 0;
			if ( prct > 1 ) prct = 1;
			
			return prct * 100;
		}
		
		public function get disposed():Boolean { return _disposed; }
		
		public function get status():int { return _status; }
		
		public function set status(value:int):void 
		{
			_status = value;
		}
		
		public function get preventCache():Boolean { return _preventCache; }
		
		public function set preventCache(value:Boolean):void 
		{
			_preventCache = value;
			
			if ( _preventCache )
			{
				preventCacheId = StringUtils.generateRandomString(8);
			}
		}
		
		public function get preventCacheId():String { return _preventCacheId; }
		
		public function set preventCacheId(value:String):void 
		{
			_preventCacheId = value;
		}
		
		
	}
	
}