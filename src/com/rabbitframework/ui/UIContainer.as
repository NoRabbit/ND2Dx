package com.rabbitframework.ui 
{
	import com.rabbitframework.ui.layout.UILayoutBase;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIContainer extends UIBase
	{
		public var vItems:Vector.<UIBase> = new Vector.<UIBase>();
		public var itemsContainer:DisplayObjectContainer;
		
		protected var _layout:UILayoutBase;
		
		protected var _itemSpace:Number = 4.0;
		protected var _hideChildren:Boolean = false;
		protected var _roundPositionValues:Boolean = true;
		
		protected var _extendUIWidthToTotalItemsWidth:Boolean = true;
		protected var _extendUIHeightToTotalItemsHeight:Boolean = true;
		
		protected var preventDisposingChildrenOnDisposeForPool:Boolean = false;
		
		public function UIContainer() 
		{
			if ( !itemsContainer ) itemsContainer = this;
			super();
		}
		
		override public function draw():void 
		{
			var i:int = 0;
			var n:int = vItems.length;
			
			for (; i < n; i++) 
			{
				if ( _hideChildren )
				{
					vItems[i].visible = false;
				}
				else
				{
					vItems[i].visible = true;
				}
			}
			
			if ( !_hideChildren )
			{
				if ( _layout ) _layout.positionItems(this);
			}
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
		
		public function getItemAt(index:int):UIBase
		{
			if ( index < 0 ) return null;
			if ( index >= vItems.length ) return null;
			return vItems[index];
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			
			_extendUIHeightToTotalItemsHeight = false;
			_extendUIWidthToTotalItemsWidth = false;
			
			if ( !preventDisposingChildrenOnDisposeForPool )
			{
				while ( numItems )
				{
					poolManager.releaseObject(getItemAt(0));
					removeItemAt(0, false);
				}
				
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			removeAllItems(false);
			
			vItems = null;
		}
		
		public function get numItems():int 
		{
			return vItems.length;
		}
		
		public function get layout():UILayoutBase 
		{
			return _layout;
		}
		
		public function set layout(value:UILayoutBase):void 
		{
			_layout = value;
			draw();
		}
		
		public function get itemSpace():Number 
		{
			return _itemSpace;
		}
		
		public function set itemSpace(value:Number):void 
		{
			if ( _itemSpace == value ) return;
			_itemSpace = value;
			draw();
		}
		
		public function get hideChildren():Boolean 
		{
			return _hideChildren;
		}
		
		public function set hideChildren(value:Boolean):void 
		{
			if ( _hideChildren == value ) return;
			_hideChildren = value;
			draw();
		}
		
		public function get roundPositionValues():Boolean 
		{
			return _roundPositionValues;
		}
		
		public function set roundPositionValues(value:Boolean):void 
		{
			if ( _roundPositionValues == value ) return;
			_roundPositionValues = value;
			draw();
		}
		
		public function get extendUIWidthToTotalItemsWidth():Boolean 
		{
			return _extendUIWidthToTotalItemsWidth;
		}
		
		public function set extendUIWidthToTotalItemsWidth(value:Boolean):void 
		{
			if ( _extendUIWidthToTotalItemsWidth == value ) return;
			_extendUIWidthToTotalItemsWidth = value;
			draw();
		}
		
		public function get extendUIHeightToTotalItemsHeight():Boolean 
		{
			return _extendUIHeightToTotalItemsHeight;
		}
		
		public function set extendUIHeightToTotalItemsHeight(value:Boolean):void 
		{
			if ( _extendUIHeightToTotalItemsHeight == value ) return;
			_extendUIHeightToTotalItemsHeight = value;
			draw();
		}
	}

}