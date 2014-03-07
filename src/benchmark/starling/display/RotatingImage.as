package benchmark.starling.display 
{
	import starling.display.Image;
	import starling.events.EnterFrameEvent;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RotatingImage extends Image
	{
		
		public function RotatingImage(texture:Texture) 
		{
			super(texture);
			
			scaleX = scaleY = 0.25;
			
			addEventListener(EnterFrameEvent.ENTER_FRAME, onEnterFrameHandler);
		}
		
		private function onEnterFrameHandler(e:EnterFrameEvent):void 
		{
			rotation += e.passedTime;
		}
		
	}

}