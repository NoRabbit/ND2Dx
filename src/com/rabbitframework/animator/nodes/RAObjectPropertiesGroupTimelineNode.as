package com.rabbitframework.animator.nodes 
{
	import com.rabbitframework.animator.style.RAStyle;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAObjectPropertiesGroupTimelineNode extends RANode
	{
		public var bg:Sprite;
		
		public function RAObjectPropertiesGroupTimelineNode() 
		{
			
		}
		
		override public function draw():void 
		{
			super.draw();
			
			bg.width = RAStyle.TIMELINE_PANEL_WIDTH;
			bg.height = nodeHeight;
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
	}

}