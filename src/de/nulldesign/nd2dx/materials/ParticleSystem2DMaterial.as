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

	public class ParticleSystem2DMaterial extends Texture2DMaterial 
	{
		private static const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1, uv;" +
			
			"alias va2.x, startTime;" +
			"alias va2.y, lifeTime;" +
			"alias va2.z, startSize;" +
			"alias va2.w, endSize;" +
			
			"alias va3.xy, velocity;" +
			"alias va3.zw, startPos;" +
			
			"alias va4, startColor;" +
			"alias va5, endColor;" +
			"alias va6, rotation;" +
			
			"alias vc0, viewProjection;" +
			"alias vc4, clipSpace;" +
			"alias vc8, uvSheet;" +
			"alias vc9, uvScroll;" +
			
			"alias vc10.xy, gravity;" +
			"alias vc10.z, currentTime;" +
			"alias vc10.w, CONST(0.0);" +
			"alias vc11, clipScaleOffset;" +
			"alias vc12, parentColor;" +
			
			// progress calculation
			// 		clamp( frac( (currentTime - startTime) / lifeTime ) )
			
			// test
			"temp0.x = startTime + lifeTime;" +
			"temp0.y = currentTime / temp0.x;" +
			"#if !BURST;" +
			"	temp0.y = frac(temp0.y);" +
			"#endif;" +
			"temp0.x *= temp0.y;" +
			"temp0.x -= startTime;" +
			"temp0.x /= lifeTime;" +
			"sge temp0.y, temp0.x, 0.0;" +
			"temp0.x = clamp(temp0.x);" +
			"alias temp0, progress;" +
			
			// original
			//"temp0.x = currentTime - startTime;" +
			//"temp0.x /= lifeTime;" +
			//"#if !BURST;" +
			//"	temp0.x = frac(temp0.x);" +
			//"#endif;" +
			//"temp0.x = clamp(temp0.x);" +
			//"alias temp0.x, progress.x;" +
			
			// velocity / gravity calculation
			// 		(velocity + (gravity * progress)) * progress
			"temp1.x = gravity.x * progress.x;" +
			"temp1.y = gravity.y * progress.x;" +
			"temp1.x = velocity.x + temp1.x;" +
			"temp1.y = velocity.y + temp1.y;" +
			"temp1.x *= progress.x;" +
			"temp1.y *= progress.x;" +
			
			"alias temp1, currentVelocity;" +
			
			// size calculation
			"temp2.x = endSize - startSize;" +
			"temp2.x *= progress.x;" +
			"temp2.x += startSize;" +
			"temp2.x *= progress.y;" +
			"alias temp2, currentSize;" +
			
			// size calculation -> float size = startSize * (1.0 - progress) + endSize * progress;
			//"temp2.x = 1.0 - progress.x;" +
			//"temp2.x *= startSize;" +
			//"temp2.y = endSize * progress.x;" +
			//"temp2.x += temp2.y;" +
			//"alias temp2, currentSize;" +
			
			// move
			// 		(position * currentSize) + startPos + currentVelocity
			//"mov temp3, position;" +
			"temp3 = position;" +
			"temp3.x *= clipScaleOffset.x;" +
			"temp3.y *= clipScaleOffset.y;" +
			"temp3.x *= currentSize.x;" +
			"temp3.y *= currentSize.x;" +
			"temp4.xy = clipScaleOffset.zw * currentSize.x;" +
			"temp3.xy += temp4.xy;" +
			
			// ####### ROTATION
			"mov vt6, va6;" +
			"mov vt7, va6;" +
			"mul vt6.y vt6.y, progress.x;" +
			"add vt6.x vt6.x, vt6.y;" +
			
			//x = (x * cos(a)) - (y * sin(a));
			//y = sin(a) * x + cos(a) * y;
			
			// x
			"cos vt7.x vt6.x;" +
			"mul vt7.x vt7.x, temp3.x;" +
			"sin vt7.y vt6.x;" +
			"mul vt7.y vt7.y, temp3.y;" +
			"sub temp4.x vt7.x, vt7.y;" +
			
			// y
			"sin vt7.x vt6.x;" +
			"mul vt7.x vt7.x, temp3.x;" +
			"cos vt7.y vt6.x;" +
			"mul vt7.y vt7.y, temp3.y;" +
			"add temp4.y vt7.x, vt7.y;" +
			
			"temp3.xy = temp4.xy;" +
			//"output = temp3;" +
			// ####### END ROTATION
			
			
			
			"temp3.xy += startPos.xy;" +
			
			"temp3.xy += currentVelocity.xy;" +
			
			"temp3 = mul4x4(temp3, clipSpace);" +
			"output = mul4x4(temp3, viewProjection);" +
			
			
			
			// mix colors
			// 		(startColor * (1.0 - progress)) + (endColor * progress)
			"temp4 = endColor - startColor;" +
			"temp4 *= progress.x;" +
			"temp4 += startColor;" +
			"temp4 *= parentColor;" +
			
			"#if PREMULTIPLIED_ALPHA;" +
			"	temp4.xyz *= temp4.w;" +
			//"	temp4.xyz *= parentColor.w;" +
			"#endif;" +
			
			// pass to fragment shader
			//"v0 = uv;" +
			"temp0 = applyUV(uv, uvScroll, uvSheet);" +
			"v0 = temp0;" +
			"v1 = temp4;";

		private static const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			"alias v1, colorMultiplier;" +
			"temp0 = sample(texCoord, texture0);" +
			"output = temp0 * colorMultiplier;";
			
		
		public var gravityX:Number = 0.0;
		public var gravityY:Number = 0.0;
		public var currentTime:Number = 0.0;
		public var isBurst:Boolean = false;
		
		public function ParticleSystem2DMaterial() 
		{
			programConstants = new Vector.<Number>(20, true);
		}
		
		override public function updateClipSpace():void 
		{
			clipSpaceMatrix = _node.worldModelMatrix;
			invalidateClipSpace = false;
		}
		
		override protected function prepareForRender(context:Context3D):void 
		{
			if ( invalidateClipSpace || _node.invalidateMatrix ) updateClipSpace();
			context.setBlendFactors(blendMode.src, blendMode.dst);
			updateProgram(context);
			
			context.setTextureAt(0, texture.getTexture(context));
			
			context.setVertexBufferAt(0, mesh.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, mesh.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			context.setVertexBufferAt(2, mesh.vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4); // misc (starttime, life, startsize, endsize
			context.setVertexBufferAt(3, mesh.vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_4); // velocity / startpos
			context.setVertexBufferAt(4, mesh.vertexBuffer, 12, Context3DVertexBufferFormat.FLOAT_4); // startcolor
			context.setVertexBufferAt(5, mesh.vertexBuffer, 16, Context3DVertexBufferFormat.FLOAT_4); // endcolor
			context.setVertexBufferAt(6, mesh.vertexBuffer, 20, Context3DVertexBufferFormat.FLOAT_2); // rotation
			
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
			
			programConstants[8] = gravityX;
			programConstants[9] = gravityY;
			programConstants[10] = currentTime;
			programConstants[11] = 0.0;
			
			programConstants[12] = _width >> 1;
			programConstants[13] = _height >> 1;
			programConstants[14] = frameOffsetX;
			programConstants[15] = frameOffsetY;
			
			programConstants[16] = _node.combinedTintRed;
			programConstants[17] = _node.combinedTintGreen;
			programConstants[18] = _node.combinedTintBlue;
			programConstants[19] = _node._alpha;
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, programConstants);
		}
		
		override protected function clearAfterRender(context:Context3D):void 
		{
			context.setTextureAt(0, null);
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
			context.setVertexBufferAt(3, null);
			context.setVertexBufferAt(4, null);
			context.setVertexBufferAt(5, null);
			context.setVertexBufferAt(6, null);
			context.setScissorRectangle(null);
		}
		
		override protected function initProgram(context:Context3D):void 
		{
			if (!shaderData) 
			{
				var defines:Array = ["TextureMaterial",
					"BURST", isBurst,
					"USE_UV", false,
					"USE_COLOR", false,
					"USE_COLOR_OFFSET", false];
					
				shaderData = ShaderCache.getShader(context, defines, VERTEX_SHADER, FRAGMENT_SHADER, texture);
			}
		}
		
	}
}
