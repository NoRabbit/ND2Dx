package de.nulldesign.nd2dx.resource 
{
	import com.rabbitframework.signals.SignalDispatcher;
	import com.rabbitframework.utils.IDisposable;
	import de.nulldesign.nd2dx.signals.SignalTypes;
	import de.nulldesign.nd2dx.utils.IIdentifiable;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ResourceBase extends SignalDispatcher implements IIdentifiable, IDisposable
	{
		private var _id:String = "";
		private var _name:String = "";
		
		private var _allocator:ResourceAllocatorBase;
		
		public var isCore:Boolean = false;
		
		private var _isAllocating:Boolean = false;
		private var _isLocallyAllocated:Boolean = false;
		private var _isRemotellyAllocated:Boolean = false;
		
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
		
		public function get name():String 
		{
			return _name;
		}
		
		public function set name(value:String):void 
		{
			_name = value;
		}
		
		public function freeResource():void
		{
			
		}
		
		public function handleDeviceLoss():void
		{
			
		}
		
		/* INTERFACE de.nulldesign.nd2dx.utils.IIdentifiable */
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		public function get isAllocating():Boolean 
		{
			return _isAllocating;
		}
		
		public function set isAllocating(value:Boolean):void 
		{
			if ( _isAllocating == value ) return;
			
			_isAllocating = value;
			
			if ( _isAllocating ) dispatchSignal(SignalTypes.RESOURCE_ALLOCATING, this);
		}
		
		public function get isLocallyAllocated():Boolean 
		{
			return _isLocallyAllocated;
		}
		
		public function set isLocallyAllocated(value:Boolean):void 
		{
			if ( _isLocallyAllocated == value ) return;
			
			_isLocallyAllocated = value;
			
			if ( _isLocallyAllocated )
			{
				dispatchSignal(SignalTypes.RESOURCE_LOCALLY_ALLOCATED, this);
			}
			else
			{
				dispatchSignal(SignalTypes.RESOURCE_LOCALLY_DEALLOCATED, this);
			}
			
			dispatchSignal(SignalTypes.RESOURCE_UPDATED, this);
		}
		
		public function get isRemotelyAllocated():Boolean 
		{
			return _isRemotellyAllocated;
		}
		
		public function set isRemotelyAllocated(value:Boolean):void 
		{
			if ( _isRemotellyAllocated == value ) return;
			
			_isRemotellyAllocated = value;
			
			if ( _isRemotellyAllocated )
			{
				dispatchSignal(SignalTypes.RESOURCE_REMOTELY_ALLOCATED, this);
			}
			else
			{
				dispatchSignal(SignalTypes.RESOURCE_REMOTELY_DEALLOCATED, this);
			}
			
			dispatchSignal(SignalTypes.RESOURCE_UPDATED, this);
		}
		
		/* INTERFACE com.rabbitframework.utils.IDisposable */
		
		public function dispose():void 
		{
			
		}
		
		
	}

}