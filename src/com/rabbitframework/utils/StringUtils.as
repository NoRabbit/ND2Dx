package com.rabbitframework.utils 
{
	
	/**
	 * ...
	 * @author Thomas John (thomas.john@open-design.be)
	 */
	public class StringUtils
	{
		
		public function StringUtils() 
		{
			
		}
		
		/**
		 * Add leading characters in 's' until 'finalLength' is reached.
		 * @param	s Main string to add characters to.
		 * @param	lead String that is going to be added to the main string. This string will be cut if too big to reach the final length.
		 * @param	finalLength Final length that the main string should have
		 * @return	A string with leading characters added to main string
		 */
		
		public static function addLeadingChars(s:String, lead:String, finalLength:int):String
		{
			var need:int = finalLength - s.length;
			var leadingChars:String = "";
			
			var i:int = 0;
			var n:int = need;
			
			for (i = 0; i < n; i++) 
			{
				var j:int = 0;
				var m:int = lead.length;
				
				for (j = 0; j < m; j++) 
				{
					leadingChars += lead.substr(j, 1);
				}
			}
			
			return leadingChars + s;
		}
		
		public static function addEndingChars(s:String, end:String, finalLength:int):String
		{
			var need:int = finalLength - s.length;
			var endingChars:String = "";
			
			var i:int = 0;
			var n:int = need;
			
			for (i = 0; i < n; i++) 
			{
				var j:int = 0;
				var m:int = end.length;
				
				for (j = 0; j < m; j++) 
				{
					endingChars += end.substr(j, 1);
				}
			}
			
			return endingChars + s;
		}
		
		/**
		 * Check if a string is empty.
		 * @param	value String to check.
		 * @return True if empty, False if not.
		 */
		public static function isEmpty(value:String):Boolean 
		{
			if (value == null) return true;
			return !value.length;
		}
		
		public static function trim(value:String):String
		{ 
			if (value == null) return null;
			return rtrim(ltrim(value));
		} 
		
        public static function ltrim(value:String):String
        { 
			if (value == null) return null;
			var pattern:RegExp = /^\s*/;
			return value.replace(pattern, "");
		} 
		
        public static function rtrim(value:String):String
        { 
			if (value == null) return null;
			var pattern:RegExp = /\s*$/;
			return value.replace(pattern, "");
		}
		
		public static function isEmail(value:String):Boolean
		{
			value = trim(value);
			var pattern:RegExp = /(\w|[_.\-])+@((\w|-)+\.)+\w{2,4}+/;
			var result:Object = pattern.exec(value);
			if (result == null) return false;
			return true;
		}
		
		public static function generateRandomString(length:int = 4, chars:String = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"):String
		{
			var s:String = "";
			
			while (length--)
			{
				s += chars.substr(Math.floor(Math.random() * chars.length), 1);
			}
			
			return s;
		}
		
		public static function getFileName(path:String, keepExtension:Boolean = true):String
		{
			var fSlash:int = path.lastIndexOf("/");
			var bSlash:int = path.lastIndexOf("\\");
			var sIndex:int = fSlash > bSlash ? fSlash : bSlash;
			
			var fileName:String = path.substring(sIndex + 1);
			
			trace(fSlash, bSlash, sIndex, fileName);
			
			if ( !keepExtension )
			{
				sIndex = fileName.lastIndexOf(".");
				fileName = fileName.substring(0, sIndex);
			}
			
			return fileName;
		}
		
		public static function getAfter(s:String, after:String, lastIndex:Boolean = false):String
		{
			var pos:int = -1;
			
			if ( lastIndex )
			{
				pos = s.lastIndexOf(after);
			}
			else
			{
				pos = s.indexOf(after);
			}
			
			if ( pos >= 0 )
			{
				s = s.substr(pos + after.length);
			}
			
			return s;
		}
		
		public static function getBefore(s:String, before:String, lastIndex:Boolean = false):String
		{
			var pos:int = -1;
			
			if ( lastIndex )
			{
				pos = s.lastIndexOf(before);
			}
			else
			{
				pos = s.indexOf(before);
			}
			
			if ( pos >= 0 )
			{
				s = s.substr(0, pos);
			}
			
			return s;
		}
		
		public static function getExtension(s:String):String
		{
			return getAfter(s, ".", true);
		}
		
		public static function getNumericCounter(s:String, after:String, lastIndex:Boolean = false):String
		{
			s = getAfter(s, after, lastIndex);
			s = StringUtils.getBefore(s, ".", true);
			return s;
		}
		
		public static function left(s:String, length:int):String
		{
			if ( s.length <= length ) return s;
			return s.substr(0, length);
		}
		
		public static function right(s:String, length:int):String
		{
			if ( s.length <= length ) return s;
			return s.substr(s.length - length, length);
		}
		
		public static function getLine(s:String, index:int, newlineChar:String = "\n"):String
		{
			var i:int = 0;
			var n:int = index + 1;
			var pos1:int = 0;
			var pos2:int = 0;
			
			for (i = 0; i < n; i++) 
			{
				pos1 = s.indexOf(newlineChar, pos2);
				
				if ( i == index && pos1 >= 0 )
				{
					return s.substring(pos2, pos1);
				}
				
				pos2 = pos1 + newlineChar.length;
			}
			
			return "";
		}
	}
	
}