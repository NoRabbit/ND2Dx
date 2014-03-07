package de.nulldesign.nd2dx.fsm 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSMEvent 
	{
		public static const EVENT_TYPE_STATE:int = 1;
		public static const EVENT_TYPE_FSM:int = 2;
		public static const EVENT_TYPE_ALL_FSMS_IN_NODE:int = 3;
		public static const EVENT_TYPE_GLOBAL:int = 4;
		
		public var name:String = "";
		public var type:int = EVENT_TYPE_STATE;
		
		public var action:FSMStateAction;
		
		public function FSMEvent(name:String = "", type:int = EVENT_TYPE_STATE) 
		{
			this.name = name;
			this.type = type;
		}
		
	}

}