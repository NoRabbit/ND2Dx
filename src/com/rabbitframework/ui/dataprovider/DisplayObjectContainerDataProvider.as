package com.rabbitframework.ui.dataprovider 
{
	import com.rabbitframework.ui.styles.UIStyles;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DisplayObjectContainerDataProvider extends DataProviderBase
	{
		
		public function DisplayObjectContainerDataProvider() 
		{
			
		}
		
		override public function getLabel(dataSource:Object):String 
		{
			var doc:DisplayObjectContainer = dataSource as DisplayObjectContainer;
			
			if ( doc )
			{
				return doc.name;
			}
			
			return "";
		}
		
		override public function getIcon(dataSource:Object):BitmapData 
		{
			return UIStyles.getBitmapDataForClassName("FolderIconBmp");
		}
		
		override public function getItemAt(dataSource:Object, index:uint):* 
		{
			var doc:DisplayObjectContainer = dataSource as DisplayObjectContainer;
			
			if ( doc && doc.numChildren > index )
			{
				return doc.getChildAt(index);
			}
			
			return null;
		}
		
		override public function getItemIndex(dataSource:Object, dataSourceToFind:Object):int 
		{
			var doc:DisplayObjectContainer = dataSource as DisplayObjectContainer;
			
			if ( doc )
			{
				return doc.getChildIndex(dataSourceToFind as DisplayObject);
			}
			
			return -1;
		}
		
		override public function addItem(dataSource:Object, dataSourceToAdd:Object):void 
		{
			var doc:DisplayObjectContainer = dataSource as DisplayObjectContainer;
			
			if ( doc )
			{
				doc.addChild(dataSourceToAdd as DisplayObject);
			}
		}
		
		override public function addItemAt(dataSource:Object, dataSourceToAdd:Object, index:int):void 
		{
			var doc:DisplayObjectContainer = dataSource as DisplayObjectContainer;
			
			if ( doc )
			{
				if ( index >= doc.numChildren ) index = doc.numChildren;
				if ( index < 0 ) index = 0;
				doc.addChildAt(dataSourceToAdd as DisplayObject, index);
			}
		}
		
		override public function removeItem(dataSource:Object, dataSourceToRemove:Object):void 
		{
			var doc:DisplayObjectContainer = dataSource as DisplayObjectContainer;
			
			if ( doc )
			{
				doc.removeChild(dataSourceToRemove as DisplayObject);
			}
		}
		
		override public function removeItemAt(dataSource:Object, index:int):void 
		{
			var doc:DisplayObjectContainer = dataSource as DisplayObjectContainer;
			
			if ( doc )
			{
				doc.removeChildAt(index);
			}
		}
		
		override public function getNumChildren(dataSource:Object):uint 
		{
			var doc:DisplayObjectContainer = dataSource as DisplayObjectContainer;
			
			if ( doc )
			{
				return doc.numChildren;
			}
			
			return 0;
		}
		
		override public function canContainChildren(dataSource:Object):Boolean 
		{
			return true;
		}
	}

}