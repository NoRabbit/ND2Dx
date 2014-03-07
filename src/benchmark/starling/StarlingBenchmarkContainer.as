package benchmark.starling 
{
	import benchmark.Main;
	import flash.display.Stage;
	import net.hires.debug.Stats;
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class StarlingBenchmarkContainer 
	{
		public var stats:Stats = Main.stats;
		
		public var starling:Starling;
		public var stage:Stage;
		
		public function StarlingBenchmarkContainer(stage:Stage, benchmarkClass:Class) 
		{
			this.stage = stage;
			
			starling = new Starling(benchmarkClass, stage);
		}
		
		public function start():void
		{
			starling.start();
		}
		
		public function dispose():void
		{
			starling.dispose();
		}
	}

}