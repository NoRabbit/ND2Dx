package de.nulldesign.nd2dx.support 
{
	import de.nulldesign.nd2dx.components.Mesh2DRendererComponent;
	import de.nulldesign.nd2dx.geom.BatchMesh2D;
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.materials.BlendModePresets;
	import de.nulldesign.nd2dx.materials.MaterialBase;
	import de.nulldesign.nd2dx.materials.shader.ShaderCache;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.materials.TextureMaterial;
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
	public class BatchRenderSupport extends RenderSupportBase
	{
		private static const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1.xy, uv;" +
			
			"alias vc0, viewProjection;" +
			
			"alias vc[va2.x], clipSpace;" +
			"alias vc[va2.y], colorMultiplier;" +
			"alias vc[va2.z], colorOffset;" +
			"alias vc[va2.w], uvSheet;" +
			"alias vc[va3.x], uvScroll;" +
			
			"temp0 = mul4x4(position, clipSpace);" +
			"output = mul4x4(temp0, viewProjection);" +
			
			"temp0 = applyUV(uv, uvScroll, uvSheet);" +
			
			// pass to fragment shader
			"v0 = temp0;" +
			"v1 = colorMultiplier;" +
			"v2 = colorOffset;" +
			"v3 = uvSheet;";
			
		private static const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			"alias v1, colorMultiplier;" +
			"alias v2, colorOffset;" +
			"alias v3, uvSheet;" +
			
			"temp0 = sampleUV(texCoord, texture0, uvSheet);" +
			"output = colorize(temp0, colorMultiplier, colorOffset);";
		
		public var mesh:BatchMesh2D;
		public var texture:Texture2D;
		public var material:TextureMaterial;
		
		private var idx:int = 0;
		private const constantsGlobal:uint = 4;
		private const constantsPerMatrix:uint = 4;
		private const constantsPerSprite:uint = 4; // colorMultiplier, colorOffset, uvSheet, uvOffsetAndScale
		
		private var batchLen:uint = 0;
		private const BATCH_SIZE:uint = (126 - constantsGlobal) / (constantsPerMatrix + constantsPerSprite);
		
		private var programConstants:Vector.<Number> = new Vector.<Number>(4 * constantsPerSprite * BATCH_SIZE, true);
		//private var programConstants:Vector.<Number> = new Vector.<Number>(16, true);
		private var uvSheet:Rectangle;
		
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
		
		public function BatchRenderSupport() 
		{
			// create mesh
			var mesh2d:Mesh2D = MeshUtil.generateMesh2D(1, 1, 2, 2);
			mesh = new BatchMesh2D();
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
			
			//updateProgram(context);
			//context.setProgram(shaderData.shader);
			//context.setTextureAt(0, texture.getTexture(context));
			//context.setBlendFactors(blendMode.src, blendMode.dst);
			
			//context.setVertexBufferAt(0, mesh.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			//context.setVertexBufferAt(1, mesh.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			//context.setVertexBufferAt(2, mesh.vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4); // idx
			//context.setVertexBufferAt(3, mesh.vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_1); // idx2
			//
			//if (scrollRect) 
			//{
				//context.setScissorRectangle(scrollRect);
			//}
			//
			//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
			
			isFirstNode = true;
		}
		
		final override public function drawMesh(meshRenderer:Mesh2DRendererComponent):void 
		{
			material = meshRenderer.material as TextureMaterial;
			material.node2D = meshRenderer.node2D;
			//if ( material.invalidateUV ) material.updateUV();
			if ( material.node2D.invalidateClipSpace || material.node2D.invalidateMatrix ) material.updateClipSpace();
			
			//uvSheet = (texture.sheet ? material.animation.frameUV : texture.uvRect);
			
			//usesUV = material.usesUV;
			//usesColor = material.usesColor;
			//usesColorOffset = material.usesColorOffset;
			
			//updateProgram(context);
			// if there is a change, draw what we currently have and reset our batch with new values
			if (isFirstNode)// || usesUV != lastUsesUV || usesColor != lastUsesColor || usesColorOffset != lastUsesColorOffset) 
			{
				isFirstNode = false;
				// draw what we currently have
				drawCurrentBatch();
				
				// reset shader
				//shaderData = ShaderCache.getShader(context, ["Sprite2DBatch", "USE_UV", usesUV, "USE_COLOR", usesColor, "USE_COLOR_OFFSET", usesColorOffset], VERTEX_SHADER, FRAGMENT_SHADER, 9, texture);
				shaderData = ShaderCache.getShader(context, ["Sprite2DBatch", "USE_UV", false, "USE_COLOR", false, "USE_COLOR_OFFSET", false], VERTEX_SHADER, FRAGMENT_SHADER, 9, texture);
				
				context.setProgram(shaderData.shader);
				
				context.setTextureAt(0, texture.getTexture(context));
				context.setBlendFactors(blendMode.src, blendMode.dst);
				
				context.setVertexBufferAt(0, mesh.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
				context.setVertexBufferAt(1, mesh.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
				context.setVertexBufferAt(2, mesh.vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4); // idx
				context.setVertexBufferAt(3, mesh.vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_1); // idx2
				
				if (scrollRect) 
				{
					context.setScissorRectangle(scrollRect);
				}
				
				context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
				
				uvSheet = texture.uvRect;
				
				lastUsesUV = usesUV;
				lastUsesColor = usesColor;
				lastUsesColorOffset = usesColorOffset;
				
				idx = 0;
				batchLen = 0;
			}
			
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX,
			//constantsGlobal + batchLen * (constantsPerMatrix + constantsPerSprite), material.clipSpaceMatrix, true);
			constantsGlobal + batchLen * constantsPerMatrix, material.clipSpaceMatrix, true);
			
			//idx = 0;
			
			//colorTransform = material.colorTransform;
			
			programConstants[idx++] = 0;// colorTransform.redMultiplier;
			programConstants[idx++] = 0;// colorTransform.greenMultiplier;
			programConstants[idx++] = 0;// colorTransform.blueMultiplier;
			programConstants[idx++] = 0;// colorTransform.alphaMultiplier;
			
			programConstants[idx++] = 0;// colorTransform.redOffset;
			programConstants[idx++] = 0;// colorTransform.greenOffset;
			programConstants[idx++] = 0;// colorTransform.blueOffset;
			programConstants[idx++] = 0;// colorTransform.alphaOffset;
			
			programConstants[idx++] = uvSheet.x;
			programConstants[idx++] = uvSheet.y;
			programConstants[idx++] = uvSheet.width;
			programConstants[idx++] = uvSheet.height;
			
			programConstants[idx++] = material.uvOffsetX;
			programConstants[idx++] = material.uvOffsetY;
			programConstants[idx++] = material.uvScaleX;
			programConstants[idx++] = material.uvScaleY;
			
			//programConstants[0] = material.colorTransform.redMultiplier;
			//programConstants[1] = material.colorTransform.greenMultiplier;
			//programConstants[2] = material.colorTransform.blueMultiplier;
			//programConstants[3] = material.colorTransform.alphaMultiplier;
			//
			//programConstants[4] = material.colorTransform.redOffset;
			//programConstants[5] = material.colorTransform.greenOffset;
			//programConstants[6] = material.colorTransform.blueOffset;
			//programConstants[7] = material.colorTransform.alphaOffset;
			//
			//programConstants[8] = uvSheet.x;
			//programConstants[9] = uvSheet.y;
			//programConstants[10] = uvSheet.width;
			//programConstants[11] = uvSheet.height;
			//
			//programConstants[12] = material.uvOffsetX;
			//programConstants[13] = material.uvOffsetY;
			//programConstants[14] = material.uvScaleX;
			//programConstants[15] = material.uvScaleY;
			
			//context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,
					//constantsGlobal + (batchLen * (constantsPerMatrix + constantsPerSprite)) + constantsPerMatrix, programConstants, constantsPerSprite);
					
			batchLen++;
			
			Statistics.sprites++;
			
			if (batchLen == BATCH_SIZE) 
			{
				//drawCurrentBatch();
				if (batchLen)
				{
					context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,
						constantsGlobal + BATCH_SIZE * constantsPerMatrix, programConstants, batchLen * constantsPerSprite);
						
					context.drawTriangles(mesh.indexBuffer, 0, batchLen << 1);
					
					Statistics.drawCalls++;
					Statistics.triangles += (batchLen << 1);
					
					//trace("drawing: " + (batchLen << 1));
				}
				
				idx = 0;
				batchLen = 0;
			}
		}
		
		[Inline]
		final public function drawCurrentBatch():void 
		{
			if (batchLen)
			{
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,
					constantsGlobal + BATCH_SIZE * constantsPerMatrix, programConstants, batchLen * constantsPerSprite);
					
				context.drawTriangles(mesh.indexBuffer, 0, batchLen << 1);
				
				Statistics.drawCalls++;
				Statistics.triangles += (batchLen << 1);
				
				//trace("drawing: " + (batchLen << 1));
			}
			
			idx = 0;
			batchLen = 0;
		}
		
		override public function finalize():void 
		{
			super.finalize();
			
			//drawCurrentBatch();
			
			if (batchLen)
			{
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,
					constantsGlobal + BATCH_SIZE * constantsPerMatrix, programConstants, batchLen * constantsPerSprite);
					
				context.drawTriangles(mesh.indexBuffer, 0, batchLen << 1);
				
				Statistics.drawCalls++;
				Statistics.triangles += (batchLen << 1);
				
				//trace("drawing: " + (batchLen << 1));
			}
			
			idx = 0;
			batchLen = 0;
			
			context.setTextureAt(0, null);
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
			context.setVertexBufferAt(3, null);
			context.setScissorRectangle(null);
		}
		
	}

}