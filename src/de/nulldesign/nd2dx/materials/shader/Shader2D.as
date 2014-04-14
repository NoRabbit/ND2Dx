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

package de.nulldesign.nd2dx.materials.shader 
{
	
	import com.adobe.utils.AGALMacroAssembler;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import flash.display3D.Context3DTextureFormat;

	import de.nulldesign.nd2dx.materials.texture.TextureOption;

	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Program3D;

	public class Shader2D 
	{
		public var shader:Program3D;
		
		public static const COMMON_LIB:String =
			"macro min( a, b ) {" +
			"	min out, a, b;" +
			"}" +

			"macro max( a, b ) {" +
			"	max out, a, b;" +
			"}" +

			"macro sin( a ) {" +
			"	sin out, a" +
			"}" +

			"macro cos( a ) {" +
			"	cos out, a;" +
			"}" +

			// fractional part
			"macro frac( a ) {" +
			"	frc out, a;" +
			"}" +

			// clamp between 0 and 1
			"macro clamp( a ) {" +
			"	sat out, a;" +
			"}";

		public static const VERTEX_LIB:String =
			"alias op, output;" +

			"alias vt0, temp0;" +
			"alias vt1, temp1;" +
			"alias vt2, temp2;" +
			"alias vt3, temp3;" +
			"alias vt4, temp4;" +
			"alias vt5, temp5;" +
			"alias vt6, temp6;" +
			"alias vt7, temp7;" +

			"macro applyUV( uv, uvScroll, uvSheet ) {" +
			"	out = uv * uvScroll.zw;" +
			"	out += uvScroll.xy;" +

			"	#if !USE_UV;" +
			"		out *= uvSheet.zw;" +
			"		out += uvSheet.xy;" +
			"	#endif;" +
			"}";

		public static const FRAGMENT_LIB:String =
			"alias oc, output;" +

			"alias fs0, texture0;" +
			"alias fs1, texture1;" +
			"alias fs2, texture2;" +
			"alias fs3, texture3;" +
			"alias fs4, texture4;" +
			"alias fs5, texture5;" +
			"alias fs6, texture6;" +
			"alias fs7, texture7;" +

			"alias ft0, temp0;" +
			"alias ft1, temp1;" +
			"alias ft2, temp2;" +
			"alias ft3, temp3;" +
			"alias ft4, temp4;" +
			"alias ft5, temp5;" +
			"alias ft6, temp6;" +
			"alias ft7, temp7;" +

			// sample texture
			"macro sample( texCoord, texture ) {" +
			"	tex out, texCoord, texture <???>;" +
			"}" +

			// sample texture without mipmap
			"macro sampleNoMip( texCoord, texture ) {" +
			"	tex out, texCoord, texture <???,mipnone>;" +
			"}" +

			// sample texture with UV scroll
			"macro sampleUV( texCoord, texture, uvSheet ) {" +
			"	#if USE_UV;" +
			"		#if REPEAT_CLAMP;" +
			"			out = clamp(texCoord);" +
			"		#else;" +
			"			out = frac(texCoord);" +
			"		#endif;" +
			
			"		out *= uvSheet.zw;" +
			"		out += uvSheet.xy;" +
			
			"		out = sample(out, texture);" +
			"	#else;" +
			//"		out = texCoord - uvSheet.xy;" +
			//"		out = out / uvSheet.zw;" +
			//"		out = frac(texCoord);" +
			//"		out *= uvSheet.zw;" +
			//"		out += uvSheet.xy;" +
			//"		out = sample(out, texture);" +
			"		out = sample(texCoord, texture);" +
			"	#endif;" +
			"}" +
			
			// colorize (uses temp7.a)
			"macro colorize( color, colorMultiplier, colorOffset ) {" +
			"	#if USE_COLOR;" +
			"		color *= colorMultiplier;" +
			"	#endif;" +

			"	#if USE_COLOR_OFFSET;" +
			"		#if PREMULTIPLIED_ALPHA;" +
			"			color.rgb /= color.a;" +
			"		#endif;" +

			"		color.rgb += colorOffset.rgb;" +

			"		temp7.a = colorOffset.a * color.a;" +	// temp register
			"		temp7.a /= color.a;" +
			"		color.a += temp7.a;" +

			"		color = clamp(color);" +

			"		#if PREMULTIPLIED_ALPHA;" +
			"			color.rgb *= color.a;" +
			"		#endif;" +
			"	#endif;" +

			"	out = color;" +
			"}";

		//public function Shader2D(context:Context3D, commonShaderString:String, vertexShaderString:String, fragmentShaderString:String, numFloatsPerVertex:uint, textureOptions:uint) {
		public function Shader2D(context:Context3D, commonShaderString:String, vertexShaderString:String, fragmentShaderString:String, texture:Texture2D) {
			var texOptions:Array = ["2d"];
			var optionMissing:Boolean = false;
			var textureOptions:uint = texture.textureOptions;

			if(textureOptions & TextureOption.MIPMAP_DISABLE) {
				texOptions.push("mipnone");
			} else if(textureOptions & TextureOption.MIPMAP_NEAREST) {
				texOptions.push("mipnearest");
			} else if(textureOptions & TextureOption.MIPMAP_LINEAR) {
				texOptions.push("miplinear");
			} else {
				optionMissing = true;
			}

			if(textureOptions & TextureOption.FILTERING_NEAREST) {
				texOptions.push("nearest");
			} else if(textureOptions & TextureOption.FILTERING_LINEAR) {
				texOptions.push("linear");
			} else {
				optionMissing = true;
			}

			if(textureOptions & TextureOption.REPEAT_CLAMP) {
				texOptions.push("clamp");
			} else if(textureOptions & TextureOption.REPEAT_NORMAL) {
				texOptions.push("repeat");
			} else {
				optionMissing = true;
			}

			if(optionMissing && textureOptions > 0) {
				throw new Error("You need to specify all three texture option components. (MIPMAP_NEAREST | FILTERING_NEAREST | REPEAT_NORMAL)");
			}
			
			if ( texture.textureFormat == Context3DTextureFormat.COMPRESSED )
			{
				texOptions.push("dxt1");
			}
			else if ( texture.textureFormat == "compressedAlpha" )
			{
				texOptions.push("dxt5");
			}
			
			var finalVertexShader:String = COMMON_LIB + VERTEX_LIB + commonShaderString + vertexShaderString;
			var finalFragmentShader:String = (COMMON_LIB + FRAGMENT_LIB + commonShaderString + fragmentShaderString).replace(/\?\?\?/g, texOptions.join(","));

			var vertexShaderAssembler:AGALMacroAssembler = new AGALMacroAssembler();
			vertexShaderAssembler.assemble(Context3DProgramType.VERTEX, finalVertexShader);

			var colorFragmentShaderAssembler:AGALMacroAssembler = new AGALMacroAssembler();
			colorFragmentShaderAssembler.assemble(Context3DProgramType.FRAGMENT, finalFragmentShader);
			
			shader = context.createProgram();
			shader.upload(vertexShaderAssembler.agalcode, colorFragmentShaderAssembler.agalcode);
		}

		public function dispose():void {
			if(shader) {
				shader.dispose();
				shader = null;
			}
		}
	}
}
