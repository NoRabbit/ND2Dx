package de.nulldesign.nd2dx.resource.font 
{
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.assets.AssetUrlLoader;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DStyleFileAllocator extends BitmapFont2DStyleAllocator
	{
		public var loader:AssetUrlLoader;
		
		public function BitmapFont2DStyleFileAllocator(filePath:String, texture:Object, freeLocalResourceAfterAllocated:Boolean=false) 
		{
			super(null, texture, freeLocalResourceAfterAllocated);
			this.filePath = filePath;
			isExternalLoader = true;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( bitmapFont2DStyle.isAllocating ) return;
			bitmapFont2DStyle.isAllocating = true;
			
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
			
			bitmapFont2DStyle.onLocalAllocationError.dispatch();
		}
		
		private function loader_completeHandler(e:AssetEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".loader");
			
			xml = new XML(e.asset.getContent());
			
			loader.dispose();
			loader = null;
			
			bitmapFont2DStyle.isAllocating = false;
			
			super.allocateLocalResource();
		}
	}

}