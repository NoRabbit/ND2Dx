package com.rabbitframework.easing 
{
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class Strobe 
	{
		public static const _PI = Math.PI;
		public static const _2PI = Math.PI * 2;
		
		public static function easeStrobe (t:Number, b:Number, c:Number, d:Number, a:Number = 5.0):Number 
		{
			var res:Number = c * t / d + b;
			res = 1 - res;
			
			var wave1:Number = Math.cos(_PI * a * res * res);
			var wave2:Number = Math.cos(_2PI * a * res * res);
			
			res = wave1 * wave2;
			res = (res + 1) / 2;
			
			return res;
		}
		
	}
	
}