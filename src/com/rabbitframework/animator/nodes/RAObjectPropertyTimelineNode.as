package com.rabbitframework.animator.nodes 
{
	import com.bit101.components.WheelMenu;
	import com.rabbitframework.animator.panels.objectstimeline.Timeline;
	import com.rabbitframework.animator.style.RAStyle;
	import com.rabbitframework.animator.system.RASystemObjectProperty;
	import com.rabbitframework.animator.system.RASystemObjectPropertyKey;
	import com.rabbitframework.animator.ui.TimelineKey;
	import com.rabbitframework.managers.keyboard.KeyboardManager;
	import com.rabbitframework.utils.StageUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAObjectPropertyTimelineNode extends RANode
	{
		public var keyboardManager:KeyboardManager = KeyboardManager.getInstance();
		
		public var bg:Sprite;
		
		public var vTimelineKeys:Vector.<TimelineKey> = new Vector.<TimelineKey>();
		public var currentDraggingTimelineKey:TimelineKey;
		public var currentDraggingTimelineKeyTime:Number = 0.0;
		
		public var systemProperty:RASystemObjectProperty;
		
		public function RAObjectPropertyTimelineNode() 
		{
			
		}
		
		override public function draw():void 
		{
			super.draw();
			
			bg.width = RAStyle.TIMELINE_PANEL_WIDTH;
			bg.height = nodeHeight;
			
			var i:int = 0;
			var n:int = vTimelineKeys.length;
			var timelineKey:TimelineKey;
			
			//trace("draw", vTimelineKeys.length);
			
			for (; i < n; i++) 
			{
				timelineKey = vTimelineKeys[i];
				timelineKey.x = animatorManager.objectsTimelinePanel.timeline.currentStartX + (animatorManager.objectsTimelinePanel.timeline.currentTimeWidthForOneSecond * timelineKey.systemKey.time);
				timelineKey.y = 8.0;
				timelineKey.visible = true;
				if ( timelineKey.x + timelineKey.width < 0.0 ) timelineKey.visible = false;
				if ( timelineKey.x - timelineKey.width > animatorManager.objectsTimelinePanel.timeline.bg.width ) timelineKey.visible = false;
				
				if ( timelineKey.visible && timelineKey.parent != this )
				{
					addChild(timelineKey);
				}
				else if ( !timelineKey.visible && timelineKey.parent )
				{
					timelineKey.parent.removeChild(timelineKey);
				}
			}
		}
		
		public function setSystemProperty(systemProperty:RASystemObjectProperty):void
		{
			trace(this, "setSystemProperty", systemProperty);
			if ( this.systemProperty == systemProperty ) return;
			
			if ( this.systemProperty )
			{
				this.systemProperty.onKeyAdded.remove(systemProperty_onKeyAddedHandler);
			}
			
			this.systemProperty = systemProperty;
			systemProperty.onKeyAdded.add(systemProperty_onKeyAddedHandler);
			systemProperty.onKeyRemoved.add(systemProperty_onKeyRemovedHandler);
			syncTimelineKeysAndSystemKeys();
		}
		
		private function systemProperty_onKeyAddedHandler(systemKey:RASystemObjectPropertyKey):void 
		{
			trace("systemProperty_onKeyAddedHandler", systemKey);
			createTimelineKey(systemKey);
		}
		
		private function systemProperty_onKeyRemovedHandler(systemKey:RASystemObjectPropertyKey):void 
		{
			trace("systemProperty_onKeyRemovedHandler", systemKey);
			var i:int = 0;
			var n:int = vTimelineKeys.length;
			
			for (; i < n; i++) 
			{
				if ( vTimelineKeys[i].systemKey == systemKey )
				{
					removeTimelineKey(vTimelineKeys[i]);
					return;
				}
			}
		}
		
		public function syncTimelineKeysAndSystemKeys():void
		{
			trace("syncTimelineKeysAndSystemKeys", systemProperty);
			
			if ( !systemProperty ) return;
			
			var currentSystemKey:RASystemObjectPropertyKey = systemProperty.head;
			
			while ( currentSystemKey )
			{
				createTimelineKey(currentSystemKey);
				currentSystemKey = currentSystemKey.next;
			}
		}
		
		public function createTimelineKey(systemKey:RASystemObjectPropertyKey):TimelineKey
		{
			trace("createTimelineKey", systemKey);
			
			var i:int = 0;
			var n:int = vTimelineKeys.length;
			
			for (; i < n; i++) 
			{
				// if already exists, quit here
				if ( vTimelineKeys[i].systemKey == systemKey ) return null;
			}
			
			// ok, doesn't exist yet, create a TimelineKey
			var timelineKey:TimelineKey = new TimelineKey();
			timelineKey.systemKey = systemKey;
			
			initTimelineKey(timelineKey);
			
			draw();
			
			return timelineKey;
		}
		
		public function removeTimelineKey(timelineKey:TimelineKey):void
		{
			trace("removeTimelineKey", timelineKey);
			
			var index:int = vTimelineKeys.indexOf(timelineKey);
			if ( index >= 0 ) vTimelineKeys.splice(index, 1);
			if ( timelineKey.parent ) timelineKey.parent.removeChild(timelineKey);
			
			eManager.removeAllFromDispatcher(timelineKey);
			
			timelineKey.dispose();
		}
		
		public function initTimelineKey(timelineKey:TimelineKey):void
		{
			trace("initTimelineKey", timelineKey, vTimelineKeys.indexOf(timelineKey));
			if ( vTimelineKeys.indexOf(timelineKey) >= 0 ) return;
			
			vTimelineKeys.push(timelineKey);
			addChild(timelineKey);
			
			timelineKey.doubleClickEnabled = true;
			eManager.add(timelineKey, MouseEvent.DOUBLE_CLICK, timelineKey_doubleClickHandler, eventGroup);
			eManager.add(timelineKey, MouseEvent.CLICK, timelineKey_clickHandler, eventGroup);
			eManager.add(timelineKey, MouseEvent.MOUSE_DOWN, timelineKey_mouseDownHandler, [eventGroup, eventGroup + "timelineKeyDown"]);
		}
		
		private function timelineKey_mouseDownHandler(e:MouseEvent):void 
		{
			e.stopImmediatePropagation();
			e.stopPropagation();
			
			eManager.suspendAllFromGroup(eventGroup + "timelineKeyDown");
			
			var timelineKey:TimelineKey = e.currentTarget as TimelineKey;
			
			currentDraggingTimelineKey = timelineKey;
			
			eManager.add(stage, MouseEvent.MOUSE_MOVE, stage_mouseMoveHandler, [eventGroup, eventGroup + "stageUp"]);
			eManager.add(stage, MouseEvent.MOUSE_UP, stage_mouseUpHandler, [eventGroup, eventGroup + "stageUp"]);
		}
		
		private function stage_mouseMoveHandler(e:MouseEvent):void 
		{
			if ( currentDraggingTimelineKey )
			{
				currentDraggingTimelineKey.x = mouseX;
				
				if ( currentDraggingTimelineKey.x < animatorManager.objectsTimelinePanel.timeline.currentStartX )
				{
					currentDraggingTimelineKey.x = animatorManager.objectsTimelinePanel.timeline.currentStartX;
				}
				
				currentDraggingTimelineKeyTime = (currentDraggingTimelineKey.x - animatorManager.objectsTimelinePanel.timeline.currentStartX) / animatorManager.objectsTimelinePanel.timeline.currentTimeWidthForOneSecond;
				
				var snapCursor:Boolean = animatorManager.objectsTimelinePanel.snapCursor;
				var snapPrecision:Number = animatorManager.objectsTimelinePanel.snapPrecision;
				
				if ( snapCursor )
				{
					var rest:Number = currentDraggingTimelineKeyTime % snapPrecision;
					
					if ( rest > snapPrecision * 0.5 )
					{
						currentDraggingTimelineKeyTime = Math.round(currentDraggingTimelineKeyTime + (snapPrecision - rest));
					}
					else
					{
						currentDraggingTimelineKeyTime = Math.round(currentDraggingTimelineKeyTime - rest);
					}
				}
				
				currentDraggingTimelineKey.x = animatorManager.objectsTimelinePanel.timeline.currentStartX + (currentDraggingTimelineKeyTime * animatorManager.objectsTimelinePanel.timeline.currentTimeWidthForOneSecond);
			}
		}
		
		private function stage_mouseUpHandler(e:MouseEvent):void 
		{
			if ( currentDraggingTimelineKey )
			{
				currentDraggingTimelineKeyTime = (currentDraggingTimelineKey.x - animatorManager.objectsTimelinePanel.timeline.currentStartX) / animatorManager.objectsTimelinePanel.timeline.currentTimeWidthForOneSecond;
				trace("stage_mouseUpHandler", currentDraggingTimelineKeyTime, currentDraggingTimelineKey.systemKey);
				
				var propNode:RAObjectPropertyNode = refNode as RAObjectPropertyNode;
				propNode.systemProperty.changeKeyTime(currentDraggingTimelineKey.systemKey, currentDraggingTimelineKeyTime);
				propNode.systemProperty.debugKeys();
			}
			
			draw();
			
			systemProperty.getAndSetPropertyValueFromTime(animatorManager.objectsTimelinePanel.cursor.currentTime);
			
			currentDraggingTimelineKey = null;
			eManager.removeAllFromGroup(eventGroup + "stageUp");
			eManager.resumeAllFromGroup(eventGroup + "timelineKeyDown");
		}
		
		private function timelineKey_clickHandler(e:MouseEvent):void 
		{
			var timelineKey:TimelineKey = e.currentTarget as TimelineKey;
			
			trace("timelineKey_clickHandler", timelineKey);
			
			if ( keyboardManager.isKeyDown(Keyboard.CONTROL) || keyboardManager.isKeyDown(Keyboard.COMMAND) || e.ctrlKey )
			{
				var wheelMenu:WheelMenu = new WheelMenu(StageUtils.stage, 1, 80, 50, 20, wheelMenuHandler);
				wheelMenu.setItem(0, "Delete", { action:"delete", object:timelineKey } );
				wheelMenu.show();
				
				return;
			}
			//animatorManager.selectedTimelineKey = timelineKey;
		}
		
		private function wheelMenuHandler(e:Event):void 
		{
			var wheelMenu:WheelMenu = e.currentTarget as WheelMenu;
			
			switch (String(wheelMenu.selectedItem.action)) 
			{
				case "delete":
				{
					var timelineKey:TimelineKey = wheelMenu.selectedItem.object as TimelineKey;
					trace("delete", timelineKey);
					systemProperty.removeKey(timelineKey.systemKey);
					break;
				}
				
				default:
					break;
			}
			
			if ( wheelMenu.parent ) wheelMenu.parent.removeChild(wheelMenu);
		}
		
		private function timelineKey_doubleClickHandler(e:MouseEvent):void 
		{
			var timelineKey:TimelineKey = e.currentTarget as TimelineKey;
			animatorManager.setTimeCursorAt(timelineKey.systemKey.time);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			systemProperty = null;
		}
	}

}