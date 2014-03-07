package de.nulldesign.nd2dx.pools 
{
	import de.nulldesign.nd2dx.display.Sprite2D;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class Sprite2DPool 
	{
		private static var instance:Sprite2DPool = new Sprite2DPool();
		
		public function Sprite2DPool() 
		{
			if ( instance ) throw new Error( "Sprite2DPool can only be accessed through Sprite2DPool.getInstance()" );
		}
		
		public static function getInstance():Sprite2DPool 
		{
			return instance;
		}
		
		public var vPool:Vector.<Sprite2D> = new Vector.<Sprite2D>();
		
		public var maxPoolCount:int = 10;
		
		public function populatePool(maxCount:int = 10):void
		{
			var i:int = vPool.length;
			var n:int = maxCount;
			
			for (; i < n; i++) 
			{
				vPool.push(new Sprite2D());
			}
		}
		
		public function getObject(texture2D:Texture2D = null):Sprite2D
		{
			if ( vPool.length <= 0 ) populatePool(maxPoolCount);
			
			var sprite2D:Sprite2D = vPool.pop() as Sprite2D;
			if( texture2D ) sprite2D.setTexture(texture2D);
			return sprite2D;
		}
		
		public function releaseObject(object:Sprite2D):void
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