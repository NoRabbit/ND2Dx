package benchmark.nd2dx 
{
	import benchmark.assets.Assets;
	import benchmark.Main;
	import benchmark.nd2dx.display.RotatingSprite2D;
	import de.nulldesign.nd2dx.display.Scene2D;
	import de.nulldesign.nd2dx.display.Sprite2D;
	import net.hires.debug.Stats;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ND2DxBenchmarkBase extends Scene2D
	{
		public var stats:Stats = Main.stats;
		
		public var numSprites:int;
		
		public function ND2DxBenchmarkBase() 
		{
			
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( stats.measuredFPS >= 60 )
			{
				createSprites();
			}
		}
		
		public function createSprites(count:int = 10):void
		{
			
		}
	}

}