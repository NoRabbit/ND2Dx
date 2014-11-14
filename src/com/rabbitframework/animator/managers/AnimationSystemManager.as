package com.rabbitframework.animator.managers 
{
	import com.rabbitframework.animator.parser.RAParserProperty;
	import com.rabbitframework.animator.system.RASystem;
	import com.rabbitframework.animator.system.RASystemObject;
	import com.rabbitframework.animator.system.RASystemObjectProperty;
	import com.rabbitframework.animator.system.RASystemObjectPropertyKey;
	import com.rabbitframework.utils.StringUtils;
	import com.rabbitframework.utils.UniqueIdUtil;
	import flash.utils.Dictionary;
	import worldgamemaker.objects.WgmObject;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class AnimationSystemManager 
	{
		private static var instance:AnimationSystemManager = new AnimationSystemManager();
		
		public var dIDForSystem:Dictionary = new Dictionary();
		public var dNameForSystem:Dictionary = new Dictionary();
		//public var dSystemObjectForTarget:Dictionary = new Dictionary();
		
		public function AnimationSystemManager() 
		{
			if ( instance ) throw new Error( "AnimationSystemManager can only be accessed through AnimationSystemManager.getInstance()" );
		}
		
		public static function getInstance():AnimationSystemManager 
		{
			return instance;
		}
		
		public function createSystem(name:String, id:String = ""):RASystem
		{
			if ( dNameForSystem[name] ) return null;
			
			var system:RASystem = new RASystem();
			system.name = name;
			dNameForSystem[name] = system;
			
			if ( id == "" )
			{
				setUniqueIDForSystem(system);
			}
			else
			{
				system.id = id;
				dIDForSystem[id] = system;
			}
			
			return system;
		}
		
		public function createSystemObject(wgmObject:WgmObject):RASystemObject
		{
			var systemObject:RASystemObject = new RASystemObject();
			systemObject.targetWgmObject = wgmObject;
			systemObject.target = wgmObject.node2D;
			return systemObject;
		}
		
		public function getSystemPropertyByName(systemObject:RASystemObject, propertyName:String):RASystemObjectProperty
		{
			var i:int = 0;
			var n:int = systemObject.vProperties.length;
			
			for (; i < n; i++) 
			{
				if ( systemObject.vProperties[i].propertyName == propertyName ) return systemObject.vProperties[i];
			}
			
			return null;
		}
		/*
		public function createSystemProperty(systemObject:RASystemObject, parserProperty:RAParserProperty):RASystemObjectProperty
		{
			if ( getSystemPropertyByName(systemObject, parserProperty.propertyName) ) return null;
			var systemProperty:RASystemObjectProperty = new RASystemObjectProperty();
			systemProperty.propertyName = parserProperty.propertyName;
			systemObject.addProperty(systemProperty);
			return systemProperty;
		}
		*/
		public function setUniqueIDForSystem(system:RASystem):void
		{
			var id:String = "";
			var i:int = 100;
			
			while (i--)
			{
				id = StringUtils.generateRandomString(4);
				
				if ( !dIDForSystem[id] )
				{
					system.id = id;
					dIDForSystem[id] = system;
					return;
				}
			}
		}
		
		public function getSystemForID(id:String):RASystem
		{
			return dIDForSystem[id] as RASystem;
		}
		
		public function getSystemForName(name:String):RASystem
		{
			return dNameForSystem[name] as RASystem;
		}
		
		public function freeID(id:String):void
		{
			delete dIDForSystem[id];
		}
		
		public function mapKeysSystemObject(systemObject:RASystemObject, callback:Function, data:Object):void
		{
			var i:int = 0;
			var n:int = systemObject.vProperties.length;
			
			for (; i < n; i++) 
			{
				mapKeysSystemProperty(systemObject.vProperties[i], callback, data);
			}
		}
		
		public function mapKeysSystemProperty(systemProperty:RASystemObjectProperty, callback:Function, data:Object):void
		{
			var key:RASystemObjectPropertyKey = systemProperty.head;
			
			while (key)
			{
				callback.call(null, key, data);
				key = key.next;
			}
		}
		
		public function getXMLData():XML
		{
			var id:String;
			var system:RASystem;
			
			var xml:XML  = 
			<animations>
			</animations>;
			
			for ( id in dIDForSystem )
			{
				system = dIDForSystem[id] as RASystem;
				xml.appendChild(system.getXMLData());
			}
			
			return xml;
		}
		
		public function setXMLData(xml:XML, vTargetsToAvoid:Vector.<String> = null):void
		{
			var system:RASystem;
			
			for each (var xmlSystem:XML in xml.system) 
			{
				system = createSystem(xmlSystem.name, xmlSystem.id);
				system.setXMLData(xmlSystem, vTargetsToAvoid);
			}
		}
	}
	
}