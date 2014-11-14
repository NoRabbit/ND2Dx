package com.rabbitframework.animator.panels.objectstimeline 
{
	import com.rabbitframework.animator.managers.AnimatorManager;
	import com.rabbitframework.animator.style.RAStyle;
	import com.rabbitframework.display.RabbitSprite;
	import com.rabbitframework.managers.keyboard.KeyboardManager;
	import com.rabbitframework.ui.movieclip.buttons.RabbitButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Timeline extends RabbitButton
	{
		public var animatorManager:AnimatorManager = AnimatorManager.getInstance();
		public var kbManager:KeyboardManager = KeyboardManager.getInstance();
		
		public var bg:Sprite;
		
		public var zoom:Number = 1.0;
		public var minZoom:Number = 0.02;
		public var maxZoom:Number = 2.0;
		public var timeWidthForOneSecond:Number = 80.0;
		public var currentTimeWidthForOneSecond:Number;
		
		public var vTimeObjects:Vector.<TimelineTime> = new Vector.<TimelineTime>();
		public var currentTimeIndex:int = 0;
		public var timesContainer:Sprite = new Sprite();
		public var minSpaceBetweenTimeObjects:Number = 16.0;
		
		public var startX:Number = 16.0;
		public var currentStartX:Number = 16.0;
		public var maxX:Number = 16.0;
		public var timeStep:Number = 0.5;
		public var currentStartTime:Number = 0.0;
		
		public var isShiftPressed:Boolean = false;
		public var startDragX:Number;
		public var startDragCurrentStartX:Number;
		public var startDragCurrentZoom:Number;
		public var startDragCurrentTimeWidthForOneSecond:Number;
		public var startDragCurrentTimeOnX:Number;
		
		public function Timeline() 
		{
			addChildAt(timesContainer, 1);
			timesContainer.visible = true;
			
			currentTimeWidthForOneSecond = timeWidthForOneSecond;
			
			eManager.add(this, MouseEvent.MOUSE_DOWN, this_mouseDownHandler, [eventGroup, eventGroup + ".mouseDown"]);
			mouseEnabled = true;
			
			eManager.add(kbManager, KeyboardEvent.KEY_DOWN , kbManager_keyDownHandler, [eventGroup, eventGroup + ".keyUpDown"]);
			eManager.add(kbManager, KeyboardEvent.KEY_UP, kbManager_keyUpHandler, [eventGroup, eventGroup + ".keyUpDown"]);
		}
		
		private function kbManager_keyUpHandler(e:KeyboardEvent):void 
		{
			checkPressedKeys();
		}
		
		private function kbManager_keyDownHandler(e:KeyboardEvent):void 
		{
			checkPressedKeys();
		}
		
		public function checkPressedKeys():void
		{
			if ( isOver )
			{
				if ( kbManager.isKeyDown(Keyboard.SPACE) )
				{
					buttonMode = true;
					
					if ( kbManager.isKeyDown(Keyboard.SHIFT) )
					{
						Mouse.cursor = MouseCursor.BUTTON;
					}
					else
					{
						
						Mouse.cursor = MouseCursor.HAND;
					}
				}
				else
				{
					buttonMode = false;
					Mouse.cursor = MouseCursor.AUTO;
				}
			}
			else
			{
				buttonMode = false;
				Mouse.cursor = MouseCursor.AUTO;
			}
		}
		
		override public function _onRollOver(e:MouseEvent):void 
		{
			super._onRollOver(e);
			checkPressedKeys();
		}
		
		override public function _onRollOut(e:MouseEvent):void 
		{
			super._onRollOut(e);
			checkPressedKeys();
		}
		
		private function this_mouseDownHandler(e:MouseEvent):void 
		{
			if ( !kbManager.isKeyDown(Keyboard.SPACE) )
			{
				animatorManager.objectsTimelinePanel.cursor.currentTime = (this.mouseX - currentStartX) / currentTimeWidthForOneSecond;
				animatorManager.objectsTimelinePanel.draw();
				return;
			}
			
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			isShiftPressed = e.shiftKey;
			startDragX = this.mouseX;
			startDragCurrentStartX = currentStartX;
			startDragCurrentZoom = zoom;
			startDragCurrentTimeWidthForOneSecond = currentTimeWidthForOneSecond;
			
			startDragCurrentTimeOnX = (startDragX - currentStartX);
			startDragCurrentTimeOnX = startDragCurrentTimeOnX / currentTimeWidthForOneSecond;
			
			eManager.suspendAllFromGroup(eventGroup + ".mouseDown");
			eManager.add(this, Event.ENTER_FRAME, this_enterFrameHandler, [eventGroup, eventGroup + ".efMouseUp"]);
			eManager.add(this.stage, MouseEvent.MOUSE_UP, stage_mouseUpHandler, [eventGroup, eventGroup + ".efMouseUp"]);
		}
		
		private function stage_mouseUpHandler(e:MouseEvent):void 
		{
			eManager.suspendAllFromGroup(eventGroup + ".efMouseUp");
			eManager.resumeAllFromGroup(eventGroup + ".mouseDown");
		}
		
		private function this_enterFrameHandler(e:Event):void 
		{
			if ( isShiftPressed )
			{
				zoom = startDragCurrentZoom - ((startDragX - this.mouseX) / startDragCurrentTimeWidthForOneSecond);
				//trace("this_enterFrameHandler", zoom, minZoom, maxZoom, startDragCurrentZoom);
				if ( zoom > maxZoom ) zoom = maxZoom;
				if ( zoom < minZoom ) zoom = minZoom;
				currentTimeWidthForOneSecond = timeWidthForOneSecond * zoom;
				currentStartX = startDragX - (startDragCurrentTimeOnX * currentTimeWidthForOneSecond);
				if ( currentStartX > maxX ) currentStartX = maxX;
				
			}
			else
			{
				currentStartX = startDragCurrentStartX - (startDragX - this.mouseX);
				if ( currentStartX > maxX ) currentStartX = maxX;
			}
			
			animatorManager.objectsTimelinePanel.draw();
		}
		
		public function draw():void
		{
			bg.width = RAStyle.TIMELINE_PANEL_WIDTH;
			
			currentTimeWidthForOneSecond = timeWidthForOneSecond * zoom;
			
			var currentTotalWidth:Number = bg.width - currentStartX;
			if ( currentTotalWidth > bg.width ) currentTotalWidth = bg.width;
			
			var startTime:Number = Math.floor(Math.abs((currentStartX - startX) / currentTimeWidthForOneSecond));
			var endTime:Number = Math.ceil((currentTotalWidth - (currentStartX - startX)) / currentTimeWidthForOneSecond);
			
			//trace(startTime, endTime, currentTotalWidth, currentTimeWidthForOneSecond);
			
			var currentTotalTime:Number = endTime - startTime;
			var currentTotalTimeWidth:Number = currentTotalTime * currentTimeWidthForOneSecond;
			var widthForASecond:Number = currentTotalTimeWidth / (endTime - startTime);
			var itemsPerWidthForASecond:int = Math.floor(widthForASecond / minSpaceBetweenTimeObjects);
			
			var timeWidth:Number = currentTotalWidth / (currentTimeWidthForOneSecond * timeStep);
			//var timeWidth:Number = currentTotalWidth / minSpaceBetweenTimeObjects;
			//var itemsToShow:int = Math.ceil(timeWidth) + 2;
			//var itemsToShow:int = (endTime - startTime) + 1;
			//itemsToShow += (endTime - startTime) * itemsPerWidthForASecond;
			
			//populateTimeObjects(itemsToShow + 3);
			//populateTimeObjects(itemsToShow);
			currentTimeIndex = 0;
			
			currentStartTime = -(currentStartX - startX) / currentTimeWidthForOneSecond;
			currentStartTime -= (currentStartTime % timeStep);
			
			var i:int = startTime;
			var iStep:int = 1;
			//var n:int = itemsToShow;
			var n:int = endTime;
			var time:TimelineTime;
			//var objectTimeStep:Number = (currentTotalWidth * currentTimeWidthForOneSecond) / itemsToShow;
			
			while ( (iStep * currentTimeWidthForOneSecond) < minSpaceBetweenTimeObjects )
			{
				iStep *= 2;
			}
			
			//trace("###################### DRAW", i, n, iStep, vTimeObjects.length);
			
			for (; i <= n; i+=iStep) 
			{
				//time = getTimeObject(currentStartTime + (i * timeStep), i);
				//time = getTimeObject(currentStartTime + (i * objectTimeStep), i);
				//time = getTimeObject(i, i + 1);
				//trace("DRAW", i, n);
				time = getTimeObject(i);
				if( i < n ) setTimeObjectsForPeriod(i, i + 1);
			}
			
			hideUnusedTimeObjects();
			
			//trace("###################### END DRAW");
		}
		
		public function setTimeObjectsForPeriod(startTime:Number, endTime:Number):void
		{
			var time:TimelineTime;
			
			var currentWidth:Number = (endTime - startTime) * currentTimeWidthForOneSecond;
			var stepWidth:Number = currentWidth * 0.5;
			
			//trace("setTimeObjectsForPeriod", startTime, endTime, currentWidth, stepWidth, minSpaceBetweenTimeObjects);
			
			if ( stepWidth >= minSpaceBetweenTimeObjects )
			{
				var stepTime:Number = (stepWidth / currentTimeWidthForOneSecond);
				var time:TimelineTime = getTimeObject(startTime + stepTime);
				setTimeObjectsForPeriod(startTime, startTime + stepTime);
				setTimeObjectsForPeriod(startTime + stepTime, endTime);
			}
		}
		
		public function populateTimeObjects(count:int):void
		{
			if ( vTimeObjects.length < count )
			{
				var i:int = 0;
				var n:int = count - vTimeObjects.length;
				var time:TimelineTime;
				
				for (; i < n; i++) 
				{
					time = new TimelineTime();
					time.mouseChildren = time.mouseEnabled = false;
					vTimeObjects.push(time);
					timesContainer.addChild(time);
				}
			}
		}
		
		public function getTimeObject(t:Number):TimelineTime
		{
			var time:TimelineTime;
			
			if ( currentTimeIndex >= vTimeObjects.length )
			{
				time = new TimelineTime();
				time.mouseChildren = time.mouseEnabled = false;
				vTimeObjects.push(time);
				timesContainer.addChild(time);
			}
			else
			{
				time = vTimeObjects[currentTimeIndex];
			}
			
			
			
			time.txt.text = t.toString();
			time.x = currentStartX + (currentTimeWidthForOneSecond * t);
			time.y = 24.0;
			time.visible = true;
			
			//trace("getTimeObject", t, time.x);
			
			time.alpha = 1.0;
			
			
			if ( t == Math.round(t) )
			{
				time.alpha = 1.0;
			}
			else
			{
				//if ( zoom < 0.5 )
				//{
					//time.alpha = 0.0;
				//}
				//else
				//{
					time.alpha = 0.5;
				//}
			}
			
			
			time.visible = true;
			if ( t < 0 ) time.visible = false;
			if ( time.x + time.width < 0.0 ) time.visible = false;
			if ( time.x - time.width > bg.width ) time.visible = false;
			
			if ( time.visible && time.parent != timesContainer )
			{
				timesContainer.addChild(time);
			}
			else if ( !time.visible && time.parent )
			{
				time.parent.removeChild(time);
			}
			
			currentTimeIndex++;
			return time;
		}
		
		public function hideUnusedTimeObjects():void
		{
			var i:int = currentTimeIndex;
			var n:int = vTimeObjects.length;
			var time:TimelineTime;
			
			for (; i < n; i++) 
			{
				time = vTimeObjects[i];
				time.visible = false;
				
				if ( time.parent )
				{
					time.parent.removeChild(time);
				}
			}
		}
	}

}