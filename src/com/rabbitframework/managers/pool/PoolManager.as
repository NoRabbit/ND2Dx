package com.rabbitframework.managers.pool 
{
	import com.rabbitframework.utils.IPoolable;
	import de.nulldesign.nd2dx.display.Node2D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class PoolManager 
	{
		private static var instance:PoolManager = new PoolManager();
		
		public function PoolManager() 
		{
			if ( instance ) throw new Error( "PoolManager can only be accessed through PoolManager.getInstance()" );
		}
		
		public static function getInstance():PoolManager 
		{
			return instance;
		}
		
		public var dPoolForClass:Dictionary = new Dictionary();
		public var dPoolSizeForClass:Dictionary = new Dictionary();
		
		public function setPoolSizeForClass(classObject:Class, poolSize:int = 10):void
		{
			dPoolSizeForClass[classObject] = poolSize;
		}
		
		public function createPool(classObject:Class, automaticallyPopulatePool:Boolean = true, maxItems:int = 0):Pool
		{
			if ( maxItems == 0 ) maxItems = 10;
			if ( dPoolSizeForClass[classObject] ) maxItems = dPoolSizeForClass[classObject] as Number;
			
			var pool:Pool = dPoolForClass[classObject];
			if ( !pool ) pool = dPoolForClass[classObject] = new Pool(classObject, maxItems, automaticallyPopulatePool);
			return pool;
		}
		
		public function getPoolForClass(classObject:Class, createIfDoesNotExist:Boolean = true, maxItems:int = 0):Pool
		{
			var pool:Pool = dPoolForClass[classObject];
			if ( !pool && createIfDoesNotExist ) pool = createPool(classObject, true, maxItems);
			return pool;
		}
		
		public function getObject(classObject:Class):IPoolable
		{
			var pool:Pool = getPoolForClass(classObject);
			if ( pool ) return pool.getObject();
			return null;
		}
		
		public function releaseObject(object:IPoolable):void
		{
			var pool:Pool = getPoolForClass(getDefinitionByName(getQualifiedClassName(object)) as Class);
			
			if ( pool )
			{
				pool.releaseObject(object);
			}
			else
			{
				object.dispose();
			}
		}
	}
	
}