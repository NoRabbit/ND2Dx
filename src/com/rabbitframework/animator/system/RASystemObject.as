package com.rabbitframework.animator.system 
{
	import de.nulldesign.nd2d.display.Node2D;
	import org.osflash.signals.Signal;
	import worldgamemaker.managers.objects.ObjectsManager;
	import worldgamemaker.objects.WgmObject;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RASystemObject 
	{
		public var objectsManager:ObjectsManager = ObjectsManager.getInstance();
		
		public var parent:RASystem;
		//public var id:String = "";
		
		public var targetWgmObject:WgmObject;
		public var target:Node2D;
		
		public var vProperties:Vector.<RASystemObjectProperty> = new Vector.<RASystemObjectProperty>();
		//public var vObjects:Vector.<RASystemObject> = new Vector.<RASystemObject>();
		
		public var onPropertyAdded:Signal = new Signal(RASystemObjectProperty);
		public var onPropertyRemoved:Signal = new Signal(RASystemObjectProperty);
		public var onChange:Signal = new Signal();
		
		public function RASystemObject() 
		{
			
		}
		
		public function addProperty(property:RASystemObjectProperty):void
		{
			property.target = target;
			property.parent = this;
			if ( vProperties.indexOf(property) >= 0 ) return;
			vProperties.push(property);
			onPropertyAdded.dispatch(property);
			onChange.dispatch();
		}
		
		public function removeProperty(property:RASystemObjectProperty):void
		{
			var index:int = vProperties.indexOf(property);
			
			if ( index >= 0 )
			{
				vProperties.splice(index, 1);
				onPropertyRemoved.dispatch(property);
				onChange.dispatch();
			}
			
			property.dispose();
		}
		
		public function getAndSetPropertiesValueFromTime(time:Number):void
		{
			var i:int = 0;
			var n:int = vProperties.length;
			
			for (; i < n; i++) 
			{
				vProperties[i].getAndSetPropertyValueFromTime(time);
			}
		}
		
		public function getXMLData():XML
		{
			var xml:XML  = 
			<object>
				<wgmObjectId>{targetWgmObject.objectId}</wgmObjectId>
			</object>;
			
			var i:int = 0;
			var n:int = vProperties.length;
			
			for (; i < n; i++) 
			{
				xml.appendChild(vProperties[i].getXMLData());
			}
			
			return xml;
		}
		
		public function setXMLData(xml:XML):void
		{
			targetWgmObject = objectsManager.getWgmObjectForId(objectsManager.currentObjectsIdPrefix + xml.wgmObjectId);
			target = targetWgmObject.node2D;
			
			//trace(this, "setXMLData", targetWgmObject, target, xml);
			
			var prop:RASystemObjectProperty;
			
			for each (var xmlProp:XML in xml.property) 
			{
				prop = new RASystemObjectProperty();
				prop.target = target;
				prop.parent = this;
				prop.setXMLData(xmlProp);
				addProperty(prop);
			}
		}
		
		public function dispose():void
		{
			var i:int = 0;
			var n:int = vProperties.length;
			
			for (; i < n; i++) 
			{
				vProperties[i].dispose();
			}
			
			target = null;
			
			onPropertyAdded.removeAll();
			onPropertyRemoved.removeAll();
			onChange.removeAll();
		}
	}

}