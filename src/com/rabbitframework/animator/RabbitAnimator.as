package com.rabbitframework.animator 
{
	import com.bit101.components.VSlider;
	import com.rabbitframework.animator.managers.AnimationSystemManager;
	import com.rabbitframework.animator.managers.AnimatorManager;
	import com.rabbitframework.animator.nodes.RANode;
	import com.rabbitframework.animator.nodes.RAObjectNode;
	import com.rabbitframework.animator.nodes.RAObjectPropertyNode;
	import com.rabbitframework.animator.panels.objects.RAObjectsPanel;
	import com.rabbitframework.animator.panels.objectstimeline.RAObjectsTimelinePanel;
	import com.rabbitframework.animator.parser.RAParserProperty;
	import com.rabbitframework.animator.style.RAStyle;
	import com.rabbitframework.animator.system.RASystem;
	import com.rabbitframework.animator.system.RASystemObject;
	import com.rabbitframework.animator.system.RASystemObjectProperty;
	import com.rabbitframework.animator.system.RASystemObjectPropertyKey;
	import com.rabbitframework.animator.ui.ListOptions;
	import com.rabbitframework.display.RabbitSprite;
	import com.rabbitframework.managers.keyboard.KeyboardManager;
	import com.rabbitframework.utils.DisplayObjectUtils;
	import com.rabbitframework.utils.MathUtils;
	import de.nulldesign.nd2d.display.Node2D;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	import worldgamemaker.objects.WgmObject;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RabbitAnimator extends RabbitSprite
	{
		public var animatorManager:AnimatorManager = AnimatorManager.getInstance();
		public var animationSystemManager:AnimationSystemManager = AnimationSystemManager.getInstance();
		public var kbManager:KeyboardManager = KeyboardManager.getInstance();
		
		public var objectsPanel:RAObjectsPanel;
		public var objectsTimelinePanel:RAObjectsTimelinePanel;
		public var separatorV:Sprite;
		public var objectsMask:Sprite;
		public var objectsTimelineMask:Sprite;
		
		public var sizeWidth:Number = 800.0;
		public var sizeHeight:Number = 600.0;
		
		public var startDragX:Number;
		public var startDragSepX:Number;
		public var dragLimitLeft:Number = 200.0;
		public var dragLimitRight:Number = sizeWidth - 200.0;
		
		public var currentSystem:RASystem;
		
		//public var vSlider:VSlider;
		
		public var listOptions:ListOptions = new ListOptions();
		
		public function RabbitAnimator() 
		{
			animatorManager.rabbitAnimator = this;
			
			//objectsPanel.mask = objectsMask;
			//objectsTimelinePanel.mask = objectsTimelineMask;
			
			objectsMask.visible = objectsTimelineMask.visible = false;
			
			objectsMask.mouseEnabled = objectsMask.mouseChildren = objectsTimelineMask.mouseEnabled = objectsTimelineMask.mouseChildren = false;
			
			objectsPanel.refNode = objectsPanel.objectsTimelinePanel = objectsTimelinePanel;
			objectsTimelinePanel.refNode = objectsPanel;
			
			//vSlider = new VSlider(this, 0, 0);
			
			setSize(800, 300);
			moveSeparator(400.0);
			
			separatorV.useHandCursor = separatorV.buttonMode = true;
			
			eManager.add(separatorV, MouseEvent.MOUSE_DOWN, separatorV_mouseDownHandler, [eventGroup, eventGroup + ".sepDown"]);
			
			animatorManager.onCursorTimeChange.add(onCursorTimeChangeHandler);
		}
		
		private function onCursorTimeChangeHandler(time:Number):void 
		{
			if ( !currentSystem ) return;
			//currentSystem.getAndSetPropertiesValueFromTime(time);
		}
		
		private function separatorV_mouseDownHandler(e:MouseEvent):void 
		{
			eManager.suspendAllFromGroup(eventGroup + ".sepDown");
			
			startDragX = this.mouseX;
			startDragSepX = separatorV.x;
			
			eManager.add(this.stage, MouseEvent.MOUSE_UP, stage_mouseUpHandler, [eventGroup, eventGroup + ".sepUp"]);
			eManager.add(this.stage, Event.ENTER_FRAME, stage_enterFrameHandler, [eventGroup, eventGroup + ".sepUp"]);
		}
		
		private function stage_enterFrameHandler(e:Event):void 
		{
			moveSeparator(startDragSepX + (this.mouseX - startDragX));
		}
		
		private function stage_mouseUpHandler(e:MouseEvent):void 
		{
			eManager.suspendAllFromGroup(eventGroup + ".sepUp");
			eManager.resumeAllFromGroup(eventGroup + ".sepDown");
		}
		
		public function moveSeparator(x:Number):void
		{
			dragLimitLeft = 200;
			dragLimitRight = sizeWidth - 200;
			if ( x < dragLimitLeft ) x = dragLimitLeft;
			if ( x > dragLimitRight ) x = dragLimitRight;
			
			separatorV.x = x;
			separatorV.height = sizeHeight;
			
			draw();
		}
		
		public function setSize(w:Number, h:Number):void
		{
			sizeWidth = w;
			sizeHeight = h;
			draw();
		}
		
		public function draw():void
		{
			objectsTimelinePanel.x = separatorV.x + separatorV.width;
			
			RAStyle.OBJECTS_PANEL_WIDTH = separatorV.x;
			RAStyle.TIMELINE_PANEL_WIDTH = sizeWidth - objectsTimelinePanel.x;
			
			objectsPanel.draw();
			objectsTimelinePanel.draw();
			
			objectsMask.x = objectsPanel.x;
			objectsMask.y = objectsPanel.y;
			objectsMask.width = RAStyle.OBJECTS_PANEL_WIDTH;
			objectsMask.height = sizeHeight;
			
			objectsTimelineMask.x = objectsTimelinePanel.x;
			objectsTimelineMask.y = objectsTimelinePanel.y;
			objectsTimelineMask.width = RAStyle.TIMELINE_PANEL_WIDTH;
			objectsTimelineMask.height = sizeHeight;
			/*
			vSlider.x = w;
			vSlider.y = objectsPanel.nodeTotalWidth;
			vSlider.height = h - objectsPanel.nodeTotalWidth;
			*/
		}
		
		override public function onStageSet():void 
		{
			super.onStageSet();
			
			kbManager.init(stage);
		}
		
		public function showListOptionsForProperties(target:Object, callback:Function):void
		{
			/*
			var v:Vector.<RAParserProperty> = animationSystemManager.getParserPropertiesForTarget(target);
			
			listOptions.removeAll();
			
			var i:int = 0;
			var n:int = v.length;
			
			for (; i < n; i++) 
			{
				listOptions.addItem( { label:v[i].propertyName, data:v[i] } );
			}
			
			listOptions.show(callback);
			*/
		}
		
		public function clear():void
		{
			objectsPanel.clear();
			objectsTimelinePanel.clear();
		}
		
		public function setSystem(system:RASystem):void
		{
			if ( currentSystem == system ) return;
			
			clear();
			
			currentSystem = system;
			
			trace("setSystem", currentSystem, currentSystem.vObjects.length);
			
			var i:int = 0;
			var n:int = currentSystem.vObjects.length;
			var systemObject:RASystemObject;
			var nodeObject:RAObjectNode;
			
			var vObjectNodes:Vector.<RAObjectNode> = new Vector.<RAObjectNode>();
			
			for (; i < n; i++)
			{
				systemObject = currentSystem.vObjects[i];
				trace("systemObject", systemObject);
				nodeObject = animatorManager.parseSystemObject(systemObject);
				nodeObject.showGroupColor = true;
				objectsPanel.addChildNode(nodeObject);
				vObjectNodes.push(nodeObject);
			}
			
			i = 0;
			n = vObjectNodes.length;
			var nodeObject2:RAObjectNode;
			
			for (; i < n; i++)
			{
				nodeObject = vObjectNodes[i];
				
				var j:int = 0;
				var o:int = vObjectNodes.length;
				
				for (; j < o; j++) 
				{
					nodeObject2 = vObjectNodes[j];
					
					if ( nodeObject2 == nodeObject ) continue;
					
					if ( nodeObject2.systemObject.target == nodeObject.systemObject.target.parent )
					{
						nodeObject.parentNode.removeChildNode(nodeObject);
						nodeObject2.addChildNode(nodeObject);
					}
				}
			}
		}
		
		public function parseAndAddObject(wgmObject:WgmObject):RAObjectNode
		{
			if ( !currentSystem ) return null;
			
			// first check we don't have it already
			var nodeObject:RAObjectNode = getObjectNodeForObject(wgmObject, objectsPanel);
			
			// if not, create it
			if ( !nodeObject )
			{
				nodeObject = animatorManager.parseObject(wgmObject, currentSystem);
				nodeObject.showGroupColor = true;
				objectsPanel.addChildNode(nodeObject);
			}
			
			return nodeObject;
		}
		
		public function getObjectNodeForObject(wgmObject:WgmObject, lookIn:RANode):RAObjectNode
		{
			var i:int = 0;
			var n:int = lookIn.vChildrenNode.length;
			var currentObjectNode:RAObjectNode;
			
			for (; i < n; i++) 
			{
				currentObjectNode = lookIn.vChildrenNode[i] as RAObjectNode;
				
				if ( currentObjectNode )
				{
					if ( currentObjectNode.systemObject && currentObjectNode.systemObject.targetWgmObject == wgmObject )
					{
						return currentObjectNode;
					}
					else
					{
						getObjectNodeForObject(wgmObject, currentObjectNode);
					}
				}
			}
			
			return null;
		}
	}

}