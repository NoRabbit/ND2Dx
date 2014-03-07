package benchmark.starling 
{
	import benchmark.starling.display.RotatingImage;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	
	public class StarlingBenchmark01 extends StarlingBenchmarkBase
	{
		public function StarlingBenchmark01() 
		{
			
		}
		
		override public function createSprites(count:int = 10):void 
		{
			var i:int = 0;
			var n:int = count;
			var s:RotatingImage;
			
			for (; i < n; i++) 
			{
				s = new RotatingImage(atlas01TextureAtlas.getTexture("bug01"));
				addChild(s);
				
				s.x = stage.stageWidth * Math.random();
				s.y = stage.stageHeight * Math.random();
				
				numSprites++;
			}
		}
	}

}