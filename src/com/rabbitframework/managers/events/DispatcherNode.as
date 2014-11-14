package com.rabbitframework.managers.events 
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	/**
	 * ...
	 * @author Thomas John (thomas.john@open-design.be)
	 */
	public class DispatcherNode 
	{
		private var eManager:EventsManager = EventsManager.getInstance();
		
		public var listener:Function = null;
		public var useCapture:Boolean = false;
		public var groups:Array = new Array();
		public var dispatcher:EventDispatcher = null;
		public var type:String = "";
		
		public function DispatcherNode(eventDispatcher:EventDispatcher, eventType:String, eventListener:Function, eventGroups:Array, autoStart:Boolean = true, autoAdd:Boolean = true, eventUseCapture:Boolean = false ) 
		{
			dispatcher = eventDispatcher;
			type = eventType;
			listener = eventListener;
			groups = eventGroups;
			useCapture = eventUseCapture;
			
			addToGroups(groups);
			if ( autoStart ) startEvent();
		}
		
		/**
		 * Start listening for event
		 */
		public function startEvent():void
		{
			dispatcher.addEventListener(type, listener, useCapture);
		}
		
		/**
		 * Stop listening for event
		 */
		public function stopEvent():void
		{
			dispatcher.removeEventListener(type, listener, useCapture);
		}
		
		/**
		 * Add this node to specified groups
		 * @param	eventGroups
		 */
		public function addToGroups(eventGroups:Array):void
		{
			var i:int = 0;
			var n:int = eventGroups.length;
			
			for (i = 0; i < n; i++) 
			{
				eManager.addNodeToGroup(this, eventGroups[i]);
			}
		}
		
		/**
		 * Remove node from specified groups.
		 * @param	removeFromAllGroups If set to true then this node will be removed from all its associated groups.
		 * @param	groupsToRemoveFrom If removeFromAllGroups is set to false then this node will be removed from specified groups in this array.
		 */
		public function removeFromGroups(removeFromAllGroups:Boolean = true, groupsToRemoveFrom:Array = null):void
		{
			var i:int = 0;
			var n:int = 0;
			
			if ( removeFromAllGroups )
			{
				n = groups.length;
				
				for (i = 0; i < n; i++) 
				{
					eManager.removeNodeFromGroup(this, groups[i]);
				}
			}
			else if( groupsToRemoveFrom != null )
			{
				n = groupsToRemoveFrom.length;
				
				for (i = 0; i < n; i++) 
				{
					eManager.removeNodeFromGroup(this, groupsToRemoveFrom[i]);
				}
			}
		}
	}
	
}