package com.rabbitframework.animator.panels.objects 
{
	import com.rabbitframework.animator.nodes.RANode;
	import com.rabbitframework.animator.nodes.RAObjectNode;
	import com.rabbitframework.animator.nodes.RAObjectPropertyNode;
	import com.rabbitframework.animator.nodes.RAObjectTimelineNode;
	import com.rabbitframework.animator.panels.objectstimeline.RAObjectsTimelinePanel;
	import com.rabbitframework.animator.panels.RAPanel;
	import com.rabbitframework.animator.style.RAStyle;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAObjectsPanel extends RAPanel
	{
		public var header:Sprite;
		
		public var objectsTimelinePanel:RAObjectsTimelinePanel;
		
		public function RAObjectsPanel() 
		{
			mainNode = true;
			super();
			
			animatorManager.objectsPanel = this;
			
			childrenContainer = new Sprite();
			childrenContainer.y = 28;
			addChild(childrenContainer);
		}
		
		override public function draw():void 
		{
			header.width = RAStyle.OBJECTS_PANEL_WIDTH;
			
			super.draw();
		}
		
	}

}