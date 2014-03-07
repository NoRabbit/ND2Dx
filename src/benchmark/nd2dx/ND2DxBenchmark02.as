package benchmark.nd2dx 
{
	import benchmark.assets.Assets;
	import benchmark.nd2dx.display.RotatingAnimatedSprite2D;
	import de.nulldesign.nd2dx.materials.texture.AnimatedTexture2D;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ND2DxBenchmark02 extends ND2DxBenchmarkBase
	{
		public var animatedTexture2D:AnimatedTexture2D;
		
		public function ND2DxBenchmark02() 
		{
			animatedTexture2D = TextureUtil.animatedTexture2DFromName("meteor_short_", Assets.atlas01Texture2D);
		}
		
		override public function createSprites(count:int = 10):void
		{
			var i:int = 0;
			var n:int = count;
			var s:RotatingAnimatedSprite2D;
			
			for (; i < n; i++) 
			{
				s = new RotatingAnimatedSprite2D(animatedTexture2D);
				addChild(s);
				
				s.x = stage.stageWidth * Math.random();
				s.y = stage.stageHeight * Math.random();
				
				numSprites++;
			}
		}
	}

}