package benchmark.starling 
{
	import benchmark.starling.display.RotatingMovieClip;
	import starling.core.Starling;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class StarlingBenchmark02 extends StarlingBenchmarkBase
	{
		
		public function StarlingBenchmark02() 
		{
			
		}
		
		override public function createSprites(count:int = 10):void 
		{
			var i:int = 0;
			var n:int = count;
			var s:RotatingMovieClip;
			
			for (; i < n; i++) 
			{
				s = new RotatingMovieClip(atlas01TextureAtlas.getTextures("meteor_short_"));
				addChild(s);
				
				Starling.juggler.add(s);
				
				s.x = stage.stageWidth * Math.random();
				s.y = stage.stageHeight * Math.random();
				
				numSprites++;
			}
		}
	}

}