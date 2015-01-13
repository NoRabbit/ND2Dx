package com.rabbitframework.ui.divider 
{
	import com.rabbitframework.ui.UIBase;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DividerLine extends UIBase
	{
		public var bg:Sprite;
		
		public function DividerLine() 
		{
			
		}
		
		override public function init():void 
		{
			minUIHeight = 8.0;
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = 1.0;
			
			bg.y = Math.round((uiHeight - bg.height) * 0.5);
		}
		
	}

}