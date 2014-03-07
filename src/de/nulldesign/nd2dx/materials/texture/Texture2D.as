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
package de.nulldesign.nd2dx.materials.texture
{
	import de.nulldesign.nd2dx.utils.Statistics;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import flash.utils.Dictionary;

	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class Texture2D 
	{
		private var _textureOptions:uint = TextureOption.QUALITY_ULTRA;
		
		public function get textureOptions():uint 
		{
			return _textureOptions;
		}
		
		public function set textureOptions(value:uint):void 
		{
			if (_textureOptions != value) 
			{
				_textureOptions = value;
				textureFilteringOptionChanged = true;
			}
		}
		
		public var texture:Texture;
		public var bitmapData:BitmapData;
		public var compressedBitmap:ByteArray;
		
		public var bitmapWidth:Number;
		public var bitmapHeight:Number;
		
		public var textureWidth:Number;
		public var textureHeight:Number;
		public var textureFormat:String = Context3DTextureFormat.BGRA;
		
		public var uvRect:Rectangle = new Rectangle(0, 0, 1, 1);
		
		public var hasPremultipliedAlpha:Boolean = true;
		public var textureFilteringOptionChanged:Boolean = true;
		
		public var memoryUsed:uint = 0;
		
		public var autoCleanUpResources:Boolean;
		public var currentContext3D:Context3D;
		
		// offsets and frame rect if this texture is a sub texture (part of an atlas)
		public var uvOffsetX:Number = 0.0;
		public var uvOffsetY:Number = 0.0;
		public var uvScaleX:Number = 1.0;
		public var uvScaleY:Number = 1.0;
		
		public var frameRect:Rectangle = null;
		public var frameOffsetX:Number = 0.0;
		public var frameOffsetY:Number = 0.0;
		
		public var originalFrameRect:Rectangle = null;
		
		// list of all sub textures
		public var vSubTextures:Vector.<Texture2D> = new Vector.<Texture2D>();
		
		// parent Texture2D if is a sub texture
		public var parent:Texture2D;
		
		// name of frame if this texture is part of an atlas
		public var frameName:String = "";
		public var frameNameToSubTexture2D:Dictionary;
		
		public function Texture2D(autoCleanUpResources:Boolean = true) 
		{
			this.autoCleanUpResources = autoCleanUpResources;
		}
		
		public function updateUvRect():void 
		{
			uvRect.width = bitmapWidth / textureWidth;
			uvRect.height = bitmapHeight / textureHeight;
		}
		
		public function getTexture(context:Context3D):Texture 
		{
			// if context has changed (lost context)
			if ( currentContext3D != context && texture )
			{
				// check if this is a subtexture
				if ( parent )
				{
					// yes, get main texture object from parent
					texture = parent.getTexture(context);
				}
				else
				{
					// this is not a subtexture, dispose it for reupload
					texture.dispose();
					texture = null;
					Statistics.textures--;
					Statistics.texturesMem -= memoryUsed;
					memoryUsed = 0;
				}
			}
			
			currentContext3D = context;
			
			// upload texture to gpu if necessary
			if ( !texture )
			{
				memoryUsed = 0;
				
				if ( parent )
				{
					texture = parent.getTexture(context);
				}
				else if (bitmapData) 
				{
					var useMipMapping:Boolean = (_textureOptions & TextureOption.MIPMAP_LINEAR) + (_textureOptions & TextureOption.MIPMAP_NEAREST) > 0;
					texture = TextureUtil.generateTextureFromBitmap(context, bitmapData, useMipMapping, this);
					//texture = TextureUtil.generateTextureFromBitmap(context, bitmapData, false, this);
				}
				else if (compressedBitmap)
				{
					texture = TextureUtil.generateTextureFromByteArray(context, compressedBitmap);
				}
				else
				{
					texture = context.createTexture(textureWidth, textureHeight, Context3DTextureFormat.BGRA, true);
					memoryUsed = textureWidth * textureHeight * 4;
				}
				
				Statistics.textures++;
				Statistics.texturesMem += memoryUsed;
			}
			
			return texture;
		}
		
		public function getSubTextureByName(name:String):Texture2D
		{
			if ( frameNameToSubTexture2D[name] ) return frameNameToSubTexture2D[name];
			return null;
		}
		
		public function localToGlobalUV(uvRect:Rectangle):Rectangle
		{
			var currentParent:Texture2D = parent;
			
			uvRect.width *= this.uvRect.width;
			uvRect.height *= this.uvRect.height;
			uvRect.x = this.uvRect.x + (uvRect.x * this.uvRect.width);
			uvRect.y = this.uvRect.y + (uvRect.y * this.uvRect.height);
			
			if ( parent ) uvRect = parent.localToGlobalUV(uvRect);
			
			return uvRect;
		}
		
		public function getUVRectFromDimensions(x:Number, y:Number, width:Number, height:Number):Rectangle
		{
			var finalTextureWidth:Number = textureWidth;
			var finalTextureHeight:Number = textureHeight;
			
			if ( parent )
			{
				if ( frameRect )
				{
					x += frameRect.x;
					y += frameRect.y;
				}
				
				var currentParent:Texture2D = parent;
				
				while (currentParent)
				{
					if ( currentParent.frameRect )
					{
						x += currentParent.frameRect.x;
						y += currentParent.frameRect.y;
					}
					
					finalTextureWidth = currentParent.textureWidth;
					finalTextureHeight = currentParent.textureHeight;
					
					currentParent = currentParent.parent;
				}
			}
			
			var rect:Rectangle = new Rectangle(x, y, width, height);
			
			rect.x /= finalTextureWidth;
			rect.y /= finalTextureHeight;
			rect.width /= finalTextureWidth;
			rect.height /= finalTextureHeight;
			
			return rect;
		}
		
		public function dispose(forceCleanUpResources:Boolean = false):void
		{
			if (texture)
			{
				texture.dispose();
				texture = null;
				
				Statistics.textures--;
				Statistics.texturesMem -= memoryUsed;
			}
			
			if (forceCleanUpResources || autoCleanUpResources)
			{
				if (bitmapData)
				{
					bitmapData.dispose();
					bitmapData = null;
				}
				
				compressedBitmap = null;
			}
		}
		
		public function toString():String
		{
			return "Texture2D: " + frameName + ", " + textureWidth + "/" + textureHeight + ", " + bitmapWidth + "/" + bitmapHeight;
		}
	}
}
