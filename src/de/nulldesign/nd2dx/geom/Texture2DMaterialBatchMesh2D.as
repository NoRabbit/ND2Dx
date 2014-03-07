package de.nulldesign.nd2dx.geom 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Texture2DMaterialBatchMesh2D extends Mesh2D
	{
		public var numMeshes:int = 1;
		
		public function Texture2DMaterialBatchMesh2D() 
		{
			
		}
		
		override public function prepareBuffersData():void 
		{
			mIndexBuffer = new Vector.<uint>();
			mVertexBuffer = new Vector.<Number>();
			
			var i:int = 0;
			var n:int = numMeshes;
			var vertex:Vertex2D;
			var idx:int;
			
			for (; i < n; i++) 
			{
				var j:int = 0;
				var m:int = vertexList.length;
				
				for (; j < m; j++) 
				{
					vertex = vertexList[j];
					mVertexBuffer.push(vertex.x);
					mVertexBuffer.push(vertex.y);
					mVertexBuffer.push(vertex.u);
					mVertexBuffer.push(vertex.v);
					
					// first id (we start at offset 4 -> viewProjection matrix 4 constants needed for that) and we * by 8 as we have 8 contants per distinct mesh/shape
					idx = 4 + (i * 4);
					mVertexBuffer.push(idx); // this one is gonna hold our clipspace matrix (4 constants again)
					
					idx = 4 + (numMeshes * 4) + (i * 2);
					mVertexBuffer.push(idx); // uvSheet (1 constant)
					idx += 1;
					mVertexBuffer.push(idx); // uvScroll (1 constant)
				}
				
				idx = i * 4;
				mIndexBuffer.push(indexList[0] + idx);
				mIndexBuffer.push(indexList[1] + idx);
				mIndexBuffer.push(indexList[2] + idx);
				mIndexBuffer.push(indexList[3] + idx);
				mIndexBuffer.push(indexList[4] + idx);
				mIndexBuffer.push(indexList[5] + idx);
			}
			
			numFloatsPerVertex = 7;
			numVertices = mVertexBuffer.length / numFloatsPerVertex;
			numIndices = mIndexBuffer.length;
			numTriangles = numIndices / 3;
			
			//trace("numMeshes: ", numMeshes);
			//trace("numVertices: ", numVertices);
			//trace("numIndices: ", numIndices);
			//trace("numTriangles: ", numTriangles);
		}
	}

}