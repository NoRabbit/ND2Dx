package de.nulldesign.nd2dx.resource.mesh 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	import flash.display3D.Context3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Mesh2DAllocator extends ResourceAllocatorBase
	{
		public var mesh:Mesh2D;
		
		public var mIndexBuffer:Vector.<uint> = null;
		public var mVertexBuffer:Vector.<Number> = null;
		
		public var isDataPreparedForRemoteAllocation:Boolean = false;
		
		public function Mesh2DAllocator(freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( mesh.isLocallyAllocated && !forceAllocation ) return;
			
			isDataPreparedForRemoteAllocation = false;
			
			mesh.isLocallyAllocated = true;
			
			if ( mesh.isLocallyAllocated && freeLocalResourceAfterRemoteAllocation ) freeLocalResource();
		}
		
		override public function freeLocalResource():void 
		{
			if ( mesh.vertexList && mesh.vertexList.length  ) mesh.vertexList.splice(0, mesh.vertexList.length);
			if ( mesh.indexList && mesh.indexList.length  ) mesh.indexList.splice(0, mesh.indexList.length);
			
			if ( mIndexBuffer && mIndexBuffer.length  ) mIndexBuffer.splice(0, mIndexBuffer.length);
			if ( mVertexBuffer && mVertexBuffer.length  ) mVertexBuffer.splice(0, mVertexBuffer.length);
			
			mesh.isLocallyAllocated = false;
		}
		
		override public function allocateRemoteResource(context:Context3D, forceAllocation:Boolean = false):void 
		{
			if ( mesh.isRemotelyAllocated && !forceAllocation ) return;
			
			if ( !isDataPreparedForRemoteAllocation ) prepareDataForRemoteAllocation();
			
			if ( mesh.vertexBuffer ) mesh.vertexBuffer.dispose();
			mesh.vertexBuffer = context.createVertexBuffer(mesh.numVertices, mesh.numFloatsPerVertex);
			mesh.vertexBuffer.uploadFromVector(mVertexBuffer, 0, mesh.numVertices);
			
			if ( mesh.indexBuffer ) mesh.indexBuffer.dispose();
			mesh.indexBuffer = context.createIndexBuffer(mesh.numIndices);
			mesh.indexBuffer.uploadFromVector(mIndexBuffer, 0, mesh.numIndices);
			
			mesh.isRemotelyAllocated = true;
		}
		
		override public function freeRemoteResource():void 
		{
			if ( mesh.vertexBuffer ) mesh.vertexBuffer.dispose();
			if ( mesh.indexBuffer ) mesh.indexBuffer.dispose();
			
			mesh.vertexBuffer = null;
			mesh.indexBuffer = null;
		}
		
		public function prepareDataForRemoteAllocation():void
		{
			mIndexBuffer = mesh.indexList;
			mVertexBuffer = new Vector.<Number>();
			
			var i:int = 0;
			var n:int = mesh.vertexList.length;
			var vertex:Vertex3D;
			
			for (; i < n; i++) 
			{
				vertex = mesh.vertexList[i];
				mVertexBuffer.push(vertex.x);
				mVertexBuffer.push(vertex.y);
				mVertexBuffer.push(vertex.u);
				mVertexBuffer.push(vertex.v);
			}
			
			mesh.numVertices = mesh.vertexList.length;
			mesh.numIndices = mesh.indexList.length;
			mesh.numTriangles = mesh.numIndices / 3;
			
			isDataPreparedForRemoteAllocation = true;
		}
		
		override public function get resource():ResourceBase 
		{
			return super.resource;
		}
		
		override public function set resource(value:ResourceBase):void 
		{
			super.resource = value;
			mesh = value as Mesh2D;
		}
	}

}