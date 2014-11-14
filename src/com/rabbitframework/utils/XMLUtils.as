package com.rabbitframework.utils 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class XMLUtils 
	{
		
		public static function getCleanString(o:*, defaultValue:String = ""):String
		{
			if ( o == null ) return defaultValue;
			if ( o == undefined ) return defaultValue;
			
			return StringUtils.cleanMasterString(String(o));
		}
		
		public static function getCleanNumber(o:*, defaultValue:Number = 0.0):Number
		{
			if ( o == null ) return defaultValue;
			if ( o == undefined ) return defaultValue;
			
			return Number(StringUtils.cleanMasterString(String(o)));
		}
		
		public static function getCleanInt(o:*, defaultValue:int = 0):int
		{
			if ( o == null ) return defaultValue;
			if ( o == undefined ) return defaultValue;
			
			return int(StringUtils.cleanMasterString(String(o)));
		}
		
		public static function getCleanBoolean(o:*, defaultValue:Boolean = false):Boolean
		{
			if ( o == null ) return defaultValue;
			if ( o == undefined ) return defaultValue;
			
			var res:String = StringUtils.cleanMasterString(String(o));
			
			if ( res.toLowerCase() == "true" || res == "1" ) return true;
			
			return false
		}
	}

}