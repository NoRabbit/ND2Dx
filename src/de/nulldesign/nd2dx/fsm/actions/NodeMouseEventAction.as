package de.nulldesign.nd2dx.fsm.actions 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.fsm.FSMStateAction;
	import de.nulldesign.nd2dx.fsm.FSMEvent;
	import de.nulldesign.nd2dx.utils.FSMTargetUtil;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class NodeMouseEventAction extends FSMStateAction
	{
		public var target:Object;
		public var eventType:String;
		
		public var sendEvent:FSMEvent;
		
		private var targetNode:Node2D;
		
		public function NodeMouseEventAction(eventType:String = "", target:Object = null, sendEvent:FSMEvent = null) 
		{
			// no need to step
			type = FSMStateAction.ACTION_TYPE_NO_STEP;
			
			this.eventType = eventType;
			this.target = target;
			this.sendEvent = sendEvent;
		}
		
		override public function onActivate():void 
		{
			targetNode = FSMTargetUtil.getTargetObject(target, this) as Node2D;
			if( targetNode ) targetNode.onMouseEvent.add(onMouseEventHandler);
		}
		
		private function onMouseEventHandler(type:String, node2D:Node2D, event:MouseEvent):void 
		{
			if ( type == eventType )
			{
				if ( sendEvent ) dispatchEvent(sendEvent);
			}
		}
		
		override public function onDeactivate():void 
		{
			targetNode.onMouseEvent.remove(onMouseEventHandler);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			targetNode.onMouseEvent.remove(onMouseEventHandler);
			
			target = null;
			targetNode = null;
			sendEvent = null;
			eventType = "";
		}
	}

}