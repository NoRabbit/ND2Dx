package de.nulldesign.nd2dx.resource.font 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import flash.display3D.Context3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DStyleAllocator extends ResourceAllocatorBase
	{
		public var bitmapFont2DStyle:BitmapFont2DStyle;
		
		public var textureObject:Object;
		public var texture:Texture2D;
		public var xml:XML;
		
		public function BitmapFont2DStyleAllocator(xml:XML, texture:Object, freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
			
			this.xml = xml;
			this.textureObject = texture;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( bitmapFont2DStyle.isAllocating ) return;
			
			if ( bitmapFont2DStyle.isLocallyAllocated && !forceAllocation )
			{
				// try to allocate it remotely
				allocateRemoteResource(null);
				
				return;
			}
			
			// try to allocate it remotely
			allocateRemoteResource(null);
			
			bitmapFont2DStyle.isLocallyAllocated = true;
		}
		
		override public function allocateRemoteResource(context:Context3D, forceAllocation:Boolean = false):void 
		{
			if ( bitmapFont2DStyle.isRemotelyAllocated && !forceAllocation ) return;
			
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
			
			if ( texture && xml )
			{
				bitmapFont2DStyle.texture = texture;
				bitmapFont2DStyle.scaleFactor = texture.scaleFactor;
				parseXML(xml);
				bitmapFont2DStyle.isRemotelyAllocated = true;
			}
			
			if ( bitmapFont2DStyle.isLocallyAllocated && freeLocalResourceAfterRemoteAllocation ) freeLocalResource();
		}
		
		public function parseXML(xml:XML):void
		{
			bitmapFont2DStyle.face = xml.info.attribute("face");
			bitmapFont2DStyle.size = uint(xml.info.attribute("size")) / texture.scaleFactor;
			bitmapFont2DStyle.bold = Boolean(xml.info.attribute("bold"));
			bitmapFont2DStyle.italic = Boolean(xml.info.attribute("italic"));
			bitmapFont2DStyle.charset = xml.info.attribute("charset");
			bitmapFont2DStyle.unicode = Boolean(xml.info.attribute("unicode"));
			bitmapFont2DStyle.smooth = int(xml.info.attribute("smooth"));
			
			//trace("parsing", bitmapFont2DStyle.face, bitmapFont2DStyle.size);
			
			var aPadding:Array = xml.info.attribute("padding").split(",");
			bitmapFont2DStyle.paddingUp = aPadding[0] * 0.5;
			bitmapFont2DStyle.paddingRight = aPadding[1] * 0.5;
			bitmapFont2DStyle.paddingDown = aPadding[2] * 0.5;
			bitmapFont2DStyle.paddingLeft = aPadding[3] * 0.5;
			
			bitmapFont2DStyle.lineHeight = Number(xml.common.attribute("lineHeight"));
			bitmapFont2DStyle.base = Number(xml.common.attribute("base"));
			bitmapFont2DStyle.scaleW = Number(xml.common.attribute("scaleW"));
			bitmapFont2DStyle.scaleH = Number(xml.common.attribute("scaleH"));
			
			var offsetX:Number = 0.0;
			var offsetY:Number = 0.0;
			
			// chars
			for each(var char:XML in xml.chars.char) 
			{
				var glyph:BitmapFont2DGlyph = new BitmapFont2DGlyph();
				glyph.id = char.attribute("id");
				glyph.bitmapRect.x = char.attribute("x");
				glyph.bitmapRect.y = char.attribute("y");
				glyph.bitmapRect.width = char.attribute("width");
				glyph.bitmapRect.height = char.attribute("height");
				glyph.offsetX = char.attribute("xoffset") / texture.scaleFactor;
				glyph.offsetY = char.attribute("yoffset") / texture.scaleFactor;
				glyph.advanceX = char.attribute("xadvance") / texture.scaleFactor;
				
				//trace("glyph A", glyph.id, glyph.bitmapRect, glyph.offsetX, glyph.offsetY, glyph.advanceX);
				
				offsetX = 0.0;
				offsetY = 0.0;
				
				// add padding to texture
				glyph.bitmapRect.x -= bitmapFont2DStyle.paddingLeft;
				glyph.bitmapRect.y -= bitmapFont2DStyle.paddingUp;
				
				glyph.bitmapRect.width += bitmapFont2DStyle.paddingRight + bitmapFont2DStyle.paddingLeft;
				glyph.bitmapRect.height += bitmapFont2DStyle.paddingDown + bitmapFont2DStyle.paddingUp;
				
				if ( texture.originalFrameRect )
				{
					// add atlas offset (which is < 0) to position
					glyph.bitmapRect.x += texture.originalFrameRect.x;
					glyph.bitmapRect.y += texture.originalFrameRect.y;
				}
				
				
				// check if texture position is not out of bounds
				if ( glyph.bitmapRect.x < 0 )
				{
					// remove same amount of pixels that are out of bounds from width
					glyph.bitmapRect.width += glyph.bitmapRect.x;
					
					offsetX += glyph.bitmapRect.x;
					
					// set position to its minimum
					glyph.bitmapRect.x = 0;
				}
				
				if ( glyph.bitmapRect.y < 0 )
				{
					// remove same amount of pixels that are out of bounds from height
					glyph.bitmapRect.height += glyph.bitmapRect.y;
					
					offsetY += glyph.bitmapRect.y;
					
					// set position to its minimum
					glyph.bitmapRect.y = 0;
				}
				
				// check if texture size is not out of bounds
				if ( texture.frameRect )
				{
					if ( glyph.bitmapRect.x + glyph.bitmapRect.width > texture.frameRect.width ) glyph.bitmapRect.width = texture.frameRect.width - glyph.bitmapRect.x;
					if ( glyph.bitmapRect.y + glyph.bitmapRect.height > texture.frameRect.height ) glyph.bitmapRect.height = texture.frameRect.height - glyph.bitmapRect.y;
				}
				
				//trace("glyph b", glyph.id, glyph.bitmapRect, offsetX, offsetY, texture.frameRect);
				
				if ( glyph.bitmapRect.width > 0 && glyph.bitmapRect.height > 0)
				{
					var subTexture2D:Texture2D = TextureUtil.createSubTexture(texture, bitmapFont2DStyle.face + "-" + glyph.id);
					
					subTexture2D.textureWidth = subTexture2D.originalBitmapWidth = subTexture2D.bitmapWidth = glyph.bitmapRect.width;
					subTexture2D.textureHeight = subTexture2D.originalBitmapHeight = subTexture2D.bitmapHeight = glyph.bitmapRect.height;
					
					subTexture2D.bitmapWidth /= texture.scaleFactor;
					subTexture2D.bitmapHeight /= texture.scaleFactor;
					
					//subTexture2D.frameOffsetX = glyph.offsetX + (glyph.bitmapRect.width * 0.5) - bitmapFont2DStyle.paddingLeft + offsetX;
					//subTexture2D.frameOffsetY = glyph.offsetY + (glyph.bitmapRect.height * 0.5) - bitmapFont2DStyle.paddingUp + offsetY;
					
					subTexture2D.frameOffsetX = -(bitmapFont2DStyle.paddingLeft + offsetX) / texture.scaleFactor;
					subTexture2D.frameOffsetY = -(bitmapFont2DStyle.paddingUp + offsetY) / texture.scaleFactor;
					
					subTexture2D.uvRect = texture.getUVRectFromDimensions(glyph.bitmapRect.x, glyph.bitmapRect.y, glyph.bitmapRect.width, glyph.bitmapRect.height);
					
					//trace("glyph subTexture2D uvRect", subTexture2D.uvRect);
					
					glyph.texture = subTexture2D;
				}
				
				bitmapFont2DStyle.dIdForGlyph[glyph.id] = glyph;
			}
			
			// kernings
			for each(var kerning:XML in xml.kernings.kerning) 
			{
				//<kerning first="46" second="119" amount="-2"/>
				
				var firstId:int = kerning.attribute("first");
				var secondId:int = kerning.attribute("second");
				var amount:Number = kerning.attribute("amount");
				
				var firstGlyph:BitmapFont2DGlyph = bitmapFont2DStyle.getGlyphForId(firstId);
				
				firstGlyph.dGlyphIdToAmount[secondId] = amount / texture.scaleFactor;
			}
		}
		
		override public function freeLocalResource():void 
		{
			xml = null;
		}
		
		override public function get resource():ResourceBase 
		{
			return super.resource;
		}
		
		override public function set resource(value:ResourceBase):void 
		{
			super.resource = value;
			bitmapFont2DStyle = value as BitmapFont2DStyle;
		}
	}

}