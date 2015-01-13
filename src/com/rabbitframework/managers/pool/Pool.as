package com.rabbitframework.managers.pool 
{
	import com.rabbitframework.utils.IPoolable;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Pool 
	{
		public var classObject:Class = null;
		public var maxItems:int = 0;
		public var automaticIncrementCount:int = 10;
		
		public var activeObjects:Vector.<IPoolable> = new Vector.<IPoolable>();
		public var inactiveObjects:Vector.<IPoolable> = new Vector.<IPoolable>();
		
		public function Pool(classObject:Class, maxItems:int = 10, automaticallyPopulatePool:Boolean = true) 
		{
			this.classObject = classObject;
			this.maxItems = maxItems;
			
			if ( automaticallyPopulatePool ) populatePool();
		}
		
		public function populatePool(count:int = -1):void
		{
			if ( count < 0 ) count = automaticIncrementCount;
			maxItems = activeObjects.length + count;
			
			var i:int = inactiveObjects.length;
			var n:int = count;
			var object:IPoolable;
			
			for (; i < n; i++) 
			{
				object = new classObject() as IPoolable;
				inactiveObjects.push(object);
			}
		}
		
		public function getObject():IPoolable
		{
			if ( inactiveObjects.length <= 0 ) populatePool();
			var object:IPoolable = inactiveObjects.pop() as IPoolable;
			//trace(this, "getObject", classObject, ((object as Object).hasOwnProperty("eGroup") ? object["eGroup"] : "no eGroup"));
			
			activeObjects.push(object);
			object.initFromPool();
			return object;
		}
		
		public function releaseObject(object:IPoolable):void
		{
			var index:int = activeObjects.indexOf(object);
			if ( index >= 0 ) activeObjects.splice(index, 1);
			
			if ( inactiveObjects.length >= maxItems )
			{
				object.dispose();
			}
			else
			{
				object.disposeForPool();
				inactiveObjects.push(object);
			}
		}
		
		public function releaseAllActiveObjectsToPool():void
		{
			while (activeObjects.length)
			{
				releaseObject(activeObjects[0]);
			}
		}
		
	}

}