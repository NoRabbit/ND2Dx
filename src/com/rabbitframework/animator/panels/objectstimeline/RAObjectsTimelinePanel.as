package com.rabbitframework.animator.panels.objectstimeline 
{
	import com.rabbitframework.animator.panels.RAPanel;
	import com.rabbitframework.utils.MathUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAObjectsTimelinePanel extends RAPanel
	{
		public var timeline:Timeline;
		public var cursor:TimelineCursor;
		public var cursorLine:Sprite;
		
		public var cursorStartDragX:Number = 0.0;
		public var mouseStartDragX:Number = 0.0;
		
		public var snapCursor:Boolean = true;
		public var snapPrecision:Number = 1.0;
		
		public function RAObjectsTimelinePanel() 
		{
			super();
			
			animatorManager.objectsTimelinePanel = this;
			
			childrenContainer = new Sprite();
			childrenContainer.y = 28;
			addChildAt(childrenContainer, 0);
			
			cursorLine.mouseEnabled = cursorLine.mouseChildren = false;
			
			eManager.add(cursor, MouseEvent.MOUSE_DOWN, cursor_mouseDownHandler, [eventGroup, eventGroup + ".cursorMouseDown"]);
		}
		
		private function cursor_mouseDownHandler(e:MouseEvent):void 
		{
			eManager.suspendAllFromGroup(eventGroup + ".cursorMouseDown");
			
			mouseStartDragX = this.mouseX;
			cursorStartDragX = cursor.x;
			
			eManager.add(cursor, Event.ENTER_FRAME, cursor_enterFrameHandler, [eventGroup, eventGroup + ".cursorEfMouseUp"]);
			eManager.add(cursor.stage, MouseEvent.MOUSE_UP, cursorStage_mouseUpHandler, [eventGroup, eventGroup + ".cursorEfMouseUp"]);
		}
		
		private function cursor_enterFrameHandler(e:Event):void 
		{
			//cursor.x = cursorStartDragX - (mouseStartDragX - this.mouseX);
			//cursor.currentTime = (cursor.x - timeline.currentStartX) / timeline.currentTimeWidthForOneSecond;
			cursor.currentTime = (mouseX - timeline.currentStartX) / timeline.currentTimeWidthForOneSecond;
			
			if ( cursor.currentTime <= 0 ) cursor.currentTime = 0.0;
			
			if ( snapCursor )
			{
				//var rest:Number = MathUtils.roundTo(cursor.currentTime % snapPrecision, 12);
				var rest:Number = cursor.currentTime % snapPrecision;
				
				//trace(cursor.currentTime, rest);
				
				if ( rest > snapPrecision * 0.5 )
				{
					cursor.currentTime = Math.round(cursor.currentTime + (snapPrecision - rest));
				}
				else
				{
					cursor.currentTime = Math.round(cursor.currentTime - rest);
				}
			}
			
			updateCursor();
		}
		
		private function cursorStage_mouseUpHandler(e:MouseEvent):void 
		{
			eManager.removeAllFromGroup(eventGroup + ".cursorEfMouseUp");
			eManager.resumeAllFromGroup(eventGroup + ".cursorMouseDown");
		}
		
		override public function draw():void 
		{
			timeline.draw();
			
			super.draw();
			
			updateCursor();
		}
		
		public function updateCursor():void
		{
			cursor.x = timeline.currentStartX + (cursor.currentTime * timeline.currentTimeWidthForOneSecond);
			cursorLine.x = cursor.x;
			cursorLine.y = cursor.y + cursor.height - 4.0;
			cursorLine.height = nodeTotalHeight + 28 - cursorLine.y;
		}
	}

}