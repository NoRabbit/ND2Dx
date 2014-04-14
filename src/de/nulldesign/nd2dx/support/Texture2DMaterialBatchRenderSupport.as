package de.nulldesign.nd2dx.support 
{
	import de.nulldesign.nd2dx.components.Mesh2DRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.geom.Texture2DMaterialBatchMesh2D;
	import de.nulldesign.nd2dx.materials.BlendModePresets;
	import de.nulldesign.nd2dx.materials.MaterialBase;
	import de.nulldesign.nd2dx.materials.shader.Shader2D;
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
			"alias vc[va2.w], color;" +
			
			"temp0 = mul4x4(position, clipSpace);" +
			"output = mul4x4(temp0, viewProjection);" +
			
			"temp0 = applyUV(uv, uvScroll, uvSheet);" +
			
			"temp1 = color;" +
			
			"#if PREMULTIPLIED_ALPHA;" +
			"	temp1.x = temp1.x * temp1.w;" +
			"	temp1.y = temp1.y * temp1.w;" +
			"	temp1.z = temp1.z * temp1.w;" +
			"#endif;" +
			
			// pass to fragment shader
			"v0 = temp0;" +
			"v1 = uvSheet;" +
			"v2 = temp1;";
			
		private static const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			"alias v1, uvSheet;" +
			"alias v2, color;" +
			
			"temp1 = sampleUV(texCoord, texture0, uvSheet);" +
			"temp1 *= color;" +
			"output = temp1;";
		
		public var node:Node2D;
		public var mesh:Texture2DMaterialBatchMesh2D;
		public var shaderData:Shader2D;
		public var texture:Texture2D;
		public var material:Texture2DMaterial;
		
		public var currentScrollRect:Rectangle = null;
		public var vScrollRects:Vector.<Rectangle> = new Vector.<Rectangle>();
		
		private var idx:int = 0;
		private const constantsGlobal:uint = 4;
		private const constantsPerMatrix:uint = 4;
		private const constantsPerSprite:uint = 3; // uvRect, uvOffsetAndScale, color
		
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
			mesh = MeshUtil.generateMesh2D(1, 1, 1, 1, Texture2DMaterialBatchMesh2D) as Texture2DMaterialBatchMesh2D;
			mesh.numMeshes = BATCH_SIZE;
		}
		
		final override public function prepare():void 
		{
			isPrepared = true;
			
			if ( mesh.needUploadVertexBuffer ) mesh.uploadBuffers(context);
			
			idx = 0;
			batchLen = 0;
		}
		
		override public function setScrollRect(node:Node2D):void 
		{
			drawBatch();
			
			node.checkAndUpdateMatrixIfNeeded();
			
			currentScrollRect = node.worldScrollRect;
			vScrollRects.push(currentScrollRect);
		}
		
		final override public function drawMesh(meshRenderer:Mesh2DRendererComponent):void 
		{
			node = meshRenderer.node;
			material = meshRenderer.material as Texture2DMaterial;
			texture = material.texture;
			
			node.checkAndUpdateMatrixIfNeeded();
			
			if ( material.invalidateClipSpace || material.node.invalidateMatrix ) material.updateClipSpace();
			
			if ( node.localScrollRect )
			{
				setScrollRect(node);
			}
			
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
			
			programConstants[idx++] = node.combinedTintRed;
			programConstants[idx++] = node.combinedTintGreen;
			programConstants[idx++] = node.combinedTintBlue;
			programConstants[idx++] = node.combinedAlpha;
			
			batchLen++;
			
			if (batchLen == BATCH_SIZE) 
			{
				drawBatch();
			}
		}
		
		override public function endDrawNode(node:Node2D):void 
		{
			if ( node.localScrollRect )
			{
				var index:int = vScrollRects.indexOf(node.worldScrollRect);
				
				if ( index >= 0 )
				{
					vScrollRects.splice(index, 1);
				}
				
				drawBatch();
				
				if ( vScrollRects.length )
				{
					currentScrollRect = vScrollRects[vScrollRects.length - 1];
				}
				else
				{
					currentScrollRect = null;
				}
			}
		}
		
		final public function drawBatch():void 
		{
			if (batchLen)
			{
				if( !shaderData )
				{
					shaderData = ShaderCache.getShader(context, ["Texture2DBatch", "USE_UV", false, "USE_COLOR", false, "USE_COLOR_OFFSET", false], VERTEX_SHADER, FRAGMENT_SHADER, texture);
				}
				
				context.setProgram(shaderData.shader);
				
				context.setTextureAt(0, texture.getTexture(context));
				context.setBlendFactors(blendMode.src, blendMode.dst);
				
				context.setVertexBufferAt(0, mesh.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
				context.setVertexBufferAt(1, mesh.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
				context.setVertexBufferAt(2, mesh.vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4); // idx
				
				if ( currentScrollRect ) 
				{
					context.setScissorRectangle(currentScrollRect);
				}
				
				context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
				
				
				context.setProgramConstantsFromVector(Context3DProgramType.VERTEX,
					constantsGlobal + BATCH_SIZE * constantsPerMatrix, programConstants, batchLen * constantsPerSprite);
					
				context.drawTriangles(mesh.indexBuffer, 0, batchLen << 1);
				
				Statistics.drawCalls++;
				Statistics.triangles += batchLen << 1;
				Statistics.sprites += batchLen;
				
				context.setTextureAt(0, null);
				context.setVertexBufferAt(0, null);
				context.setVertexBufferAt(1, null);
				context.setVertexBufferAt(2, null);
				context.setScissorRectangle(null);
			}
			
			idx = 0;
			batchLen = 0;
		}
		
		override public function finalize():void 
		{
			drawBatch();
		}
		
	}

}