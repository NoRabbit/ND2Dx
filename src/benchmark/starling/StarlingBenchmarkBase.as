package benchmark.starling 
{
	import benchmark.assets.Assets;
	import benchmark.Main;
	import benchmark.starling.display.RotatingImage;
	import net.hires.debug.Stats;
	import starling.display.Sprite;
	import starling.events.EnterFrameEvent;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class StarlingBenchmarkBase extends Sprite
	{
		public var stats:Stats = Main.stats;
		
		public var atlas01TextureAtlas:TextureAtlas;
		
		public var numSprites:int;
		
		public function StarlingBenchmarkBase() 
		{
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
			
			var _t:Texture = Texture.fromBitmap(Assets.bitmap);
			var _d:XML = XML(new Assets.atlas01XML());
			atlas01TextureAtlas = new TextureAtlas(_t, _d);
		}
		
		private function onEnterFrameHandler(e:EnterFrameEvent):void 
		{
			stats.update(0, numSprites * 2, numSprites);
			
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