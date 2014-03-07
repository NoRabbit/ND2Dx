package de.nulldesign.nd2dx.pools 
{
	import de.nulldesign.nd2dx.display.BitmapFont2D;
	import de.nulldesign.nd2dx.text.BitmapFont2DStyle;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class BitmapFont2DPool 
	{
		private static var instance:BitmapFont2DPool = new BitmapFont2DPool();
		
		public function BitmapFont2DPool() 
		{
			if ( instance ) throw new Error( "BitmapFont2DPool can only be accessed through BitmapFont2DPool.getInstance()" );
		}
		
		public static function getInstance():BitmapFont2DPool 
		{
			return instance;
		}
		
		public var vPool:Vector.<BitmapFont2D> = new Vector.<BitmapFont2D>();
		
		public var maxPoolCount:int = 10;
		
		public function populatePool(maxCount:int = 10):void
		{
			var i:int = vPool.length;
			var n:int = maxCount;
			
			for (; i < n; i++) 
			{
				vPool.push(new BitmapFont2D());
			}
		}
		
		public function getObject(style:BitmapFont2DStyle = null):BitmapFont2D
		{
			if ( vPool.length <= 0 ) populatePool(maxPoolCount);
			
			var bmpFont2D:BitmapFont2D = vPool.pop() as BitmapFont2D;
			if( style ) bmpFont2D.setStyle(style);
			return bmpFont2D;
		}
		
		public function releaseObject(object:BitmapFont2D):void
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