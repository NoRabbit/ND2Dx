package de.nulldesign.nd2dx.resource.mesh 
{
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.assets.AssetUrlLoader;
	import com.rabbitframework.utils.XMLUtils;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Mesh2DFileAllocator extends Mesh2DAllocator
	{
		public var loader:AssetUrlLoader;
		
		public function Mesh2DFileAllocator(filePath:String, freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
			this.filePath = filePath;
			isExternalLoader = true;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( mesh.isAllocating ) return;
			if ( mesh.isLocallyAllocated && !forceAllocation ) return;
			if ( !filePath ) return;
			
			mesh.isAllocating = true;
			
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
			
			mesh.isAllocating = false;
		}
		
		private function loader_completeHandler(e:AssetEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".loader");
			
			var xml:XML = new XML(e.asset.getContent());
			
			if ( xml )
			{
				if ( mesh.vertexList && mesh.vertexList.length ) mesh.vertexList.splice(0, mesh.vertexList.length);
				if ( mesh.indexList && mesh.indexList.length ) mesh.indexList.splice(0, mesh.indexList.length);
				
				var aVertices:Array = XMLUtils.getCleanString(xml.vertices).split(",");
				var aUVs:Array = XMLUtils.getCleanString(xml.uvs).split(",");
				var aIndices:Array = XMLUtils.getCleanString(xml.indices).split(",");
				var aColors:Array = XMLUtils.getCleanString(xml.colors).split(",");
				
				var i:int = 0;
				var n:int = aVertices.length;
				var vertex:Vertex3D;
				
				trace("aVertices", aVertices.length, aVertices);
				trace("aUVs", aUVs.length, aUVs);
				trace("aIndices", aIndices.length, aIndices);
				trace("aColors", aColors.length, aColors);
				
				// positions
				for (; i < n; i+=3) 
				{
					vertex = new Vertex3D(Number(aVertices[i]), Number(aVertices[i + 1]), Number(aVertices[i + 2]));
					mesh.vertexList.push(vertex);
				}
				
				// uvs and colors
				i = 0;
				n = mesh.vertexList.length;
				
				for (; i < n; i++) 
				{
					vertex = mesh.vertexList[i];
					
					vertex.u = Number(aUVs[(i * 2)]);
					vertex.v = Number(aUVs[(i * 2) + 1]);
					
					vertex.r = Number(aColors[(i * 4)]);
					vertex.g = Number(aColors[(i * 4) + 1]);
					vertex.b = Number(aColors[(i * 4) + 2]);
					vertex.a = Number(aColors[(i * 4) + 3]);
					
					trace(vertex);
				}
				
				i = 0;
				n = aIndices.length;
				
				for (; i < n; i++) 
				{
					mesh.indexList.push(uint(aIndices[i]));
				}
			}
			
			loader.dispose();
			loader = null;
			
			mesh.isAllocating = false;
			
			super.allocateLocalResource();
		}
	}

}