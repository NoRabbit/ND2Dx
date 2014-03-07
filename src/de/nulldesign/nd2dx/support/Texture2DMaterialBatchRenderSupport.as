package de.nulldesign.nd2dx.support 
{
	import de.nulldesign.nd2dx.components.Mesh2DRendererComponent;
	import de.nulldesign.nd2dx.geom.BatchMesh2D;
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.geom.Texture2DMaterialBatchMesh2D;
	import de.nulldesign.nd2dx.materials.BlendModePresets;
	import de.nulldesign.nd2dx.materials.MaterialBase;
	import de.nulldesign.nd2dx.materials.shader.ShaderCache;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.materials.Texture2DMaterial;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	import de.nulldesign.nd2dx.utils.NodeBlendMode;
	import de.nulldesign.nd2dx.utils.Statistics;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Texture2DMaterialBatchRenderSupport extends RenderSupportBase
	{
		private static const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1.xy, uv;" +
			
			"alias vc0, viewProjection;" +
			
			"alias vc[va2.x], clipSpace;" +
			"alias vc[va2.y], uvSheet;" +
			"alias vc[va2.z], uvScroll;" +
			
			"temp0 = mul4x4(position, clipSpace);" +
			"output = mul4x4(temp0, viewProjection);" +
			
			"temp0 = applyUV(uv, uvScroll, uvSheet);" +
			
			// pass to fragment shader
			"v0 = temp0;" +
			"v1 = uvSheet;";
			
		private static const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			"alias v1, uvSheet;" +
			
			"output = sampleUV(texCoord, texture0, uvSheet);";
		
		public var mesh:Texture2DMaterialBatchMesh2D;
		public var texture:Texture2D;
		public var material:Texture2DMaterial;
		
		private var idx:int = 0;
		private const constantsGlobal:uint = 4;
		private const constantsPerMatrix:uint = 4;
		private const constantsPerSprite:uint = 2; // uvRect, uvOffsetAndScale
		
		private var batchLen:uint = 0;
		private const BATCH_SIZE:uint = (126 - constantsGlobal) / (constantsPerMatrix + constantsPerSprite);
		
		private var programConstants:Vector.<Number> = new Vector.<Number>(4 * constantsPerSprite * BATCH_SIZE, true);
		private var uvRect:Rectangle;
		
		public var scrollRect:Rectangle;
		
		public var usesUV:Boolean = false;
		public var lastUsesUV:Boolean = false;
		
		public var usesColor:Boolean = false;
		public var lastUsesColor:Boolean = false;
		
		public var usesColorOffset:Boolean = false;
		public var lastUsesColorOffset:Boolean = false;
		
		public var isFirstNode:Boolean = true;
		
		public var blendMode:NodeBlendMode = BlendModePresets.NORMAL;
		public var colorTransform:ColorTransform;
		
		public function Texture2DMaterialBatchRenderSupport() 
		{
			// create mesh
			var mesh2d:Mesh2D = MeshUtil.generateMesh2D(1, 1, 2, 2);
			mesh = new Texture2DMaterialBatchMesh2D();
			mesh.vertexList = mesh2d.vertexList;
			mesh.indexList = mesh2d.indexList;
			mesh.numMeshes = BATCH_SIZE;
			mesh2d = null;
		}
		
		final override public function prepare():void 
		{
			super.prepare();
			
			// upload mesh to buffers if needed
			if ( mesh.needUploadVertexBuffer ) mesh.uploadBuffers(context);
			
			shaderData = ShaderCache.getShader(context, ["Texture2DBatch", "USE_UV", false, "USE_COLOR", false, "USE_COLOR_OFFSET", false], VERTEX_SHADER, FRAGMENT_SHADER, 7, texture);
			
			context.setProgram(shaderData.shader);
			
			context.setTextureAt(0, texture.getTexture(context));
			context.setBlendFactors(blendMode.src, blendMode.dst);
			
			context.setVertexBufferAt(0, mesh.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, mesh.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			context.setVertexBufferAt(2, mesh.vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_3); // idx
			
			//if (scrollRect) 
			//{
				//context.setScissorRectangle(scrollRect);
			//}
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
			
			idx = 0;
			batchLen = 0;
		}
		
		final override public function drawMesh(meshRenderer:Mesh2DRendererComponent):void 
		{
			material = meshRenderer.material as Texture2DMaterial;
			material.node2D = meshRenderer.node2D;
			
			if ( material.invalidateClipSpace || material.node2D.invalidateMatrix ) material.updateClipSpace();
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, constantsGlobal + batchLen * constantsPerMatrix, material.clipSpaceMatrix, true);
			
			uvRect = material.uvRect;
			
			programConstants[idx++] = uvRect.x;
			programConstants[idx++] = uvRect.y;
			programConstants[idx++] = uvRect.width;
			programConstants[idx++] = uvRect.height;
			
			programConstants[idx++] = material.uvOffsetX;
			programConstants[idx++] = material.uvOffsetY;
			programConstants[idx++] = material.uvScaleX;
			programConstants[idx++] = material.uvScaleY;
			
			batchLen++;
			
			Statistics.sprites++;
			
			if (batchLen == BATCH_SIZE) 
			{
				drawCurrentBatch();
			}
		}
		
		final public function drawCurrentBatch():void 
		{
			if (batchLen)
			{
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,
					constantsGlobal + BATCH_SIZE * constantsPerMatrix, programConstants, batchLen * constantsPerSprite);
					
				context.drawTriangles(mesh.indexBuffer, 0, batchLen << 1);
				
				Statistics.drawCalls++;
				Statistics.triangles += (batchLen << 1);
			}
			
			idx = 0;
			batchLen = 0;
		}
		
		override public function finalize():void 
		{
			super.finalize();
			
			drawCurrentBatch();
			
			context.setTextureAt(0, null);
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
			//context.setScissorRectangle(null);
		}
		
	}

}