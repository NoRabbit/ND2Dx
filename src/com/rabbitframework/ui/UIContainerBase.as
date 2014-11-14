package com.rabbitframework.ui 
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIContainerBase extends UIBase
	{
		public var vItems:Vector.<UIBase> = new Vector.<UIBase>();
		public var itemsContainer:DisplayObjectContainer;
		
		public function UIContainerBase() 
		{
			if( !itemsContainer ) itemsContainer = this;
		}
		
		public function addItem(item:UIBase, callDraw:Boolean = true):UIBase
		{
			if ( vItems.indexOf(item) < 0 )
			{
				addItemAt(item, vItems.length, callDraw);
			}
			
			return item;
		}
		
		public function addItemBefore(item:UIBase, before:UIBase, callDraw:Boolean = true):UIBase
		{
			if ( vItems.indexOf(item) < 0 )
			{
				var index:int = vItems.indexOf(before);
				
				if ( index >= 0 )
				{
					addItemAt(item, index, callDraw);
				}
			}
			
			return item;
		}
		
		public function addItemAfter(item:UIBase, after:UIBase, callDraw:Boolean = true):UIBase
		{
			if ( vItems.indexOf(item) < 0 )
			{
				var index:int = vItems.indexOf(after);
				
				if ( index >= 0 )
				{
					addItemAt(item, index + 1, callDraw);
				}
			}
			
			return item;
		}
		
		public function addItemAt(item:UIBase, index:int, callDraw:Boolean = true):UIBase
		{
			if ( index > vItems.length ) index = vItems.length;
			if ( index < 0 ) index = 0;
			vItems.splice(index, 0, item);
			itemsContainer.addChild(item);
			item.uiParent = this;
			if( callDraw ) draw();
			return item;
		}
		
		public function removeItem(item:UIBase, callDraw:Boolean = true):UIBase
		{
			var index:int = vItems.indexOf(item);
			
			if ( index >= 0 )
			{
				removeItemAt(index, callDraw);
			}
			
			return item;
		}
		
		public function removeItemAt(index:int, callDraw:Boolean = true):UIBase
		{
			var item:UIBase = vItems[index];
			vItems.splice(index, 1);
			if( item.parent == itemsContainer ) itemsContainer.removeChild(item);
			item.uiParent = null;
			if ( callDraw ) draw();
			return item;
		}
		
		public function removeAllItems(callDraw:Boolean = true, vItemsToAvoid:Vector.<UIBase> = null):void
		{
			var vItemsToRemove:Vector.<UIBase> = new Vector.<UIBase>();
			
			var i:int = 0;
			var n:int = vItems.length;
			
			for (; i < n; i++) 
			{
				if ( vItemsToAvoid && vItemsToAvoid.indexOf(vItems[i]) >= 0 ) continue;
				vItemsToRemove.push(vItems[i]);
			}
			
			i = 0;
			n = vItemsToRemove.length;
			
			for (; i < n; i++) 
			{
				removeItem(vItemsToRemove[i], false);
			}
			
			if ( callDraw ) draw();
		}
		
		public function getItemIndex(item:UIBase):int
		{
			return vItems.indexOf(item);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			while ( numItems )
			{
				removeItemAt(0);
			}
			
			vItems = null;
		}
		
		public function get numItems():int 
		{
			return vItems.length;
		}
	}

}