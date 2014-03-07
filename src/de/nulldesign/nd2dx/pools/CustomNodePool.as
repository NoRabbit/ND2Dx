package de.nulldesign.nd2dx.pools 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class CustomNodePool 
	{
		private static var instance:CustomNodePool = new CustomNodePool();
		
		public function CustomNodePool() 
		{
			if ( instance ) throw new Error( "CustomNodePool can only be accessed through CustomNodePool.getInstance()" );
		}
		
		public static function getInstance():CustomNodePool 
		{
			return instance;
		}
		
		public var dPoolForClass:Dictionary = new Dictionary();
		
		public var maxPoolCount:int = 10;
		
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
			
			for (; i < n; i++) 
			{
				pool.push(new classObject());
			}
		}
		
		public function getObject(classObject:Class):Node2D
		{
			var pool:Array = getPoolForClass(classObject);
			if ( pool.length <= 0 ) populatePool(pool, classObject, maxPoolCount);
			return pool.pop();
		}
		
		public function releaseObject(object:Node2D):void
		{
			var pool:Array = getPoolForClass(getDefinitionByName(getQualifiedClassName(object)) as Class);
			
			if ( pool.length >= maxPoolCount )
			{
				object.dispose();
			}
			else
			{
				object.releaseForPooling();
				pool.push(object);
			}
		}
	}
	
}