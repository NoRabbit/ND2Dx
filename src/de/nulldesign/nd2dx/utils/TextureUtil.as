package de.nulldesign.nd2dx.utils 
{
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.resource.texture.parser.AtlasParserBase;
	import de.nulldesign.nd2dx.resource.texture.AnimatedTexture2D;
	import de.nulldesign.nd2dx.resource.texture.Atlas;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TextureUtil 
	{
		public static const SLICE_TYPE_NONE:int = 0;
		public static const SLICE_TYPE_1:int = 1;
		public static const SLICE_TYPE_3_VERTICAL:int = 2;
		public static const SLICE_TYPE_3_HORIZONTAL:int = 3;
		public static const SLICE_TYPE_9:int = 4;
		
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
		 * @param bitmapData
		 * @return x = width, y = height of the texture
		 */
		public static function getTextureDimensionsFromBitmap(bitmapData:BitmapData):Point
		{
			return getTextureDimensionsFromSize(bitmapData.width, bitmapData.height);
		}
		
		/**
		 * Create a texture from a bitmapData. Will use the smallest possible size
		 * (2^n)
		 * @param context
		 * @param bitmapData
		 * @return The created texture
		 */
		public static function createTextureFromBitmapData(context:Context3D, bitmapData:BitmapData, useMipMaps:Boolean, texture2d:Texture2D = null):Texture
		{
			//trace("createTextureFromBitmapData", context, bitmapData, useMipMaps, texture2d);
			
			var textureDimensions:Point = getTextureDimensionsFromBitmap(bitmapData);
			var newBitmap:BitmapData = new BitmapData(textureDimensions.x, textureDimensions.y, true, 0x00000000);
			
			newBitmap.copyPixels(bitmapData, new Rectangle(0, 0, bitmapData.width, bitmapData.height), new Point(0, 0));
			
			var texture:Texture = context.createTexture(textureDimensions.x, textureDimensions.y, Context3DTextureFormat.BGRA, false);
			
			if (useMipMaps)
			{
				uploadTextureWithMipmaps(texture, newBitmap, texture2d);
			}
			else
			{
				texture.uploadFromBitmapData(newBitmap);
				
				if (texture2d)
				{
					texture2d.memoryUsed += textureDimensions.x * textureDimensions.y * 4;
				}
			}
			
			newBitmap.dispose();
			
			return texture;
		}
		
		/**
		 * Create and upload mipmaps of a BitmapData to a Texture
		 * @param	texture
		 * @param	bitmapData
		 * @param	texture2d
		 */
		public static function uploadTextureWithMipmaps(texture:Texture, bitmapData:BitmapData, texture2d:Texture2D = null):void
		{
			var ws:int = bitmapData.width;
			var hs:int = bitmapData.height;
			var level:int = 0;
			var tmp:BitmapData = new BitmapData(bitmapData.width, bitmapData.height, true, 0x00000000);
			var transform:Matrix = new Matrix();
			
			while (ws >= 1 || hs >= 1)
			{
				tmp.fillRect(tmp.rect, 0x00000000);
				tmp.draw(bitmapData, transform, null, null, null, true);
				
				texture.uploadFromBitmapData(tmp, level);
				
				if (texture2d)
				{
					texture2d.memoryUsed += ws * hs * 4;
				}
				
				transform.scale(0.5, 0.5);
				level++;
				ws >>= 1;
				hs >>= 1;
			}
			
			tmp.dispose();
		}
		
		/**
		 * Creates a texture from a bytearray (generally ATF data). Will use the smallest possible size
		 * (2^n)
		 * @param context
		 * @param byteArray
		 * @return The created texture
		 */
		public static function createTextureFromByteArray(context:Context3D, byteArray:ByteArray, texture2d:Texture2D = null):Texture
		{
			var w:int = Math.pow(2, byteArray[7]);
			var h:int = Math.pow(2, byteArray[8]);
			//var numTextures:int = byteArray[9];
			
			//var textureFormat:String = (byteArray[6] == 2 ? Context3DTextureFormat.COMPRESSED : Context3DTextureFormat.BGRA);
			var textureFormat:String = "";
			
			switch (byteArray[6])
            {
                case 0:
                case 1: textureFormat = Context3DTextureFormat.BGRA; break;
				case 2:
				default:
                case 3: textureFormat = Context3DTextureFormat.COMPRESSED; break;
                case 4:
                case 5: textureFormat = "compressedAlpha"; break;// Context3DTextureFormat.COMPRESSED_ALPHA; break;
            }
			
			var texture:Texture = context.createTexture(w, h, textureFormat, false);
			texture.uploadCompressedTextureFromByteArray(byteArray, 0, false);
			
			// TODO: add memory usage to Statistics
			/*if ( texture2d )
			{
				
			}*/
			
			return texture;
		}
		
		/**
		 * Create a Texture2D from a BitmapData
		 * @param	bitmapData
		 * @param	autoCleanUpResources
		 * @return
		 */
		/*public static function createTexture2DFromBitmapData(bitmapData:BitmapData, autoCleanUpResources:Boolean = true):Texture2D
		{
			var texture2D:Texture2D = new Texture2D(autoCleanUpResources);
			
			if ( bitmapData )
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
		}*/
		
		/**
		 * Create a Texture2D from a ByteArrat (ATF data)
		 * @param	byteArray
		 * @param	autoCleanUpResources
		 * @return
		 */
		/*public static function createTexture2DFromATF(byteArray:ByteArray, autoCleanUpResources:Boolean = true):Texture2D
		{
			var texture2D:Texture2D = new Texture2D(autoCleanUpResources);
			
			if ( byteArray )
			{
				var w:int = Math.pow(2, byteArray[7]);
				var h:int = Math.pow(2, byteArray[8]);
				
				switch ( byteArray[6] )
				{
					case 0:
					case 1: texture2D.textureFormat = Context3DTextureFormat.BGRA; break;
					case 2:
					default:
					case 3: texture2D.textureFormat = Context3DTextureFormat.COMPRESSED; break;
					case 4:
					case 5: texture2D.textureFormat = "compressedAlpha"; break;
				}
				
				texture2D.compressedBitmap = byteArray;
				texture2D.textureWidth = texture2D.bitmapWidth = w;
				texture2D.textureHeight = texture2D.bitmapHeight = h;
				texture2D.hasPremultipliedAlpha = false;
				
				texture2D.updateUvRect();
			}
			
			return texture2D;
		}*/
		
		/**
		 * Create a blank Texture2D from specified size
		 * @param	textureWidth
		 * @param	textureHeight
		 * @return
		 */
		/*public static function createTexture2DFromSize(textureWidth:uint, textureHeight:uint):Texture2D 
		{
			var texture2D:Texture2D = new Texture2D();
			var size:Point = getTextureDimensionsFromSize(textureWidth, textureHeight);
			
			texture2D.textureWidth = size.x;
			texture2D.textureHeight = size.y;
			texture2D.bitmapWidth = size.x;
			texture2D.bitmapHeight = size.y;
			
			texture2D.updateUvRect();
			
			return texture2D;
		}*/
		
		/**
		 * Transfrom a "simple" Texture2D to an atlas with the specified parser
		 * @param	texture2D
		 * @param	parser
		 * @return
		 */
		public static function transformTexture2DIntoAtlas(texture2D:Texture2D, parser:AtlasParserBase):Texture2D
		{
			parser.parse(texture2D);
			
			// create all subtextures
			var i:int = 0;
			var n:int = parser.frames.length;
			var subTexture2D:Texture2D;
			
			for (; i < n; i++) 
			{
				subTexture2D = createSubTexture(texture2D, parser.frameNames[i]);
				
				subTexture2D.uvRect = parser.uvRects[i];
				
				subTexture2D.frameOffsetX = parser.offsets[i].x;
				subTexture2D.frameOffsetY = parser.offsets[i].y;
				subTexture2D.frameRect = parser.frames[i];
				
				subTexture2D.originalFrameRect = parser.originalFrames[i];
				
				subTexture2D.textureWidth = subTexture2D.originalBitmapWidth = subTexture2D.bitmapWidth = subTexture2D.frameRect.width;
				subTexture2D.textureHeight = subTexture2D.originalBitmapHeight = subTexture2D.bitmapHeight = subTexture2D.frameRect.height;
				
				subTexture2D.bitmapWidth /= subTexture2D.scaleFactor;
				subTexture2D.bitmapHeight /= subTexture2D.scaleFactor;
			}
			
			parser.dispose();
			
			return texture2D;
		}
		
		public static function createSubTexture(parentTexture2D:Texture2D, frameName:String):Texture2D
		{
			var subTexture2D:Texture2D = new Texture2D();
			
			subTexture2D.texture = parentTexture2D.texture;
			subTexture2D.parent = parentTexture2D;
			subTexture2D.mainParent = parentTexture2D.mainParent;
			
			subTexture2D.frameName = frameName;
			
			subTexture2D.scaleFactor = parentTexture2D.scaleFactor;
			
			subTexture2D.isLocallyAllocated = parentTexture2D.isLocallyAllocated;
			subTexture2D.isRemotellyAllocated = parentTexture2D.isRemotellyAllocated;
			
			subTexture2D.onLocalAllocationError = parentTexture2D.onLocalAllocationError;
			subTexture2D.onLocallyAllocated = parentTexture2D.onLocallyAllocated;
			subTexture2D.onLocallyDeallocated = parentTexture2D.onLocallyDeallocated;
			subTexture2D.onRemoteAllocationError = parentTexture2D.onRemoteAllocationError;
			subTexture2D.onRemotelyAllocated = parentTexture2D.onRemotelyAllocated;
			subTexture2D.onRemotelyDeallocated = parentTexture2D.onRemotelyDeallocated;
			
			parentTexture2D.vSubTextures.push(subTexture2D);
			parentTexture2D.frameNameToSubTexture2D[subTexture2D.frameName] = subTexture2D;
			
			return subTexture2D;
		}
		
		public static function removeSubTextureByName(parentTexture2D:Texture2D, frameName:String):Texture2D
		{
			var subTexture2D:Texture2D = parentTexture2D.frameNameToSubTexture2D[frameName] as Texture2D;
			
			if ( subTexture2D )
			{
				var index:int = parentTexture2D.vSubTextures.indexOf(subTexture2D);
				
				if ( index >= 0 ) parentTexture2D.vSubTextures.splice(index, 1);
			}
			
			return subTexture2D;
		}
		
		public static function getTexture2DResourceIdArrayFromFrameName(texture2D:Texture2D, frameName:String):Array
		{
			var aFrames:Array = new Array();
			
			var i:int = 0;
			var n:int = texture2D.vSubTextures.length;
			var subTexture2D:Texture2D;
			
			for (; i < n; i++) 
			{
				subTexture2D = texture2D.vSubTextures[i];
				if ( subTexture2D.frameName.substr(0, frameName.length) == frameName ) aFrames.push(subTexture2D);
			}
			
			var aSortedFrames:Array = aFrames.sortOn("frameName");
			
			i = 0;
			n = aSortedFrames.length;
			aFrames = [];
			
			for (; i < n; i++) 
			{
				aFrames.push(aSortedFrames[i].resourceId);
			}
			
			return aFrames;
		}
		
		public static function generateAnimatedTexture2DDataFromFrameNames(animatedTexture2D:AnimatedTexture2D, aFrameNames:Array):AnimatedTexture2D
		{
			var frames:Vector.<Texture2D> = new Vector.<Texture2D>();
			
			var i:int = 0;
			var n:int = aFrameNames.length;
			var subTexture2D:Texture2D;
			var resourceManager:ResourceManager = ResourceManager.getInstance();
			
			for (; i < n; i++) 
			{
				subTexture2D = resourceManager.getTextureById(aFrameNames[i]);
				if ( subTexture2D ) frames.push(subTexture2D);
			}
			
			animatedTexture2D.frames = frames;
			
			return animatedTexture2D;
		}
		
		/*public static function getTexture2DForBitmapData(bitmapData:BitmapData, autoCleanUpResources:Boolean = true):Texture2D
		{
			// first check if we already have one
			var i:int = 0;
			var n:int = vTextures.length;
			
			for (; i < n; i++) 
			{
				if ( vTextures[i].bitmapData == bitmapData ) return vTextures[i];
			}
			
			// no, then create it
			var texture2D:Texture2D = createTexture2DFromBitmapData(bitmapData, autoCleanUpResources);
			
			vTextures.push(texture2D);
			
			return texture2D;
		}*/
		
		// SLICES
		
		public static function getSlicesType(texture:Texture2D):int
		{
			if ( !texture ) return SLICE_TYPE_NONE;
			
			var i:int = 0;
			var n:int = texture.vSubTextures.length;
			var resourceId:String;
			var index:int;
			
			for (; i < n; i++) 
			{
				resourceId = texture.vSubTextures[i].resourceId;
				
				index = resourceId.indexOf("@slice");
				
				if ( index >= 0 )
				{
					switch ( resourceId.substr(index + 6, 1) ) 
					{
						case "3":
							{
								switch ( resourceId.substr(index + 7, 1) ) 
								{
									case "h":
										{
											return SLICE_TYPE_3_HORIZONTAL;
											break;
										}
										
									case "v":
										{
											return SLICE_TYPE_3_VERTICAL;
											break;
										}
								}
								
								break;
							}
							
						case "9":
							{
								return SLICE_TYPE_9;
								break;
							}
					}
				}
			}
			
			return SLICE_TYPE_1;
		}
		
		public static function getSlice(texture:Texture2D, slice:String = "tl"):Texture2D
		{
			var i:int = 0;
			var n:int = texture.vSubTextures.length;
			var resourceId:String;
			var index:int;
			
			for (; i < n; i++) 
			{
				resourceId = texture.vSubTextures[i].resourceId;
				
				index = resourceId.indexOf("@slice");
				
				if ( index >= 0 )
				{
					if ( resourceId.substr(index + 6, slice.length) == slice ) return texture.vSubTextures[i];
				}
			}
			
			return null;
		}
		
		public static function getSliceType(sliceName:String):String
		{
			var index:int = sliceName.indexOf("@slice");
			
			if ( index >= 0 )
			{
				return sliceName.substr(index + 8, 2);
			}
			
			return "";
		}
	}

}