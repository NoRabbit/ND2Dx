package de.nulldesign.nd2dx.resource.mesh 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.ColorUtil;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	import de.nulldesign.nd2dx.utils.NumberUtil;
	import de.nulldesign.nd2dx.utils.ParticleSystem2DPreset;
	import de.nulldesign.nd2dx.utils.VectorUtil;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ParticleSystemMesh2DAllocator extends Mesh2DAllocator
	{
		public var preset:ParticleSystem2DPreset;
		
		public var particleEndColor:Number;
		public var particleStartColor:Number;
		public var speed:Number;
		public var angle:Number;
		
		public var numParticles:int = 1;
		
		public var startColorR:Number;
		public var startColorG:Number;
		public var startColorB:Number;
		
		public var startAlpha:Number;
		
		public var startX:Number;
		public var startY:Number;
		
		public var startRotation:Number;
		public var endRotation:Number;
		
		public var endColorR:Number;
		public var endColorG:Number;
		public var endColorB:Number;
		
		public var endAlpha:Number;
		
		public var vx:Number;
		public var vy:Number;
		
		public var startTime:Number;
		public var life:Number;
		public var startSize:Number;
		public var endSize:Number;
		
		public var totalDuration:Number = 0.0;
		
		public function ParticleSystemMesh2DAllocator(freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( mesh.isLocallyAllocated && !forceAllocation ) return;
			
			MeshUtil.generateMeshData(mesh, 1, 1, 1, 1);
			
			super.allocateLocalResource(assetGroup, forceAllocation);
		}
		
		override public function prepareDataForRemoteAllocation():void 
		{
			mIndexBuffer = new Vector.<uint>();
			mVertexBuffer = new Vector.<Number>();
			
			var i:int = 0;
			var n:int = numParticles;
			var vertex:Vertex3D;
			var idx:int;
			
			totalDuration = 0.0;
			
			for (; i < n; i++) 
			{
				var j:int = 0;
				var m:int = mesh.vertexList.length;
				
				angle = NumberUtil.random(VectorUtil.deg2rad(preset.minEmitAngle), VectorUtil.deg2rad(preset.maxEmitAngle));
				speed = NumberUtil.random(preset.minSpeed, preset.maxSpeed);
				particleStartColor = ColorUtil.mixColors(preset.startColor, preset.startColorVariance, NumberUtil.random());
				particleEndColor = ColorUtil.mixColors(preset.endColor, preset.endColorVariance, NumberUtil.random());
				
				// start time
				startTime = Math.random() * preset.spawnDelay;
				// life
				life = NumberUtil.random(preset.minLife, preset.maxLife);
				// start size
				startSize = NumberUtil.random(preset.minStartSize, preset.maxStartSize);
				// end size
				endSize = NumberUtil.random(preset.minEndSize, preset.maxEndSize);
				// velocity x
				vx = Math.sin(angle) * speed;
				// velocity y
				vy = Math.cos(angle) * speed;
				// start x
				startX = NumberUtil.random(preset.minStartPosition.x, preset.maxStartPosition.x);
				// start y
				startY = NumberUtil.random(preset.minStartPosition.y, preset.maxStartPosition.y);
				// start color R
				startColorR = ColorUtil.r(particleStartColor);
				// start color G
				startColorG = ColorUtil.g(particleStartColor);
				// start color B
				startColorB = ColorUtil.b(particleStartColor);
				// start color A
				startAlpha = preset.startAlpha;
				// end color R
				endColorR = ColorUtil.r(particleEndColor);
				// end color G
				endColorG = ColorUtil.g(particleEndColor);
				// end color B
				endColorB = ColorUtil.b(particleEndColor);
				// end color A
				endAlpha = preset.endAlpha;
				// start rotation
				startRotation = NumberUtil.random(VectorUtil.deg2rad(preset.minStartRotation), VectorUtil.deg2rad(preset.maxStartRotation));
				// end rotation
				endRotation = NumberUtil.random(VectorUtil.deg2rad(preset.minEndRotation), VectorUtil.deg2rad(preset.maxEndRotation));
				
				if ( startTime + life > totalDuration ) totalDuration = startTime + life;
				
				for (; j < m; j++) 
				{
					vertex = mesh.vertexList[j];
					mVertexBuffer.push(vertex.x);
					mVertexBuffer.push(vertex.y);
					mVertexBuffer.push(vertex.u);
					mVertexBuffer.push(vertex.v);
					
					// start time
					mVertexBuffer.push(startTime);
					// life
					mVertexBuffer.push(life);
					// start size
					mVertexBuffer.push(startSize);
					// end size
					mVertexBuffer.push(endSize);
					// velocity x
					mVertexBuffer.push(vx);
					// velocity y
					mVertexBuffer.push(vy);
					// start x
					mVertexBuffer.push(startX);
					// start y
					mVertexBuffer.push(startY);
					// start color R
					mVertexBuffer.push(startColorR);
					// start color G
					mVertexBuffer.push(startColorG);
					// start color B
					mVertexBuffer.push(startColorB);
					// start color A
					mVertexBuffer.push(startAlpha);
					// end color R
					mVertexBuffer.push(endColorR);
					// end color G
					mVertexBuffer.push(endColorG);
					// end color B
					mVertexBuffer.push(endColorB);
					// end color A
					mVertexBuffer.push(endAlpha);
					// start rotation
					mVertexBuffer.push(startRotation);
					// end rotation
					mVertexBuffer.push(endRotation);
				}
				
				idx = i * 4;
				
				mIndexBuffer.push(mesh.indexList[0] + idx);
				mIndexBuffer.push(mesh.indexList[1] + idx);
				mIndexBuffer.push(mesh.indexList[2] + idx);
				mIndexBuffer.push(mesh.indexList[3] + idx);
				mIndexBuffer.push(mesh.indexList[4] + idx);
				mIndexBuffer.push(mesh.indexList[5] + idx);
			}
			
			mesh.numFloatsPerVertex = 22;
			mesh.numVertices = mVertexBuffer.length / mesh.numFloatsPerVertex;
			mesh.numIndices = mIndexBuffer.length;
			mesh.numTriangles = mesh.numIndices / 3;
		}
	}

}