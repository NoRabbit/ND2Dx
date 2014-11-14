package com.rabbitframework.utils 
{
	
	/**
	 * ...
	 * @author Thomas John (thomas.john@open-design.be) www.open-design.be
	 */
	public class MathUtils 
	{
		
		public function MathUtils() 
		{
			
		}
		
		public static function isNumber(value:Object):Boolean
		{
			if ( isNaN( Number(value) ) )
			{
				return false;
			}
			else
			{
				return true;
			}
		}
		
		public static function roundTo(value:Number, toDecimal:int = 1):Number
		{
			var divider:int = Math.pow(10, toDecimal);
			return Math.round(value * divider) / divider;
		}
		
		public static function getDecimalsCount(value:Number):int
		{
			var s:String = value.toString();
			s = StringUtils.getAfter(s, ".")
			if ( s == "" ) return 0;
			return s.length;
		}
	}
	
}