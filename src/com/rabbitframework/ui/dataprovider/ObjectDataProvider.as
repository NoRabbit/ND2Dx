package com.rabbitframework.ui.dataprovider 
{
	import flash.display.BitmapData;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ObjectDataProvider extends DataProviderBase
	{
		public function ObjectDataProvider() 
		{
			
		}
		
		override public function getLabel(dataSource:Object):String 
		{
			// this to check if dataSource is dynamic (better than using reflection I think)
			for (var s:String in dataSource)
			{
				if ( s == "label" ) return dataSource["label"];
			}
			
			return dataSource.toString();
		}
		
		override public function getIcon(dataSource:Object):BitmapData 
		{
			// this to check if dataSource is dynamic (better than using reflection I think)
			for (var s:String in dataSource)
			{
				if ( s == "icon" )
				{
					return dataSource["icon"] as BitmapData;
				}
			}
			
			return null;
		}
		
		override public function getItemAt(dataSource:Object, index:uint):* 
		{
			var a:Array = dataSource["children"] as Array;
			if ( a && index >= 0 && a.length > index ) return a[index];
			return null;
		}
		
		override public function getItemIndex(dataSource:Object, dataSourceToFind:Object):int 
		{
			var a:Array = dataSource["children"] as Array;
			if ( a ) return a.indexOf(dataSourceToFind);
			return -1;
		}
		
		override public function addItem(dataSource:Object, dataSourceToAdd:Object):void 
		{
			var a:Array = dataSource["children"] as Array;
			if ( !a ) a = dataSource["children"] = new Array();
			a.push(dataSourceToAdd);
		}
		
		override public function addItemAt(dataSource:Object, dataSourceToAdd:Object, index:int):void 
		{
			var a:Array = dataSource["children"] as Array;
			if ( !a ) a = dataSource["children"] = new Array();
			
			if ( a )
			{
				if ( index >= a.length ) index = a.length - 1;
				if ( index < 0 ) index = 0;
				a.splice(index, 0, dataSourceToAdd);
			}
		}
		
		override public function removeItem(dataSource:Object, dataSourceToRemove:Object):void 
		{
			var a:Array = dataSource["children"] as Array;
			
			if ( a )
			{
				var index:int = a.indexOf(dataSourceToRemove);
				if ( index >= 0 ) a.splice(index, 1);
			}
		}
		
		override public function removeItemAt(dataSource:Object, index:int):void 
		{
			var a:Array = dataSource["children"] as Array;
			
			if ( a )
			{
				a.splice(index, 1);
			}
		}
		
		override public function getNumChildren(dataSource:Object):uint 
		{
			var a:Array = dataSource["children"] as Array;
			if ( a ) return a.length;
			return 0;
		}
		
		override public function canContainChildren(dataSource:Object):Boolean 
		{
			return true;
		}
	}

}