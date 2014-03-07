package de.nulldesign.nd2dx.text 
{
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DStyle 
	{
		public var name:String = "";
		
		public var texture2D:Texture2D;
		
		public var face:String = "";
		public var size:uint = 0;
		public var bold:Boolean = false;
		public var italic:Boolean = false;
		public var charset:String = "";
		public var unicode:Boolean = false;
		public var stretchH:int = 0;
		public var smooth:int = 0;
		public var aa:int = 0;
		public var paddingUp:Number = 0.0;
		public var paddingRight:Number = 0.0;
		public var paddingDown:Number = 0.0;
		public var paddingLeft:Number = 0.0;
		public var spacingHorizontal:Number = 0.0;
		public var spacingVertical:Number = 0.0;
		public var outline:Boolean = false;
		public var lineHeight:Number = 0.0;
		public var base:Number = 0.0;
		public var scaleW:Number = 0.0;
		public var scaleH:Number = 0.0;
		
		public var dIdForGlyph:Dictionary = new Dictionary();
		
		public function BitmapFont2DStyle(name:String, texture2D:Texture2D, xml:XML) 
		{
			this.name = name;
			this.texture2D = texture2D;
			parseXML(xml);
		}
		
		public function parseXML(xml:XML):void
		{
			face = xml.info.attribute("face");
			size = uint(xml.info.attribute("size"));
			bold = Boolean(xml.info.attribute("bold"));
			italic = Boolean(xml.info.attribute("italic"));
			charset = xml.info.attribute("charset");
			unicode = Boolean(xml.info.attribute("unicode"));
			smooth = int(xml.info.attribute("smooth"));
			
			var aPadding:Array = xml.info.attribute("padding").split(",");
			paddingUp = aPadding[0] * 0.5;
			paddingRight = aPadding[1] * 0.5;
			paddingDown = aPadding[2] * 0.5;
			paddingLeft = aPadding[3] * 0.5;
			
			lineHeight = Number(xml.common.attribute("lineHeight"));
			base = Number(xml.common.attribute("base"));
			scaleW = Number(xml.common.attribute("scaleW"));
			scaleH = Number(xml.common.attribute("scaleH"));
			
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
				glyph.offsetX = char.attribute("xoffset");
				glyph.offsetY = char.attribute("yoffset");
				glyph.advanceX = char.attribute("xadvance");
				
				offsetX = glyph.bitmapRect.x - (paddingLeft - texture2D.originalFrameRect.x);
				
				if ( offsetX < 0.0 )
				{
					glyph.bitmapRect.x += texture2D.originalFrameRect.x;
					offsetX = paddingLeft;
				}
				else
				{
					glyph.bitmapRect.x -= paddingLeft;
					glyph.bitmapRect.x += texture2D.originalFrameRect.x;
					offsetX = 0.0;
				}
				
				offsetY = glyph.bitmapRect.y - (paddingLeft - texture2D.originalFrameRect.y);
				
				if ( offsetY < 0.0 )
				{
					glyph.bitmapRect.y += texture2D.originalFrameRect.y;
					offsetY = paddingLeft;
				}
				else
				{
					glyph.bitmapRect.y -= paddingUp;
					glyph.bitmapRect.y += texture2D.originalFrameRect.y;
					offsetY = 0.0;
				}
				
				glyph.bitmapRect.width += paddingRight + paddingLeft;
				glyph.bitmapRect.height += paddingDown + paddingUp;
				
				//glyph.bitmapRect.x -= paddingLeft;
				//glyph.bitmapRect.width += paddingRight + paddingLeft;
				//glyph.bitmapRect.y -= paddingUp;
				//glyph.bitmapRect.height += paddingDown + paddingUp;
				
				if ( glyph.bitmapRect.width > 0 && glyph.bitmapRect.height > 0)
				{
					var subTexture2D:Texture2D = new Texture2D();
					subTexture2D.parent = texture2D;
					texture2D.vSubTextures.push(subTexture2D);
					
					subTexture2D.frameName = face + "-" + glyph.id;
					
					subTexture2D.uvRect = texture2D.getUVRectFromDimensions(glyph.bitmapRect.x, glyph.bitmapRect.y, glyph.bitmapRect.width, glyph.bitmapRect.height);
					
					subTexture2D.textureWidth = subTexture2D.bitmapWidth = glyph.bitmapRect.width;
					subTexture2D.textureHeight = subTexture2D.bitmapHeight = glyph.bitmapRect.height;
					
					subTexture2D.frameOffsetX = glyph.offsetX + (glyph.bitmapRect.width * 0.5) - paddingLeft + offsetX;
					subTexture2D.frameOffsetY = glyph.offsetY + (glyph.bitmapRect.height * 0.5) - paddingUp + offsetY;
					
					glyph.texture2D = subTexture2D;
				}
				
				dIdForGlyph[glyph.id] = glyph;
			}
			
			// kernings
			for each(var kerning:XML in xml.kernings.kerning) 
			{
				<kerning first="46" second="119" amount="-2"/>
				
				var firstId:int = kerning.attribute("first");
				var secondId:int = kerning.attribute("second");
				var amount:Number = kerning.attribute("amount");
				
				var firstGlyph:BitmapFont2DGlyph = getGlyphForId(firstId);
				
				firstGlyph.dGlyphIdToAmount[secondId] = amount;
			}
		}
		
		public function getGlyphForId(id:uint):BitmapFont2DGlyph
		{
			if ( dIdForGlyph[id] ) return dIdForGlyph[id];
			return null;
		}
		
	}

}