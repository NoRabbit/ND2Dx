package de.nulldesign.nd2dx.resource.texture 
{
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.assets.AssetLoader;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.Statistics;
	import de.nulldesign.nd2dx.utils.TextureOption;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Texture2DAllocator extends ResourceAllocatorBase
	{
		public var texture2D:Texture2D;
		
		public var bitmapData:BitmapData;
		public var compressedBitmap:ByteArray;
		
		public function Texture2DAllocator(freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( texture2D.isAllocating ) return;
			if ( texture2D.isLocallyAllocated && !forceAllocation ) return;
			
			if ( bitmapData )
			{
				if ( texture2D.texture ) texture2D.texture.dispose();
				
				texture2D.texture = null;
				
				texture2D.compressedBitmap = null;
				
				texture2D.bitmapData = bitmapData;
				texture2D.originalBitmapWidth = texture2D.bitmapWidth = bitmapData.width;
				texture2D.originalBitmapHeight = texture2D.bitmapHeight = bitmapData.height;
				
				texture2D.bitmapWidth /= resourceManager.contentScaleFactor;
				texture2D.bitmapHeight /= resourceManager.contentScaleFactor;
				
				texture2D.scaleFactor = resourceManager.contentScaleFactor;
				
				var dimensions:Point = TextureUtil.getTextureDimensionsFromBitmap(bitmapData);
				texture2D.textureWidth = dimensions.x;
				texture2D.textureHeight = dimensions.y;
				texture2D.hasPremultipliedAlpha = true;
				
				//trace(this, "allocateLocalResource", texture2D.originalBitmapWidth, texture2D.originalBitmapHeight, dimensions);
				
				texture2D.updateUvRect();
				
				// to force update signal dispatch
				texture2D.isLocallyAllocated = false;
				texture2D.isLocallyAllocated = true;
			}
			
			// we don't free local resource here (only after it has been uploaded to gpu
		}
		
		override public function allocateRemoteResource(context:Context3D, forceAllocation:Boolean = false):void 
		{
			if ( texture2D.isRemotelyAllocated && !forceAllocation ) return;
			
			if ( texture2D.isRemotelyAllocated ) freeRemoteResource();
			
			// if we don't have a local resource, try to allocate it
			if ( !texture2D.isLocallyAllocated )
			{
				allocateLocalResource();
			}
			
			// now try to upload data to gpu
			if( bitmapData || compressedBitmap )
			{
				if ( bitmapData ) 
				{
					texture2D.texture = TextureUtil.createTextureFromBitmapData(context, bitmapData, (texture2D.textureOptions & TextureOption.MIPMAP_LINEAR) + (texture2D.textureOptions & TextureOption.MIPMAP_NEAREST) > 0, texture2D);
				}
				else if ( compressedBitmap )
				{
					texture2D.texture = TextureUtil.createTextureFromByteArray(context, compressedBitmap, texture2D);
				}
				
				Statistics.textures++;
				Statistics.texturesMem += texture2D.memoryUsed;
				
				texture2D.currentContext3D = context;
				
				// force update signal dispatch
				texture2D.isRemotelyAllocated = false;
				texture2D.isRemotelyAllocated = true;
				
				//trace(this, "allocateRemoteResource", texture2D.texture, freeLocalResourceAfterRemoteAllocation);
				
				// free local resource if necessary
				if ( texture2D.isLocallyAllocated && freeLocalResourceAfterRemoteAllocation ) freeLocalResource();
			}
		}
		
		override public function freeLocalResource():void 
		{
			if ( bitmapData ) bitmapData.dispose();
			
			texture2D.bitmapData = null;
			bitmapData = null;
			
			texture2D.isLocallyAllocated = false;
		}
		
		override public function freeRemoteResource():void 
		{
			if ( texture2D.texture ) texture2D.texture.dispose();
			
			texture2D.texture = null;
			
			Statistics.textures--;
			Statistics.texturesMem -= texture2D.memoryUsed;
			
			texture2D.memoryUsed = 0;
			
			texture2D.isRemotelyAllocated = false;
		}
		
		override public function get resource():ResourceBase 
		{
			return super.resource;
		}
		
		override public function set resource(value:ResourceBase):void 
		{
			super.resource = value;
			texture2D = value as Texture2D;
		}
	}

}