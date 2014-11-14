package showdown.scenes.animatedtexturestresstest 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import showdown.scenes.common.AnimatedMeteor;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedTextureStressTestScene extends SceneBase
	{
		public var maxElapsed:Number = 1 / 60;
		
		public function AnimatedTextureStressTestScene() 
		{
			name = "Animated Textures Stress Test (Scene Graph)";
		}
		
		override protected function onAddedToStageHandler():void 
		{
			removeAllChildren();
		}
		
		override protected function onRemovedFromStageHandler():void 
		{
			removeAllChildren();
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( elapsed <= maxElapsed ) addObjects();
		}
		
		public function addObjects(count:int = 100):void
		{
			var i:int = 0;
			var n:int = count;
			var node:Node2D;
			
			for (; i < n; i++) 
			{
				node = new AnimatedMeteor();
				
				node.x = Math.random() * stage.stageWidth;
				node.y = Math.random() * 480;
				//node.rotationX = Math.random() * 360.0;
				//node.rotationY = Math.random() * 360.0;
				node.rotationZ = Math.random() * 360.0;
				node.scaleX = node.scaleY = 0.25;
				
				this.addChild(node);
			}
		}
	}

}