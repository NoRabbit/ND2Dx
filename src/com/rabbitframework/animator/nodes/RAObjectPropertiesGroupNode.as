package com.rabbitframework.animator.nodes 
{
	import com.rabbitframework.animator.nodes.elements.INodeElement;
	import com.rabbitframework.animator.nodes.elements.NEArrow;
	import com.rabbitframework.animator.nodes.elements.NEButtonDelete;
	import com.rabbitframework.animator.nodes.elements.NEGroupPropertyTitle;
	import com.rabbitframework.animator.nodes.elements.NESeparatorV01;
	import com.rabbitframework.animator.parser.RAParserProperty;
	import com.rabbitframework.animator.style.RAStyle;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAObjectPropertiesGroupNode extends RANode
	{
		public var bg:Sprite;
		
		//public var butDeleteProperty:NEButtonDelete;
		public var arrow:NEArrow;
		//public var separator01:NESeparatorV01;
		public var title:NEGroupPropertyTitle;
		
		public var timelineNode:RAObjectPropertiesGroupTimelineNode;
		
		public var vElements:Vector.<INodeElement> = new Vector.<INodeElement>();
		
		public var parserProperty:RAParserProperty;
		
		public function RAObjectPropertiesGroupNode() 
		{
			mainNode = true;
			refNode = timelineNode = new RAObjectPropertiesGroupTimelineNode();
			timelineNode.refNode = this;
		}
		
		override public function preInit():void 
		{
			super.preInit();
			//butDeleteProperty.elementWidth = 24;
			
			//vElements.push(butDeleteProperty);
			//vElements.push(separator01);
			vElements.push(arrow);
			vElements.push(title);
			
			checkArrowState();
			
			eManager.add(arrow, MouseEvent.CLICK, arrow_clickHandler, [eventGroup, eventGroup + ".arrow"]);
		}
		
		override public function draw():void 
		{
			super.draw();
			
			bg.width = RAStyle.OBJECTS_PANEL_WIDTH;
			bg.height = nodeHeight;
			
			currentElementX = RAStyle.drawLeftElements(vElements, currentElementX, RAStyle.OBJECTS_PANEL_WIDTH - currentElementX);
		}
		
		override public function addChildNode(child:RANode):RANode 
		{
			super.addChildNode(child);
			checkArrowState();
			return child;
		}
		
		override public function removeChildNode(child:RANode):RANode 
		{
			super.removeChildNode(child);
			checkArrowState();
			return child;
		}
		
		public function checkArrowState():void
		{
			if ( vChildrenNode.length <= 0 )
			{
				arrow.alpha = 0.2;
				arrow.open = false;
				arrow.mouseEnabled = arrow.mouseChildren = false;
			}
			else
			{
				arrow.alpha = 1.0;
				arrow.mouseEnabled = arrow.mouseChildren = true;
			}
		}
		
		private function arrow_clickHandler(e:MouseEvent):void 
		{
			expanded = !expanded;
		}
		
		override public function set expanded(value:Boolean):void 
		{
			super.expanded = value;
			
			if ( _expanded )
			{
				arrow.open = true;
			}
			else
			{
				arrow.open = false;
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			parserProperty = null;
			if ( timelineNode ) timelineNode.dispose();
		}
		
	}

}