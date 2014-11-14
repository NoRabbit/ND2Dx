package com.rabbitframework.animator.nodes 
{
	import com.rabbitframework.animator.nodes.elements.INodeElement;
	import com.rabbitframework.animator.nodes.elements.NEButtonAddKey;
	import com.rabbitframework.animator.nodes.elements.NEButtonDelete;
	import com.rabbitframework.animator.nodes.elements.NEEye;
	import com.rabbitframework.animator.nodes.elements.NEInputValue;
	import com.rabbitframework.animator.nodes.elements.NEPropertyTitle;
	import com.rabbitframework.animator.nodes.elements.NESeparatorV01;
	import com.rabbitframework.animator.parser.RAParserProperty;
	import com.rabbitframework.animator.style.RAStyle;
	import com.rabbitframework.animator.system.RASystemObjectProperty;
	import com.rabbitframework.animator.system.RASystemObjectPropertyKey;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import worldgamemaker.objects.WgmObject;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAObjectPropertyNode extends RANode
	{
		public var bg:Sprite;
		
		public var separator01:NESeparatorV01;
		public var separator02:NESeparatorV01;
		public var separator03:NESeparatorV01;
		public var eye:NEEye;
		public var value:NEInputValue;
		public var title:NEPropertyTitle;
		public var butAddKey:NEButtonAddKey;
		//public var butDeleteProperty:NEButtonDelete;
		
		public var systemProperty:RASystemObjectProperty;
		
		public var timelineNode:RAObjectPropertyTimelineNode;
		
		public var vElements:Vector.<INodeElement> = new Vector.<INodeElement>();
		
		public var parserProperty:RAParserProperty;
		
		public function RAObjectPropertyNode() 
		{
			refNode = timelineNode = new RAObjectPropertyTimelineNode();
			timelineNode.refNode = this;
		}
		
		override public function preInit():void 
		{
			vElements.push(eye);
			vElements.push(separator03);
			vElements.push(title);
			vElements.push(separator01);
			vElements.push(value);
			vElements.push(separator02);
			
			vElements.push(butAddKey);
			
			//eManager.add(butDeleteProperty, MouseEvent.CLICK, butDeleteProperty_clickHandler, eventGroup);
			eManager.add(butAddKey, MouseEvent.CLICK, butAddKey_clickHandler, eventGroup);
			eManager.add(value, Event.CHANGE, value_changeHandler, eventGroup);
			
			animatorManager.onCursorTimeChange.add(onCursorTimeChangeHandler);
			
			eye.open = false;
			
			animatorManager.objectsManager.onObjectChange.add(onObjectChange_handler);
			
			super.preInit();
		}
		
		private function onObjectChange_handler(object:WgmObject):void 
		{
			//trace("onObjectChange_handler", object, "systemProperty", systemProperty);
			
			//var parentObjectNode:RAObjectNode = animatorManager.getParentObjectNodeForPropertyNode(this);
			
			//trace("onObjectChange_handler", object, "parentObjectNode", parentObjectNode);
			
			//if ( !parentObjectNode ) return;
			
			//trace("onObjectChange_handler", object, "parentObjectNode.eye.open", parentObjectNode.eye.open);
			
			//if ( !parentObjectNode.eye.open ) return;
			if ( !eye.open ) return;
			
			if ( !systemProperty )
			{
				// create one
				setSystemProperty(animatorManager.createSystemPropertyForPropertyNode(this));
			}
			
			trace("onObjectChange_handler", object, systemProperty, systemProperty.target, systemProperty.currentTarget, systemProperty.target == object.node2D);
			
			if ( systemProperty.target != object.node2D ) return;
			
			var currentKey:RASystemObjectPropertyKey = systemProperty.head;
			var key:RASystemObjectPropertyKey;
			
			while (currentKey) 
			{
				if ( currentKey.time == animatorManager.rabbitAnimator.objectsTimelinePanel.cursor.currentTime )
				{
					key = currentKey;
					break;
				}
				
				currentKey = currentKey.next;
			}
			
			if ( !key )
			{
				animatorManager.createKeyTime(systemProperty, 0.0, true);
			}
			else
			{
				key.value = systemProperty.getCurrentTargetValue();
			}
		}
		
		private function onCursorTimeChangeHandler(time:Number):void 
		{
			if ( !systemProperty ) return;
			systemProperty.getAndSetPropertyValueFromTime(time);
			// if not NaN
			if ( systemProperty.currentValue == systemProperty.currentValue )
			{
				value.value = systemProperty.currentValue;
			}
			else
			{
				value.txt.text = "";
			}
		}
		
		private function value_changeHandler(e:Event):void 
		{
			var systemKey:RASystemObjectPropertyKey = animatorManager.getKeyForTime(this, animatorManager.objectsTimelinePanel.cursor.currentTime);
			
			if ( systemKey )
			{
				systemKey.value = value.value;
				systemProperty.getAndSetPropertyValueFromTime(animatorManager.objectsTimelinePanel.cursor.currentTime);
			}
		}
		
		private function butAddKey_clickHandler(e:MouseEvent):void 
		{
			if ( !systemProperty )
			{
				// create one
				setSystemProperty(animatorManager.createSystemPropertyForPropertyNode(this));
			}
			
			animatorManager.createKeyTime(systemProperty, 0.0, true);
			
			/*
			// testing purpose
			var i:int = 0;
			var n:int = 2000;
			
			for (; i < n; i++) 
			{
				//animatorManager.createKeyTime(systemProperty, 0.0, true);
				animatorManager.createKeyTime(systemProperty, Math.random() * 2000, false);
			}
			*/
		}
		
		//private function butDeleteProperty_clickHandler(e:MouseEvent):void 
		//{
			//systemProperty.parent.removeProperty(systemProperty);
		//}
		
		override public function draw():void 
		{
			super.draw();
			
			bg.width = RAStyle.OBJECTS_PANEL_WIDTH;
			bg.height = nodeHeight;
			
			currentElementX = RAStyle.drawLeftElements(vElements, currentElementX, RAStyle.OBJECTS_PANEL_WIDTH - currentElementX);
		}
		
		public function setSystemProperty(systemProperty:RASystemObjectProperty):void
		{
			trace(this, "setSystemProperty", systemProperty, this.systemProperty, timelineNode);
			if ( this.systemProperty == systemProperty ) return;
			this.systemProperty = systemProperty;
			title.txt.text = systemProperty.propertyName;
			value.txt.text = String(systemProperty.getCurrentTargetValue());
			if ( this.systemProperty && timelineNode ) timelineNode.setSystemProperty(this.systemProperty);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			systemProperty = null;
			if( timelineNode ) timelineNode.dispose();
			timelineNode = null;
			parserProperty = null;
		}
	}

}