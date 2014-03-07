package benchmark.nd2dx 
{
	import benchmark.assets.Assets;
	import benchmark.nd2dx.display.RotatingSprite2D;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ND2DxBenchmark01 extends ND2DxBenchmarkBase
	{
		public function ND2DxBenchmark01() 
		{
			
		}
		
		override public function createSprites(count:int = 10):void
		{
			var i:int = 0;
			var n:int = count;
			var s:RotatingSprite2D;
			
			for (; i < n; i++) 
			{
				s = new RotatingSprite2D(Assets.atlas01Texture2D.getSubTextureByName("bug01"));
				addChild(s);
				
				s.x = stage.stageWidth * Math.random();
				s.y = stage.stageHeight * Math.random();
				
				numSprites++;
			}
		}
	}

}