package com.rabbitframework.animator.managers 
{
	import com.rabbitframework.animator.nodes.RANode;
	import com.rabbitframework.animator.nodes.RAObjectNode;
	import com.rabbitframework.animator.nodes.RAObjectPropertiesGroupNode;
	import com.rabbitframework.animator.nodes.RAObjectPropertyNode;
	import com.rabbitframework.animator.nodes.RAObjectPropertyTimelineNode;
	import com.rabbitframework.animator.panels.objects.RAObjectsPanel;
	import com.rabbitframework.animator.panels.objectstimeline.RAObjectsTimelinePanel;
	import com.rabbitframework.animator.panels.objectstimeline.Timeline;
	import com.rabbitframework.animator.panels.objectstimeline.TimelineCursor;
	import com.rabbitframework.animator.parser.RAParser;
	import com.rabbitframework.animator.parser.RAParserProperty;
	import com.rabbitframework.animator.RabbitAnimator;
	import com.rabbitframework.animator.system.RASystem;
	import com.rabbitframework.animator.system.RASystemObject;
	import com.rabbitframework.animator.system.RASystemObjectProperty;
	import com.rabbitframework.animator.system.RASystemObjectPropertyKey;
	import com.rabbitframework.animator.ui.TimelineKey;
	import com.rabbitframework.managers.events.EventsManager;
	import com.rabbitframework.utils.StageUtils;
	import de.nulldesign.nd2d.display.Node2D;
	import flash.events.EventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	import org.osflash.signals.Signal;
	import worldgamemaker.managers.objects.ObjectsManager;
	import worldgamemaker.objects.WgmObject;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class AnimatorManager extends EventDispatcher
	{
		private static var instance:AnimatorManager = new AnimatorManager();
		
		public var eManager:EventsManager = EventsManager.getInstance();
		public var eventGroup:String = "AnimatorManager";
		
		public var animationSystemManager:AnimationSystemManager = AnimationSystemManager.getInstance();
		public var objectsManager:ObjectsManager = ObjectsManager.getInstance();
		
		public var rabbitAnimator:RabbitAnimator;
		public var objectsPanel:RAObjectsPanel;
		public var objectsTimelinePanel:RAObjectsTimelinePanel;
		
		private var _selectedTimelineKey:TimelineKey;
		
		public var vParsers:Vector.<RAParser> = new Vector.<RAParser>();
		public var vParserProperties:Vector.<RAParserProperty> = new Vector.<RAParserProperty>();
		
		public var onCursorTimeChange:Signal = new Signal(Number);
		
		public function AnimatorManager() 
		{
			if ( instance ) throw new Error( "AnimatorManager can only be accessed through AnimatorManager.getInstance()" );
		}
		
		public static function getInstance():AnimatorManager 
		{
			return instance;
		}
		
		public function addParser(parser:RAParser):void
		{
			if ( vParsers.indexOf(parser) >= 0 ) return;
			vParsers.push(parser);
		}
		
		public function getParserForTarget(target:Object):RAParser
		{
			var i:int = 0;
			var n:int = vParsers.length;
			
			for (; i < n; i++) 
			{
				if ( target is vParsers[i].targetClass )
				{
					return vParsers[i];
				}
			}
			
			return null;
		}
		
		public function addParserProperty(parserProperty:RAParserProperty):void
		{
			if ( vParserProperties.indexOf(parserProperty) >= 0 ) return;
			vParserProperties.push(parserProperty);
		}
		
		public function getParserPropertiesForTarget(target:Object):Vector.<RAParserProperty>
		{
			var i:int = 0;
			var n:int = vParserProperties.length;
			var parserProperty:RAParserProperty;
			var vResults:Vector.<RAParserProperty> = new Vector.<RAParserProperty>();
			
			for (; i < n; i++) 
			{
				parserProperty = vParserProperties[i];
				if ( target is parserProperty.targetClass ) vResults.push(parserProperty);
			}
			
			return vResults;
		}
		
		/*
		 * TIME
		*/
		
		public function setTimeCursorAt(time:Number):void
		{
			objectsTimelinePanel.cursor.currentTime = time;
			objectsTimelinePanel.updateCursor();
		}
		
		public function createKeyTime(systemProperty:RASystemObjectProperty, time:Number, useCurrentCursorTime:Boolean = false):void
		{
			var systemKey:RASystemObjectPropertyKey = new RASystemObjectPropertyKey();
			
			if ( useCurrentCursorTime )
			{
				time = getCurrentTime();
			}
			
			//systemKey = systemProperty.createKey(time, systemProperty.target[systemProperty.propertyName]);
			systemKey = systemProperty.createKey(time, systemProperty.getCurrentTargetValue());
		}
		
		public function getKeyForTime(objectPropertyNode:RAObjectPropertyNode, time:Number):RASystemObjectPropertyKey
		{
			var i:int = 0;
			var n:int = objectPropertyNode.timelineNode.vTimelineKeys.length;
			
			for (; i < n; i++) 
			{
				if ( objectPropertyNode.timelineNode.vTimelineKeys[i].systemKey.time == time ) return objectPropertyNode.timelineNode.vTimelineKeys[i].systemKey;
			}
			
			return null;
		}
		
		/*
		 * OBJECT NODES
		*/
		
		public function createObjectNode(target:Object):RAObjectNode
		{
			var object:RAObjectNode = new RAObjectNode();
			object.title.txt.text = target.toString();
			return object;
		}
		
		public function createObjectPropertyNode(parserProperty:RAParserProperty, parentNode:RANode = null):RAObjectPropertyNode
		{
			var objectProperty:RAObjectPropertyNode = new RAObjectPropertyNode();
			
			objectProperty.title.txt.text = parserProperty.propertyName;
			objectProperty.value.txt.text = "";
			
			if( parentNode ) parentNode.addChildNode(objectProperty);

			return objectProperty;
		}
		
		public function createObjectPropertiesGroupNode(parserProperty:RAParserProperty, parentNode:RANode = null):RAObjectPropertiesGroupNode
		{
			var objectPropertiesGroup:RAObjectPropertiesGroupNode = new RAObjectPropertiesGroupNode();
			
			objectPropertiesGroup.title.txt.text = parserProperty.propertyName;
			
			if ( parentNode ) parentNode.addChildNode(objectPropertiesGroup);
			
			return objectPropertiesGroup;
		}
		
		public function getPropertyNodeByPropertyName(node:RANode, propertyName:String):RAObjectPropertyNode
		{
			var i:int = 0;
			var n:int = node.vChildrenNode.length;
			var objectProperty:RAObjectPropertyNode;
			
			for (; i < n; i++)
			{
				objectProperty = node.vChildrenNode[i] as RAObjectPropertyNode;
				
				if ( objectProperty && objectProperty.parserProperty.propertyName == propertyName )
				{
					return objectProperty;
				}
				else
				{
					objectProperty = getPropertyNodeByPropertyName(node.vChildrenNode[i], propertyName);
					if ( objectProperty ) return objectProperty;
				}
			}
			
			return null;
		}
		
		public function getPropertyNodeMatchSystemProperty(node:RANode, systemProperty:RASystemObjectProperty):RAObjectPropertyNode
		{
			var i:int = 0;
			var n:int = node.vChildrenNode.length;
			var objectProperty:RAObjectPropertyNode;
			
			for (; i < n; i++)
			{
				objectProperty = node.vChildrenNode[i] as RAObjectPropertyNode;
				
				if ( objectProperty )
				{
					if ( objectProperty.parserProperty.propertyName == systemProperty.propertyName
					&& objectProperty.parserProperty.propertyPath == systemProperty.propertyPath
					&& objectProperty.parserProperty.propertyType == systemProperty.propertyType )
					{
						return objectProperty;
					}
				}
				else
				{
					objectProperty = getPropertyNodeMatchSystemProperty(node.vChildrenNode[i], systemProperty);
					if ( objectProperty ) return objectProperty;
				}
			}
			
			return null;
		}
		
		public function getParentObjectNodeForPropertyNode(propertyNode:RAObjectPropertyNode):RAObjectNode
		{
			var currentParent:RANode = propertyNode.parentNode;
			
			while ( currentParent )
			{
				if ( currentParent is RAObjectNode ) return currentParent as RAObjectNode;
				currentParent = currentParent.parentNode;
			}
			
			return null;
		}
		
		public function getPropertyNodeBySystemProperty(objectNode:RAObjectNode, systemProperty:RASystemObjectProperty):RAObjectPropertyNode
		{
			var i:int = 0;
			var n:int = objectNode.vChildrenNode.length;
			var objectProperty:RAObjectPropertyNode;
			
			for (; i < n; i++)
			{
				if ( objectNode.vChildrenNode[i] is RAObjectPropertyNode )
				{
					objectProperty = objectNode.vChildrenNode[i] as RAObjectPropertyNode;
					if ( objectProperty.systemProperty == systemProperty ) return objectProperty;
				}
			}
			
			return null;
		}
		
		public function createSystemPropertyForPropertyNode(propertyNode:RAObjectPropertyNode):RASystemObjectProperty
		{
			// get parent object node
			var currentParent:RANode = propertyNode.parentNode;
			var objectNode:RAObjectNode;
			var systemProperty:RASystemObjectProperty = new RASystemObjectProperty();
			systemProperty.propertyName = propertyNode.parserProperty.propertyName;
			systemProperty.propertyPath = propertyNode.parserProperty.propertyPath;
			systemProperty.propertyType = propertyNode.parserProperty.propertyType;
			
			while ( currentParent )
			{
				if ( currentParent is RAObjectNode )
				{
					objectNode = currentParent as RAObjectNode;
					objectNode.systemObject.addProperty(systemProperty);
					break;
				}
				
				currentParent = currentParent.parentNode;
			}
			
			systemProperty.initTargetAndProperty();
			
			return systemProperty;
		}
		
		public function getCurrentTime():Number
		{
			return objectsTimelinePanel.cursor.currentTime;
		}
		
		/*
		public function get selectedTimelineKey():TimelineKey 
		{
			return _selectedTimelineKey;
		}
		
		public function set selectedTimelineKey(value:TimelineKey):void 
		{
			if ( _selectedTimelineKey == value ) return;
			if ( _selectedTimelineKey ) _selectedTimelineKey.selected = false;
			
			_selectedTimelineKey = value;
			
			eManager.removeAllFromGroup(eventGroup + "stageClick");
			
			if ( _selectedTimelineKey )
			{
				_selectedTimelineKey.selected = true;
				eManager.add(StageUtils.stage, MouseEvent.MOUSE_DOWN, stage_mouseDownHandler, eventGroup + "stageClick");
			}
		}
		
		private function stage_mouseDownHandler(e:MouseEvent):void 
		{
			if ( e.target != _selectedTimelineKey )
			{
				trace("ciao!!!!");
				selectedTimelineKey = null;
			}
		}
		*/
		public function parseObject(wgmObject:WgmObject, system:RASystem):RAObjectNode
		{
			var parser:RAParser = getParserForTarget(wgmObject.node2D);
			
			if ( !parser ) return null;
			
			var objectNode:RAObjectNode = parser.createObjectNodeForTarget(wgmObject.node2D);
			
			var currentChild:Node2D = wgmObject.node2D.childFirst;
			
			while ( currentChild )
			{
				objectNode.addChildNode(parseObject(objectsManager.getWgmObjectForNode2D(currentChild), system));
				currentChild = currentChild.next;
			}
			
			objectNode.setSystemObject(animationSystemManager.createSystemObject(wgmObject));
			system.addObject(objectNode.systemObject);
			
			return objectNode;
		}
		
		public function parseSystemObject(systemObject:RASystemObject):RAObjectNode
		{
			var wgmObject:WgmObject = systemObject.targetWgmObject;
			var parser:RAParser = getParserForTarget(wgmObject.node2D);
			
			trace("parseSystemObject", systemObject, wgmObject, parser);
			
			if ( !parser ) return null;
			
			var objectNode:RAObjectNode = parser.createObjectNodeForTarget(wgmObject.node2D);
			/*
			var currentChild:Node2D = wgmObject.node2D.childFirst;
			
			while ( currentChild )
			{
				objectNode.addChildNode(parseObject(objectsManager.getWgmObjectForNode2D(currentChild), system));
				currentChild = currentChild.next;
			}
			*/
			objectNode.setSystemObject(systemObject);
			
			return objectNode;
		}
	}
	
}