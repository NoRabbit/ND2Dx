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
	public class _test_CloudRenderSupport extends RenderSupportBase
	{
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
		
		//protected var uv1:UV;
		//protected var uv2:UV;
		//protected var uv3:UV;
		//protected var uv4:UV;
		
		public var v1x:Number;
		public var v1y:Number;
		public var v2x:Number;
		public var v2y:Number;
		public var v3x:Number;
		public var v3y:Number;
		public var v4x:Number;
		public var v4y:Number;
		
		//protected var v1:Vertex;
		//protected var v2:Vertex;
		//protected var v3:Vertex;
		//protected var v4:Vertex;

		//private const numFloatsPerVertex:uint = 16;
		private const numFloatsPerVertex:uint = 4;

		private const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1, uv;" +
			//"alias va2, uvSheet;" +
			//"alias va3, colorMultiplier;" +
			//"alias va4, colorOffset;" +

			"alias vc0, viewProjection;" +
			"alias vc4, clipSpace;" +

			"temp0 = mul4x4(position, clipSpace);" +
			"output = mul4x4(temp0, viewProjection);" +

			//"#if !USE_UV;" +
			//"	temp0 = uv * uvSheet.zw;" +
			//"	temp0 += uvSheet.xy;" +
			//"#else;" +
			"	temp0 = uv;" +
			//"#endif;" +

			// pass to fragment shader
			"v0 = temp0;";// +
			//"v1 = colorMultiplier;" +
			//"v2 = colorOffset;" +
			//"v3 = uvSheet;";

		private const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			//"alias v1, colorMultiplier;" +
			//"alias v2, colorOffset;" +
			//"alias v3, uvSheet;" +

			"output = sample(texCoord, texture0);";// +
			//"temp0 = sampleUV(texCoord, texture0, uvSheet);" +

			//"output = colorize(temp0, colorMultiplier, colorOffset);";

		protected var maxCapacity:uint;

		//protected var elapsed:Number;
		protected var shaderData:Shader2D;
		protected var indexBuffer:IndexBuffer3D;
		protected var vertexBuffer:VertexBuffer3D;
		public var mVertexBuffer:Vector.<Number>;
		protected var mIndexBuffer:Vector.<uint>;
		
		public var vColors:Vector.<Number> = new Vector.<Number>(8, true);

		protected var _static:Boolean = false;

		protected var staticIdx:uint = 0;
		protected var staticLast:Node2D = null;

		protected var lastUsesUV:Boolean = false;
		protected var lastUsesColor:Boolean = false;
		protected var lastUsesColorOffset:Boolean = false;
		
		public var totalNodes:int = 0;
		public var parentNode2D:Node2D;
		public var node2D:Node2D;
		
		private static var DEG2RAD:Number = Math.PI / 180;
		
		public var blendMode:NodeBlendMode = BlendModePresets.NORMAL;
		
		var vIdx:uint = 0;
		var rMultiplier:Number;
		var gMultiplier:Number;
		var bMultiplier:Number;
		var aMultiplier:Number;
		var rOffset:Number;
		var gOffset:Number;
		var bOffset:Number;
		var aOffset:Number;
		var uvSheet:Rectangle;
		var rot:Number;
		var cr:Number;
		var sr:Number;
		var sx:Number;
		var sy:Number;
		var pivotX:Number, pivotY:Number;
		var offsetX:Number, offsetY:Number;
		var somethingChanged:Boolean = false;
		var atlasOffset:Point = new Point();
		var currentUsesUV:Boolean = false;
		var currentUsesColor:Boolean = false;
		var currentUsesColorOffset:Boolean = false;
		var halfTextureWidth:Number;// = texture.bitmapWidth >> 1;
		var halfTextureHeight:Number;// = texture.bitmapHeight >> 1;
		
		public var uvRect:Rectangle;
		public var uvOffsetX:Number = 0.0;
		public var uvOffsetY:Number = 0.0;
		public var uvScaleX:Number = 1.0;
		public var uvScaleY:Number = 1.0;
		
		public function _test_CloudRenderSupport() 
		{
			maxCapacity = 1000;
			
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
			
			halfTextureWidth = texture.bitmapWidth >> 1;
			halfTextureHeight = texture.bitmapHeight >> 1;
			
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
				drawCloud();
				parentNode2D = node2D.parent;
			}
			
			//node2D.step(elapsed);
			
			//if (node2D.invalidateUV) 
			//{
				//if (node2D.invalidateUV) 
				//{
					//node2D.updateUV();
				//}
				
				//uvSheet = (texture.sheet ? node2D.animation.frameUV : texture.uvRect);
				//uvSheet = texture.uvRect;
				//node2D.animation.frameUpdated = false;
				
				//node2D.uv01 = uv1x * material.uvScaleX + material.uvOffsetX;
				//node2D.uv02 = uv1y * material.uvScaleY + material.uvOffsetY;
				//node2D.uv03 = uv2x * material.uvScaleX + material.uvOffsetX;
				//node2D.uv04 = uv2y * material.uvScaleY + material.uvOffsetY;
				//node2D.uv05 = uv3x * material.uvScaleX + material.uvOffsetX;
				//node2D.uv06 = uv3y * material.uvScaleY + material.uvOffsetY;
				//node2D.uv07 = uv4x * material.uvScaleX + material.uvOffsetX;
				//node2D.uv08 = uv4y * material.uvScaleY + material.uvOffsetY;
				//node2D.uv09 = xxx;
				//node2D.uv10 = xxx;
				//node2D.uv11 = xxx;
				//node2D.uv12 = xxx;
				//node2D.uv13 = xxx;
				//node2D.uv14 = xxx;
				//node2D.uv15 = xxx;
				//node2D.uv16 = xxx;
				//node2D.uv17 = xxx;
				//node2D.uv18 = xxx;
				//node2D.uv19 = xxx;
				//node2D.uv20 = xxx;
				//node2D.uv21 = xxx;
				//node2D.uv22 = xxx;
				//node2D.uv23 = xxx;
				//node2D.uv24 = xxx;
				
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
				//mVertexBuffer[vIdx + 4] = uvSheet.x;
				//mVertexBuffer[vIdx + 5] = uvSheet.y;
				//mVertexBuffer[vIdx + 6] = uvSheet.width;
				//mVertexBuffer[vIdx + 7] = uvSheet.height;
				
				 //v2
				mVertexBuffer[int(vIdx + 6)] = uv2x * uvScaleX + uvOffsetX;
				mVertexBuffer[int(vIdx + 7)] = uv2y * uvScaleY + uvOffsetY;
				//mVertexBuffer[vIdx + 20] = uvSheet.x;
				//mVertexBuffer[vIdx + 21] = uvSheet.y;
				//mVertexBuffer[vIdx + 22] = uvSheet.width;
				//mVertexBuffer[vIdx + 23] = uvSheet.height;
				
				 //v3
				mVertexBuffer[int(vIdx + 10)] = uv3x * uvScaleX + uvOffsetX;
				mVertexBuffer[int(vIdx + 11)] = uv3y * uvScaleY + uvOffsetY;
				//mVertexBuffer[vIdx + 36] = uvSheet.x;
				//mVertexBuffer[vIdx + 37] = uvSheet.y;
				//mVertexBuffer[vIdx + 38] = uvSheet.width;
				//mVertexBuffer[vIdx + 39] = uvSheet.height;
				
				 //v4
				mVertexBuffer[int(vIdx + 14)] = uv4x * uvScaleX + uvOffsetX;
				mVertexBuffer[int(vIdx + 15)] = uv4y * uvScaleY + uvOffsetY;
				//mVertexBuffer[vIdx + 52] = uvSheet.x;
				//mVertexBuffer[vIdx + 53] = uvSheet.y;
				//mVertexBuffer[vIdx + 54] = uvSheet.width;
				//mVertexBuffer[vIdx + 55] = uvSheet.height;
				
				//somethingChanged = true;
			//}
			
			// UV
			// v1
			//mVertexBuffer[int(vIdx + 2)] = node2D.uv01;
			//mVertexBuffer[int(vIdx + 3)] = node2D.uv02;
			//mVertexBuffer[int(vIdx + 4)] = uvSheet.x;
			//mVertexBuffer[int(vIdx + 5)] = uvSheet.y;
			//mVertexBuffer[int(vIdx + 6)] = uvSheet.width;
			//mVertexBuffer[int(vIdx + 7)] = uvSheet.height;
			//
			// v2
			//mVertexBuffer[int(vIdx + 18)] = node2D.uv03;
			//mVertexBuffer[int(vIdx + 19)] = node2D.uv04;
			//mVertexBuffer[int(vIdx + 20)] = uvSheet.x;
			//mVertexBuffer[int(vIdx + 21)] = uvSheet.y;
			//mVertexBuffer[int(vIdx + 22)] = uvSheet.width;
			//mVertexBuffer[int(vIdx + 23)] = uvSheet.height;
			//
			// v3
			//mVertexBuffer[int(vIdx + 34)] = node2D.uv05;
			//mVertexBuffer[int(vIdx + 35)] = node2D.uv06;
			//mVertexBuffer[int(vIdx + 36)] = uvSheet.x;
			//mVertexBuffer[int(vIdx + 37)] = uvSheet.y;
			//mVertexBuffer[int(vIdx + 38)] = uvSheet.width;
			//mVertexBuffer[int(vIdx + 39)] = uvSheet.height;
			//
			// v4
			//mVertexBuffer[int(vIdx + 50)] = node2D.uv07;
			//mVertexBuffer[int(vIdx + 51)] = node2D.uv08;
			//mVertexBuffer[int(vIdx + 52)] = uvSheet.x;
			//mVertexBuffer[int(vIdx + 53)] = uvSheet.y;
			//mVertexBuffer[int(vIdx + 54)] = uvSheet.width;
			//mVertexBuffer[int(vIdx + 55)] = uvSheet.height;
			
			//if (node2D.invalidateMatrix || node2D.invalidateClipSpace) 
			//{
				//if (texture.sheet) 
				//{
					//atlasOffset = node2D.animation.frameOffset;
					//sx = node2D.scaleX * (node2D.animation.frameRect.width >> 1);
					//sy = node2D.scaleY * (node2D.animation.frameRect.height >> 1);
				//}
				//else
				//{
					//sx = node2D.scaleX * halfTextureWidth;
					//sy = node2D.scaleY * halfTextureHeight;
					sx = node2D.scaleX * (material.textureBitmapWidth >> 1);
					sy = node2D.scaleY * (material.textureBitmapHeight >> 1);
				//}
				
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
				mVertexBuffer[int(vIdx + 4)] = (v2x * sx - pivotX) * cr - (v2y * sy - pivotY) * sr + offsetX;
				mVertexBuffer[int(vIdx + 5)] = (v2x * sx - pivotX) * sr + (v2y * sy - pivotY) * cr + offsetY;
				
				 //v3
				mVertexBuffer[int(vIdx + 8)] = (v3x * sx - pivotX) * cr - (v3y * sy - pivotY) * sr + offsetX;
				mVertexBuffer[int(vIdx + 9)] = (v3x * sx - pivotX) * sr + (v3y * sy - pivotY) * cr + offsetY;
				
				 //v4
				mVertexBuffer[int(vIdx + 12)] = (v4x * sx - pivotX) * cr - (v4y * sy - pivotY) * sr + offsetX;
				mVertexBuffer[int(vIdx + 13)] = (v4x * sx - pivotX) * sr + (v4y * sy - pivotY) * cr + offsetY;
				
				//node2D.pos01 = (v1x * sx - pivotX) * cr - (v1y * sy - pivotY) * sr + offsetX;
				//node2D.pos02 = (v1x * sx - pivotX) * sr + (v1y * sy - pivotY) * cr + offsetY;
				//node2D.pos03 = (v2x * sx - pivotX) * cr - (v2y * sy - pivotY) * sr + offsetX;
				//node2D.pos04 = (v2x * sx - pivotX) * sr + (v2y * sy - pivotY) * cr + offsetY;
				//node2D.pos05 = (v3x * sx - pivotX) * cr - (v3y * sy - pivotY) * sr + offsetX;
				//node2D.pos06 = (v3x * sx - pivotX) * sr + (v3y * sy - pivotY) * cr + offsetY;
				//node2D.pos07 = (v4x * sx - pivotX) * cr - (v4y * sy - pivotY) * sr + offsetX;
				//node2D.pos08 = (v4x * sx - pivotX) * sr + (v4y * sy - pivotY) * cr + offsetY;
				
				//somethingChanged = true;
			//}
			
			// v1
			//mVertexBuffer[int(vIdx)] = node2D.pos01;
			//mVertexBuffer[int(vIdx + 1)] = node2D.pos02;
			//
			// v2
			//mVertexBuffer[int(vIdx + 16)] = node2D.pos03;
			//mVertexBuffer[int(vIdx + 17)] = node2D.pos04;
			//
			// v3
			//mVertexBuffer[int(vIdx + 32)] = node2D.pos05;
			//mVertexBuffer[int(vIdx + 33)] = node2D.pos06;
			//
			// v4
			//mVertexBuffer[int(vIdx + 48)] = node2D.pos07;
			//mVertexBuffer[int(vIdx + 49)] = node2D.pos08;
			
			/*
			if (node2D.invalidateColors || node2D.invalidateVisibility) 
			{
				if (node2D.invalidateColors) 
				{
					node2D.updateColors();
				}
				
				if (node2D.visible) 
				{
					rMultiplier = material.colorTransform.redMultiplier;
					gMultiplier = material.colorTransform.greenMultiplier;
					bMultiplier = material.colorTransform.blueMultiplier;
					aMultiplier = material.colorTransform.alphaMultiplier;
					rOffset = material.colorTransform.redOffset;
					gOffset = material.colorTransform.greenOffset;
					bOffset = material.colorTransform.blueOffset;
					aOffset = material.colorTransform.alphaOffset;
				}
				else
				{
					rMultiplier = 0.0;
					gMultiplier = 0.0;
					bMultiplier = 0.0;
					aMultiplier = 0.0;
					rOffset = 0.0;
					gOffset = 0.0;
					bOffset = 0.0;
					aOffset = 0.0;
				}
				
				// v1
				mVertexBuffer[vIdx + 8] = rMultiplier;
				mVertexBuffer[vIdx + 9] = gMultiplier;
				mVertexBuffer[vIdx + 10] = bMultiplier;
				mVertexBuffer[vIdx + 11] = aMultiplier;
				mVertexBuffer[vIdx + 12] = rOffset;
				mVertexBuffer[vIdx + 13] = gOffset;
				mVertexBuffer[vIdx + 14] = bOffset;
				mVertexBuffer[vIdx + 15] = aOffset;
				
				 //v2
				mVertexBuffer[vIdx + 24] = rMultiplier;
				mVertexBuffer[vIdx + 25] = gMultiplier;
				mVertexBuffer[vIdx + 26] = bMultiplier;
				mVertexBuffer[vIdx + 27] = aMultiplier;
				mVertexBuffer[vIdx + 28] = rOffset;
				mVertexBuffer[vIdx + 29] = gOffset;
				mVertexBuffer[vIdx + 30] = bOffset;
				mVertexBuffer[vIdx + 31] = aOffset;
				
				 //v3
				mVertexBuffer[vIdx + 40] = rMultiplier;
				mVertexBuffer[vIdx + 41] = gMultiplier;
				mVertexBuffer[vIdx + 42] = bMultiplier;
				mVertexBuffer[vIdx + 43] = aMultiplier;
				mVertexBuffer[vIdx + 44] = rOffset;
				mVertexBuffer[vIdx + 45] = gOffset;
				mVertexBuffer[vIdx + 46] = bOffset;
				mVertexBuffer[vIdx + 47] = aOffset;
				
				 //v4
				mVertexBuffer[vIdx + 56] = rMultiplier;
				mVertexBuffer[vIdx + 57] = gMultiplier;
				mVertexBuffer[vIdx + 58] = bMultiplier;
				mVertexBuffer[vIdx + 59] = aMultiplier;
				mVertexBuffer[vIdx + 60] = rOffset;
				mVertexBuffer[vIdx + 61] = gOffset;
				mVertexBuffer[vIdx + 62] = bOffset;
				mVertexBuffer[vIdx + 63] = aOffset;
				
				//node2D.color01 = rMultiplier;
				//node2D.color02 = gMultiplier;
				//node2D.color03 = bMultiplier;
				//node2D.color04 = aMultiplier;
				//node2D.color05 = rOffset;
				//node2D.color06 = gOffset;
				//node2D.color07 = bOffset;
				//node2D.color08 = aOffset;
				
				somethingChanged = true;
			}
			*/
			
			// v1
			//mVertexBuffer[int(vIdx + 8)] = node2D.color01;
			//mVertexBuffer[int(vIdx + 9)] = node2D.color02;
			//mVertexBuffer[int(vIdx + 10)] = node2D.color03;
			//mVertexBuffer[int(vIdx + 11)] = node2D.color04;
			//mVertexBuffer[int(vIdx + 12)] = node2D.color05;
			//mVertexBuffer[int(vIdx + 13)] = node2D.color06;
			//mVertexBuffer[int(vIdx + 14)] = node2D.color07;
			//mVertexBuffer[int(vIdx + 15)] = node2D.color08;
			//
			// v2
			//mVertexBuffer[int(vIdx + 24)] = node2D.color01;
			//mVertexBuffer[int(vIdx + 25)] = node2D.color02;
			//mVertexBuffer[int(vIdx + 26)] = node2D.color03;
			//mVertexBuffer[int(vIdx + 27)] = node2D.color04;
			//mVertexBuffer[int(vIdx + 28)] = node2D.color05;
			//mVertexBuffer[int(vIdx + 29)] = node2D.color06;
			//mVertexBuffer[int(vIdx + 30)] = node2D.color07;
			//mVertexBuffer[int(vIdx + 31)] = node2D.color08;
			//
			// v3
			//mVertexBuffer[int(vIdx + 40)] = node2D.color01;
			//mVertexBuffer[int(vIdx + 41)] = node2D.color02;
			//mVertexBuffer[int(vIdx + 42)] = node2D.color03;
			//mVertexBuffer[int(vIdx + 43)] = node2D.color04;
			//mVertexBuffer[int(vIdx + 44)] = node2D.color05;
			//mVertexBuffer[int(vIdx + 45)] = node2D.color06;
			//mVertexBuffer[int(vIdx + 46)] = node2D.color07;
			//mVertexBuffer[int(vIdx + 47)] = node2D.color08;
			//
			// v4
			//mVertexBuffer[int(vIdx + 56)] = node2D.color01;
			//mVertexBuffer[int(vIdx + 57)] = node2D.color02;
			//mVertexBuffer[int(vIdx + 58)] = node2D.color03;
			//mVertexBuffer[int(vIdx + 59)] = node2D.color04;
			//mVertexBuffer[int(vIdx + 60)] = node2D.color05;
			//mVertexBuffer[int(vIdx + 61)] = node2D.color06;
			//mVertexBuffer[int(vIdx + 62)] = node2D.color07;
			//mVertexBuffer[int(vIdx + 63)] = node2D.color08;
			
			vIdx += numFloatsPerVertex * 4;
			
			// update static references
			//staticIdx = vIdx;
			//staticLast = node;
			
			//node2D.invalidateUV = false;
			//node2D.invalidateMatrix = false;
			//node2D.invalidateClipSpace = false;
			//node2D.invalidateVisibility = false;
			
			//currentUsesUV = currentUsesUV || node2D.usesUV;
			//currentUsesColor = currentUsesColor || node2D.usesColor || !node2D.visible;
			//currentUsesColorOffset = currentUsesColorOffset || node2D.usesColorOffset;
			
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
			
			//if (vertexBuffer)
			//{
				//vertexBuffer.dispose();
				//vertexBuffer = null;
			//}
			
			// upload changed vertexBuffer
			vertexBuffer.uploadFromVector(mVertexBuffer, 0, mVertexBuffer.length / numFloatsPerVertex);
			
			
			
			//if (currentUsesUV != lastUsesUV || currentUsesColor != lastUsesColor || currentUsesColorOffset != lastUsesColorOffset)
			//{
				//shaderData = null;
				//lastUsesUV = currentUsesUV;
				//lastUsesColor = currentUsesColor;
				//lastUsesColorOffset = currentUsesColorOffset;
			//}
			
			if (!shaderData)
			{
				var defines:Array = ["Texture2DCloud",
					"USE_UV", false,
					"USE_COLOR", false,
					"USE_COLOR_OFFSET", false];
					
				shaderData = ShaderCache.getShader(context, defines, VERTEX_SHADER, FRAGMENT_SHADER, numFloatsPerVertex, texture);
				
				context.setProgram(shaderData.shader);
				
				context.setTextureAt(0, texture.getTexture(context));
			
				context.setBlendFactors(blendMode.src, blendMode.dst);
			}
			
			//context.setProgram(shaderData.shader);
			
			context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			//context.setVertexBufferAt(2, vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4); // uvSheet
			//context.setVertexBufferAt(3, vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_4); // colorMultiplier
			//context.setVertexBufferAt(4, vertexBuffer, 12, Context3DVertexBufferFormat.FLOAT_4); // colorOffset
			
			//if (parentNode2D.worldScrollRect) 
			//{
				//context.setScissorRectangle(parentNode2D.worldScrollRect);
			//}
			
			
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, parentNode2D.worldModelMatrix, true);
			//context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 4, parentNode2D.worldModelMatrix, true);
			
			context.drawTriangles(indexBuffer, 0, totalNodes << 1);
			
			//trace("oki");
			
			Statistics.drawCalls++;
			//Statistics.sprites += childCount;
			//Statistics.triangles += (childCount << 1);
			
			//context.setTextureAt(0, null);
			
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
			context.setVertexBufferAt(3, null);
			context.setVertexBufferAt(4, null);
			
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