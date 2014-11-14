package showdown.scenes.directgpustresstest 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import showdown.assets.Assets;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DirectGPUStressTestScene extends SceneBase
	{
		public var maxElapsed:Number = 1 / 60;
		
		public var directGPUObjectFirst:DirectGPUObject;
		public var directGPUObjectLast:DirectGPUObject;
		public var texture:Texture2D;
		
		public function DirectGPUStressTestScene() 
		{
			name = "Direct GPU Drawing Stress Test: much more performant than the scene graph (display list) approach but less easy and practical to use.";
		}
		
		override protected function onAddedToStageHandler():void 
		{
			directGPUObjectFirst = null;
			texture = Assets.assetsTexture.getSubTextureByName("bug01");
		}
		
		override protected function onRemovedFromStageHandler():void 
		{
			directGPUObjectFirst = null;
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( elapsed <= maxElapsed ) addObjects();
		}
		
		override public function drawNode(renderer:RendererBase):void 
		{
			for (var directGPUObject:DirectGPUObject = directGPUObjectFirst; directGPUObject; directGPUObject = directGPUObject.next)
			{
				directGPUObject.rotationZ += renderer.elapsed * 100;
				renderer.drawTexturedQuad(texture, true, this, null, directGPUObject.x, directGPUObject.y, 0.0, directGPUObject.scaleX, directGPUObject.scaleY, 1.0, directGPUObject.rotationZ, directGPUObject.rotationY, directGPUObject.rotationX);
			}
			
			super.drawNode(renderer);
		}
		
		public function addObjects(count:int = 100):void
		{
			var i:int = 0;
			var n:int = 100;
			var directGPUObject:DirectGPUObject;
			
			for (; i < n; i++) 
			{
				directGPUObject = new DirectGPUObject();
				directGPUObject.x = Math.random() * stage.stageWidth;
				directGPUObject.y = Math.random() * 480;
				//directGPUObject.rotationX = Math.random() * 360.0;
				//directGPUObject.rotationY = Math.random() * 360.0;
				directGPUObject.rotationZ = Math.random() * 360.0;
				
				if ( !directGPUObjectFirst )
				{
					directGPUObjectFirst = directGPUObjectLast = directGPUObject;
				}
				else
				{
					directGPUObject.prev = directGPUObjectLast;
					directGPUObjectLast.next = directGPUObject;
					directGPUObjectLast = directGPUObject;
				}
			}
		}
	}

}