package de.nulldesign.nd2dx.utils 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TextUtil 
	{
		public static function splitIntoLines(s:String):Array
		{
			return s.split("\n");
		}
		
		public static function splitIntoWords(s:String):Array
		{
			return trim(s).split(" ");
			
			/*
			var aWords:Array = new Array();
			
			var i:int = 0;
			var n:int = s.length;
			var char:String = "";
			var previousChar:String = "";
			var nextChar:String = "";
			
			var currentWord:String = "";
			
			for (; i < n; i++) 
			{
				char = s.charAt(i);
				
				if ( i < s.length )
				{
					nextChar = s.charAt(i + 1);
				}
				
				if ( i == 0 )
				{
					// first character of the string, this also is the first character of the first word
					currentWord += char;
				}
				else
				{
					if ( isDelimiter(char, previousChar, nextChar) )
					{
						// finish word
						aWords.push(currentWord);
						
						// new word
						currentWord = char;
					}
					else
					{
						// continue word
						currentWord += char;
					}
				}
				
				previousChar = char;
				char = nextChar = "";
			}
			*/
		}
		/*
		public static function isDelimiter(char:String, previousChar:String, nextChar:String):Boolean
		{
			// alpha numeric are never delimiters
			if ( isAlphabetic(char) || isNumeric(char) ) return false;
			
			// white space is always a delimiter
			if ( char == " " ) return true;
			
			if ( char == "'" || char == '"' )
			{
				if ( isAlphaNumeric(previousChar) || isAlphaNumeric(nextChar) ) return false;
			}
			
			return true;
		}
		*/
		public static function isAlphabetic(s:String):Boolean
		{
			var pattern:RegExp = /(A-Z)(a-z)/;
			return pattern.test(s);
		}
		
		// taken from http://snipplr.com/view/27807/
		public static function isNumeric(s:String):Boolean
		{
			var pattern:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return pattern.test(s);
		}
		
		public static function isAlphaNumeric(s:String):Boolean
		{
			if ( isAlphabetic(s) || isNumeric(s) ) return true;
			return false;
		}
		
		// taken from http://snipplr.com/view/27807/
		public static function trim(s:String):String
		{
			return s.replace(/^\s+|\s+$/g, '');
		}
		
		// taken from http://snipplr.com/view/27807/
		public static function trimLeft(s:String):String
		{
			return s.replace(/^\s+/, '');
		}
		
		// taken from http://snipplr.com/view/27807/
		public static function trimRight(s:String):String
		{
			return s.replace(/\s+$/, '');
		}
		
		
	}

}