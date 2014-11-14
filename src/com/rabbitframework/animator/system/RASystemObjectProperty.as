package com.rabbitframework.animator.system 
{
	import de.nulldesign.nd2d.display.Node2D;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RASystemObjectProperty 
	{
		public static const PROPERTY_TYPE_PROPERTY:String = "PROPERTY_TYPE_PROPERTY";
		public static const PROPERTY_TYPE_FUNCTION:String = "PROPERTY_TYPE_FUNCTION";
		
		public var parent:RASystemObject;
		
		public var head:RASystemObjectPropertyKey;
		public var tail:RASystemObjectPropertyKey;
		public var length:int = 0;
		
		public var target:Object;
		public var currentTarget:Object;
		public var currentPropertyName:String;
		public var currentFunction:Function;
		
		public var propertyType:String = PROPERTY_TYPE_PROPERTY;
		public var propertyPath:String = "";
		public var propertyName:String;
		
		public var currentValue:Number;
		
		public var onKeyAdded:Signal = new Signal(RASystemObjectPropertyKey);
		public var onKeyRemoved:Signal = new Signal(RASystemObjectPropertyKey);
		public var onChange:Signal = new Signal(RASystemObjectPropertyKey);
		
		public function RASystemObjectProperty(target:Object = null, propertyName:String = "", propertyPath:String = "", propertyType = PROPERTY_TYPE_PROPERTY, parent:RASystemObject = null) 
		{
			this.target = target;
			this.propertyName = propertyName;
			this.propertyPath = propertyPath;
			this.propertyType = propertyType;
			
			//trace("RASystemObjectProperty", target, propertyName, propertyPath, propertyType, parent);
			
			if ( parent ) parent.addProperty(this);
			this.parent = parent;
			
			initTargetAndProperty();
		}
		
		public function initTargetAndProperty():void
		{
			//trace("initTargetAndProperty", target, propertyPath);
			
			if ( !target ) return;
			
			var path:Array = propertyPath.split(".");
			
			currentTarget = target;
			
			//trace("initTargetAndProperty", path, currentTarget, propertyType);
			
			var i:int = 0;
			var n:int = path.length - 1;
			
			for (; i < n; i++) 
			{
				currentTarget = currentTarget[path[i]];
				trace(path[i], currentTarget);
			}
			
			if ( propertyType == PROPERTY_TYPE_FUNCTION )
			{
				currentFunction = currentTarget[path[path.length - 1]] as Function;
			}
			else if ( propertyType == PROPERTY_TYPE_PROPERTY )
			{
				currentPropertyName = path[path.length - 1];
			}
			
			//trace("currentFunction", currentFunction);
			//trace("currentPropertyName", currentPropertyName);
		}
		
		public function getCurrentTargetValue():Number
		{
			if ( propertyType == PROPERTY_TYPE_FUNCTION )
			{
				return currentFunction.call(null, null) as Number;
			}
			else if ( propertyType == PROPERTY_TYPE_PROPERTY )
			{
				return currentTarget[currentPropertyName];
			}
			
			return NaN;
		}
		
		public function createKey(time:Number, value:Number, add:Boolean = true):RASystemObjectPropertyKey
		{
			var newKey:RASystemObjectPropertyKey = new RASystemObjectPropertyKey();
			newKey.time = time;
			newKey.value = value;
			if ( add ) addKey(newKey);
			
			return newKey;
		}
		
		public function addKey(key:RASystemObjectPropertyKey, dispatchEvent:Boolean = true):RASystemObjectPropertyKey
		{
			length++;
			
			if ( !head )
			{
				head = tail = key;
			}
			else
			{
				var currentKey:RASystemObjectPropertyKey = head;
				
				while (currentKey) 
				{
					if ( key.time < currentKey.time )
					{
						insertKeyBefore(currentKey, key);
						break;
					}
					
					currentKey = currentKey.next;
				}
				
				if ( !currentKey )
				{
					// else, add it to the tail
					tail.next = key;
					key.prev = tail;
					tail = key;
				}
			}
			
			key.parent = this;
			
			// dispatch signal
			if( dispatchEvent ) onKeyAdded.dispatch(key);
			
			return key;
		}
		
		public function insertKeyBefore(before:RASystemObjectPropertyKey, key:RASystemObjectPropertyKey):void
		{
			//trace("insertKeyBefore", before, key);
			
			if ( before == head )
			{
				head = key;
				key.next = before;
				before.prev = key;
				key.prev = null;
			}
			else
			{
				before.prev.next = key;
				key.prev = before.prev;
				before.prev = key;
				key.next = before;
			}
		}
		
		public function insertKeyAfter(after:RASystemObjectPropertyKey, key:RASystemObjectPropertyKey):void
		{
			//trace("insertKeyAfter", after, key);
			
			if ( after == tail )
			{
				tail = key;
				key.prev = after;
				after.next = key;
				key.next = null;
			}
			else
			{
				after.next.prev = key;
				key.next = after.next;
				after.next = key;
				key.prev = after;
			}
		}
		
		public function removeKey(key:RASystemObjectPropertyKey, dispatchEvent:Boolean = true):void
		{
			if ( key == head )
			{
				head = key.next;
				if( head ) head.prev = null;
			}
			else if ( key == tail )
			{
				tail = key.prev;
				if( tail ) tail.next = null;
			}
			else
			{
				if( key.prev ) key.prev.next = key.next;
				if( key.next ) key.next.prev = key.prev;
			}
			
			key.next = key.prev = null;
			key.parent = null;
			
			length--;
			
			if( dispatchEvent ) onKeyRemoved.dispatch(key);
		}
		
		public function changeKeyTime(key:RASystemObjectPropertyKey, time:Number):void
		{
			if ( !head ) return;
			
			removeKey(key, false);
			
			if ( length <= 0 )
			{
				key.time = time;
				addKey(key, false);
				return;
			}
			
			var currentKey:RASystemObjectPropertyKey = head;
			
			while ( currentKey )
			{
				if ( time == currentKey.time )
				{
					// same time as another key, just replace it where it was
					//trace("same time");
					
					addKey(key, false);
					return;
				}
				else if ( time < currentKey.time )
				{
					// place key before node
					//trace("ok, found one", currentKey);
					
					length ++;
					key.time = time;
					insertKeyBefore(currentKey, key);
					return;
				}
				
				currentKey = currentKey.next;
			}
			
			// just insert it at the end
			//trace("nothing, just insert after tail");
			
			length ++;
			key.time = time;
			insertKeyAfter(tail, key);
		}
		
		public function debugKeys():void
		{
			var currentKey:RASystemObjectPropertyKey = head;
			
			//trace("debug", this, " length:", length);
			
			while (currentKey) 
			{
				trace(currentKey, "-prev:" + currentKey.prev, "-next:" + currentKey.next);
				
				currentKey = currentKey.next;
			}
		}
		
		public function getAndSetPropertyValueFromTime(time:Number, setPropertyValue:Boolean = true):Number
		{
			//trace("getAndSetPropertyValueFromTime", target, length);
			
			if ( length <= 0 )
			{
				currentValue = NaN;
			}
			else if ( length == 1 )
			{
				currentValue = head.value;
			}
			else
			{
				var currentKey:RASystemObjectPropertyKey = head;
				
				while (currentKey) 
				{
					if ( currentKey.time > time ) break;
					currentKey = currentKey.next;
				}
				
				//trace("currentKey", currentKey, (currentKey ? currentKey.prev + " " + currentKey.next : ""));
				
				if ( !currentKey )
				{
					currentValue = tail.value;
				}
				else if ( !currentKey.prev )
				{
					currentValue = currentKey.value;
				}
				else
				{
					var duration:Number = currentKey.time - currentKey.prev.time;
					var startTime:Number = time - currentKey.prev.time;
					var valueDelta:Number = currentKey.value - currentKey.prev.value;
					currentValue = currentKey.prev.value + (currentKey.prev.ease(startTime, 0, 1, duration) * valueDelta);
				}
			}
			
			//trace(target, setPropertyValue, currentValue);
			
			if( target && setPropertyValue ) setCurrentPropertyValue();
			
			return currentValue;
		}
		
		public function setCurrentPropertyValue():void
		{
			//trace("setCurrentPropertyValue", currentValue, propertyType, currentFunction, currentTarget, currentPropertyName);
			
			// currentValue != currentValue --> isNaN
			if ( currentValue == currentValue )
			{
				try 
				{
					if ( propertyType == PROPERTY_TYPE_FUNCTION )
					{
						//trace("setCurrentPropertyValue", currentFunction);
						currentFunction.call(null, currentValue);
					}
					else if ( propertyType == PROPERTY_TYPE_PROPERTY )
					{
						currentTarget[currentPropertyName] = currentValue;
						//if( const_target == currentTarget ) trace(currentTarget, currentPropertyName, currentValue);
					}
				}
				catch (err:Error)
				{
					trace(err);
				}
			}
		}
		
		//public static var const_target:Object = null;
		
		public function getXMLData():XML
		{
			var xml:XML = 
			<property>
				<propertyName>{propertyName}</propertyName>
				<propertyType>{propertyType}</propertyType>
				<propertyPath>{propertyPath}</propertyPath>
			</property>;
			
			var currentKey:RASystemObjectPropertyKey = head;
			
			while (currentKey) 
			{
				xml.appendChild(currentKey.getXMLData());
				currentKey = currentKey.next;
			}
			
			return xml;
		}
		
		public function setXMLData(xml:XML):void
		{
			propertyName = xml.propertyName;
			propertyType = xml.propertyType;
			propertyPath = xml.propertyPath;
			
			//trace(this, "setXMLData", target, propertyName, propertyType, propertyPath, xml);
			
			initTargetAndProperty();
			
			var key:RASystemObjectPropertyKey;
			
			for each (var xmlKey:XML in xml.key) 
			{
				key = new RASystemObjectPropertyKey();
				key.setXMLData(xmlKey);
				addKey(key);
			}
		}
		
		public function dispose():void
		{
			var currentKey:RASystemObjectPropertyKey = head;
			var nextKey:RASystemObjectPropertyKey = head;
			
			while (currentKey) 
			{
				nextKey = currentKey.next;
				currentKey.dispose();
				currentKey = nextKey;
			}
			
			currentTarget = target = null;
			currentFunction = null;
			head = tail = null;
			parent = null;
			
			propertyName = propertyPath = propertyType = currentPropertyName = "";
			
			onKeyAdded.removeAll();
			onKeyRemoved.removeAll();
			onChange.removeAll();
		}
	}

}