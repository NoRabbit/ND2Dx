package de.nulldesign.nd2dx.resource.mesh 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Mesh2DStepsAllocator extends Mesh2DAllocator
	{
		public var stepsX:uint = 0;
		public var stepsY:uint = 0;
		public var width:Number = 0.0;
		public var height:Number = 0.0;
		
		public function Mesh2DStepsAllocator(stepsX:uint = 0, stepsY:uint = 0, width:Number = 0.0, height:Number = 0.0, freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
			
			this.stepsX = stepsX;
			this.stepsY = stepsY;
			this.width = width;
			this.height = height;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			MeshUtil.generateMeshData(mesh, stepsX, stepsY, width, height);
			
			mesh.isLocallyAllocated = true;
			
			if ( mesh.isLocallyAllocated && freeLocalResourceAfterRemoteAllocation ) freeLocalResource();
		}
	}

}