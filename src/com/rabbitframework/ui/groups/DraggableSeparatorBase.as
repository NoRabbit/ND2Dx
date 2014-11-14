package com.rabbitframework.ui.groups 
{
	import com.rabbitframework.ui.button.ButtonDrag;
	import com.rabbitframework.ui.UIBase;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DraggableSeparatorBase extends ButtonDrag
	{
		public var icon:Sprite;
		
		public var itemBefore:UIBase;
		public var itemAfter:UIBase;
		
		public function DraggableSeparatorBase() 
		{
			
		}
		
		override public function draw():void 
		{
			super.draw();
			
			icon.x = uiWidth * 0.5;
			icon.y = uiHeight * 0.5;
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			itemAfter = itemBefore = null;
			if ( parent ) parent.removeChild(this);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			disposeForPool();
		}
	}

}