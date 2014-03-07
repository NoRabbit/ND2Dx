package de.nulldesign.nd2dx.text 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DWord 
	{
		public var vChars:Vector.<BitmapFont2DChar> = new Vector.<BitmapFont2DChar>();
		
		public var word:String = "";
		public var width:Number = 0.0;
		public var advanceX:Number = 0.0;
		
		public function BitmapFont2DWord() 
		{
			
		}
		
		public static function getWord(word:String, bitmapFont2DStyle:BitmapFont2DStyle):BitmapFont2DWord
		{
			var bitmapFont2DWord:BitmapFont2DWord = new BitmapFont2DWord();
			
			bitmapFont2DWord.word = word;
			
			var currentX:Number = 0.0;
			var char:BitmapFont2DChar;
			var lastChar:BitmapFont2DChar;
			
			var i:int = 0;
			var n:int = word.length;
			
			// for each char in word
			for (; i < n; i++) 
			{
				char = new BitmapFont2DChar();
				bitmapFont2DWord.vChars.push(char);
				char.glyph = bitmapFont2DStyle.getGlyphForId(word.charCodeAt(Number(i)));
				
				if ( char.glyph )
				{
					if ( lastChar )
					{
						currentX += lastChar.glyph.getAmountForGlyphId(char.glyph.id);
					}
					
					char.positionX = currentX;
					
					currentX += char.glyph.advanceX;
				}
				
				lastChar = char;
			}
			
			if ( lastChar && lastChar.glyph )
			{
				currentX -= lastChar.glyph.advanceX;
				bitmapFont2DWord.width = currentX + lastChar.glyph.bitmapRect.width;
			}
			
			return bitmapFont2DWord;
		}
	}

}