package de.nulldesign.nd2dx.resource.texture 
{
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.assets.AssetLoader;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Texture2DBitmapFileAllocator extends Texture2DAllocator
	{
		public var loader:AssetLoader;
		
		public function Texture2DBitmapFileAllocator(filePath:String, freeLocalResourceAfterAllocated:Boolean = false) 
		{
			super(freeLocalResourceAfterAllocated);
			this.filePath = filePath;
			isExternalLoader = true;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( texture2D.isAllocating ) return;
			if ( !filePath ) return;
			
			texture2D.isAllocating = true;
			
			eManager.removeAllFromGroup(eGroup + ".loader");
			
			if ( loader ) loader.dispose();
			loader = new AssetLoader();
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
			
			texture2D.onLocalAllocationError.dispatch();
		}
		
		private function loader_completeHandler(e:AssetEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".loader");
			
			var bitmap:Bitmap = e.asset.getContent() as Bitmap;
			
			if ( bitmap )
			{
				bitmapData = bitmap.bitmapData;
			}
			
			loader.dispose();
			loader = null;
			
			texture2D.isAllocating = false;
			
			super.allocateLocalResource();
		}
	}

}