package de.nulldesign.nd2dx.resource.texture 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AtlasSlicedNode2DAllocator extends ResourceAllocatorBase
	{
		public var atlasSlicedNode2D:AtlasSlicedNode2D;
		
		public var textureObject:Object;
		public var texture:Texture2D;
		
		public var sliceLeft:Number = 0.2;
		public var sliceRight:Number = 0.8;
		public var sliceTop:Number = 0.2;
		public var sliceBottom:Number = 0.8;
		
		public var sliceType:int = TextureUtil.SLICE_TYPE_3_HORIZONTAL;
		
		public function AtlasSlicedNode2DAllocator(texture:Object, sliceLeft:Number = 0.2, sliceRight:Number = 0.8, sliceTop:Number = 0.2, sliceBottom:Number = 0.8, sliceType:int = TextureUtil.SLICE_TYPE_3_HORIZONTAL, freeLocalResourceAfterAllocated:Boolean = false) 
		{
			super(freeLocalResourceAfterAllocated);
			
			this.textureObject = texture;
			this.sliceLeft = sliceLeft;
			this.sliceRight = sliceRight;
			this.sliceTop = sliceTop;
			this.sliceBottom = sliceBottom;
			this.sliceType = sliceType;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( atlasSlicedNode2D.isLocallyAllocated && !forceAllocation ) return;
			
			if ( !texture && textureObject )
			{
				if ( textureObject is Texture2D )
				{
					texture = textureObject as Texture2D;
				}
				else if ( textureObject is String )
				{
					texture = resourceManager.getTextureById(textureObject as String);
				}
			}
			
			if ( texture )
			{
				atlasSlicedNode2D.texture = texture;
				atlasSlicedNode2D.sliceLeft = sliceLeft;
				atlasSlicedNode2D.sliceRight = sliceRight;
				atlasSlicedNode2D.sliceTop = sliceTop;
				atlasSlicedNode2D.sliceBottom = sliceBottom;
				atlasSlicedNode2D.sliceType = sliceType;
				
				var currentSubTexture2D:Texture2D;
				
				//trace(this, "allocate", atlasSlicedNode2D.sliceType);
				
				// create subtextures
				if ( atlasSlicedNode2D.sliceType == TextureUtil.SLICE_TYPE_3_HORIZONTAL )
				{
					// top left
					createSlice(texture, 0.0, 0.0, atlasSlicedNode2D.sliceLeft, 1.0, "@slice3h_tl");
					
					// top middle
					createSlice(texture, atlasSlicedNode2D.sliceLeft, 0.0, atlasSlicedNode2D.sliceRight - atlasSlicedNode2D.sliceLeft, 1.0, "@slice3h_tm");
					
					// top right
					createSlice(texture, atlasSlicedNode2D.sliceRight, 0.0, 1.0 - atlasSlicedNode2D.sliceRight, 1.0, "@slice3h_tr");
					
					// remove all other slices (if existant)
					TextureUtil.removeSubTextureByName(texture, "@slice3v_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice3v_ml");
					TextureUtil.removeSubTextureByName(texture, "@slice3v_bl");
					
					TextureUtil.removeSubTextureByName(texture, "@slice9_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice9_tm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_tr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice9_ml");
					TextureUtil.removeSubTextureByName(texture, "@slice9_mm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_mr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice9_bl");
					TextureUtil.removeSubTextureByName(texture, "@slice9_bm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_br");
				}
				else if ( atlasSlicedNode2D.sliceType == TextureUtil.SLICE_TYPE_3_VERTICAL )
				{
					// top left
					createSlice(texture, 0.0, 0.0, 1.0, atlasSlicedNode2D.sliceTop, "@slice3v_tl");
					
					// middle left
					createSlice(texture, 0.0, atlasSlicedNode2D.sliceTop, 1.0, atlasSlicedNode2D.sliceBottom - atlasSlicedNode2D.sliceTop, "@slice3v_ml");
					
					// bottom left
					createSlice(texture, 0.0, atlasSlicedNode2D.sliceBottom, 1.0, 1.0 - atlasSlicedNode2D.sliceBottom, "@slice3v_bl");
					
					// remove all other slices (if existant)
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tm");
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice9_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice9_tm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_tr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice9_ml");
					TextureUtil.removeSubTextureByName(texture, "@slice9_mm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_mr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice9_bl");
					TextureUtil.removeSubTextureByName(texture, "@slice9_bm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_br");
				}
				else if ( atlasSlicedNode2D.sliceType == TextureUtil.SLICE_TYPE_9 )
				{
					// top left
					createSlice(texture, 0.0, 0.0, atlasSlicedNode2D.sliceLeft, atlasSlicedNode2D.sliceTop, "@slice9_tl");
					
					// top middle
					createSlice(texture, atlasSlicedNode2D.sliceLeft, 0.0, atlasSlicedNode2D.sliceRight - atlasSlicedNode2D.sliceLeft, atlasSlicedNode2D.sliceTop, "@slice9_tm");
					
					// top right
					createSlice(texture, atlasSlicedNode2D.sliceRight, 0.0, 1.0 - atlasSlicedNode2D.sliceRight, atlasSlicedNode2D.sliceTop, "@slice9_tr");
					
					
					// middle left
					createSlice(texture, 0.0, atlasSlicedNode2D.sliceTop, atlasSlicedNode2D.sliceLeft, atlasSlicedNode2D.sliceBottom - atlasSlicedNode2D.sliceTop, "@slice9_ml");
					
					// middle middle
					createSlice(texture, atlasSlicedNode2D.sliceLeft, atlasSlicedNode2D.sliceTop, atlasSlicedNode2D.sliceRight - atlasSlicedNode2D.sliceLeft, atlasSlicedNode2D.sliceBottom - atlasSlicedNode2D.sliceTop, "@slice9_mm");
					
					// middle right
					createSlice(texture, atlasSlicedNode2D.sliceRight, atlasSlicedNode2D.sliceTop, 1.0 - atlasSlicedNode2D.sliceRight, atlasSlicedNode2D.sliceBottom - atlasSlicedNode2D.sliceTop, "@slice9_mr");
					
					
					// bottom left
					createSlice(texture, 0.0, atlasSlicedNode2D.sliceBottom, atlasSlicedNode2D.sliceLeft, 1.0 - atlasSlicedNode2D.sliceBottom, "@slice9_bl");
					
					// bottom middle
					createSlice(texture, atlasSlicedNode2D.sliceLeft, atlasSlicedNode2D.sliceBottom, atlasSlicedNode2D.sliceRight - atlasSlicedNode2D.sliceLeft, 1.0 - atlasSlicedNode2D.sliceBottom, "@slice9_bm");
					
					// bottom right
					createSlice(texture, atlasSlicedNode2D.sliceRight, atlasSlicedNode2D.sliceBottom, 1.0 - atlasSlicedNode2D.sliceRight, 1.0 - atlasSlicedNode2D.sliceBottom, "@slice9_br");
					
					// remove all other slices (if existant)
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tm");
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice3v_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice3v_ml");
					TextureUtil.removeSubTextureByName(texture, "@slice3v_bl");
				}
				else
				{
					// remove all slices
					TextureUtil.removeSubTextureByName(texture, "@slice9_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice9_tm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_tr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice9_ml");
					TextureUtil.removeSubTextureByName(texture, "@slice9_mm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_mr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice9_bl");
					TextureUtil.removeSubTextureByName(texture, "@slice9_bm");
					TextureUtil.removeSubTextureByName(texture, "@slice9_br");
					
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tm");
					TextureUtil.removeSubTextureByName(texture, "@slice3h_tr");
					
					TextureUtil.removeSubTextureByName(texture, "@slice3v_tl");
					TextureUtil.removeSubTextureByName(texture, "@slice3v_ml");
					TextureUtil.removeSubTextureByName(texture, "@slice3v_bl");
				}
				
				atlasSlicedNode2D.isLocallyAllocated = true;
				atlasSlicedNode2D.onLocallyAllocated.dispatch();
				
				texture.onSlicesChanged.dispatch();
			}
			
			//if ( atlasSlicedNode2D.isLocallyAllocated && freeLocalResourceAfterAllocated ) freeLocalResource();
		}
		
		public function removeAllSlicedSubTextures(texture:Texture2D):void
		{
			var vSubTexturesToRemove:Vector.<Texture2D> = new Vector.<Texture2D>();
			
			var i:int = 0;
			var n:int = texture.vSubTextures.length;
			var currentTexture:Texture2D;
			
			for (; i < n; i++) 
			{
				currentTexture = texture.vSubTextures[i];
				
				if ( currentTexture.frameName.indexOf("@slice") >= 0 ) vSubTexturesToRemove.push(currentTexture);
			}
			
			i = 0;
			n = vSubTexturesToRemove.length;
			var index:int;
			
			for (; i < n; i++) 
			{
				index = texture.vSubTextures.indexOf(vSubTexturesToRemove[i]);
				if ( index >= 0 ) texture.vSubTextures.splice(index, 1);
			}
		}
		
		public function createSlice(texture2D:Texture2D, x:Number, y:Number, w:Number, h:Number, frameName:String):Texture2D
		{
			x *= texture2D.originalBitmapWidth;
			y *= texture2D.originalBitmapHeight;
			w *= texture2D.originalBitmapWidth;
			h *= texture2D.originalBitmapHeight;
			
			// check if it exists already
			var currentSubTexture2D:Texture2D = texture2D.frameNameToSubTexture2D[frameName] as Texture2D;
			// else create it
			if ( !currentSubTexture2D ) currentSubTexture2D = TextureUtil.createSubTexture(texture2D, frameName);
			
			currentSubTexture2D.uvRect = texture2D.getUVRectFromDimensions(x, y, w, h);
			
			currentSubTexture2D.textureWidth = currentSubTexture2D.bitmapWidth = w;
			currentSubTexture2D.textureHeight = currentSubTexture2D.bitmapHeight = h;
			
			currentSubTexture2D.bitmapWidth /= currentSubTexture2D.scaleFactor;
			currentSubTexture2D.bitmapHeight /= currentSubTexture2D.scaleFactor;
			
			return currentSubTexture2D;
		}
		
		override public function freeLocalResource():void 
		{
			
		}
		
		override public function freeRemoteResource():void 
		{
			removeAllSlicedSubTextures(texture);
			atlasSlicedNode2D.isRemotellyAllocated = false;
		}
		
		override public function get resource():ResourceBase 
		{
			return super.resource;
		}
		
		override public function set resource(value:ResourceBase):void 
		{
			super.resource = value;
			atlasSlicedNode2D = value as AtlasSlicedNode2D;
		}
	}

}