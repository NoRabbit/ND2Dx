package com.rabbitframework.ui.dataprovider 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ArrayDataProvider extends DataProviderBase
	{
		public function ArrayDataProvider() 
		{
			
		}
		
		override public function getLabel(dataSource:Object):String 
		{
			return "Array";
		}
		
		override public function getItemAt(dataSource:Object, index:uint):* 
		{
			var a:Array = dataSource as Array;
			if( a && a.length > index && index >= 0 ) return a[index];
			return null;
		}
		
		override public function getItemIndex(dataSource:Object, dataSourceToFind:Object):int 
		{
			var a:Array = dataSource as Array;
			if ( a ) return a.indexOf(dataSourceToFind);
			return -1;
		}
		
		override public function addItem(dataSource:Object, dataSourceToAdd:Object):void 
		{
			var a:Array = dataSource as Array;
			if ( a ) a.push(dataSourceToAdd);
		}
		
		override public function addItemAt(dataSource:Object, dataSourceToAdd:Object, index:int):void 
		{
			var a:Array = dataSource as Array;
			
			if ( a )
			{
				if ( index >= a.length ) index = a.length;
				if ( index < 0 ) index = 0;
				a.splice(index, 0, dataSourceToAdd);
			}
		}
		
		override public function removeItem(dataSource:Object, dataSourceToRemove:Object):void 
		{
			var a:Array = dataSource as Array;
			
			if ( a )
			{
				var index:int = a.indexOf(dataSourceToRemove);
				if ( index >= 0 ) a.splice(index, 1);
			}
		}
		
		override public function removeItemAt(dataSource:Object, index:int):void 
		{
			var a:Array = dataSource as Array;
			
			if ( a )
			{
				a.splice(index, 1);
			}
		}
		
		override public function getNumChildren(dataSource:Object):uint 
		{
			var a:Array = dataSource as Array;
			if ( a ) return a.length;
			return 0;
		}
		
		override public function canContainChildren(dataSource:Object):Boolean 
		{
			return true;
		}
	}

}