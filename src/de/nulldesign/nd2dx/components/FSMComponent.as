package de.nulldesign.nd2dx.components 
{
	import de.nulldesign.nd2dx.fsm.FSM;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSMComponent extends ComponentBase
	{
		public var fsm:FSM;
		public var deactivateOnNodeRemovedFromStage:Boolean = true;
		
		public function FSMComponent() 
		{
			fsm = new FSM();
		}
		
		override public function onAddedToNode():void 
		{
			fsm.node = node;
		}
		
		override public function onNodeAddedToStage():void 
		{
			fsm.activate();
		}
		
		override public function onNodeRemovedFromStage():void 
		{
			if( deactivateOnNodeRemovedFromStage ) fsm.deactivate();
		}
		
		override public function step(elapsed:Number):void 
		{
			fsm.step(elapsed);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			if ( fsm ) fsm.dispose();
			fsm = null;
		}
	}

}