package de.nulldesign.nd2dx.resource.shader 
{
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.assets.AssetUrlLoader;
	import com.rabbitframework.utils.StringUtils;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Shader2DXMLFileAllocator extends Shader2DXMLAllocator
	{
		public var loader:AssetUrlLoader;
		
		public function Shader2DXMLFileAllocator(filePath:String) 
		{
			this.filePath = filePath;
			isExternalLoader = true;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( shader.isAllocating ) return;
			if ( !filePath ) return;
			
			shader.isAllocating = true;
			
			eManager.removeAllFromGroup(eGroup + ".loader");
			
			if ( loader ) loader.dispose();
			loader = new AssetUrlLoader();
			loader.init("", filePath);
			
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
			
			shader.onLocalAllocationError.dispatch();
		}
		
		private function loader_completeHandler(e:AssetEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".loader");
			
			var xml:XML = new XML(e.asset.getContent());
			
			setDataFromXML(xml);
			
			loader.dispose();
			loader = null;
			
			shader.isAllocating = false;
		}
	}

}