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
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class _test_TestBatchRenderSupport extends RenderSupportBase
	{
		private const numFloatsPerVertex:uint = 8;
		
		private const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1, uv;" +
			"alias va2, color;" +
			
			"alias vc0, viewProjection;" +
			//"alias vc4, clipSpace;" +
			
			//"temp0 = mul4x4(position, clipSpace);" +
			//"output = mul4x4(temp0, viewProjection);" +
			"temp0 = position;" +
			"output = mul4x4(temp0, viewProjection);" +
			
			"temp0 = uv;" +
			
			"temp1 = color;" +
			
			"#if PREMULTIPLIED_ALPHA;" +
			"	temp1.x = temp1.x * temp1.w;" +
			"	temp1.y = temp1.y * temp1.w;" +
			"	temp1.z = temp1.z * temp1.w;" +
			"#endif;" +
			
			// pass to fragment shader
			"v0 = temp0;" +
			"v1 = temp1;";
			
		private const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			"alias v1, color;" +
			"temp0 = sample(texCoord, texture0);" +
			"temp0 *= color;" +
			"output = temp0;";
			
			
		//private static const VERTEX_SHADER:String =
			//"alias va0, position;" +
			//"alias va1.xy, uv;" +
			//"alias vc0, viewProjection;" +
			//"alias vc4, clipSpace;" +
			//"alias vc8, uvSheet;" +
			//"alias vc9, uvScroll;" +
			//"alias vc10, color;" +
			//
			//"temp0 = mul4x4(position, clipSpace);" +
			//"output = mul4x4(temp0, viewProjection);" +
			//
			//"temp0 = applyUV(uv, uvScroll, uvSheet);" +
			//"temp1 = color;" +
			//
			//"#if PREMULTIPLIED_ALPHA;" +
			//"	temp1.x = temp1.x * temp1.w;" +
			//"	temp1.y = temp1.y * temp1.w;" +
			//"	temp1.z = temp1.z * temp1.w;" +
			//"#endif;" +
			//
			// pass to fragment shader
			//"v0 = temp0;" +
			//"v1 = uvSheet;" +
			//"v2 = temp1;";
			//
		//private static const FRAGMENT_SHADER:String =
			//"alias v0, texCoord;" +
			//"alias v1, uvSheet;" +
			//"alias v2, color;" +
			//"temp1 = sampleUV(texCoord, texture0, uvSheet);" +
			//"temp1 *= color;" +
			//"output = temp1;";
		
		protected var maxCapacity:uint;
		
		protected var shaderData:Shader2D;
		protected var indexBuffer:IndexBuffer3D;
		protected var vertexBuffer:VertexBuffer3D;
		protected var mVertexBuffer:Vector.<Number>;
		protected var mIndexBuffer:Vector.<uint>;
		
		public var totalNodes:int = 0;
		public var parentNode:Node2D;
		public var node:Node2D;
		
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
		
		public var v1x_prep:Number;
		public var v1y_prep:Number;
		public var v2x_prep:Number;
		public var v2y_prep:Number;
		public var v3x_prep:Number;
		public var v3y_prep:Number;
		public var v4x_prep:Number;
		public var v4y_prep:Number;
		
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
		
		public function _test_TestBatchRenderSupport() 
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
		
		override public function prepare():void 
		{
			super.prepare();
			
			vIdx = 0;
			totalNodes = 0;
			
			parentNode = null;
			
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
			node = meshRenderer.node;
			material = meshRenderer.material as Texture2DMaterial;
			texture = material.texture;
			
			//if ( !parentNode )
			//{
				//parentNode = node.parent;
				//updateNewParentData();
			//}
			//else if ( parentNode && node.parent != parentNode )
			//{
				// if parent has changed, draw cloud
				//drawCloud();
				//parentNode = node.parent;
				//updateNewParentData();
			//}
			
			// POSITION
			
			/*var m:Matrix3D = new Matrix3D();
			m.appendScale(material.width, material.height, 1.0);
			m.appendTranslation(material.frameOffsetX, material.frameOffsetY, 0.0);
			m.append(node.worldModelMatrix);
			
			// v1
			var v:Vector3D = new Vector3D(v1x, v1y, 0.0, 1.0);
			v = m.transformVector(v);
			
			mVertexBuffer[int(vIdx)] = v.x;
			mVertexBuffer[int(vIdx + 1)] = v.y;
			
			// v2
			v.setTo(v2x, v2y, 0.0);
			v = m.transformVector(v);
			
			mVertexBuffer[int(vIdx + numFloatsPerVertex)] = v.x;
			mVertexBuffer[int(vIdx + numFloatsPerVertex + 1)] = v.y;
			
			// v3
			v.setTo(v3x, v3y, 0.0);
			v = m.transformVector(v);
			
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2))] = v.x;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2) + 1)] = v.y;
			
			// v4
			v.setTo(v4x, v4y, 0.0);
			v = m.transformVector(v);
			
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3))] = v.x;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3) + 1)] = v.y;*/
			
			var m:Matrix3D = new Matrix3D();
			m.appendScale(material.width, material.height, 1.0);
			m.appendTranslation(material.frameOffsetX, material.frameOffsetY, 0.0);
			m.append(node.worldModelMatrix);
			var v:Vector.<Number> = m.rawData;
			parentWorldModelMatrix_00 = v[0];
			parentWorldModelMatrix_01 = v[1];
			parentWorldModelMatrix_02 = v[2];
			parentWorldModelMatrix_03 = v[3];
			parentWorldModelMatrix_10 = v[4];
			parentWorldModelMatrix_11 = v[5];
			parentWorldModelMatrix_12 = v[6];
			parentWorldModelMatrix_13 = v[7];
			parentWorldModelMatrix_20 = v[8];
			parentWorldModelMatrix_21 = v[9];
			parentWorldModelMatrix_22 = v[10];
			parentWorldModelMatrix_23 = v[11];
			parentWorldModelMatrix_30 = v[12];
			parentWorldModelMatrix_31 = v[13];
			parentWorldModelMatrix_32 = v[14];
			parentWorldModelMatrix_33 = v[15];
			
			//n11 = values[0];
			//n12 = values[1];
			//n13 = values[2];
			//n14 = values[3];
			//n21 = values[4];
			//n22 = values[5];
			//n23 = values[6];
			//n24 = values[7];
			//n31 = values[8];
			//n32 = values[9];
			//n33 = values[10];
			//n34 = values[11];
			//if ( values.length < 16 )
			//{
				//n41 = 0;
				//n42 = 0;
				//n43 = 0;
				//n44 = 1;
			//}
			//else
			//{
				//n41 = values[12];
				//n42 = values[13];
				//n43 = values[14];
				//n44 = values[15];
			//}
			
			// v1
			mVertexBuffer[int(vIdx)] = parentWorldModelMatrix_00 * v1x + parentWorldModelMatrix_01 * v1y + parentWorldModelMatrix_03;
			mVertexBuffer[int(vIdx + 1)] = parentWorldModelMatrix_10 * v1x + parentWorldModelMatrix_11 * v1y + parentWorldModelMatrix_13;
			
			// v2
			mVertexBuffer[int(vIdx + numFloatsPerVertex)] = parentWorldModelMatrix_00 * v2x + parentWorldModelMatrix_01 * v2y + parentWorldModelMatrix_03;
			mVertexBuffer[int(vIdx + numFloatsPerVertex + 1)] = parentWorldModelMatrix_10 * v2x + parentWorldModelMatrix_11 * v2y + parentWorldModelMatrix_13;
			
			// v3
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2))] = parentWorldModelMatrix_00 * v3x + parentWorldModelMatrix_01 * v3y + parentWorldModelMatrix_03;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2) + 1)] = parentWorldModelMatrix_10 * v3x + parentWorldModelMatrix_11 * v3y + parentWorldModelMatrix_13;
			
			// v4
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3))] = parentWorldModelMatrix_00 * v4x + parentWorldModelMatrix_01 * v4y + parentWorldModelMatrix_03;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3) + 1)] = parentWorldModelMatrix_10 * v4x + parentWorldModelMatrix_11 * v4y + parentWorldModelMatrix_13;
			
			//public function transformVector( vector : Vector3d, result : Vector3d = null ) : Vector3d
			//{
				//if ( result == null )
				//{
					//result = new Vector3d();
				//}
				//result.x = n11 * vector.x + n12 * vector.y + n13 * vector.z + n14 * vector.w;
				//result.y = n21 * vector.x + n22 * vector.y + n23 * vector.z + n24 * vector.w;
				//result.z = n31 * vector.x + n32 * vector.y + n33 * vector.z + n34 * vector.w;
				//result.w = n41 * vector.x + n42 * vector.y + n43 * vector.z + n44 * vector.w;
				//return result;
			//}
			
			/*
			sx = node.scaleX * material.width;
			sy = node.scaleY * material.height;
			
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
			
			offsetX = node.x + texture.frameOffsetX;
			offsetY = node.y + texture.frameOffsetY;
			
			//offsetX = node.x;
			//offsetY = node.y;
			
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
			
			mVertexBuffer[int(vIdx)] = parentWorldModelMatrix_00 * v1x_prep + parentWorldModelMatrix_10 * v1y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + 1)] = parentWorldModelMatrix_01 * v1x_prep + parentWorldModelMatrix_11 * v1y_prep + parentWorldModelMatrix_31;
			
			mVertexBuffer[int(vIdx + numFloatsPerVertex)] = parentWorldModelMatrix_00 * v2x_prep + parentWorldModelMatrix_10 * v2y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + numFloatsPerVertex + 1)] = parentWorldModelMatrix_01 * v2x_prep + parentWorldModelMatrix_11 * v2y_prep + parentWorldModelMatrix_31;
			
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2))] = parentWorldModelMatrix_00 * v3x_prep + parentWorldModelMatrix_10 * v3y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2) + 1)] = parentWorldModelMatrix_01 * v3x_prep + parentWorldModelMatrix_11 * v3y_prep + parentWorldModelMatrix_31;
			
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3))] = parentWorldModelMatrix_00 * v4x_prep + parentWorldModelMatrix_10 * v4y_prep + parentWorldModelMatrix_30;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3) + 1)] = parentWorldModelMatrix_01 * v4x_prep + parentWorldModelMatrix_11 * v4y_prep + parentWorldModelMatrix_31;
			*/
			
			/*// v1
			mVertexBuffer[int(vIdx)] = (v1x * sx - pivotX) * cr - (v1y * sy - pivotY) * sr + offsetX;
			mVertexBuffer[int(vIdx + 1)] = (v1x * sx - pivotX) * sr + (v1y * sy - pivotY) * cr + offsetY;
			
			 //v2
			mVertexBuffer[int(vIdx + numFloatsPerVertex)] = (v2x * sx - pivotX) * cr - (v2y * sy - pivotY) * sr + offsetX;
			mVertexBuffer[int(vIdx + numFloatsPerVertex + 1)] = (v2x * sx - pivotX) * sr + (v2y * sy - pivotY) * cr + offsetY;
			
			 //v3
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2))] = (v3x * sx - pivotX) * cr - (v3y * sy - pivotY) * sr + offsetX;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2) + 1)] = (v3x * sx - pivotX) * sr + (v3y * sy - pivotY) * cr + offsetY;
			
			 //v4
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3))] = (v4x * sx - pivotX) * cr - (v4y * sy - pivotY) * sr + offsetX;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3) + 1)] = (v4x * sx - pivotX) * sr + (v4y * sy - pivotY) * cr + offsetY;*/
			
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
			mVertexBuffer[int(vIdx + numFloatsPerVertex + 2)] = uv2x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + numFloatsPerVertex + 3)] = uv2y * uvScaleY + uvOffsetY;
			
			//v3
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2) + 2)] = uv3x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 2) + 3)] = uv3y * uvScaleY + uvOffsetY;
			
			//v4
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3) + 2)] = uv4x * uvScaleX + uvOffsetX;
			mVertexBuffer[int(vIdx + (numFloatsPerVertex * 3) + 3)] = uv4y * uvScaleY + uvOffsetY;
			
			// COLOR
			
			// v1
			mVertexBuffer[int(vIdx) + 4] = node.combinedTintRed;
			mVertexBuffer[int(vIdx) + 5] = node.combinedTintGreen;
			mVertexBuffer[int(vIdx) + 6] = node.combinedTintBlue;
			mVertexBuffer[int(vIdx) + 7] = node.combinedAlpha;
			
			//v2
			mVertexBuffer[int(vIdx) + numFloatsPerVertex + 4] = node.combinedTintRed;
			mVertexBuffer[int(vIdx) + numFloatsPerVertex + 5] = node.combinedTintGreen;
			mVertexBuffer[int(vIdx) + numFloatsPerVertex + 6] = node.combinedTintBlue;
			mVertexBuffer[int(vIdx) + numFloatsPerVertex + 7] = node.combinedAlpha;
			
			//v3
			mVertexBuffer[int(vIdx) + (numFloatsPerVertex * 2) + 4] = node.combinedTintRed;
			mVertexBuffer[int(vIdx) + (numFloatsPerVertex * 2) + 5] = node.combinedTintGreen;
			mVertexBuffer[int(vIdx) + (numFloatsPerVertex * 2) + 6] = node.combinedTintBlue;
			mVertexBuffer[int(vIdx) + (numFloatsPerVertex * 2) + 7] = node.combinedAlpha;
			
			//v4
			mVertexBuffer[int(vIdx) + (numFloatsPerVertex * 3) + 4] = node.combinedTintRed;
			mVertexBuffer[int(vIdx) + (numFloatsPerVertex * 3) + 5] = node.combinedTintGreen;
			mVertexBuffer[int(vIdx) + (numFloatsPerVertex * 3) + 6] = node.combinedTintBlue;
			mVertexBuffer[int(vIdx) + (numFloatsPerVertex * 3) + 7] = node.combinedAlpha;
			
			// increment id
			vIdx += numFloatsPerVertex * 4;
			
			totalNodes++;
			
			if ( totalNodes == maxCapacity )
			{
				// we need to draw our data
				drawCloud();
			}
		}
		
		public function updateNewParentData():void
		{
			//if (performMatrixCalculations && (invalidateMatrix || (parent && parent.invalidateMatrix)))
			//{
				//if (invalidateMatrix)
				//{
					//updateLocalMatrix();
				//}
				//
				//updateWorldMatrix();
				//
				//invalidateMatrix = true;
			//}
			
			parentNode.updateLocalMatrix();
			parentNode.updateWorldMatrix();
			
			var v:Vector.<Number> = parentNode.worldModelMatrix.rawData;
			
			parentWorldModelMatrix_00 = v[0];
			parentWorldModelMatrix_01 = v[1];
			parentWorldModelMatrix_02 = v[2];
			parentWorldModelMatrix_03 = v[3];
			parentWorldModelMatrix_10 = v[4];
			parentWorldModelMatrix_11 = v[5];
			parentWorldModelMatrix_12 = v[6];
			parentWorldModelMatrix_13 = v[7];
			parentWorldModelMatrix_20 = v[8];
			parentWorldModelMatrix_21 = v[9];
			parentWorldModelMatrix_22 = v[10];
			parentWorldModelMatrix_23 = v[11];
			parentWorldModelMatrix_30 = v[12];
			parentWorldModelMatrix_31 = v[13];
			parentWorldModelMatrix_32 = v[14];
			parentWorldModelMatrix_33 = v[15];
		}
		
		public function drawCloud():void
		{
			if ( totalNodes <= 0 ) return;
			
			if (!shaderData)
			{
				var defines:Array = ["Texture2DCloud",
					"USE_UV", false,
					"USE_COLOR", false,
					"USE_COLOR_OFFSET", false];
				
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
			
			//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, camera.getViewProjectionMatrix(false), true);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
			//context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, parentNode.worldModelMatrix, true);
			
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
		
		override public function finalize():void 
		{
			super.finalize();
			
			drawCloud();
		}
	}

}