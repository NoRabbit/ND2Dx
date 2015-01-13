package de.nulldesign.nd2dx.resource.texture 
{
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.assets.AssetUrlLoader;
	import de.nulldesign.nd2dx.signals.SignalTypes;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AtlasFileAllocator extends AtlasAllocator
	{
		public var loader:AssetUrlLoader;
		
		public function AtlasFileAllocator(filePath:String, texture:Object, parserClass:Class, freeLocalResourceAfterRemoteAllocation:Boolean=false) 
		{
			super(null, texture, parserClass, freeLocalResourceAfterRemoteAllocation);
			this.filePath = filePath;
			isExternalLoader = true;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( atlas.isAllocating ) return;
			if ( atlas.isLocallyAllocated && !forceAllocation ) return;
			if ( !filePath ) return;
			
			atlas.isAllocating = true;
			
			eManager.removeAllFromGroup(eGroup + ".loader");
			
			if ( loader ) loader.dispose();
			loader = new AssetUrlLoader();
			loader.init("", resourceManager.getResourceFilePathWithContentScaleFactorFileExtension(filePath));
			
			eManager.add(loader, AssetEvent.COMPLETE, loader_completeHandler, [eGroup, eGroup + ".loader"]);
			eManager.add(loader, AssetEvent.ERROR, loader_errorHandler, [eGroup, eGroup + ".loader"]);
			
			if ( assetGroup )
			{
				assetGroup.addChild(loader);
			}
			else
			{
				loader.load();
			}
		}
		
		private function loader_errorHandler(e:AssetEvent):void 
		{
			loader.dispose();
			loader = null;
			
			atlas.isAllocating = false;
			atlas.dispatchSignal(SignalTypes.RESOURCE_LOCAL_ALLOCATION_ERROR);
		}
		
		private function loader_completeHandler(e:AssetEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".loader");
			
			xml = new XML(e.asset.getContent());
			
			loader.dispose();
			loader = null;
			
			atlas.isAllocating = false;
			
			super.allocateLocalResource();
		}
	}

}