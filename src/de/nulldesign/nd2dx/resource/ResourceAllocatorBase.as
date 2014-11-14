package de.nulldesign.nd2dx.resource 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.events.EventsManager;
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import flash.display3D.Context3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ResourceAllocatorBase 
	{
		public var eManager:EventsManager = EventsManager.getInstance();
		public var eGroup:String;
		
		public var resourceManager:ResourceManager = ResourceManager.getInstance();
		
		private var _resource:ResourceBase;
		
		public var filePath:String = "";
		public var relativeFilePath:String = "";
		
		public var isExternalLoader:Boolean = false;
		
		public var freeLocalResourceAfterAllocated:Boolean = false;
		
		public function ResourceAllocatorBase(freeLocalResourceAfterAllocated:Boolean = false) 
		{
			eGroup = eManager.getUniqueGroupId();
			this.freeLocalResourceAfterAllocated = freeLocalResourceAfterAllocated;
		}
		
		public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void
		{
			
		}
		
		public function allocateRemoteResource(context:Context3D, forceAllocation:Boolean = false):void
		{
			
		}
		
		public function freeLocalResource():void
		{
			
		}
		
		public function freeRemoteResource():void
		{
			
		}
		
		public function get resource():ResourceBase 
		{
			return _resource;
		}
		
		public function set resource(value:ResourceBase):void 
		{
			_resource = value;
		}
	}

}