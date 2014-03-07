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

package de.nulldesign.nd2dx.utils
{
	import com.rabbitframework.utils.StringUtils;
	import de.nulldesign.nd2dx.materials.texture.AnimatedTexture2D;
	import de.nulldesign.nd2dx.materials.texture.parser.AtlasParserBase;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import flash.utils.Dictionary;

	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class TextureUtil
	{
		
		/**
		 * Will return a point that contains the width and height of the smallest
		 * possible texture size in 2^n
		 * @param w width
		 * @param h height
		 * @return x = width, y = height of the texture
		 */
		public static function getTextureDimensionsFromSize(w:Number, h:Number):Point
		{
			var textureWidth:Number = 2.0;
			var textureHeight:Number = 2.0;
			
			while (textureWidth < w)
			{
				textureWidth <<= 1;
			}
			
			while (textureHeight < h)
			{
				textureHeight <<= 1;
			}
			
			return new Point(textureWidth, textureHeight);
		}
		
		/**
		 * Will return a point that contains the width and height of the smallest
		 * possible texture size in 2^n
		 * @param bmp
		 * @return x = width, y = height of the texture
		 */
		public static function getTextureDimensionsFromBitmap(bmp:BitmapData):Point
		{
			return getTextureDimensionsFromSize(bmp.width, bmp.height);
		}

		/**
		 * Generates a texture from a bitmap. Will use the smallest possible size
		 * (2^n)
		 * @param context
		 * @param bmp
		 * @return The generated texture
		 */
		public static function generateTextureFromByteArray(context:Context3D, atf:ByteArray):Texture
		{
			var w:int = Math.pow(2, atf[7]);
			var h:int = Math.pow(2, atf[8]);
			//var numTextures:int = atf[9];
			
			//var textureFormat:String = (atf[6] == 2 ? Context3DTextureFormat.COMPRESSED : Context3DTextureFormat.BGRA);
			var textureFormat:String = "";
			
			switch (atf[6])
            {
                case 0:
                case 1: textureFormat = Context3DTextureFormat.BGRA; break;
				case 2:
				default:
                case 3: textureFormat = Context3DTextureFormat.COMPRESSED; break;
                case 4:
                case 5: textureFormat = "compressedAlpha"; break;
            }
			//RabbitDebug.log("TextureHelper", "generateTextureFromByteArray", atf[6], textureFormat, w, h);
			//textureFormat = "compressedAlpha";
			
			var texture:Texture = context.createTexture(w, h, textureFormat, false);
			texture.uploadCompressedTextureFromByteArray(atf, 0, false);

			// TODO: add memory usage to Statistics

			return texture;
		}

		/**
		 * Generates a texture from a bitmap. Will use the smallest possible size
		 * (2^n)
		 * @param context
		 * @param bmp
		 * @return The generated texture
		 */
		public static function generateTextureFromBitmap(context:Context3D, bmp:BitmapData, useMipMaps:Boolean, stats:Texture2D = null):Texture
		{
			var textureDimensions:Point = getTextureDimensionsFromBitmap(bmp);
			var newBmp:BitmapData = new BitmapData(textureDimensions.x, textureDimensions.y, true, 0x00000000);
			
			newBmp.copyPixels(bmp, new Rectangle(0, 0, bmp.width, bmp.height), new Point(0, 0));
			
			var texture:Texture = context.createTexture(textureDimensions.x, textureDimensions.y, Context3DTextureFormat.BGRA, false);
			
			if (useMipMaps)
			{
				uploadTextureWithMipmaps(texture, newBmp, stats);
			}
			else
			{
				texture.uploadFromBitmapData(newBmp);
				
				if (stats)
				{
					stats.memoryUsed += textureDimensions.x * textureDimensions.y * 4;
				}
			}
			
			return texture;
		}

		public static function uploadTextureWithMipmaps(dest:Texture, src:BitmapData, stats:Texture2D = null):void
		{
			var ws:int = src.width;
			var hs:int = src.height;
			var level:int = 0;
			var tmp:BitmapData = new BitmapData(src.width, src.height, true, 0x00000000);
			var transform:Matrix = new Matrix();
			
			while (ws >= 1 || hs >= 1)
			{
				tmp.fillRect(tmp.rect, 0x00000000);
				tmp.draw(src, transform, null, null, null, true);
				
				dest.uploadFromBitmapData(tmp, level);
				
				if (stats)
				{
					stats.memoryUsed += ws * hs * 4;
				}
				
				transform.scale(0.5, 0.5);
				level++;
				ws >>= 1;
				hs >>= 1;
			}
			
			tmp.dispose();
		}
		
		// create a Texture2D object from a bitmapData object
		public static function textureFromBitmapData(bitmapData:BitmapData, autoCleanUpResources:Boolean = true):Texture2D
		{
			var texture2D:Texture2D = new Texture2D(autoCleanUpResources);
			
			if (bitmapData)
			{
				texture2D.bitmapData = bitmapData;
				texture2D.bitmapWidth = bitmapData.width;
				texture2D.bitmapHeight = bitmapData.height;
				
				var dimensions:Point = getTextureDimensionsFromBitmap(bitmapData);
				texture2D.textureWidth = dimensions.x;
				texture2D.textureHeight = dimensions.y;
				texture2D.hasPremultipliedAlpha = true;
				
				texture2D.updateUvRect();
			}
			
			return texture2D;
		}
		
		// create a Texture2D from a bytearray object containing data from a ATF texture
		public static function textureFromATF(atf:ByteArray, autoCleanUpResources:Boolean = true):Texture2D
		{
			var texture2D:Texture2D = new Texture2D(autoCleanUpResources);
			
			if (atf)
			{
				var w:int = Math.pow(2, atf[7]);
				var h:int = Math.pow(2, atf[8]);
				
				switch (atf[6])
				{
					case 0:
					case 1: texture2D.textureFormat = Context3DTextureFormat.BGRA; break;
					case 2:
					default:
					case 3: texture2D.textureFormat = Context3DTextureFormat.COMPRESSED; break;
					case 4:
					case 5: texture2D.textureFormat = "compressedAlpha"; break;
				}
				
				texture2D.compressedBitmap = atf;
				texture2D.textureWidth = texture2D.bitmapWidth = w;
				texture2D.textureHeight = texture2D.bitmapHeight = h;
				texture2D.hasPremultipliedAlpha = false;
				
				texture2D.updateUvRect();
			}
			
			return texture2D;
		}
		
		// create a blank Texture2D from specified size
		public static function textureFromSize(textureWidth:uint, textureHeight:uint):Texture2D 
		{
			var texture2D:Texture2D = new Texture2D();
			var size:Point = getTextureDimensionsFromSize(textureWidth, textureHeight);
			
			texture2D.textureWidth = size.x;
			texture2D.textureHeight = size.y;
			texture2D.bitmapWidth = size.x;
			texture2D.bitmapHeight = size.y;
			
			texture2D.updateUvRect();
			
			return texture2D;
		}
		
		public static function atlasTexture2DFromParser(texture2D:Texture2D, parser:AtlasParserBase):Texture2D
		{
			trace("atlasTexture2DFromParser");
			// parse
			parser.parse(texture2D);
			
			// create all subtextures
			var i:int = 0;
			var n:int = parser.frames.length;
			var subTexture2D:Texture2D;
			
			texture2D.frameNameToSubTexture2D = new Dictionary();
			
			for (; i < n; i++) 
			{
				subTexture2D = new Texture2D();
				subTexture2D.texture = texture2D.texture;
				subTexture2D.parent = texture2D;
				
				subTexture2D.uvRect = parser.uvRects[i];
				
				subTexture2D.frameOffsetX = parser.offsets[i].x;
				subTexture2D.frameOffsetY = parser.offsets[i].y;
				subTexture2D.frameRect = parser.frames[i];
				
				subTexture2D.originalFrameRect = parser.originalFrames[i];
				
				subTexture2D.textureWidth = subTexture2D.bitmapWidth = subTexture2D.frameRect.width;
				subTexture2D.textureHeight = subTexture2D.bitmapHeight = subTexture2D.frameRect.height;
				
				subTexture2D.frameName = parser.frameNames[i];
				texture2D.frameNameToSubTexture2D[subTexture2D.frameName] = subTexture2D;
				
				texture2D.vSubTextures.push(subTexture2D);
			}
			
			parser.dispose();
			
			return texture2D;
		}
		
		public static function subTexture2DFromName(name:String, atlasedTexture2D:Texture2D):Texture2D
		{
			if ( atlasedTexture2D.frameNameToSubTexture2D[name] ) return atlasedTexture2D.frameNameToSubTexture2D[name];
			return null;
		}
		
		public static function animatedTexture2DFromName(name:String, atlasedTexture2D:Texture2D):AnimatedTexture2D
		{
			var frames:Vector.<Texture2D> = new Vector.<Texture2D>();
			var aFrames:Array = new Array();
			
			var i:int = 0;
			var n:int = atlasedTexture2D.vSubTextures.length;
			var subTexture2D:Texture2D;
			
			for (; i < n; i++) 
			{
				subTexture2D = atlasedTexture2D.vSubTextures[i];
				if ( subTexture2D.frameName.substr(0, name.length) == name ) aFrames.push(subTexture2D);
			}
			
			aFrames = aFrames.sortOn("frameName");
			
			i = 0;
			n = aFrames.length;
			
			for (; i < n; i++) 
			{
				frames.push(aFrames[i] as Texture2D);
			}
			
			return new AnimatedTexture2D(frames);
		}
	}
}
