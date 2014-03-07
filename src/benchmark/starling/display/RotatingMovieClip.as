package benchmark.starling.display 
{
	import starling.display.MovieClip;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RotatingMovieClip extends MovieClip
	{
		
		public function RotatingMovieClip(textures:Vector.<Texture>, fps:Number=30) 
		{
			super(textures, fps);
			
			scaleX = scaleY = 0.25;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(e:EnterFrameEvent):void 
		{
			rotation += e.passedTime;
		}
		
	}

}