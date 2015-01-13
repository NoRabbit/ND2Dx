package com.rabbitframework.ui.toolbar 
{
	import com.rabbitframework.ui.UIContainer;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Toolbar extends UIContainer
	{
		public var bg:Sprite;
		
		public function Toolbar() 
		{
			
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			super.draw();
		}
	}

}