package com.rabbitframework.animator.nodes.elements 
{
	import com.rabbitframework.utils.StringUtils;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class NEGroupPropertyTitle extends NodeElementSprite
	{
		public var txt:TextField;
		
		public function NEGroupPropertyTitle() 
		{
			//txt.text = StringUtils.generateRandomString(10);
			txt.text = "";
			elementWidth = 50;
			fixed = false;
		}
		
		override public function set elementWidth(value:Number):void 
		{
			super.elementWidth = value;
			txt.width = value - 8;
		}
	}

}