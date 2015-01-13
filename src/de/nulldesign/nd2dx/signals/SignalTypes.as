package de.nulldesign.nd2dx.signals
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class SignalTypes 
	{
		public static const SCENE_CHANGED:String = "SCENE_CHANGED";
		public static const COMPONENT_ADDED_TO_NODE:String = "COMPONENT_ADDED_TO_NODE";
		public static const COMPONENT_REMOVED_FROM_NODE:String = "COMPONENT_REMOVED_FROM_NODE";
		
		public static const RESOURCE_LOCALLY_ALLOCATED:String = "RESOURCE_LOCALLY_ALLOCATED";
		public static const RESOURCE_REMOTELY_ALLOCATED:String = "RESOURCE_REMOTELY_ALLOCATED";
		
		public static const RESOURCE_LOCAL_ALLOCATION_ERROR:String = "RESOURCE_LOCAL_ALLOCATION_ERROR";
		public static const RESOURCE_REMOTE_ALLOCATION_ERROR:String = "RESOURCE_REMOTE_ALLOCATION_ERROR";
		
		public static const RESOURCE_LOCALLY_DEALLOCATED:String = "RESOURCE_LOCALLY_DEALLOCATED";
		public static const RESOURCE_REMOTELY_DEALLOCATED:String = "RESOURCE_REMOTELY_DEALLOCATED";
		
		public static const RESOURCE_ALLOCATING:String = "RESOURCE_ALLOCATING";
		public static const RESOURCE_UPDATED:String = "RESOURCE_ALLOCATING";
		
		public static const OPEN:String = "OPEN";
		public static const CLOSE:String = "CLOSE";
		public static const COMPLETE:String = "COMPLETE";
		public static const PROGRESS:String = "PROGRESS";
		public static const ERROR:String = "ERROR";
		public static const CANCEL:String = "CANCEL";
	}

}