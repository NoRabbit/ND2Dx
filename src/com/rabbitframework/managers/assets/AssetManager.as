package com.rabbitframework.managers.assets 
{
	import com.rabbitframework.utils.StringUtils;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequestMethod;
	import flash.system.LoaderContext;
	
	/**
	 * Singleton class
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class AssetManager 
	{
		// our unique instance of this class
		private static var instance:AssetManager = new AssetManager();
		
		public static const FILE_TYPES_LOADER:Array = ["swf", "jpeg", "jpg", "png", "gif"];
		
		public var aGroups:Array = [];
		public var aAssets:Array = [];
		
		private var _preventCache:Boolean = true;
		
		public function AssetManager() 
		{
			if ( instance ) throw new Error( "AssetManager can only be accessed through AssetManager.getInstance()" );
		}
		
		/**
		 * Get unique instance of this singleton class
		 * @return					<AssetManager> Instance of this class
		 */
		public static function getInstance():AssetManager 
		{
			return instance;
		}
		
		public function file_add(id:String, url:String, groupId:String = "", preventCache:Object = null, bytesTotal:int = 0, maxRetries:int = 3, timeOutDelay:int = 3000, method:String = "GET", dataFormat:String = "text", loaderContext:LoaderContext = null):Asset
		{
			// get file type
			var fileType:String = StringUtils.getAfter(url, ".", true).toLowerCase();
			var asset:Asset;
			
			if ( FILE_TYPES_LOADER.indexOf(fileType) >= 0 )
			{
				// loader
				asset = new AssetLoader();
				(asset as AssetLoader).loaderContext = loaderContext;
			}
			else
			{
				// url loader
				asset = new AssetUrlLoader();
			}
			
			asset.init(id, url, false, maxRetries, timeOutDelay);
			asset.bytesTotal = bytesTotal;
			asset.method = method;
			asset.dataFormat = dataFormat;
			
			if ( preventCache == null )
			{
				asset.preventCache = _preventCache;
			}
			else
			{
				asset.preventCache = Boolean(preventCache);
			}
			
			asset_add(asset);
			
			if ( groupId != "" )
			{
				var group:AssetGroup = group_getFromId(groupId, true);
				group.addChild(asset);
			}
			
			return asset;
		}
		
		public function asset_add(asset:Asset):void
		{
			aAssets.push(asset);
		}
		
		public function asset_remove(asset:Asset):void
		{
			var index:int = aAssets.indexOf(asset);
			if ( index >= 0 ) aAssets.splice(index, 1);
		}
		
		public function asset_addToGroup(asset:Asset, groupId:String, createIfNonExistant:Boolean = true):AssetGroup
		{
			var group:AssetGroup = group_getFromId(groupId, createIfNonExistant);
			group.addChild(asset);
			return group;
		}
		
		public function group_getFromId(groupId:String, createIfNonExistant:Boolean = false):AssetGroup
		{
			var i:int = 0;
			var n:int = aGroups.length;
			var group:AssetGroup;
			
			for (i = 0; i < n; i++) 
			{
				group = aGroups[i] as AssetGroup;
				if ( group.id == groupId ) return group;
			}
			
			if ( createIfNonExistant )
			{
				group = new AssetGroup();
				group.id = groupId;
				
				group_add(group);
				
				return group;
			}
			
			return null;
			
		}
		
		public function group_add(group:AssetGroup):void
		{
			aGroups.push(group);
		}
		
		public function group_remove(group:AssetGroup):void
		{
			var index:int = aGroups.indexOf(group);
			if ( index >= 0 ) aGroups.splice(index, 1);
		}
		
		public function group_changeAssetIndex(group:AssetGroup, asset:Asset, index:int = 0):void
		{
			var assetIndex:int = group.aChildren.indexOf(asset);
			group.aChildren.splice(assetIndex, 1);
			group.aChildren.splice(index, 0, asset);
			
			var i:int = 0;
			var n:int = group.aChildren.length;
			
			for (i = 0; i < n; i++) 
			{
				//trace(group.aChildren[i].id);
			}
		}
		
		public function group_getAssetFromId(group:AssetGroup, assetId:String):Asset
		{
			var a:Array = group.aChildren;
			var i:int = 0;
			var n:int = a.length;
			var asset:Asset;
			
			for (i = 0; i < n; i++) 
			{
				if ( a[i] is Asset )
				{
					asset = a[i] as Asset;
					
					if ( asset.id == assetId ) return asset;
				}
			}
			
			return null;
		}
		
		public function get preventCache():Boolean { return _preventCache; }
		
		public function set preventCache(value:Boolean):void 
		{
			_preventCache = value;
		}
	}
	
}