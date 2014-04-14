package de.nulldesign.nd2dx.support 
{
	import de.nulldesign.nd2dx.components.Mesh2DRendererComponent;
	import de.nulldesign.nd2dx.display.Camera2D;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Sprite2D;
	import de.nulldesign.nd2dx.materials.BlendModePresets;
	import de.nulldesign.nd2dx.materials.shader.Shader2D;
	import de.nulldesign.nd2dx.materials.shader.ShaderCache;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.materials.Texture2DMaterial;
	import de.nulldesign.nd2dx.utils.NodeBlendMode;
	import de.nulldesign.nd2dx.utils.Statistics;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.display3D.IndexBuffer3D;
	import flash.display3D.VertexBuffer3D;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Texture2DMaterialFastCloudRenderSupport
	{
		private const numFloatsPerVertex:uint = 8;
		
		private const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1, uv;" +
			"alias va2, color;" +
			
			"alias vc0, viewProjection;" +
			"temp0 = position;" +
			"output = mul4x4(temp0, viewProjection);" +
			
			"temp0 = uv;" +
			
			"temp1 = color;" +
			
			"#if PREMULTIPLIED_ALPHA;" +
			"	temp1.x = temp1.x * temp1.w;" +
			"	temp1.y = temp1.y * temp1.w;" +
			"	temp1.z = temp1.z * temp1.w;" +
			"#endif;" +
			
			"v0 = temp0;" +
			"v1 = temp1;";
			
		private const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			"alias v1, color;" +
			"temp0 = sample(texCoord, texture0);" +
			"temp0 *= color;" +
			"output = temp0;";
			
		
		public var context:Context3D = null;
		public var camera:Camera2D = null;
		public var elapsed:Number = 0.0
		public var deviceWasLost:Boolean = false;
		public var viewProjectionMatrix:Matrix3D;
		public var isPrepared:Boolean = false;
			
		protected var maxCapacity:uint;
		
		protected var shaderData:Shader2D;
		protected var indexBuffer:IndexBuffer3D;
		protected var vertexBuffer:VertexBuffer3D;
		protected var mVertexBuffer:Vector.<Number>;
		protected var mIndexBuffer:Vector.<uint>;
		
		public var totalNodes:int = 0;
		
		public var currentScrollRect:Rectangle = null;
		public var vScrollRects:Vector.<Rectangle> = new Vector.<Rectangle>();
		
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
		private var frameOffsetXScaled:Number;
		private var frameOffsetYScaled:Number;
		
		public var uvRect:Rectangle;
		public var uvOffsetX:Number = 0.0;
		public var uvOffsetY:Number = 0.0;
		public var uvScaleX:Number = 1.0;
		public var uvScaleY:Number = 1.0;
		
		public var v1x_prep:Number;
		public var v1y_prep:Number;
		public var v2x_prep:Number;
		public var v2y_prep:Number;
		public var v3x_prep:Number;
		public var v3y_prep:Number;
		public var v4x_prep:Number;
		public var v4y_prep:Number;
		
		public var parentWorldModelMatrixVector:Vector.<Number>;
		public var parentWorldModelMatrix_00:Number = 1.0;
		public var parentWorldModelMatrix_01:Number = 1.0;
		public var parentWorldModelMatrix_02:Number = 1.0;
		public var parentWorldModelMatrix_03:Number = 1.0;
		public var parentWorldModelMatrix_10:Number = 1.0;
		public var parentWorldModelMatrix_11:Number = 1.0;
		public var parentWorldModelMatrix_12:Number = 1.0;
		public var parentWorldModelMatrix_13:Number = 1.0;
		public var parentWorldModelMatrix_20:Number = 1.0;
		public var parentWorldModelMatrix_21:Number = 1.0;
		public var parentWorldModelMatrix_22:Number = 1.0;
		public var parentWorldModelMatrix_23:Number = 1.0;
		public var parentWorldModelMatrix_30:Number = 0.0;
		public var parentWorldModelMatrix_31:Number = 0.0;
		public var parentWorldModelMatrix_32:Number = 0.0;
		public var parentWorldModelMatrix_33:Number = 0.0;
		
		public function Texture2DMaterialFastCloudRenderSupport() 
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
			
			v1x = -0.5;
			v1y = -0.5;
			v2x = 0.5;
			v2y = -0.5;
			v3x = -0.5;
			v3y = 0.5;
			v4x = 0.5;
			v4y = 0.5;
			
			mVertexBuffer = new Vector.<Number>(maxCapacity * numFloatsPerVertex * 4, true);
			mIndexBuffer = new Vector.<uint>(maxCapacity * 6, true);
		}
		
		public function prepare():void 
		{
			vIdx = 0;
			totalNodes = 0;
			
			//parentNode = null;
			//currentScrollRect = null;
			//if ( vScrollRects.length ) vScrollRects.splice(0, vScrollRects.length);
			
			//parentWorldModelMatrix_00 = 1.0;
			//parentWorldModelMatrix_01 = 1.0;
			//parentWorldModelMatrix_02 = 1.0;
			//parentWorldModelMatrix_03 = 1.0;
			//parentWorldModelMatrix_10 = 1.0;
			//parentWorldModelMatrix_11 = 1.0;
			//parentWorldModelMatrix_12 = 1.0;
			//parentWorldModelMatrix_13 = 1.0;
			//parentWorldModelMatrix_20 = 1.0;
			//parentWorldModelMatrix_21 = 1.0;
			//parentWorldModelMatrix_22 = 1.0;
			//parentWorldModelMatrix_23 = 1.0;
			//parentWorldModelMatrix_30 = 0.0;
			//parentWorldModelMatrix_31 = 0.0;
			//parentWorldModelMatrix_32 = 0.0;
			//parentWorldModelMatrix_33 = 0.0;
			
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
		
		//public function setScrollRect(node:Node2D):void 
		//{
			//drawCloud();
			//
			//node.checkAndUpdateMatrixIfNeeded();
			//
			//currentScrollRect = node.worldScrollRect;
			//vScrollRects.push(currentScrollRect);
		//}
		
		public function drawChildren(childFirst:Node2D):void
		{
			for (var child:Node2D = childFirst; child; child = child.next)
			{
				drawChild(child);
			}
		}
		
		public function drawChild(node:Node2D):void 
		{
			//material = node.mesh2DRendererComponent.material as Texture2DMaterial;
			//texture = material.texture;
			
			node.step(elapsed)
			
			// POSITION
			sx = node._scaleX * material.width;
			sy = node._scaleY * material.height;
			
			if (node.rotation) 
			{
				rot = node.rotation * DEG2RAD;
				cr = Math.cos(rot);
				sr = Math.sin(rot);
			}
			else
			{
				cr = 1.0;
				sr = 0.0;
			}
			
			pivotX = node.pivot.x;
			pivotY = node.pivot.y;
			
			frameOffsetXScaled = material.frameOffsetX * node._scaleX;
			frameOffsetYScaled = material.frameOffsetY * node._scaleY;
			
			offsetX = node.x + (frameOffsetXScaled * cr - frameOffsetYScaled * sr);
			offsetY = node.y + (frameOffsetXScaled * sr + frameOffsetYScaled * cr);
			
			// v1
			v1x_prep = (v1x * sx - pivotX) * cr - (v1y * sy - pivotY) * sr + offsetX;
			v1y_prep = (v1x * sx - pivotX) * sr + (v1y * sy - pivotY) * cr + offsetY;
			
			//v2
			v2x_prep = (v2x * sx - pivotX) * cr - (v2y * sy - pivotY) * sr + offsetX;
			v2y_prep = (v2x * sx - pivotX) * sr + (v2y * sy - pivotY) * cr + offsetY;
			
			//v3
			v3x_prep = (v3x * sx - pivotX) * cr - (v3y * sy - pivotY) * sr + offsetX;
			v3y_prep = (v3x * sx - pivotX) * sr + (v3y * sy - pivotY) * cr + offsetY;
			
			//v4
			v4x_prep = (v4x * sx - pivotX) * cr - (v4y * sy - pivotY) * sr + offsetX;
			v4y_prep = (v4x * sx - pivotX) * sr + (v4y * sy - pivotY) * cr + offsetY;
			
			// v1
			mVertexBuffer[int(vIdx)] = parentWorldModelMatrix_00 * v1x_prep + parentWorldModelMatrix_10 * v1y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 1)] = parentWorldModelMatrix_01 * v1x_prep + parentWorldModelMatrix_11 * v1y_prep + parentWorldModelMatrix_31;
			
			// v2
			mVertexBuffer[int(vIdx + 8)] = parentWorldModelMatrix_00 * v2x_prep + parentWorldModelMatrix_10 * v2y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 9)] = parentWorldModelMatrix_01 * v2x_prep + parentWorldModelMatrix_11 * v2y_prep + parentWorldModelMatrix_31;
			
			// v3
			mVertexBuffer[int(vIdx + 16)] = parentWorldModelMatrix_00 * v3x_prep + parentWorldModelMatrix_10 * v3y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 17)] = parentWorldModelMatrix_01 * v3x_prep + parentWorldModelMatrix_11 * v3y_prep + parentWorldModelMatrix_31;
			
			// v4
			mVertexBuffer[int(vIdx + 24)] = parentWorldModelMatrix_00 * v4x_prep + parentWorldModelMatrix_10 * v4y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 25)] = parentWorldModelMatrix_01 * v4x_prep + parentWorldModelMatrix_11 * v4y_prep + parentWorldModelMatrix_31;
			
			/*mVertexBuffer[int(vIdx)] = 100;// parentWorldModelMatrix_00 * v1x_prep + parentWorldModelMatrix_10 * v1y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 1)] = 100;// parentWorldModelMatrix_01 * v1x_prep + parentWorldModelMatrix_11 * v1y_prep + parentWorldModelMatrix_31;
			
			// v2
			mVertexBuffer[int(vIdx + 8)] = 200;// parentWorldModelMatrix_00 * v2x_prep + parentWorldModelMatrix_10 * v2y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 9)] = 100;// parentWorldModelMatrix_01 * v2x_prep + parentWorldModelMatrix_11 * v2y_prep + parentWorldModelMatrix_31;
			
			// v3
			mVertexBuffer[int(vIdx + 16)] = 200;// parentWorldModelMatrix_00 * v3x_prep + parentWorldModelMatrix_10 * v3y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 17)] = 200;// parentWorldModelMatrix_01 * v3x_prep + parentWorldModelMatrix_11 * v3y_prep + parentWorldModelMatrix_31;
			
			// v4
			mVertexBuffer[int(vIdx + 24)] = 100;// parentWorldModelMatrix_00 * v4x_prep + parentWorldModelMatrix_10 * v4y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 25)] = 200;// parentWorldModelMatrix_01 * v4x_prep + parentWorldModelMatrix_11 * v4y_prep + parentWorldModelMatrix_31;*/
			
			//trace(mVertexBuffer[int(vIdx)], mVertexBuffer[int(vIdx + 1)], mVertexBuffer[int(vIdx + 8)], mVertexBuffer[int(vIdx + 9)], mVertexBuffer[int(vIdx + 16)], mVertexBuffer[int(vIdx + 17)], mVertexBuffer[int(vIdx + 24)], mVertexBuffer[int(vIdx + 25)]);
			
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
			mVertexBuffer[int(vIdx + 10)] = uv2x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + 11)] = uv2y * uvScaleY + uvOffsetY;
			
			//v3
			mVertexBuffer[int(vIdx + 18)] = uv3x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + 19)] = uv3y * uvScaleY + uvOffsetY;
			
			//v4
			mVertexBuffer[int(vIdx + 26)] = uv4x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + 27)] = uv4y * uvScaleY + uvOffsetY;
			
			// COLOR
			
			// v1
			mVertexBuffer[int(vIdx) + 4] = node.combinedTintRed;
			mVertexBuffer[int(vIdx) + 5] = node.combinedTintGreen;
			mVertexBuffer[int(vIdx) + 6] = node.combinedTintBlue;
			mVertexBuffer[int(vIdx) + 7] = node.combinedAlpha;
			
			//v2
			mVertexBuffer[int(vIdx) + 12] = node.combinedTintRed;
			mVertexBuffer[int(vIdx) + 13] = node.combinedTintGreen;
			mVertexBuffer[int(vIdx) + 14] = node.combinedTintBlue;
			mVertexBuffer[int(vIdx) + 15] = node.combinedAlpha;
			
			//v3
			mVertexBuffer[int(vIdx) + 20] = node.combinedTintRed;
			mVertexBuffer[int(vIdx) + 21] = node.combinedTintGreen;
			mVertexBuffer[int(vIdx) + 22] = node.combinedTintBlue;
			mVertexBuffer[int(vIdx) + 23] = node.combinedAlpha;
			
			//v4
			mVertexBuffer[int(vIdx) + 28] = node.combinedTintRed;
			mVertexBuffer[int(vIdx) + 29] = node.combinedTintGreen;
			mVertexBuffer[int(vIdx) + 30] = node.combinedTintBlue;
			mVertexBuffer[int(vIdx) + 31] = node.combinedAlpha;
			
			// increment id
			vIdx += numFloatsPerVertex * 4;
			
			totalNodes++;
			
			if ( totalNodes == maxCapacity )
			{
				// we need to draw our data
				drawCloud();
			}
		}
		
		//override public function endDrawNode(node:Node2D):void 
		//{
			//if ( node.localScrollRect )
			//{
				//var index:int = vScrollRects.indexOf(node.worldScrollRect);
				//
				//if ( index >= 0 )
				//{
					//vScrollRects.splice(index, 1);
				//}
				//
				//drawCloud();
				//
				//if ( vScrollRects.length )
				//{
					//currentScrollRect = vScrollRects[vScrollRects.length - 1];
				//}
				//else
				//{
					//currentScrollRect = null;
				//}
			//}
		//}
		
		public function updateNewParentData(parentNode:Node2D):void
		{
			parentWorldModelMatrixVector = parentNode.worldModelMatrix.rawData;
			
			parentWorldModelMatrix_00 = parentWorldModelMatrixVector[0];
			parentWorldModelMatrix_01 = parentWorldModelMatrixVector[1];
			parentWorldModelMatrix_02 = parentWorldModelMatrixVector[2];
			parentWorldModelMatrix_03 = parentWorldModelMatrixVector[3];
			parentWorldModelMatrix_10 = parentWorldModelMatrixVector[4];
			parentWorldModelMatrix_11 = parentWorldModelMatrixVector[5];
			parentWorldModelMatrix_12 = parentWorldModelMatrixVector[6];
			parentWorldModelMatrix_13 = parentWorldModelMatrixVector[7];
			parentWorldModelMatrix_20 = parentWorldModelMatrixVector[8];
			parentWorldModelMatrix_21 = parentWorldModelMatrixVector[9];
			parentWorldModelMatrix_22 = parentWorldModelMatrixVector[10];
			parentWorldModelMatrix_23 = parentWorldModelMatrixVector[11];
			parentWorldModelMatrix_30 = parentWorldModelMatrixVector[12];
			parentWorldModelMatrix_31 = parentWorldModelMatrixVector[13];
			parentWorldModelMatrix_32 = parentWorldModelMatrixVector[14];
			parentWorldModelMatrix_33 = parentWorldModelMatrixVector[15];
		}
		
		public function drawCloud():void
		{
			if ( totalNodes <= 0 ) return;
			
			if (!shaderData)
			{
				var defines:Array = ["Texture2DFastCloud"];
				
				shaderData = ShaderCache.getShader(context, defines, VERTEX_SHADER, FRAGMENT_SHADER, texture);
			}
			
			// set shader, texture and blendmode
			context.setProgram(shaderData.shader);
			context.setTextureAt(0, texture.getTexture(context));
			context.setBlendFactors(blendMode.src, blendMode.dst);
			
			// upload vertexBuffer
			vertexBuffer.uploadFromVector(mVertexBuffer, 0, mVertexBuffer.length / numFloatsPerVertex);
			
			context.setVertexBufferAt(0, vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			context.setVertexBufferAt(2, vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4); // color
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
			
			context.setScissorRectangle(null);
			//if ( currentScrollRect )
			//{
				//context.setScissorRectangle(currentScrollRect);
			//}
			
			context.drawTriangles(indexBuffer, 0, totalNodes << 1);
			
			Statistics.sprites += totalNodes;
			Statistics.drawCalls++;
			
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
			context.setScissorRectangle(null);
			
			vIdx = 0;
			totalNodes = 0;
		}
		
		public function finalize():void 
		{
			drawCloud();
		}
	}

}