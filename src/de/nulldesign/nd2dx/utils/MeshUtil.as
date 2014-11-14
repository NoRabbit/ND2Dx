package de.nulldesign.nd2dx.utils 
{
	import de.nulldesign.nd2dx.resource.mesh.Mesh2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class MeshUtil 
	{
		public static function generateMeshData(mesh:Mesh2D, stepsX:uint = 1, stepsY:uint = 1, width:Number = 1.0, height:Number = 1.0):Mesh2D
		{
			//mesh.stepsX = stepsX;
			//mesh.stepsY = stepsY;
			
			var vertexList:Vector.<Vertex3D> = mesh.vertexList;
			var indexList:Vector.<uint> = mesh.indexList;
			
			var texW:Number = width * 0.5;
			var texH:Number = height * 0.5;
			
			var i:int;
			var j:int;
			
			var currentX:Number;
			var currentY:Number;
			
			var v:Vertex3D;
			
			var sx:Number = width / stepsX;
			var sy:Number = height / stepsY;
			
			for (i = 0; i <= stepsY; i++) 
			{
				for (j = 0; j <= stepsX; j++) 
				{
					currentX = j * sx - texW;
					currentY = i * sy - texH;
					
					v = new Vertex3D(currentX, currentY, 0.0, (j / stepsX), (i / stepsY));
					vertexList.push(v);
				}
			}
			
			for (i = 0; i < stepsY; i++) 
			{
				for (j = 0; j < stepsX; j++) 
				{
					currentY = i * (stepsX + 1);
					currentX = j + currentY;
					
					indexList.push(currentX);
					indexList.push(currentX + 1);
					indexList.push(currentX + stepsX + 1 + 1);
					
					indexList.push(currentX);
					indexList.push(currentX + stepsX + 1 + 1);
					indexList.push(currentX + stepsX + 1);
				}
			}
			
			mesh.needUploadVertexBuffer = true;
			
			return mesh;
		}
	}

}