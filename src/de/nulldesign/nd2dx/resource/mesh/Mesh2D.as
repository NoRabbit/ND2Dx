package de.nulldesign.nd2dx.resource.mesh 
{
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Mesh2D extends ResourceBase
	{
		public var vertexList:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		public var indexList:Vector.<uint> = new Vector.<uint>();
		
		public var indexBuffer:IndexBuffer3D;
		public var vertexBuffer:VertexBuffer3D;
		
		public var numFloatsPerVertex:int = 4;
		public var numVertices:int = 0;
		public var numIndices:int = 0;
		public var numTriangles:int = 0;
		
		// parent mesh (if this one is a copy of its parent)
		public var parent:Mesh2D = null;
		
		public function Mesh2D(allocator:ResourceAllocatorBase = null) 
		{
			super(allocator);
		}
		
		override public function handleDeviceLoss():void 
		{
			indexBuffer = null;
			vertexBuffer = null;
			
			isRemotelyAllocated = false;
		}
		
		override public function dispose():void 
		{
			if ( vertexList && vertexList.length ) vertexList.splice(0, vertexList.length);
			if ( indexList && indexList.length ) indexList.splice(0, indexList.length);
			
			if ( indexBuffer ) indexBuffer.dispose();
			if ( vertexBuffer ) vertexBuffer.dispose();
			
			vertexList = null;
			indexList = null;
			indexBuffer = null;
			vertexBuffer = null;
		}
	}

}