package com.rabbitframework.utils 
{
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2009.
	 */
	public class ObjectUtils 
	{
		
		public function ObjectUtils() 
		{
			
		}
		
		public static function copyProperties(objectFrom:Object, objectTo:Object, overwrite:Boolean = true):void
		{
			if ( !objectFrom ) return;
			if ( !objectTo ) return;
			
			var xml:XML = DescribeTypeUtils.describeTypeWithValues(objectFrom);
			var variable:XML;
			var prop:String;
			var value:Object;
			
			for each(variable in xml.variable)
			{
				prop = variable.@name;
				value = variable.@value;
				
				try
				{
					if ( overwrite )
					{
						objectTo[prop] = value;
					}
					else if ( !(prop in objectTo) )
					{
						objectTo[prop] = value;
					}
				}
				catch(e:Error)
				{
					
				}
			}
		}
		
		public static function copySpecifiedProperties(objectFrom:Object, objectTo:Object, specifiedProps:Array, overwrite:Boolean = true):void
		{
			var s:String;
			
			for each (s in specifiedProps) 
			{
				try
				{
					if ( overwrite )
					{
						objectTo[s] = objectFrom[s];
					}
					else if ( !(s in objectTo) )
					{
						objectTo[s] = objectFrom[s];
					}
				}
				catch(e:Error)
				{
					
				}
			}
		}
		
		public static function getStringProperty(object:*, property:String, defaultValue:String = ""):String
		{
			if ( property in object && object[property] != undefined ) return String(object[property]);
			return defaultValue;
		}
		
		public static function getNumberProperty(object:*, property:String, defaultValue:Number = 0.0):Number
		{
			if ( property in object && object[property] != undefined ) return Number(object[property]);
			return defaultValue;
		}
		
		public static function getBooleanProperty(object:*, property:String, defaultValue:Boolean = false):Boolean
		{
			if ( property in object && object[property] != undefined )
			{
				var value:* = object[property];
				
				if ( value == undefined || !value ) return defaultValue;
				
				if ( value is Boolean )
				{
					return value as Boolean;
				}
				else if ( value is String )
				{
					switch (value as String) 
					{
						case "1":
						case "true":
							{
								return true;
								break;
							}
							
						case "0":
						case "false":
							{
								return false;
								break;
							}
					}
				}
				else if ( value is Number )
				{
					switch (value as Number) 
					{
						case 0:
							{
								return false;
								break;
							}
							
						case 1:
							{
								return true;
								break;
							}
					}
				}
			}
			
			return defaultValue;
		}
		
		public static function getString(value:*, defaultValue:String = ""):String
		{
			if ( !value ) return defaultValue;
			if ( value == undefined ) return defaultValue;
			return value as String;
		}
		
		public static function getNumber(value:*, defaultValue:Number = 0.0):Number
		{
			if ( !value ) return defaultValue;
			if ( value == undefined ) return defaultValue;
			if ( isNaN(Number(value)) ) return defaultValue;
			return value as Number
		}
		
		public static function getBoolean(value:*, defaultValue:Boolean = false):Boolean
		{
			var s:String = String(value);
			
			switch (s.toLowerCase())
			{
				case "true":
				case "1":
				{
					return true;
					break;
				}
				
				case "false":
				case "0":
				{
					return false;
					break;
				}
				
				default:
				{
					return defaultValue;
					break;
				}
			}
		}
		
		public static function getObjectByClassName(className:String, defaultClassName:String = "", args:Array = null):Object
		{
			//trace("getObjectByClassName", className, defaultClassName);
			
			if ( className == "" )
			{
				if ( defaultClassName == "" ) return null;
				
				return getObjectByClassName(defaultClassName, "", args);
			}
			
			var classObject:Class
			
			try
			{
				classObject = getDefinitionByName(className) as Class;
			}
			catch (err:Error)
			{
				classObject = null;
			}
			
			if ( classObject )
			{
				var object:Object;
				
				if ( !args )
				{
					object = new classObject();
				}
				else if ( args.length == 0 )
				{
					object = new classObject();
				}
				else if ( args.length == 1 )
				{
					object = new classObject(args[0]);
				}
				else if ( args.length == 2 )
				{
					object = new classObject(args[0], args[1]);
				}
				else if ( args.length == 3 )
				{
					object = new classObject(args[0], args[1], args[2]);
				}
				else if ( args.length == 4 )
				{
					object = new classObject(args[0], args[1], args[2], args[3]);
				}
				else if ( args.length == 5 )
				{
					object = new classObject(args[0], args[1], args[2], args[3], args[4]);
				}
				
				//trace("getObjectByClassName", "object", object);
				
				if ( object )
				{
					return object;
				}
			}
			
			return getObjectByClassName(defaultClassName);
		}
		
		/**
		 * DUMP OBJECT
		 */
		
		// these two static variables will be emptied when 
		// the method recursiveDump is called with false 
		// as isInside parameter
		
		// static string that will contain the dump
		private static var _dumpString:String = ""; 
		// static string that will contain the indent
		private static var _dumpIndent:String = "";
		
		// our dump function
		// using ...rest parameter to have at least one
		// parameter and accept as many as needed
		public static function dump(o:Object,...rest):String
		{
			var tmpStr:String = "";
			var len:uint = rest.length;
			// call for the first parameter (object)
			tmpStr += recursiveDump(o,false);
			// if we have more than one parameter 
			// at method call we display them
			if (len > 0)
			{
				// looping through the ...rest array
				for (var i:uint = 0; i < len; i++)
				{
					// call internal recursive dump
					tmpStr += recursiveDump(rest[i],false);
				}
			}
			return tmpStr;
		}
		
		// internal recursive dump method
		// called by dump
		internal static function recursiveDump(o:Object,isInside:Boolean = true):String
		{
			// check if is not called by itself which means
			// is called from the first time and from here
			// it will be called recursivelly 
			if (!isInside)
			{
				// reinitializing the static dump strings
				_dumpString = "";
				_dumpIndent = "";
			}
			
			// type of the object
			var type:String = typeof(o);
			// another way to get the type more accuratelly
			// used for display
			var className:String = getQualifiedClassName(o);
			// starting from here we create the dump string
			_dumpString += _dumpIndent + className;
			if (type == "object") {
				_dumpString += " (" + getLength(o) + ")";
				_dumpString += " {\n";
				_dumpIndent += "    ";
				for (var i:Object in o) {
					_dumpString += _dumpIndent + "[" +i+ "] => ";
					// recursive call
					// by default isInside parameter is true
					// so the dump string will NOT be reinitialized
					recursiveDump(o[i]);
				}
				_dumpIndent = _dumpIndent.substring(0,_dumpIndent.length-4);
				_dumpString += _dumpIndent + "}\n";
			} else {
				if (type == "string")
					_dumpString += " (" + o.length + ") = \"" + o + "\"\n";
				else
					_dumpString += "(" + o + ")\n";
			}
			// returning the dump string
			return _dumpString;			
		}
		
		// internal function to get the number of children
		// from the object - getting only the first level
		internal static function getLength(o:Object):uint
		{
			var len:uint = 0;
			for (var item:* in o)
				len++;
			return len;
		}
	}
	
}