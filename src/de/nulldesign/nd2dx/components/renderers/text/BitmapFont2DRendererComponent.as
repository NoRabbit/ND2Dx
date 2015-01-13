package de.nulldesign.nd2dx.components.renderers.text 
{
	import com.rabbitframework.utils.XMLUtils;
	import de.nulldesign.nd2dx.components.renderers.RendererComponentBase;
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItem;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemChar;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemIcon;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemLineBreak;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemWhiteSpace;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DItemWord;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DStyle;
	import de.nulldesign.nd2dx.utils.BitmapFontUtil;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DRendererComponent extends RendererComponentBase
	{
		public var resourceManager:ResourceManager = ResourceManager.getInstance();
		
		private var _style:BitmapFont2DStyle;
		
		private var _text:String = "";
		
		public var invalidateText:Boolean = false;
		public var invalidateTextItemsPosition:Boolean = false;
		
		private var _textAlign:String = TextFormatAlign.LEFT;
		private var _textWidth:Number = 0.0;
		private var _textHeight:Number = 0.0;
		private var _textLineHeight:Number = 0.0;
		private var _letterSpacing:Number = 0.0;
		private var _whiteSpaceSpacing:Number = 0.0;
		private var _xOffset:Number = 0.0;
		
		public var totalTextWidth:Number = 0.0;
		public var totalTextHeight:Number = 0.0;
		
		private var _isMultiline:Boolean = false;
		
		public var vItems:Vector.<BitmapFont2DItem> = new Vector.<BitmapFont2DItem>();
		
		private var currentCharIndex:int = 0;
		
		public var roundValues:Boolean = false;
		public var isPassword:Boolean = false;
		public var passwordChar:String = "*";
		
		public function BitmapFont2DRendererComponent() 
		{
			
		}
		
		override public function draw(renderer:RendererBase):void 
		{
			if ( invalidateText )
			{
				updateText();
			}
			else if ( invalidateTextItemsPosition )
			{
				updateTextItemsPosition();
			}
			
			if ( vItems.length ) drawItems(renderer, vItems);
		}
		
		public function drawItems(renderer:RendererBase, vItems:Vector.<BitmapFont2DItem>):void
		{
			var i:int = 0;
			var n:int = vItems.length;
			var item:BitmapFont2DItem;
			
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				if ( item is BitmapFont2DItemWord )
				{
					drawItems(renderer, (item as BitmapFont2DItemWord).vItems);
				}
				else if( item.texture )
				{
					renderer.drawTexturedQuad(item.texture, true, node, null, item.x, item.y, 0.0, 1.0, 1.0, 1.0, 0.0, 0.0, 0.0, item.tintRed, item.tintGreen, item.tintBlue, item.tintAlpha, 0.0, 0.0, 1.0, 1.0, blendModeSrc, blendModeDst);
				}
			}
		}
		
		public function updateText():void
		{
			if ( !_style ) return;
			
			invalidateText = false;
			
			// remove all items
			if ( vItems.length ) vItems.splice(0, vItems.length);
			
			// put text in a xml for easier parsing
			XML.ignoreWhitespace = false;
			var xml:XML = new XML("<xml>" + _text + "</xml>");
			XML.ignoreWhitespace = true;
			
			parseXmlText(xml.children(), _style, 1.0, 1.0, 1.0, 1.0);
			
			updateTextItemsPosition();
		}
		
		public function parseXmlText(xml:XMLList, style:BitmapFont2DStyle, tintRed:Number, tintGreen:Number, tintBlue:Number, tintAlpha:Number):void
		{
			for each (var child:XML in xml) 
			{
				switch (String(child.name())) 
				{
					case "style":
						{
							// set new style and parse that xml node
							var newStyle:BitmapFont2DStyle = resourceManager.getBitmapFont2DStyleById(child.id);
							if ( !newStyle ) newStyle = style;
							
							parseXmlText(child.children(), newStyle, tintRed, tintGreen, tintBlue, tintAlpha);
							break;
						}
						
					case "tint":
						{
							// set new tint
							var newTintRed:Number = XMLUtils.getCleanNumber(child.@tintRed, tintRed);
							var newTintGreen:Number = XMLUtils.getCleanNumber(child.@tintGreen, tintGreen);
							var newTintBlue:Number = XMLUtils.getCleanNumber(child.@tintBlue, tintBlue);
							var newTintAlpha:Number = XMLUtils.getCleanNumber(child.@tintAlpha, tintAlpha);
							
							parseXmlText(child.children(), style, newTintRed, newTintGreen, newTintBlue, newTintAlpha);
							break;
						}
						
					case "icon":
						{
							// create new icon item
							vItems.push(BitmapFontUtil.createItemIconFromXML(child, style, tintRed, tintGreen, tintBlue, tintAlpha));
							break;
						}
						
					case "null":
						{
							// parse text
							parseText(child, style, tintRed, tintGreen, tintBlue, tintAlpha);
							break;
						}
						
					default:
						{
							parseXmlText(child.children(), style, tintRed, tintGreen, tintBlue, tintAlpha);
							break;
						}
				}
			}
		}
		
		public function parseText(text:String, style:BitmapFont2DStyle, tintRed:Number, tintGreen:Number, tintBlue:Number, tintAlpha:Number):void
		{
			var i:int = 0;
			var n:int = text.length;
			
			var currentChar:String;
			var currentWord:String = "";
			
			for (; i < n; i++) 
			{
				currentChar = text.charAt(i);
				
				// check if that char is a word breaker
				if ( BitmapFontUtil.aWordBreakers.indexOf(currentChar) >= 0 )
				{
					// yes
					
					// get word preceding it if there is one
					if ( currentWord ) vItems.push(BitmapFontUtil.createItemWordFromText(currentWord, style, tintRed, tintGreen, tintBlue, tintAlpha, _letterSpacing));
					
					// check wich one it is
					if ( currentChar == "\n" )
					{
						// line break
						vItems.push(BitmapFontUtil.createItemLineBreak(style));
					}
					else if ( currentChar == " " )
					{
						// white space
						vItems.push(BitmapFontUtil.createItemWhiteSpace(style, _whiteSpaceSpacing));
					}
					else
					{
						if ( isPassword ) currentChar = passwordChar;
						
						// add this char as a word
						vItems.push(BitmapFontUtil.createItemWordFromText(currentChar, style, tintRed, tintGreen, tintBlue, tintAlpha, _letterSpacing));
					}
					
					currentWord = "";
				}
				else
				{
					if ( isPassword ) currentChar = passwordChar;
					currentWord += currentChar;
				}
			}
			
			if ( currentWord ) vItems.push(BitmapFontUtil.createItemWordFromText(currentWord, style, tintRed, tintGreen, tintBlue, tintAlpha, _letterSpacing));
		}
		
		public function updateTextItemsPosition():void
		{
			invalidateTextItemsPosition = false;
			
			var i:int = 0;
			var n:int = vItems.length;
			var item:BitmapFont2DItem;
			
			var currentX:Number = _xOffset;
			var currentY:Number = 0.0;
			
			var vItemsInLine:Vector.<BitmapFont2DItem> = new Vector.<BitmapFont2DItem>();
			var currentItemsInLineTotalWidth:Number = 0.0;
			
			currentCharIndex = -1;
			
			for (; i < n; i++)
			{
				item = vItems[i];
				
				// do we have a line break ?
				if ( _isMultiline && item is BitmapFont2DItemLineBreak )
				{
					// yes, update current line items first
					if( vItemsInLine.length ) updateTextItemsPositionInLine(vItemsInLine, currentX, currentY, currentItemsInLineTotalWidth);
					
					// then set position for next items in next line
					currentItemsInLineTotalWidth = 0.0;
					currentX = _xOffset;
					currentY += _textLineHeight;
				}
				else
				{
					// no, then we have normal items to position
					// check first if this item we need to position is not too big for the current text width
					if ( _isMultiline && currentItemsInLineTotalWidth + item.width > _textWidth )
					{
						// yes
						// TODO: check if it's a white space
						
						// position our current line
						updateTextItemsPositionInLine(vItemsInLine, currentX, currentY, currentItemsInLineTotalWidth)
						
						// then set position for next items in next line
						currentItemsInLineTotalWidth = 0.0;
						currentX = _xOffset;
						currentY += _textLineHeight;
					}
					
					vItemsInLine.push(item);
					currentItemsInLineTotalWidth += item.width;
				}
			}
			
			if( vItemsInLine.length ) updateTextItemsPositionInLine(vItemsInLine, currentX, currentY, currentItemsInLineTotalWidth)
		}
		
		public function updateTextItemsPositionInLine(vItemsInLine:Vector.<BitmapFont2DItem>, positionX:Number, positionY:Number, currentItemsInLineTotalWidth:Number):void
		{
			var i:int = 0;
			var n:int = vItemsInLine.length;
			
			var item:BitmapFont2DItem;
			var icon:BitmapFont2DItemIcon;
			var word:BitmapFont2DItemWord;
			var char:BitmapFont2DItemChar;
			
			var spaceWidth:Number = 0.0;
			
			var currentX:Number = positionX;
			var currentY:Number = positionY;
			
			var currentItemX:Number = 0.0;
			var currentItemY:Number = 0.0;
			var currentItemHalfWidth:Number = 0.0;
			var currentItemHalfHeight:Number = 0.0;
			
			if ( _textAlign == TextFormatAlign.JUSTIFY && vItemsInLine.length > 1 )
			{
				spaceWidth = BitmapFontUtil.getJustifyWhiteSpaceWidthForLineItems(vItemsInLine, _textWidth);
			}
			else if ( _textAlign == TextFormatAlign.RIGHT )
			{
				currentX = _textWidth - currentItemsInLineTotalWidth;
			}
			else if ( _textAlign == TextFormatAlign.CENTER )
			{
				currentX = (_textWidth - currentItemsInLineTotalWidth) * 0.5;
			}
			
			// for each item in line
			for (; i < n; i++) 
			{
				item = vItemsInLine[i];
				
				currentCharIndex++;
				
				item.index = currentCharIndex;
				item.x = currentX;
				item.y = currentY;
				//item.lineY = currentY;
				
				
				if ( item is BitmapFont2DItemWhiteSpace )
				{
					// WHITE SPACE
					if ( spaceWidth > 0 )
					{
						currentX += spaceWidth;
					}
					else
					{
						currentX += item.width;
					}
				}
				else if ( item is BitmapFont2DItemIcon )
				{
					// ICON
					icon = item as BitmapFont2DItemIcon;
					
					icon.x = currentX + icon.paddingLeft + icon.width * 0.5;
					icon.y = currentY + icon.paddingTop + icon.height * 0.5;
					
					if ( roundValues )
					{
						icon.x = Math.round(icon.x);
						icon.y = Math.round(icon.y);
					}
					
					currentX += icon.width + icon.paddingLeft + icon.paddingRight;
				}
				else if ( item is BitmapFont2DItemWord )
				{
					// WORD & CHARS
					word = item as BitmapFont2DItemWord;
					
					var j:int = 0;
					var m:int = word.vItems.length;
					
					currentCharIndex--;
					
					for (; j < m; j++) 
					{
						currentCharIndex++;
						
						char = word.vItems[j] as BitmapFont2DItemChar;
						
						char.index = currentCharIndex;
						char.x = currentX + char.xInText + (char.glyph ? char.glyph.offsetX : 0.0) + char.width * 0.5;
						char.y = currentY + (char.glyph ? char.glyph.offsetY : 0.0) + char.height * 0.5;
						//char.lineY = currentY;
					}
					
					currentX += item.width;
				}
			}
			
			if ( vItemsInLine.length ) vItemsInLine.splice(0, vItemsInLine.length);
		}
		
		[WGM (position = -1000)]
		public function get text():String 
		{
			return _text;
		}
		
		public function set text(value:String):void 
		{
			if ( _text == value ) return;
			_text = value;
			invalidateText = true;
		}
		
		[WGM (position = -900)]
		public function get style():BitmapFont2DStyle 
		{
			return _style;
		}
		
		public function set style(value:BitmapFont2DStyle):void 
		{
			if ( _style == value ) return;
			_style = value;
			textLineHeight = _style.lineHeight;
			invalidateText = true;
		}
		
		public function get textAlign():String 
		{
			return _textAlign;
		}
		
		public function set textAlign(value:String):void 
		{
			if ( _textAlign == value ) return;
			_textAlign = value;
			invalidateTextItemsPosition = true;
		}
		
		[WGM (position = -700)]
		public function get textWidth():Number 
		{
			return _textWidth;
		}
		
		public function set textWidth(value:Number):void 
		{
			if ( _textWidth == value ) return;
			_textWidth = value;
			invalidateTextItemsPosition = true;
		}
		
		[WGM (position = -600)]
		public function get textHeight():Number 
		{
			return _textHeight;
		}
		
		public function set textHeight(value:Number):void 
		{
			if ( _textHeight == value ) return;
			_textHeight = value;
		}
		
		[WGM (position = -500)]
		public function get textLineHeight():Number 
		{
			return _textLineHeight;
		}
		
		public function set textLineHeight(value:Number):void 
		{
			if ( _textLineHeight == value ) return;
			_textLineHeight = value;
			invalidateTextItemsPosition = true;
		}
		
		[WGM (position = -400)]
		public function get isMultiline():Boolean 
		{
			return _isMultiline;
		}
		
		public function set isMultiline(value:Boolean):void 
		{
			if ( _isMultiline == value ) return;
			_isMultiline = value;
			invalidateTextItemsPosition = true;
		}
		
		[WGM (position = -300)]
		public function get letterSpacing():Number 
		{
			return _letterSpacing;
		}
		
		public function set letterSpacing(value:Number):void 
		{
			if ( _letterSpacing == value ) return;
			_letterSpacing = value;
			invalidateText = true;
		}
		
		[WGM (position = -200)]
		public function get whiteSpaceSpacing():Number 
		{
			return _whiteSpaceSpacing;
		}
		
		public function set whiteSpaceSpacing(value:Number):void 
		{
			if ( _whiteSpaceSpacing == value ) return;
			_whiteSpaceSpacing = value;
			invalidateText = true;
		}
		
		public function get xOffset():Number 
		{
			return _xOffset;
		}
		
		public function set xOffset(value:Number):void 
		{
			if ( _xOffset == value ) return;
			_xOffset = value;
			invalidateTextItemsPosition = true;
		}
	}

}