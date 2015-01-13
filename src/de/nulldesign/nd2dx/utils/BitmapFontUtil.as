package de.nulldesign.nd2dx.utils 
{
	import com.rabbitframework.utils.XMLUtils;
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemChar;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DGlyph;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItem;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemIcon;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemLineBreak;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemWhiteSpace;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemWord;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DStyle;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFontUtil 
	{
		private static var _aWordBreakers:Array;
		
		public static function createItemIconFromXML(xml:XML, style:BitmapFont2DStyle, tintRed:Number, tintGreen:Number, tintBlue:Number, tintAlpha:Number):BitmapFont2DItemIcon
		{
			var resourceManager:ResourceManager = ResourceManager.getInstance();
			
			var icon:BitmapFont2DItemIcon = new BitmapFont2DItemIcon();
			
			icon.style = style;
			icon.tintRed = tintRed;
			icon.tintGreen = tintGreen;
			icon.tintBlue = tintBlue;
			icon.tintAlpha = tintAlpha;
			
			icon.texture = resourceManager.getTextureById(XMLUtils.getCleanString(xml.@textureId));
			icon.width = XMLUtils.getCleanNumber(xml.@width, (icon.texture ? icon.texture.bitmapWidth : 0.0));
			icon.height = XMLUtils.getCleanNumber(xml.@height, (icon.texture ? icon.texture.bitmapHeight : 0.0));
			icon.paddingLeft = XMLUtils.getCleanNumber(xml.@paddingLeft);
			icon.paddingRight = XMLUtils.getCleanNumber(xml.@paddingRight);
			icon.paddingTop = XMLUtils.getCleanNumber(xml.@paddingTop);
			icon.paddingBottom = XMLUtils.getCleanNumber(xml.@paddingBottom);
			
			return icon;
		}
		
		public static function createItemWordFromText(text:String, style:BitmapFont2DStyle, tintRed:Number, tintGreen:Number, tintBlue:Number, tintAlpha:Number, letterSpacing:Number = 0.0):BitmapFont2DItemWord
		{
			var word:BitmapFont2DItemWord = new BitmapFont2DItemWord();
			
			word.style = style;
			word.tintRed = tintRed;
			word.tintGreen = tintGreen;
			word.tintBlue = tintBlue;
			word.tintAlpha = tintAlpha;
			
			word.word = text;
			
			var currentX:Number = 0.0;
			var char:BitmapFont2DItemChar;
			var lastChar:BitmapFont2DItemChar;
			
			var i:int = 0;
			var n:int = text.length;
			
			// for each char in text
			for (; i < n; i++) 
			{
				char = new BitmapFont2DItemChar();
				word.vItems.push(char);
				
				char.glyph = style.getGlyphForId(text.charCodeAt(Number(i)));
				
				if ( char.glyph )
				{
					if ( lastChar && lastChar.glyph )
					{
						currentX += lastChar.glyph.getAmountForGlyphId(char.glyph.id);
					}
					
					char.xInText = currentX;
					
					currentX += char.glyph.advanceX + letterSpacing;
					
					if ( char.glyph.texture )
					{
						char.texture = char.glyph.texture;
						char.width = char.glyph.texture.bitmapWidth;
						char.height = char.glyph.texture.bitmapHeight;
					}
				}
				
				lastChar = char;
			}
			
			if ( lastChar && lastChar.glyph )
			{
				currentX -= lastChar.glyph.advanceX;
				word.width = currentX + lastChar.glyph.texture.bitmapWidth;
			}
			
			return word;
		}
		
		public static function createItemLineBreak(style:BitmapFont2DStyle):BitmapFont2DItemLineBreak
		{
			var lineBreak:BitmapFont2DItemLineBreak = new BitmapFont2DItemLineBreak();
			
			lineBreak.style = style;
			
			return lineBreak;
		}
		
		public static function createItemWhiteSpace(style:BitmapFont2DStyle, whiteSpaceSpacing:Number = 0.0):BitmapFont2DItemWhiteSpace
		{
			var whiteSpace:BitmapFont2DItemWhiteSpace = new BitmapFont2DItemWhiteSpace();
			
			whiteSpace.style = style;
			
			var glyph:BitmapFont2DGlyph = style.getGlyphForId(32);
			if ( glyph ) whiteSpace.width = glyph.advanceX + whiteSpaceSpacing;
			
			return whiteSpace;
		}
		
		public static function getJustifyWhiteSpaceWidthForLineItems(vItemsInLine:Vector.<BitmapFont2DItem>, textWidth:Number):Number
		{
			var i:int = 0;
			var n:int = vItemsInLine.length;
			var item:BitmapFont2DItem;
			var totalSize:Number = 0.0;
			var totalItems:int = 0;
			
			for (; i < n; i++) 
			{
				item = vItemsInLine[i];
				
				if ( (item is BitmapFont2DItemWhiteSpace) == false )
				{
					totalSize += item.width;
					totalItems++;
				}
			}
			
			return (textWidth - totalSize) / (totalItems - 1);
		}
		
		static public function get aWordBreakers():Array 
		{
			if ( !_aWordBreakers )
			{
				_aWordBreakers = [];
				_aWordBreakers.push("\n");
				_aWordBreakers.push(" ");
				_aWordBreakers.push(",");
				_aWordBreakers.push(".");
				_aWordBreakers.push(";");
				_aWordBreakers.push(":");
				_aWordBreakers.push("-");
				_aWordBreakers.push("/");
				_aWordBreakers.push("*");
				_aWordBreakers.push("+");
			}
			
			return _aWordBreakers;
		}
		
		static public function set aWordBreakers(value:Array):void 
		{
			_aWordBreakers = value;
		}
	}

}