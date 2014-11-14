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
package de.nulldesign.nd2dx.resource.texture 
{
	import com.rabbitframework.signals.RabbitSignal;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DStyle;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.Statistics;
	import de.nulldesign.nd2dx.utils.TextureOption;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import flash.utils.Dictionary;

	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;

	public class Texture2D extends ResourceBase
	{
		public var onSlicesChanged:RabbitSignal = new RabbitSignal();
		
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
				
				if( allocator ) allocator.freeRemoteResource();
				
				var i:int = 0;
				var n:int = vSubTextures.length;
				
				for (; i < n; i++) 
				{
					vSubTextures[i].textureOptions = _textureOptions;
				}
			}
		}
		
		private var _texture:Texture;
		public var bitmapData:BitmapData;
		public var compressedBitmap:ByteArray;
		
		public var bitmapWidth:Number;
		public var bitmapHeight:Number;
		
		public var originalBitmapWidth:Number;
		public var originalBitmapHeight:Number;
		
		public var scaleFactor:Number = 1.0;
		
		public var textureWidth:Number;
		public var textureHeight:Number;
		public var textureFormat:String = Context3DTextureFormat.BGRA;
		
		public var uvRect:Rectangle = new Rectangle(0, 0, 1, 1);
		
		public var hasPremultipliedAlpha:Boolean = true;
		
		public var memoryUsed:uint = 0;
		
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
		public var mainParent:Texture2D;
		public var parent:Texture2D;
		
		// name of frame if this texture is part of an atlas
		public var frameName:String = "";
		private var _frameNameToSubTexture2D:Dictionary;
		
		public function Texture2D(allocator:ResourceAllocatorBase = null) 
		{
			mainParent = this;
			super(allocator);
		}
		
		public function updateUvRect():void 
		{
			uvRect.width = originalBitmapWidth / textureWidth;
			uvRect.height = originalBitmapHeight / textureHeight;
		}
		
		public function getTexture(context:Context3D):Texture 
		{
			// if context has changed (lost context)
			if ( currentContext3D != context)
			{
				if ( _texture )
				{
					// check if this is a subtexture
					if ( parent )
					{
						// yes, get main texture object from parent
						parent.getTexture(context);
					}
					else
					{
						// this is not a subtexture, free remote resource (meaning dispose it from gpu)
						allocator.freeRemoteResource();
					}
				}
				
				currentContext3D = context;
			}
			
			// upload texture to gpu if necessary
			if ( !_texture )
			{
				// is this texture a sub texture ?
				if ( parent )
				{
					// yes, get its main/original texture object
					parent.getTexture(context);
				}
				else
				{
					// no it's the main/original texture, allocate it on remote (gpu)
					allocator.allocateRemoteResource(context, true);
				}
			}
			
			return _texture;
		}
		
		public function getSubTextureByName(name:String):Texture2D
		{
			if ( !frameNameToSubTexture2D ) return null;
			if ( frameNameToSubTexture2D[name] ) return frameNameToSubTexture2D[name];
			return null;
		}
		
		public function getUVRectFromDimensions(x:Number, y:Number, width:Number, height:Number):Rectangle
		{
			/*
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
			rect.height /= finalTextureHeight;*/
			
			var rect:Rectangle = new Rectangle(x, y, width, height);
			
			rect.x /= originalBitmapWidth;
			rect.y /= originalBitmapHeight;
			
			rect.x *= uvRect.width;
			rect.y *= uvRect.height;
			
			rect.x += uvRect.x;
			rect.y += uvRect.y;
			
			rect.width /= originalBitmapWidth;
			rect.height /= originalBitmapHeight;
			
			rect.width *= uvRect.width;
			rect.height *= uvRect.height;
			
			//trace("getUVRectFromDimensions", x, y, width, height, rect, textureWidth, textureHeight, uvRect);
			
			return rect;
		}
		
		override public function get resourceId():String 
		{
			if ( parent )
			{
				var s:String = frameName;
				var currentParent:Texture2D = parent;
				
				while ( currentParent )
				{
					if ( currentParent.parent )
					{
						s = currentParent.frameName + "." + s;
					}
					else
					{
						s = currentParent.resourceId + "." + s;
					}
					
					currentParent = currentParent.parent;
				}
				
				return s;
			}
			else
			{
				return super.resourceId;
			}
			
		}
		
		override public function set resourceId(value:String):void 
		{
			super.resourceId = value;
		}
		
		public function get frameNameToSubTexture2D():Dictionary 
		{
			if ( !_frameNameToSubTexture2D ) _frameNameToSubTexture2D = new Dictionary();
			return _frameNameToSubTexture2D;
		}
		
		public function set frameNameToSubTexture2D(value:Dictionary):void 
		{
			_frameNameToSubTexture2D = value;
		}
		
		public function get texture():Texture 
		{
			return _texture;
		}
		
		public function set texture(value:Texture):void 
		{
			_texture = value;
			
			if ( vSubTextures.length )
			{
				var i:int = 0;
				var n:int = vSubTextures.length;
				
				for (; i < n; i++) 
				{
					vSubTextures[i].texture = _texture;
				}
			}
		}
		
		override public function dispose():void 
		{
			if ( isRemotellyAllocated ) allocator.freeRemoteResource();
			if ( isLocallyAllocated ) allocator.freeLocalResource();
		}
		
		public function toString():String
		{
			return "Texture2D: " + frameName + ", " + hasPremultipliedAlpha + ", " + textureWidth + "/" + textureHeight + ", " + bitmapWidth + "/" + bitmapHeight + ", " + originalBitmapWidth + "/" + originalBitmapHeight;
		}
	}
}
