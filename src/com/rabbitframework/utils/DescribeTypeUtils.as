package com.rabbitframework.utils 
{
	import flash.utils.describeType;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class DescribeTypeUtils 
	{
		
		public static function describeTypeWithValues(object:*, aTypes:Array = null):XML
		{
			if ( !aTypes ) aTypes = ["accessor", "variable"];
			
			var xml:XML = describeType(object);
			
			var firstLine:String = StringUtils.getLine(xml, 0);
			if ( firstLine == "" ) firstLine = "<type>";
			
			var xmlReturn:XML = new XML(firstLine + "</type>");
			
			var children:XMLList = xml.children();
			var type:String = "";
			
			for each (var item:XML in children) 
			{
				type = item.name().localName;
				
				if ( aTypes.indexOf(type) >= 0 )
				{
					if ( (type == "accessor" && item.@access.indexOf("read") >= 0) || type == "variable" )
					{
						if ( object.hasOwnProperty(item.@name) ) item.@["value"] = String(object[item.@name]);
					}
					
					xmlReturn.appendChild(item);
				}
				
			}
			
			return xmlReturn;
		}
		
	}
	
}