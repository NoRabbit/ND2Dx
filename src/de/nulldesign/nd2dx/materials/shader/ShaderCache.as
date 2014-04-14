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

	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.materials.texture.TextureOption;
	import flash.display3D.Context3DTextureFormat;

	import flash.display3D.Context3D;
	import flash.utils.Dictionary;

	public class ShaderCache 
	{
		
		private static var cache:Dictionary = new Dictionary(true);
		
		public function ShaderCache() 
		{
			
		}
		
		public static function getShader(context:Context3D, defines:Array, vertexShaderString:String, fragmentShaderString:String, texture:Texture2D):Shader2D 
		{			
			var shaders:Dictionary = cache[context];
			
			if(!shaders) {
				shaders = cache[context] = new Dictionary();
			}
			
			var key:String = defines.join() + (texture ? "," + texture.textureOptions + "," + texture.hasPremultipliedAlpha : "");
			var shader:Shader2D = shaders[key];
			
			if (shader) 
			{				
				return shader;
			}
			
			if (texture) 
			{				
				defines.push("PREMULTIPLIED_ALPHA", texture.hasPremultipliedAlpha);
				defines.push("REPEAT_CLAMP", texture.textureOptions & TextureOption.REPEAT_CLAMP);
			}
			
			var commonShaderString:String = "";
			
			for (var i:uint = 1; i < defines.length; i += 2) 
			{				
				commonShaderString += "#define " + defines[i] + "=" + int(defines[i + 1]) + ";";
			}
			
			//shader = shaders[key] = new Shader2D(context, commonShaderString, vertexShaderString, fragmentShaderString, texture ? texture.textureOptions : 0);
			shader = shaders[key] = new Shader2D(context, commonShaderString, vertexShaderString, fragmentShaderString, texture);
			
			return shader;
		}
		
		public static function handleDeviceLoss():void 
		{			
			for each(var shaders:Dictionary in cache) 
			{				
				for each(var shader:Shader2D in shaders) 
				{					
					shader.dispose();
				}
			}
			
			cache = new Dictionary(true);
		}
	}
}
