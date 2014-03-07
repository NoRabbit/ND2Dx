package de.nulldesign.nd2dx.utils 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.fsm.FSMStateAction;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FSMTargetUtil 
	{
		public static function getTargetObject(target:Object, action:FSMStateAction):Object
		{
			if ( target is String )
			{
				return FSMTargetUtil.getTargetObjectByString(target as String, action);
			}
			else
			{
				return target;
			}
		}
		
		public static function getTargetObjectByString(target:String, action:FSMStateAction):Object
		{
			var finalObject:Object = action;
			
			var a:Array = target.split(".");
			if ( a.length == 0 ) a.push(target);
			
			var i:int = 0;
			var n:int = a.length;
			var currentTarget:String;
			
			for (; i < n; i++) 
			{
				currentTarget = a[i];
				
				switch (currentTarget) 
				{
					case "$this":
						finalObject = action;
						break;
						
					case "$state":
						finalObject = action.state;
						break;
						
					case "$fsm":
						finalObject = action.state.fsm;
						break;
						
					case "$node":
						finalObject = action.state.fsm.node;
						break;
						
					case "$world":
						finalObject = action.state.fsm.node.world;
						break;
						
					case "$scene":
						finalObject = action.state.fsm.node.scene;
						break;
						
					case "$camera":
						finalObject = action.state.fsm.node.camera;
						break;
						
					default:
						finalObject = finalObject[currentTarget];
				}
			}
			
			return finalObject;
		}
	}

}