package de.nulldesign.nd2dx.pools 
{
	import de.nulldesign.nd2dx.display.Node2D;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class Node2DPool 
	{
		private static var instance:Node2DPool = new Node2DPool();
		
		public function Node2DPool() 
		{
			if ( instance ) throw new Error( "Node2DPool can only be accessed through Node2DPool.getInstance()" );
		}
		
		public static function getInstance():Node2DPool 
		{
			return instance;
		}
		
		public var vPool:Vector.<Node2D> = new Vector.<Node2D>();
		
		public var maxPoolCount:int = 10;
		
		public function populatePool(maxCount:int = 10):void
		{
			var i:int = vPool.length;
			var n:int = maxCount;
			
			for (; i < n; i++) 
			{
				vPool.push(new Node2D());
			}
		}
		
		public function getObject():Node2D
		{
			if ( vPool.length <= 0 ) populatePool(maxPoolCount);
			return vPool.pop();
		}
		
		public function releaseObject(object:Node2D):void
		{
			if ( vPool.length >= maxPoolCount )
			{
				object.dispose();
			}
			else
			{
				object.releaseForPooling();
				vPool.push(object);
			}
		}
	}
	
}