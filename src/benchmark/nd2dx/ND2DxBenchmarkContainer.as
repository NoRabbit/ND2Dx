package benchmark.nd2dx 
{
	import benchmark.Main;
	import de.nulldesign.nd2dx.display.World2D;
	import de.nulldesign.nd2dx.support.RenderSupportBase;
	import de.nulldesign.nd2dx.support.Texture2DMaterialAlphaCloudRenderSupport;
	import de.nulldesign.nd2dx.support.Texture2DMaterialCloudRenderSupport;
	import de.nulldesign.nd2dx.utils.Statistics;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import net.hires.debug.Stats;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ND2DxBenchmarkContainer extends World2D
	{
		public var stats:Stats = Main.stats;
		
		public function ND2DxBenchmarkContainer(renderMode:String=Context3DRenderMode.AUTO, frameRate:uint=60, bounds:Rectangle=null, stageID:uint=0, renderSupport:RenderSupportBase=null) 
		{
			super(renderMode, frameRate, bounds, stageID, new Texture2DMaterialAlphaCloudRenderSupport());
			//super(renderMode, frameRate, bounds, stageID, renderSupport);
		}
		
		override protected function mainLoop(e:Event):void 
		{
			super.mainLoop(e);
			stats.update(Statistics.drawCalls, Statistics.triangles, Statistics.sprites);
		}
	}

}