package com.rabbitframework.managers.draganddrop {
	import com.rabbitframework.managers.events.EventsManager;
	import com.rabbitframework.utils.IDroppableOn;
	import com.rabbitframework.utils.StageUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class DragAndDropManager 
	{
		private static var instance:DragAndDropManager = new DragAndDropManager();
		
		public var eManager:EventsManager = EventsManager.getInstance();
		public var eGroup:String = "";
		
		public var dragAndDropObject:DragAndDropObject;
		public var currentDropOnObject:IDroppableOn;
		
		public function DragAndDropManager() 
		{
			if ( instance ) throw new Error( "DragAndDropManager can only be accessed through DragAndDropManager.getInstance()" );
			
			eGroup = eManager.getUniqueGroupId();
		}
		
		public static function getInstance():DragAndDropManager 
		{
			return instance;
		}
		
		public function startDrag(dragAndDropObject:DragAndDropObject):void
		{
			if ( this.dragAndDropObject ) stopDrag(true);
			if ( !dragAndDropObject ) return;
			
			this.dragAndDropObject = dragAndDropObject;
			currentDropOnObject = null;
			
			eManager.add(StageUtil.stage, Event.ENTER_FRAME, stage_enterFrameHandler, eGroup);
			eManager.add(StageUtil.stage, MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, eGroup);
			eManager.add(StageUtil.stage, MouseEvent.MOUSE_UP, stage_mouseUpHandler, eGroup);
		}
		
		private function stage_enterFrameHandler(e:Event):void 
		{
			//if ( draggedIcon )
			//{
				//draggedIcon.x = StageUtil.stage.mouseX + 20.0;
				//draggedIcon.y = StageUtil.stage.mouseY + 20.0;
			//}
		}
		
		private function stage_mouseMoveHandler(e:MouseEvent):void 
		{
			var droppableOnObject:IDroppableOn = getNearestDroppableOnInObject(e.target);
			
			if ( droppableOnObject )
			{
				if ( droppableOnObject != currentDropOnObject )
				{
					if ( currentDropOnObject ) currentDropOnObject.onDropOut(dragAndDropObject);
					currentDropOnObject = droppableOnObject;
					currentDropOnObject.onDropOver(dragAndDropObject);
				}
			}
			else if ( currentDropOnObject )
			{
				currentDropOnObject.onDropOut(dragAndDropObject);
				currentDropOnObject = null;
			}
		}
		
		private function stage_mouseUpHandler(e:MouseEvent):void 
		{
			stopDrag(false, e.target);
		}
		
		public function stopDrag(cancelDrop:Boolean = false, dropOnObject:Object = null):void
		{
			eManager.removeAllFromGroup(eGroup);
			
			if ( !cancelDrop && dropOnObject )
			{
				var droppableOnObject:IDroppableOn = getNearestDroppableOnInObject(dropOnObject);
				
				if ( droppableOnObject )
				{
					droppableOnObject.onDrop(dragAndDropObject);
				}
			}
			
			if ( currentDropOnObject ) currentDropOnObject.onDropOut(dragAndDropObject);
			
			dragAndDropObject = null;
			currentDropOnObject = null;
		}
		
		public function getNearestDroppableOnInObject(object:Object):IDroppableOn
		{
			if ( !object ) return null;
			if ( object is IDroppableOn ) return object as IDroppableOn;
			
			if ( object is DisplayObject )
			{
				var parent:DisplayObjectContainer = (object as DisplayObject).parent;
				var droppableOnObject:IDroppableOn;
				
				while (parent) 
				{
					droppableOnObject = parent as IDroppableOn;
					if ( droppableOnObject && droppableOnObject.isDroppableOn ) return droppableOnObject;
					parent = parent.parent;
				}
			}
			
			return null;
		}
	}
	
}