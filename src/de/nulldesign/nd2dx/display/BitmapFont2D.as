package de.nulldesign.nd2dx.display 
{
	import adobe.utils.CustomActions;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.pools.Sprite2DPool;
	import de.nulldesign.nd2dx.text.BitmapFont2DChar;
	import de.nulldesign.nd2dx.text.BitmapFont2DGlyph;
	import de.nulldesign.nd2dx.text.BitmapFont2DStyle;
	import de.nulldesign.nd2dx.text.BitmapFont2DWord;
	import de.nulldesign.nd2dx.utils.TextUtil;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2D extends Node2D
	{
		private var sprite2DPool:Sprite2DPool = Sprite2DPool.getInstance();
		
		public var style:BitmapFont2DStyle;
		
		public var text:String = "";
		public var invalidateText:Boolean = false;
		
		private var _textAlign:String = TextFormatAlign.LEFT;
		private var _textWidth:Number = 0.0;
		private var _textHeight:Number = 0.0;
		private var _textLineHeight:Number = 0.0;
		
		public var vSprite2D:Vector.<Sprite2D> = new Vector.<Sprite2D>();
		
		public function BitmapFont2D(style:BitmapFont2DStyle = null) 
		{
			if( style ) setStyle(style);
		}
		
		public function setStyle(value:BitmapFont2DStyle):void
		{
			if ( style == value ) return;
			style = value;
			textLineHeight = style.lineHeight;
		}
		
		public function setText(value:String):void
		{
			if ( text == value ) return;
			text = value;
			invalidateText = true;
		}
		
		override public function step(elapsed:Number):void 
		{
			super.step(elapsed);
			
			if ( invalidateText ) updateText();
		}
		
		public function updateText():void
		{
			invalidateText = false;
			
			// release all children to pool
			var child:Node2D = childFirst;
			
			while (child)
			{
				sprite2DPool.releaseObject(child as Sprite2D);
				child = childFirst;
			}
			
			var spaceGlyph:BitmapFont2DGlyph = style.getGlyphForId(32);
			var spaceWidth:Number = (spaceGlyph ? spaceGlyph.advanceX : 0.0);
			
			var aLines:Array = TextUtil.splitIntoLines(text);
			var aWords:Array;
			
			var currentX:Number = 0.0;
			var currentY:Number = 0.0;
			
			var word:BitmapFont2DWord;
			var vWords:Vector.<BitmapFont2DWord> = new Vector.<BitmapFont2DWord>();
			var currentWordsWidth:Number = 0.0;
			
			var i:int = 0;
			var n:int = aLines.length;
			
			// for each line
			firs_for_loop: for (; i < n; i++) 
			{
				// get words
				aWords = TextUtil.splitIntoWords(aLines[i]);
				
				var j:int = 0;
				var m:int = aWords.length;
				
				currentWordsWidth = 0.0;
				
				// for each word in line
				for (; j < m; j++) 
				{
					word = BitmapFont2DWord.getWord(aWords[j], style);
					vWords.push(word);
					
					currentWordsWidth += word.width;
					
					// check if we are not going too far
					if ( _textWidth > 0 && currentWordsWidth + ((vWords.length - 1) * spaceWidth) > _textWidth )
					{
						// yes
						// if more than two words
						if ( vWords.length > 1 )
						{
							// remove last word
							vWords.pop();
							currentWordsWidth -= word.width;
							
							// render words
							renderWords(vWords, currentX, currentY, currentWordsWidth, spaceWidth);
							
							if ( vWords.length ) vWords.splice(0, vWords.length);
							
							// re add the last word
							vWords.push(word);
							currentWordsWidth = word.width;
						}
						else
						{
							// render word
							renderWords(vWords, currentX, currentY, currentWordsWidth, spaceWidth);
							
							if ( vWords.length ) vWords.splice(0, vWords.length);
							
							currentWordsWidth = 0.0;
						}
						
						currentX = 0.0;
						currentY += _textLineHeight;
					}
					
				}
				
				// render last words of this line if any
				if ( vWords.length > 0 )
				{
					renderWords(vWords, currentX, currentY, currentWordsWidth, spaceWidth);
					vWords.splice(0, vWords.length);
				}
				
				// and go to the next line
				currentY += _textLineHeight;
			}
		}
		
		private function renderWords(vWords:Vector.<BitmapFont2DWord>, positionX:Number, positionY:Number, currentWordsWidth:Number, spaceWidth:Number):void
		{
			var i:int = 0;
			var n:int = vWords.length;
			var word:BitmapFont2DWord;
			var char:BitmapFont2DChar;
			var sprite2D:Sprite2D;
			var currentX:Number = positionX;
			
			if ( _textAlign == TextFormatAlign.JUSTIFY && vWords.length > 1 )
			{
				spaceWidth = (_textWidth - currentWordsWidth) / (vWords.length - 1);
			}
			else if ( _textAlign == TextFormatAlign.RIGHT )
			{
				currentX = _textWidth - (currentWordsWidth + (spaceWidth  * (vWords.length - 1)));
			}
			else if ( _textAlign == TextFormatAlign.CENTER )
			{
				currentX = (_textWidth - (currentWordsWidth + (spaceWidth  * (vWords.length - 1)))) * 0.5;
			}
			
			for (; i < n; i++) 
			{
				word = vWords[i];
				
				var j:int = 0;
				var m:int = word.vChars.length;
				
				for (; j < m; j++) 
				{
					char = word.vChars[j];
					
					if ( char.glyph )
					{
						if ( char.glyph.texture2D )
						{
							sprite2D = sprite2DPool.getObject();
							sprite2D.setTexture(char.glyph.texture2D);
							sprite2D.x = currentX + char.positionX;
							sprite2D.y = positionY;
							addChild(sprite2D);
						}
					}
				}
				
				currentX += word.width + spaceWidth;
			}
		}
		
		public function get textAlign():String 
		{
			return _textAlign;
		}
		
		public function set textAlign(value:String):void 
		{
			if ( _textAlign == value ) return;
			_textAlign = value;
			invalidateText = true;
		}
		
		public function get textWidth():Number 
		{
			return _textWidth;
		}
		
		public function set textWidth(value:Number):void 
		{
			if ( _textWidth == value ) return;
			_textWidth = value;
			invalidateText = true;
		}
		
		public function get textHeight():Number 
		{
			return _textHeight;
		}
		
		public function set textHeight(value:Number):void 
		{
			if ( _textHeight == value ) return;
			_textHeight = value;
			invalidateText = true;
		}
		
		public function get textLineHeight():Number 
		{
			return _textLineHeight;
		}
		
		public function set textLineHeight(value:Number):void 
		{
			if ( _textLineHeight == value ) return;
			_textLineHeight = value;
			invalidateText = true;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			style = null;
			sprite2DPool = null;
			text = "";
		}
		
		override public function releaseForPooling(disposeComponents:Boolean = true, disposeChildren:Boolean = true):void 
		{
			if ( disposeChildren )
			{
				while (childLast)
				{
					if ( childLast is Sprite2D )
					{
						sprite2DPool.releaseObject(childLast as Sprite2D);
					}
					else
					{
						childLast.dispose();
					}
				}
			}
			
			super.releaseForPooling(disposeComponents, false);
			text = "";
			textAlign = TextFormatAlign.LEFT;
			style = null;
		}
	}

}