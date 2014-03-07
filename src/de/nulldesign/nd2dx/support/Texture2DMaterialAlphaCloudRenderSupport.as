package de.nulldesign.nd2dx.support 
{
	import de.nulldesign.nd2dx.components.Mesh2DRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.materials.BlendModePresets;
	import de.nulldesign.nd2dx.materials.shader.Shader2D;
	import de.nulldesign.nd2dx.materials.shader.ShaderCache;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.materials.Texture2DMaterial;
	import de.nulldesign.nd2dx.utils.NodeBlendMode;
	import de.nulldesign.nd2dx.utils.Statistics;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Texture2DMaterialAlphaCloudRenderSupport extends RenderSupportBase
	{
		private const numFloatsPerVertex:uint = 5;
		
		private const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1, uv;" +
			"alias va2, color;" +
			
			"alias vc0, viewProjection;" +
			"alias vc4, clipSpace;" +
			
			"temp0 = mul4x4(position, clipSpace);" +
			"output = mul4x4(temp0, viewProjection);" +
			
			"temp0 = uv;" +
			
			// pass to fragment shader
			"v0 = temp0;" +
			"v1 = color;";
			
		private const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			"alias v1, color;" +
			"temp0 = sample(texCoord, texture0);" +
			"temp0 *= color.x;" +
			"output = temp0;";
		
		protected var maxCapacity:uint;
		
		protected var shaderData:Shader2D;
		protected var indexBuffer:IndexBuffer3D;
		protected var vertexBuffer:VertexBuffer3D;
		protected var mVertexBuffer:Vector.<Number>;
		protected var mIndexBuffer:Vector.<uint>;
		
		public var totalNodes:int = 0;
		public var parentNode2D:Node2D;
		public var node2D:Node2D;
		
		private static var DEG2RAD:Number = Math.PI / 180;
		
		public var blendMode:NodeBlendMode = BlendModePresets.NORMAL;
		
		public var material:Texture2DMaterial;
		public var texture:Texture2D;
		
		public var uv1x:Number;
		public var uv1y:Number;
		public var uv2x:Number;
		public var uv2y:Number;
		public var uv3x:Number;
		public var uv3y:Number;
		public var uv4x:Number;
		public var uv4y:Number;
		
		public var v1x:Number;
		public var v1y:Number;
		public var v2x:Number;
		public var v2y:Number;
		public var v3x:Number;
		public var v3y:Number;
		public var v4x:Number;
		public var v4y:Number;
		
		private var vIdx:uint = 0;
		private var rot:Number;
		private var cr:Number;
		private var sr:Number;
		private var sx:Number;
		private var sy:Number;
		
		private var pivotX:Number;
		private var pivotY:Number;
		private var offsetX:Number;
		private var offsetY:Number;
		
		public var uvRect:Rectangle;
		public var uvOffsetX:Number = 0.0;
		public var uvOffsetY:Number = 0.0;
		public var uvScaleX:Number = 1.0;
		public var uvScaleY:Number = 1.0;
		
		public function Texture2DMaterialAlphaCloudRenderSupport() 
		{
			maxCapacity = 250;
			
			uv1x = 0;
			uv1y = 0;
			uv2x = 0;
			uv2y = 1;
			uv3x = 1;
			uv3y = 0;
			uv4x = 1;
			uv4y = 1;
			
			v1x = -1;
			v1y = -1;
			v2x = 1;
			v2y = -1;
			v3x = -1;
			v3y = 1;
			v4x = 1;
			v4y = 1;
			
			mVertexBuffer = new Vector.<Number>(maxCapacity * numFloatsPerVertex * 4, true);
			mIndexBuffer = new Vector.<uint>(maxCapacity * 6, true);
		}
		
		override public function prepare():void 
		{
			super.prepare();
			
			vIdx = 0;
			totalNodes = 0;
			
			parentNode2D = null;
			
			if (!vertexBuffer)
			{
				vertexBuffer = context.createVertexBuffer(mVertexBuffer.length / numFloatsPerVertex, numFloatsPerVertex);
			}
			
			if (!indexBuffer) 
			{
				var i:uint = 0;
				var idx:uint = 0;
				var refIdx:uint = 0;
				
				while (i++ < maxCapacity)
				{
					mIndexBuffer[idx++] = refIdx;
					mIndexBuffer[idx++] = refIdx + 1;
					mIndexBuffer[idx++] = refIdx + 3;
					mIndexBuffer[idx++] = refIdx;
					mIndexBuffer[idx++] = refIdx + 3;
					mIndexBuffer[idx++] = refIdx + 2;
					
					refIdx += 4;
				}
				
				indexBuffer = context.createIndexBuffer(mIndexBuffer.length);
				indexBuffer.uploadFromVector(mIndexBuffer, 0, mIndexBuffer.length);
			}
			
			if (!shaderData)
			{
				var defines:Array = ["Texture2DCloud",
					"USE_UV", false,
					"USE_COLOR", false,
					"USE_COLOR_OFFSET", false];
				
				shaderData = ShaderCache.getShader(context, defines, VERTEX_SHADER, FRAGMENT_SHADER, numFloatsPerVertex, texture);
			}
		}
		
		override public function drawMesh(meshRenderer:Mesh2DRendererComponent):void 
		{
			node2D = meshRenderer.node2D;
			material = meshRenderer.material;
			
			if ( !parentNode2D )
			{
				parentNode2D = node2D.parent;
			}
			else if ( parentNode2D && node2D.parent != parentNode2D )
			{
				// if parent has changed, draw cloud
				drawCloud();
				parentNode2D = node2D.parent;
			}
			
			// POSITION
			sx = node2D.scaleX * (material.textureBitmapWidth >> 1);
			sy = node2D.scaleY * (material.textureBitmapHeight >> 1);
			
			if (node2D.rotation) 
			{
				rot = node2D.rotation * DEG2RAD;
				cr = Math.cos(rot);
				sr = Math.sin(rot);
			}
			else
			{
				cr = 1.0;
				sr = 0.0;
			}
			
			pivotX = node2D.pivot.x;
			pivotY = node2D.pivot.y;
			
			//offsetX = node2D.x + atlasOffset.x;
			//offsetY = node2D.y + atlasOffset.y;
			
			offsetX = node2D.x;
			offsetY = node2D.y;
			
			// v1
			mVertexBuffer[int(vIdx)] = (v1x * sx - pivotX) * cr - (v1y * sy - pivotY) * sr + offsetX;
			mVertexBuffer[int(vIdx + 1)] = (v1x * sx - pivotX) * sr + (v1y * sy - pivotY) * cr + offsetY;
			
			 //v2
			mVertexBuffer[int(vIdx + 5)] = (v2x * sx - pivotX) * cr - (v2y * sy - pivotY) * sr + offsetX;
			mVertexBuffer[int(vIdx + 6)] = (v2x * sx - pivotX) * sr + (v2y * sy - pivotY) * cr + offsetY;
			
			 //v3
			mVertexBuffer[int(vIdx + 10)] = (v3x * sx - pivotX) * cr - (v3y * sy - pivotY) * sr + offsetX;
			mVertexBuffer[int(vIdx + 11)] = (v3x * sx - pivotX) * sr + (v3y * sy - pivotY) * cr + offsetY;
			
			 //v4
			mVertexBuffer[int(vIdx + 15)] = (v4x * sx - pivotX) * cr - (v4y * sy - pivotY) * sr + offsetX;
			mVertexBuffer[int(vIdx + 16)] = (v4x * sx - pivotX) * sr + (v4y * sy - pivotY) * cr + offsetY;
			
			// UV
			uvRect = material.uvRect;
			
			uv1x = uvRect.x;
			uv1y = uvRect.y;
			
			uv2x = uvRect.x + uvRect.width;
			uv2y = uvRect.y;
			
			uv3x = uvRect.x;
			uv3y = uvRect.y + uvRect.height;
			
			uv4x = uvRect.x + uvRect.width;
			uv4y = uvRect.y + uvRect.height;
			
			uvOffsetX = material.uvOffsetX;
			uvOffsetY = material.uvOffsetY;
			uvScaleX = material.uvScaleX;
			uvScaleY = material.uvScaleY;
			
			// v1
			mVertexBuffer[int(vIdx + 2)] = uv1x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + 3)] = uv1y * uvScaleY + uvOffsetY;
			
			//v2
			mVertexBuffer[int(vIdx + 7)] = uv2x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + 8)] = uv2y * uvScaleY + uvOffsetY;
			
			//v3
			mVertexBuffer[int(vIdx + 12)] = uv3x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + 13)] = uv3y * uvScaleY + uvOffsetY;
			
			//v4
			mVertexBuffer[int(vIdx + 17)] = uv4x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + 18)] = uv4y * uvScaleY + uvOffsetY;
			
			// COLOR
			
			// v1
			mVertexBuffer[int(vIdx) + 4] = node2D.alpha;
			
			 //v2
			mVertexBuffer[int(vIdx) + 9] = node2D.alpha;
			
			 //v3
			mVertexBuffer[int(vIdx) + 14] = node2D.alpha;
			
			 //v4
			mVertexBuffer[int(vIdx) + 19] = node2D.alpha;
			
			// increment id
			vIdx += numFloatsPerVertex * 4;
			
			totalNodes++;
			
			if ( totalNodes == maxCapacity )
			{
				// we need to draw our data
				drawCloud();
			}
		}
		
		public function drawCloud():void
		{
			if ( totalNodes <= 0 ) return;
			
			// set shader, texture and blendmode
			context.setProgram(shaderData.shader);
			context.setTextureAt(0, texture.getTexture(context));
			context.setBlendFactors(blendMode.src, blendMode.dst);
			
			// upload vertexBuffer
			vertexBuffer.uploadFromVector(mVertexBuffer, 0, mVertexBuffer.length / numFloatsPerVertex);
			
			context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			context.setVertexBufferAt(2, vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_1); // alpha
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, parentNode2D.worldModelMatrix, true);
			
			context.drawTriangles(indexBuffer, 0, totalNodes << 1);
			
			Statistics.drawCalls++;
			
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
			
			context.setScissorRectangle(null);
			
			vIdx = 0;
			totalNodes = 0;
		}
		
		override public function finalize():void 
		{
			super.finalize();
			
			drawCloud();
		}
	}

}