package de.nulldesign.nd2dx.resource.mesh 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Mesh2DAllocator extends ResourceAllocatorBase
	{
		public var mesh:Mesh2D;
		
		public var stepsX:uint = 0;
		public var stepsY:uint = 0;
		public var width:Number = 0.0;
		public var height:Number = 0.0;
		
		public function Mesh2DAllocator(data:Object = null, stepsX:uint = 0, stepsY:uint = 0, width:Number = 0.0, height:Number = 0.0, freeLocalResourceAfterAllocated:Boolean = false) 
		{
			super(freeLocalResourceAfterAllocated);
			
			this.stepsX = stepsX;
			this.stepsY = stepsY;
			this.width = width;
			this.height = height;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			MeshUtil.generateMeshData(mesh, stepsX, stepsY, width, height);
			
			mesh.isLocallyAllocated = true;
			
			if ( mesh.isLocallyAllocated && freeLocalResourceAfterAllocated ) freeLocalResource();
		}
		
		override public function freeLocalResource():void 
		{
			if ( mesh.mIndexBuffer && mesh.mIndexBuffer.length ) mesh.mIndexBuffer.splice(0, mesh.mIndexBuffer.length);
			if ( mesh.mVertexBuffer && mesh.mVertexBuffer.length ) mesh.mVertexBuffer.splice(0, mesh.mVertexBuffer.length);
			
			mesh.isLocallyAllocated = false;
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