package com.rabbitframework.utils 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DragAndDropUtils 
	{
		
		public function DragAndDropUtils() 
		{
			
		}
		
		public static function isObjectOfAcceptedDroppableTypes(object:Object, acceptedDroppableTypes:Array):Boolean
		{
			if ( !acceptedDroppableTypes ) return true;
			
			var i:int = 0;
			var n:int = acceptedDroppableTypes.length;
			var c:Class;
			for (; i < n; i++) 
			{
				c = acceptedDroppableTypes[i] as Class;
				if ( object is c ) return true;
			}
			
			return false;
		}
	}

}