package de.nulldesign.nd2dx.resource.mesh 
{
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	import flash.display3D.Context3D;
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
		
		public var mIndexBuffer:Vector.<uint> = null;
		public var mVertexBuffer:Vector.<Number> = null;
		
		public var indexBuffer:IndexBuffer3D;
		public var vertexBuffer:VertexBuffer3D;
		
		public var numFloatsPerVertex:int = 4;
		public var numVertices:int = 0;
		public var numIndices:int = 0;
		public var numTriangles:int = 0;
		
		public var needUploadVertexBuffer:Boolean = true;
		
		//public var stepsX:int = 0;
		//public var stepsY:int = 0;
		
		// parent mesh (if this one is a copy of its parent)
		public var parent:Mesh2D = null;
		
		public function Mesh2D(allocator:ResourceAllocatorBase = null) 
		{
			super(allocator);
		}
		
		public function prepareBuffersData():void 
		{
			mIndexBuffer = indexList;
			mVertexBuffer = new Vector.<Number>();
			
			var i:int = 0;
			var n:int = vertexList.length;
			var vertex:Vertex3D;
			
			for (; i < n; i++) 
			{
				vertex = vertexList[i];
				mVertexBuffer.push(vertex.x);
				mVertexBuffer.push(vertex.y);
				mVertexBuffer.push(vertex.u);
				mVertexBuffer.push(vertex.v);
			}
			
			numVertices = vertexList.length;
			numIndices = indexList.length;
			numTriangles = numIndices / 3;
			
			//trace("mVertexBuffer.length: ", mVertexBuffer.length);
			//trace("mVertexBuffer: ", mVertexBuffer);
			//trace("numVertices: ", numVertices);
			//trace("numIndices: ", numIndices);
			//trace("numTriangles: ", numTriangles);
		}
		
		public function uploadBuffers(context:Context3D):void
		{
			needUploadVertexBuffer = false;
			
			// prepare data if they are not
			if ( !mVertexBuffer ) prepareBuffersData();
			
			if ( vertexBuffer ) vertexBuffer.dispose();
			vertexBuffer = context.createVertexBuffer(numVertices, numFloatsPerVertex);
			vertexBuffer.uploadFromVector(mVertexBuffer, 0, numVertices);
			
			if ( indexBuffer ) indexBuffer.dispose();
			indexBuffer = context.createIndexBuffer(numIndices);
			indexBuffer.uploadFromVector(mIndexBuffer, 0, numIndices);
		}
		
		override public function handleDeviceLoss():void 
		{
			indexBuffer = null;
			vertexBuffer = null;
			mIndexBuffer = null;
			mVertexBuffer = null;
			
			needUploadVertexBuffer = true;
		}
		
		override public function dispose():void 
		{
			if ( vertexList && vertexList.length ) vertexList.splice(0, vertexList.length);
			if ( indexList && indexList.length ) indexList.splice(0, indexList.length);
			
			if ( mIndexBuffer && mIndexBuffer.length ) mIndexBuffer.splice(0, mIndexBuffer.length);
			if ( mVertexBuffer && mVertexBuffer.length ) mVertexBuffer.splice(0, mVertexBuffer.length);
			
			if ( indexBuffer ) indexBuffer.dispose();
			if ( vertexBuffer ) vertexBuffer.dispose();
			
			vertexList = null;
			indexList = null;
			indexBuffer = null;
			vertexBuffer = null;
			mIndexBuffer = null;
			mVertexBuffer = null;
			
			needUploadVertexBuffer = false;
		}
	}

}