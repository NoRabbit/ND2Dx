package showdown.scenes.animatedtexture 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import showdown.assets.Assets;
	import showdown.scenes.common.AnimatedMeteor;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedTextureScene extends SceneBase
	{
		public var container:Node2D;
		
		public function AnimatedTextureScene() 
		{
			name = "Animated Textures";
			
			container = createAnimatedTextureInContainer(new Node2D(), 5, 0.4, 80.0, true);
			addChild(container);
			
		}
		
		override protected function onAddedToStageHandler():void 
		{
			container.x = 0.5 * stage.stageWidth;
			container.y = 0.5 * 480.0;
		}
		
		public function createAnimatedTextureInContainer(container:Node2D, count:int = 10, scale:Number = 0.5, spaceBetweenSprites:Number = 40.0, createNewSpritesInSprites:Boolean = false):Node2D
		{
			var totalSize:Number = spaceBetweenSprites * (count - 1);
			
			var i:int = 0;
			var n:int = count;
			
			for (; i < n; i++) 
			{
				var j:int = 0;
				var m:int = count;
				
				for (; j < m; j++) 
				{
					var s:Node2D = new AnimatedMeteor();
					container.addChild(s);
					
					s.x = -(totalSize * 0.5) + (spaceBetweenSprites * i);
					s.y = -(totalSize * 0.5) + (spaceBetweenSprites * j);
					s.scaleX = s.scaleY = scale;
					
					if ( createNewSpritesInSprites ) s.addChild(createAnimatedTextureInContainer(new Node2D(), 2, scale * 2.0, spaceBetweenSprites));
				}
				
			}
			
			return container;
		}
	}

}