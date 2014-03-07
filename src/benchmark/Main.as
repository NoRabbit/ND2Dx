package benchmark 
{
	import benchmark.assets.Assets;
	import benchmark.nd2dx.ND2DxBenchmark01;
	import benchmark.nd2dx.ND2DxBenchmark02;
	import benchmark.nd2dx.ND2DxBenchmarkContainer;
	import benchmark.starling.StarlingBenchmark02;
	import benchmark.starling.StarlingBenchmarkContainer;
	import benchmark.starling.StarlingBenchmark01;
	import de.nulldesign.nd2dx.display.Scene2D;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import net.hires.debug.Stats;
	import fl.controls.Button;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Main extends Sprite
	{
		public static var stats:Stats = new Stats();
		
		public var nd2dxBenchmarkContainer:ND2DxBenchmarkContainer;
		public var nd2dxCurrentBenchmark:Scene2D;
		
		public var starlingBenchmarkContainer:StarlingBenchmarkContainer;
		
		public var butTest01:Button;
		public var butTest02:Button;
		public var butTest03:Button;
		public var butTest04:Button;
		
		public function Main() 
		{
			addChild(stats);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
		}
		
		private function onAddedToStageHandler(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStageHandler);
			
			Assets.init();
			
			butClear.addEventListener(MouseEvent.CLICK, butClear_clickHandler);
			butTest01.addEventListener(MouseEvent.CLICK, butTest01_clickHandler);
			butTest02.addEventListener(MouseEvent.CLICK, butTest02_clickHandler);
			butTest03.addEventListener(MouseEvent.CLICK, butTest03_clickHandler);
			butTest04.addEventListener(MouseEvent.CLICK, butTest04_clickHandler);
		}
		
		private function butClear_clickHandler(e:MouseEvent):void 
		{
			disposeAllBenchmarks();
		}
		
		private function butTest01_clickHandler(e:MouseEvent):void 
		{
			setND2DxBenchmark(new ND2DxBenchmark01());
		}
		
		private function butTest02_clickHandler(e:MouseEvent):void 
		{
			setND2DxBenchmark(new ND2DxBenchmark02());
		}
		
		private function butTest03_clickHandler(e:MouseEvent):void 
		{
			setStarlingBenchmark(StarlingBenchmark01);
		}
		
		private function butTest04_clickHandler(e:MouseEvent):void 
		{
			setStarlingBenchmark(StarlingBenchmark02);
		}
		
		public function disposeAllBenchmarks():void
		{
			if ( nd2dxBenchmarkContainer )
			{
				nd2dxBenchmarkContainer.dispose();
				if ( nd2dxBenchmarkContainer.parent ) nd2dxBenchmarkContainer.parent.removeChild(nd2dxBenchmarkContainer);
				nd2dxBenchmarkContainer = null;
			}
			
			if ( starlingBenchmarkContainer )
			{
				starlingBenchmarkContainer.dispose();
				starlingBenchmarkContainer = null;
			}
		}
		
		public function setND2DxBenchmark(benchmark:Scene2D):void
		{
			disposeAllBenchmarks();
			
			nd2dxCurrentBenchmark = benchmark;
			nd2dxBenchmarkContainer = new ND2DxBenchmarkContainer();
			nd2dxBenchmarkContainer.addEventListener(Event.INIT, onWorldInitHandler);
			addChild(nd2dxBenchmarkContainer);
		}
		
		private function onWorldInitHandler(e:Event):void 
		{
			nd2dxBenchmarkContainer.removeEventListener(Event.INIT, onWorldInitHandler);
			nd2dxBenchmarkContainer.setActiveScene(nd2dxCurrentBenchmark);
			nd2dxBenchmarkContainer.start();
		}
		
		public function setStarlingBenchmark(benchmarkClass:Class):void
		{
			disposeAllBenchmarks();
			
			starlingBenchmarkContainer = new StarlingBenchmarkContainer(stage, benchmarkClass);
			starlingBenchmarkContainer.start();
		}
	}

}