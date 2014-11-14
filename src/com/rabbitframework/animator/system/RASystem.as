package com.rabbitframework.animator.system 
{
	import com.rabbitframework.animator.managers.AnimationSystemManager;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RASystem 
	{
		public var animationSystemManager:AnimationSystemManager = AnimationSystemManager.getInstance();
		
		public var id:String = "";
		public var name:String = "";
		
		public var vObjects:Vector.<RASystemObject> = new Vector.<RASystemObject>();
		
		//public var onObjectAdded:Signal = new Signal(RASystemObject);
		//public var onObjectRemoved:Signal = new Signal(RASystemObject);
		//public var onChange:Signal = new Signal();
		
		public function RASystem() 
		{
			
		}
		
		public function addObject(object:RASystemObject):void
		{
			object.parent = this;
			if ( vObjects.indexOf(object) >= 0 ) return;
			vObjects.push(object);
		}
		
		public function removeObject(object:RASystemObject):void
		{
			var index:int = vObjects.indexOf(object);
			
			if ( index >= 0 )
			{
				vObjects.splice(index, 1);
			}
			
			object.dispose();
		}
		
		public function getAndSetPropertiesValueFromTime(time:Number):void
		{
			var i:int = 0;
			var n:int = vObjects.length;
			
			for (; i < n; i++) 
			{
				vObjects[i].getAndSetPropertiesValueFromTime(time);
			}
		}
		
		public function getXMLData():XML
		{
			var xml:XML  = 
			<system>
				<id>{id}</id>
				<name>{name}</name>
			</system>;
			
			var i:int = 0;
			var n:int = vObjects.length;
			
			for (; i < n; i++) 
			{
				xml.appendChild(vObjects[i].getXMLData());
			}
			
			return xml;
		}
		
		public function setXMLData(xml:XML, vTargetsToAvoid:Vector.<String> = null):void
		{
			//trace(this, "setXMLData", xml, vTargetsToAvoid);
			var object:RASystemObject;
			
			for each (var xmlObject:XML in xml.object) 
			{
				if ( vTargetsToAvoid && vTargetsToAvoid.indexOf(String(xmlObject.wgmObjectId)) >= 0 ) continue;
				
				object = new RASystemObject();
				object.parent = this;
				object.setXMLData(xmlObject);
				addObject(object);
			}
		}
		
		public function dispose():void
		{
			var i:int = 0;
			var n:int = vObjects.length;
			
			for (; i < n; i++) 
			{
				vObjects[i].dispose();
			}
			
			if ( id != "" ) animationSystemManager.freeID(id);
			animationSystemManager = null;
			
			//onPropertyAdded.removeAll();
			//onPropertyRemoved.removeAll();
			//onChange.removeAll();
		}
	}

}