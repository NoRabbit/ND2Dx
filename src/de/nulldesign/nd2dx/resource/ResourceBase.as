package de.nulldesign.nd2dx.resource 
{
	import com.rabbitframework.signals.RabbitSignal;
	import com.rabbitframework.utils.IDisposable;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ResourceBase implements IDisposable
	{
		private var _resourceId:String = "";
		private var _resourceName:String = "";
		private var _allocator:ResourceAllocatorBase;
		
		public var isCore:Boolean = false;
		
		public var isAllocating:Boolean = false;
		public var isLocallyAllocated:Boolean = false;
		public var isRemotellyAllocated:Boolean = false;
		
		//public var onLocallyAllocated:Signal = new Signal();
		//public var onLocallyDeallocated:Signal = new Signal();
		//public var onLocalAllocationError:Signal = new Signal();
		//public var onRemotelyAllocated:Signal = new Signal();
		//public var onRemotelyDeallocated:Signal = new Signal();
		//public var onRemoteAllocationError:Signal = new Signal();
		
		public var onLocallyAllocated:RabbitSignal = new RabbitSignal();
		public var onLocallyDeallocated:RabbitSignal = new RabbitSignal();
		public var onLocalAllocationError:RabbitSignal = new RabbitSignal();
		public var onRemotelyAllocated:RabbitSignal = new RabbitSignal();
		public var onRemotelyDeallocated:RabbitSignal = new RabbitSignal();
		public var onRemoteAllocationError:RabbitSignal = new RabbitSignal();
		
		public function ResourceBase(allocator:ResourceAllocatorBase) 
		{
			this.allocator = allocator;
		}
		
		public function get allocator():ResourceAllocatorBase 
		{
			return _allocator;
		}
		
		public function set allocator(value:ResourceAllocatorBase):void 
		{
			_allocator = value;
			if ( _allocator ) _allocator.resource = this;
		}
		
		public function get resourceId():String 
		{
			return _resourceId;
		}
		
		public function set resourceId(value:String):void 
		{
			_resourceId = value;
		}
		
		public function get resourceName():String 
		{
			return _resourceName;
		}
		
		public function set resourceName(value:String):void 
		{
			_resourceName = value;
		}
		
		public function freeResource():void
		{
			
		}
		
		public function handleDeviceLoss():void
		{
			
		}
		
		/* INTERFACE com.rabbitframework.utils.IDisposable */
		
		public function dispose():void 
		{
			
		}
	}

}