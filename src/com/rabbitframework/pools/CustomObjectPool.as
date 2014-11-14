package com.rabbitframework.pools 
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
	public class CustomObjectPool 
	{
		private static var instance:CustomObjectPool = new CustomObjectPool();
		
		public function CustomObjectPool() 
		{
			if ( instance ) throw new Error( "CustomObjectPool can only be accessed through CustomObjectPool.getInstance()" );
		}
		
		public static function getInstance():CustomObjectPool 
		{
			return instance;
		}
		
		public var dPoolForClass:Dictionary = new Dictionary();
		
		public var maxPoolCount:int = 50;
		
		public function getPoolForClass(classObject:Class, createIfDoesNotExist:Boolean = true):Array
		{
			var pool:Array = dPoolForClass[classObject];
			if ( !pool && createIfDoesNotExist ) pool = dPoolForClass[classObject] = new Array();
			return pool;
		}
		
		public function populatePool(pool:Array, classObject:Class, maxCount:int = 10):void
		{
			var i:int = pool.length;
			var n:int = maxCount;
			var object:IPoolable;
			
			for (; i < n; i++) 
			{
				object = new classObject() as IPoolable;
				object.disposeForPool();
				pool.push(object);
			}
		}
		
		public function getObject(classObject:Class):IPoolable
		{
			var pool:Array = getPoolForClass(classObject);
			if ( pool.length <= 0 ) populatePool(pool, classObject, maxPoolCount);
			var object:IPoolable = pool.pop() as IPoolable;
			object.initFromPool();
			return object;
		}
		
		public function releaseObject(object:IPoolable):void
		{
			var pool:Array = getPoolForClass(getDefinitionByName(getQualifiedClassName(object)) as Class);
			
			if ( pool.length >= maxPoolCount )
			{
				object.dispose();
			}
			else
			{
				object.disposeForPool();
				pool.push(object);
			}
		}
	}
	
}