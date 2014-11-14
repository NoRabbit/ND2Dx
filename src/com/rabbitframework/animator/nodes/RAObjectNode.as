package com.rabbitframework.animator.nodes 
{
	import com.rabbitframework.animator.nodes.elements.INodeElement;
	import com.rabbitframework.animator.nodes.elements.NEArrow;
	import com.rabbitframework.animator.nodes.elements.NEButtonAdd;
	import com.rabbitframework.animator.nodes.elements.NEEye;
	import com.rabbitframework.animator.nodes.elements.NEObjectTitle;
	import com.rabbitframework.animator.nodes.elements.NESeparatorV01;
	import com.rabbitframework.animator.parser.RAParserProperty;
	import com.rabbitframework.animator.style.RAStyle;
	import com.rabbitframework.animator.system.RASystemObject;
	import com.rabbitframework.animator.system.RASystemObjectProperty;
	import com.rabbitframework.animator.ui.ListOptions;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAObjectNode extends RANode
	{
		public var bg:Sprite;
		
		public var arrow:NEArrow;
		public var separator01:NESeparatorV01;
		public var separator02:NESeparatorV01;
		public var separator03:NESeparatorV01;
		public var eye:NEEye;
		public var title:NEObjectTitle;
		public var butAdd:NEButtonAdd;
		
		public var timelineNode:RAObjectTimelineNode;
		
		public var systemObject:RASystemObject;
		
		// group color shape
		private var _showGroupColor:Boolean = false;
		public var groupColor:uint = 0;
		public var groupShape:Shape;
		
		public var vElements:Vector.<INodeElement> = new Vector.<INodeElement>();
		
		public function RAObjectNode() 
		{
			mainNode = true;
			refNode = timelineNode = new RAObjectTimelineNode();
			timelineNode.refNode = this;
		}
		
		override public function preInit():void 
		{
			super.preInit();
			
			vElements.push(arrow);
			vElements.push(separator01);
			vElements.push(eye);
			vElements.push(separator02);
			vElements.push(title);
			//vElements.push(separator03);
			//vElements.push(butAdd);
			
			checkArrowState();
			
			eManager.add(arrow, MouseEvent.CLICK, arrow_clickHandler, [eventGroup, eventGroup + ".arrow"]);
			eManager.add(eye, MouseEvent.CLICK, eye_clickHandler, [eventGroup, eventGroup + ".eye"]);
			//eManager.add(butAdd, MouseEvent.CLICK, butAdd_clickHandler, [eventGroup, eventGroup + ".eye"]);
			
			//animatorManager.onCursorTimeChange.add(onCursorTimeChangeHandler);
		}
		
		//private function onCursorTimeChangeHandler(value:Number):void 
		//{
			//if ( systemObject ) systemObject.getAndSetPropertiesValueFromTime(value);
		//}
		
		override public function draw():void 
		{
			if ( _showGroupColor ) nodeX += RAStyle.GROUP_COLOR_WIDTH;
			
			super.draw();
			
			bg.width = RAStyle.OBJECTS_PANEL_WIDTH;
			bg.height = nodeHeight;
			
			if ( _showGroupColor )
			{
				nodeX -= RAStyle.GROUP_COLOR_WIDTH;
				currentElementX = nodeX;
				groupShape.graphics.clear();
				groupShape.graphics.beginFill(groupColor);
				groupShape.graphics.drawRect(0, 0, RAStyle.GROUP_COLOR_WIDTH, nodeTotalHeight);
				groupShape.graphics.endFill();
				setChildIndex(groupShape, numChildren - 1);
				groupShape.x = currentElementX;
				groupShape.y = 0.0;
				currentElementX += RAStyle.GROUP_COLOR_WIDTH;
			}
			
			currentElementX = RAStyle.drawLeftElements(vElements, currentElementX, RAStyle.OBJECTS_PANEL_WIDTH - currentElementX);
		}
		
		public function setSystemObject(systemObject:RASystemObject):void
		{
			if ( this.systemObject == systemObject ) return;
			this.systemObject = systemObject;
			title.txt.text = systemObject.targetWgmObject.name + " - " + systemObject.target.toString();
			
			//this.systemObject.onPropertyAdded.add(systemProperty_onPropertyAddedHandler);
			//this.systemObject.onPropertyRemoved.add(systemProperty_onPropertyRemovedHandler);
			
			// TODO: loop through systemobject properties and set them to appropriate property nodes and properties group node
			var i:int = 0;
			var n:int = systemObject.vProperties.length;
			var currentSystemProperty:RASystemObjectProperty;
			var currentSystemProperty:RASystemObjectProperty;
			var currentPropertyNode:RAObjectPropertyNode;
			
			for (; i < n; i++) 
			{
				currentSystemProperty = systemObject.vProperties[i];
				currentPropertyNode = animatorManager.getPropertyNodeMatchSystemProperty(this, currentSystemProperty);
				
				if ( currentPropertyNode )
				{
					currentPropertyNode.setSystemProperty(currentSystemProperty);
				}
			}
			
			// now add system property for each property node that doesn't have one
			
		}
		
		//private function systemProperty_onPropertyAddedHandler(systemProperty:RASystemObjectProperty):void 
		//{
			//animatorManager.createPropertyNode(this, systemProperty);
			//sortChildrenNode();
		//}
		//
		//private function systemProperty_onPropertyRemovedHandler(systemProperty:RASystemObjectProperty):void 
		//{
			//var propertyNode:RAObjectPropertyNode = animatorManager.getPropertyNodeBySystemProperty(this, systemProperty);
			//
			//if ( propertyNode )
			//{
				//removeChildNode(propertyNode);
				//propertyNode.dispose();
			//}
			//
			//sortChildrenNode();
		//}
		
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
		
		public function sortChildrenNode():void
		{
			var vObjects:Vector.<RANode> = new Vector.<RANode>();
			var vProperties:Vector.<RANode> = new Vector.<RANode>();
			
			var i:int = 0;
			var n:int = vChildrenNode.length;
			
			for (; i < n; i++) 
			{
				if ( vChildrenNode[i] is RAObjectPropertyNode || vChildrenNode[i] is RAObjectPropertiesGroupNode )
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
			
			timelineNode.sortChildrenNode();
			
			animatorManager.rabbitAnimator.draw();
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
		
		// add a new property
		//private function butAdd_clickHandler(e:MouseEvent):void 
		//{
			//animatorManager.rabbitAnimator.showListOptionsForProperties(systemObject.target, listOptions_selectHandler);
		//}
		
		//private function listOptions_selectHandler(e:Event):void 
		//{
			//var listOptions:ListOptions = animatorManager.rabbitAnimator.listOptions;
			//
			//if ( !listOptions.selectedItem ) return;
			//
			//var parserProperty:RAParserProperty = listOptions.selectedItem.data as RAParserProperty;
			//
			//if ( !parserProperty ) return;
			//
			//animationSystemManager.createSystemProperty(systemObject, parserProperty);
		//}
		
		// change visibility of target
		private function eye_clickHandler(e:MouseEvent):void 
		{
			//setSize(160 + Math.round(Math.random() * 500));
		}
		
		override public function dispose():void 
		{
			super.dispose();
			systemObject = null;
			if( timelineNode ) timelineNode.dispose();
			timelineNode = null;
		}
		
		public function get showGroupColor():Boolean 
		{
			return _showGroupColor;
		}
		
		public function set showGroupColor(value:Boolean):void 
		{
			if ( _showGroupColor == value ) return;
			
			_showGroupColor = value;
			
			if ( _showGroupColor )
			{
				if ( !groupShape )
				{
					groupShape = new Shape();
					addChild(groupShape);
				}
				
				if ( groupColor <= 0 ) groupColor = RAStyle.getGroupColor();
			}
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
	}

}