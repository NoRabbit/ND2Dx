package com.rabbitframework.animator.ui 
{
	import com.bit101.components.List;
	import com.rabbitframework.managers.events.EventsManager;
	import com.rabbitframework.utils.DisplayObjectUtils;
	import com.rabbitframework.utils.StageUtils;
	import com.rabbitframework.utils.UniqueIdUtil;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.Keyboard;
	import flash.utils.getQualifiedClassName;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ListOptions extends List
	{
		public var eManager:EventsManager = EventsManager.getInstance();
		public var eventGroup:String = "";
		
		public function ListOptions() 
		{
			eventGroup = getQualifiedClassName(this) + "_" + UniqueIdUtil.getUniqueId(8);
		}
		
		public function show(callback:Function):void
		{
			StageUtils.stage.addChild(this);
			x = StageUtils.stage.mouseX;
			y = StageUtils.stage.mouseY;
			selectedItem = null;
			
			eManager.add(this, Event.SELECT, callback, eventGroup);
			eManager.add(this, Event.SELECT, this_selectHandler, eventGroup);
			eManager.add(StageUtils.stage, MouseEvent.MOUSE_DOWN, this_stageMouseDownHandler, eventGroup);
			eManager.add(StageUtils.stage, KeyboardEvent.KEY_DOWN, this_stageKeyDownHandler, eventGroup);
		}
		
		private function this_selectHandler(e:Event):void 
		{
			hide();
		}
		
		private function this_stageMouseDownHandler(e:MouseEvent):void 
		{
			if ( DisplayObjectUtils.isParentOf(e.currentTarget as DisplayObject, this) || DisplayObjectUtils.isParentOf(e.target as DisplayObject, this) ) return;
			hide();
		}
		
		private function this_stageKeyDownHandler(e:KeyboardEvent):void 
		{
			if ( e.keyCode == Keyboard.ESCAPE ) hide();
		}
		
		public function hide():void
		{
			eManager.removeAllFromGroup(eventGroup);
			if ( parent ) parent.removeChild(this);
		}
	}

}