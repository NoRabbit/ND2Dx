/*
 * ND2D - A Flash Molehill GPU accelerated 2D engine
 *
 * Author: Lars Gerckens
 * Copyright (c) nulldesign 2011
 * Repository URL: http://github.com/nulldesign/nd2d
 * Getting started: https://github.com/nulldesign/nd2d/wiki
 *
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package de.nulldesign.nd2dx.materials 
{	
	import de.nulldesign.nd2dx.materials.shader.ShaderCache;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import flash.geom.Matrix3D;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;

	public class Texture2DMaterial extends MaterialBase 
	{
		private static const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1.xy, uv;" +
			"alias vc0, viewProjection;" +
			"alias vc4, clipSpace;" +
			"alias vc8, uvSheet;" +
			"alias vc9, uvScroll;" +
			"alias vc10, color;" +
			
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
			
		public var texture:Texture2D;
		
		public var uvRect:Rectangle;
		
		public var uvOffsetX:Number = 0.0;
		public var uvOffsetY:Number = 0.0;
		public var uvScaleX:Number = 1.0;
		public var uvScaleY:Number = 1.0;
		
		public var frameOffsetX:Number = 0.0;
		public var frameOffsetY:Number = 0.0;
		
		private var _useUV:Boolean = false;
		
		protected var programConstants:Vector.<Number> = new Vector.<Number>(12, true);
		
		public function Texture2DMaterial() 
		{
			
		}
		
		public function setTexture(value:Texture2D):void
		{
			if ( texture == value ) return;
			
			texture = value;
			
			if ( texture )
			{
				uvRect = texture.uvRect;
				width = texture.bitmapWidth;
				height = texture.bitmapHeight;
				frameOffsetX = texture.frameOffsetX;
				frameOffsetY = texture.frameOffsetY;
			}
			else
			{
				uvRect = null;
				width = 0;
				height = 0;
				frameOffsetX = 0.0;
				frameOffsetY = 0.0;
			}
			
			invalidateClipSpace = true;
		}
		
		override public function updateClipSpace():void 
		{
			clipSpaceMatrix.identity();
			clipSpaceMatrix.appendScale(_width, _height, 1.0);
			clipSpaceMatrix.appendTranslation(frameOffsetX, frameOffsetY, 0.0);
			//trace(frameOffsetX, frameOffsetY);
			clipSpaceMatrix.append(_node.worldModelMatrix);
			invalidateClipSpace = false;
		}
		
		override protected function prepareForRender(context:Context3D):void 
		{
			super.prepareForRender(context);
			
			context.setTextureAt(0, texture.getTexture(context));
			context.setVertexBufferAt(0, mesh.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, mesh.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			
			if (node.useScrollRect) 
			{
				context.setScissorRectangle(node.worldScrollRect);
			}
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, clipSpaceMatrix, true);
			
			programConstants[0] = uvRect.x;
			programConstants[1] = uvRect.y;
			programConstants[2] = uvRect.width;
			programConstants[3] = uvRect.height;
			
			programConstants[4] = uvOffsetX;
			programConstants[5] = uvOffsetY;
			programConstants[6] = uvScaleX;
			programConstants[7] = uvScaleY;
			
			programConstants[8] = _node.combinedTintRed;
			programConstants[9] = _node.combinedTintGreen;
			programConstants[10] = _node.combinedTintBlue;
			programConstants[11] = _node.combinedAlpha;
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, programConstants);
		}
		
		override protected function clearAfterRender(context:Context3D):void 
		{
			context.setTextureAt(0, null);
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setScissorRectangle(null);
		}
		
		override protected function initProgram(context:Context3D):void 
		{
			if (!shaderData || invalidateProgram) 
			{
				invalidateProgram = false;
				
				var defines:Array = ["Texture2DMaterial",
					"USE_UV", useUV];
				
				shaderData = ShaderCache.getShader(context, defines, VERTEX_SHADER, FRAGMENT_SHADER, texture);
			}
		}
		
		override public function dispose():void 
		{			
			super.dispose();
			uvRect = null;
			texture = null;
			programConstants = null;
		}
		
		public function get useUV():Boolean 
		{
			return _useUV;
		}
		
		public function set useUV(value:Boolean):void 
		{
			if ( _useUV == value ) return;
			_useUV = value;
			invalidateProgram = true;
		}
		
	}
}
