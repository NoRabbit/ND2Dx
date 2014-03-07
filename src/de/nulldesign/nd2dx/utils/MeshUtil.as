package de.nulldesign.nd2dx.utils 
{
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.geom.Vertex2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class MeshUtil 
	{
		
		public static function generateMesh2D(stepsX:uint, stepsY:uint, width:Number, height:Number, meshClass:Class = null):Mesh2D
		{
			if ( !meshClass ) meshClass = Mesh2D;
			var mesh:Mesh2D = new meshClass() as Mesh2D;
			
			var vertexList:Vector.<Vertex2D> = mesh.vertexList;
			var indexList:Vector.<uint> = mesh.indexList;
			
			var texW:Number = width * 0.5;
			var texH:Number = height * 0.5;
			
			var i:int;
			var j:int;
			
			var currentX:Number;
			var currentY:Number;
			
			var v:Vertex2D;
			
			var sx:Number = width / stepsX;
			var sy:Number = height / stepsY;
			
			for (i = 0; i <= stepsY; i++) 
			{
				for (j = 0; j <= stepsX; j++) 
				{
					currentX = j * sx - texW;
					currentY = i * sy - texH;
					
					v = new Vertex2D(currentX, currentY, (j / stepsX), (i / stepsY));
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