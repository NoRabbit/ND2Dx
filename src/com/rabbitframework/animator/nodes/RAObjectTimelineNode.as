package com.rabbitframework.animator.nodes 
{
	import com.rabbitframework.animator.style.RAStyle;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAObjectTimelineNode extends RANode
	{
		public var bg:Sprite;
		
		public function RAObjectTimelineNode() 
		{
			
		}
		
		override public function draw():void 
		{
			super.draw();
			
			bg.width = RAStyle.TIMELINE_PANEL_WIDTH;
			bg.height = nodeHeight;
		}
		
		public function sortChildrenNode():void
		{
			var vObjects:Vector.<RANode> = new Vector.<RANode>();
			var vProperties:Vector.<RANode> = new Vector.<RANode>();
			
			var i:int = 0;
			var n:int = vChildrenNode.length;
			
			for (; i < n; i++) 
			{
				if ( vChildrenNode[i] is RAObjectPropertyTimelineNode || vChildrenNode[i] is RAObjectPropertiesGroupTimelineNode )
				{
					vProperties.push(vChildrenNode[i]);
				}
				else
				{
					vObjects.push(vChildrenNode[i]);
				}
			}
			
			vChildrenNode.splice(0, vChildrenNode.length);
			
			vChildrenNode = vChildrenNode.concat(vProperties);
			vChildrenNode = vChildrenNode.concat(vObjects);
			
			//animatorManager.rabbitAnimator.draw();
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
	}

}