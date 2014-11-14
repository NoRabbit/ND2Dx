package com.rabbitframework.ui.groups 
{
	import com.rabbitframework.managers.pool.Pool;
	import com.rabbitframework.managers.pool.PoolManager;
	import com.rabbitframework.ui.button.ButtonDrag;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainerBase;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class HGroupExtended extends UIGroupBase
	{
		private var separatorsPool:Pool = PoolManager.getInstance().getPoolForClass(VDraggableSeparator, 10);
		
		private var highestHeight:Number = 0.0;
		
		private var vTemporaryFixedItems:Vector.<UIBase> = new Vector.<UIBase>();
		
		private var vSeparators:Vector.<DraggableSeparatorBase> = new Vector.<DraggableSeparatorBase>();
		private var pStartDragPosition:Point = new Point();
		private var itemBeforeDrag:UIBase;
		private var itemAfterDrag:UIBase;
		private var itemBeforeDragSize:Number;
		private var itemAfterDragSize:Number;
		private var itemBeforeDragPosition:Number;
		private var itemAfterDragPosition:Number;
		
		public function HGroupExtended() 
		{
			spaceSize = 8.0;
		}
		
		override public function draw():void 
		{
			releaseSeparators();
			
			if ( vItems.length <= 0 ) return;
			
			highestHeight = uiHeight;
			
			var separatorsTotalSize:Number = (vItems.length > 1 ? vItems.length - 1 : 0) * spaceSize;
			var availableSize:Number = uiWidth - separatorsTotalSize;
			
			// first pass
			resizeItems(availableSize);
			
			// second pass
			var i:int = 0;
			var n:int = vItems.length;
			var item:UIBase;
			var prevItem:UIBase;
			var separator:DraggableSeparatorBase;
			var finalSize:Number = 0.0;
			var currentPosition:Number = 0.0;
			
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				if ( prevItem )
				{
					separator = getSeparator();
					separator.itemBefore = prevItem;
					separator.itemAfter = item;
					addChild(separator);
					separator.x = currentPosition;
					separator.y = 0.0;
					separator.setSize(spaceSize, highestHeight);
					currentPosition += spaceSize;
				}
				
				item.x = currentPosition;
				item.y = 0.0;
				
				if ( vTemporaryFixedItems.indexOf(item) >= 0 )
				{
					item.setSize(item.minUIWidth, highestHeight);
				}
				else
				{
					item.setSize(availableSize * getPercentForItem(item), highestHeight);
				}
				
				finalSize += item.uiWidth;
				currentPosition += item.uiWidth;
				
				prevItem = item;
			}
			
			
			
			// third pass (set final prct for each item)
			i = 0;
			
			for (; i < n; i++) 
			{
				item = vItems[i];
				setPercentForItem(item, item.uiWidth / finalSize);
			}
			
			uiWidth = finalSize + separatorsTotalSize;
			uiHeight = highestHeight;
			
			// empty temporary list
			if ( vTemporaryFixedItems.length ) vTemporaryFixedItems.splice(0, vTemporaryFixedItems.length);
			
			iniSeparators();
			//debugItemsPercent();
		}
		
		private function resizeItems(availableSize:Number):void
		{
			var i:int = 0;
			var n:int = vItems.length;
			var item:UIBase;
			var sizeToSet:Number;
			
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				if ( vTemporaryFixedItems.indexOf(item) >= 0 ) continue;
				
				if ( item.minUIHeight > highestHeight ) highestHeight = item.minUIHeight;
				
				sizeToSet = availableSize * getPercentForItem(item);
				
				if ( sizeToSet < item.minUIWidth )
				{
					setPercentForItem(item, item.minUIWidth / availableSize, true, vTemporaryFixedItems);
					vTemporaryFixedItems.push(item);
					resizeItems(availableSize);
					return;
				}
			}
		}
		
		private function getSeparator():DraggableSeparatorBase
		{
			var separator:DraggableSeparatorBase = separatorsPool.getObject() as DraggableSeparatorBase;
			vSeparators.push(separator);
			return separator;
		}
		
		private function releaseSeparators():void
		{
			while (vSeparators.length)
			{
				separatorsPool.releaseObject(vSeparators.pop());
			}
		}
		
		private function iniSeparators():void
		{
			var i:int = 0;
			var n:int = vSeparators.length;
			var separator:DraggableSeparatorBase;
			
			for (; i < n; i++) 
			{
				separator = vSeparators[i];
				
				separator.rectDrag.x = separator.itemBefore.x + separator.itemBefore.minUIWidth;
				separator.rectDrag.y = 0;
				separator.rectDrag.width = separator.itemAfter.x + separator.itemAfter.uiWidth - separator.itemAfter.minUIWidth - spaceSize - separator.rectDrag.x;
				separator.rectDrag.height = 0;
				
				separator.onStartDrag.addOnce(onStartDragHandler);
				separator.onStopDrag.addOnce(onStopDragHandler);
			}
		}
		
		private function onStartDragHandler(item:ButtonDrag):void 
		{
			var separator:DraggableSeparatorBase = item as DraggableSeparatorBase;
			
			itemBeforeDrag = separator.itemBefore;
			itemAfterDrag = separator.itemAfter;
			
			itemBeforeDragSize = itemBeforeDrag.uiWidth;
			itemAfterDragSize = itemAfterDrag.uiWidth;
			
			itemBeforeDragPosition = itemBeforeDrag.x;
			itemAfterDragPosition = itemAfterDrag.x;
			
			pStartDragPosition.x = stage.mouseX;
			pStartDragPosition.y = stage.mouseY;
			
			eManager.add(stage, Event.ENTER_FRAME, onStageEnterFrameHandler, [eGroup, eGroup + ".drag"]);
		}
		
		private function onStageEnterFrameHandler(e:Event):void 
		{
			var distance:Number = stage.mouseX - pStartDragPosition.x;
			
			if ( distance != 0.0 )
			{
				if ( itemBeforeDragSize + distance < itemBeforeDrag.minUIWidth ) distance = itemBeforeDrag.minUIWidth - itemBeforeDragSize;
				if ( itemAfterDragSize - distance < itemAfterDrag.minUIWidth ) distance = itemAfterDragSize - itemAfterDrag.minUIWidth;
				
				itemBeforeDrag.setSize(itemBeforeDragSize + distance, itemBeforeDrag.uiHeight);
				itemAfterDrag.setSize(itemAfterDragSize - distance, itemAfterDrag.uiHeight);
				itemAfterDrag.x = itemAfterDragPosition + distance;
				
				var separatorsTotalSize:Number = (vItems.length > 1 ? vItems.length - 1 : 0) * spaceSize;
				var uiWidthMinusSeparators:Number = uiWidth - separatorsTotalSize;
				setPercentForItem(itemBeforeDrag, itemBeforeDrag.uiWidth / uiWidthMinusSeparators);
				setPercentForItem(itemAfterDrag, itemAfterDrag.uiWidth / uiWidthMinusSeparators);
			}
		}
		
		private function onStopDragHandler(separator:ButtonDrag):void 
		{
			eManager.removeAllFromGroup(eGroup + ".drag");
			draw();
		}
	}

}