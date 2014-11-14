package showdown.scenes.directgpu3dstresstest 
{
	import de.nulldesign.nd2dx.display.World2D;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.renderers.TexturedMesh3DCloudRenderer;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import showdown.assets.Assets;
	import showdown.scenes.directgpustresstest.DirectGPUObject;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DirectGPU3DStressTestScene extends SceneBase
	{
		public var maxElapsed:Number = 1 / 60;
		
		public var texturedMesh3DCloudRenderer:TexturedMesh3DCloudRenderer = new TexturedMesh3DCloudRenderer();
		public var previousRenderer:RendererBase;
		
		public var worldRef:World2D;
		
		public var directGPUObjectFirst:DirectGPUObject;
		public var directGPUObjectLast:DirectGPUObject;
		public var texture:Texture2D;
		
		public function DirectGPU3DStressTestScene() 
		{
			name = "Direct GPU Drawing 3D Stress Test";
		}
		
		override protected function onAddedToStageHandler():void 
		{
			directGPUObjectFirst = null;
			texture = Assets.assetsTexture.getSubTextureByName("bug01");
			
			worldRef = world;
			
			previousRenderer = world.renderer;
			world.renderer = texturedMesh3DCloudRenderer;
			//world.context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
		}
		
		override protected function onRemovedFromStageHandler():void 
		{
			directGPUObjectFirst = null;
			worldRef.renderer = previousRenderer;
			//worldRef.context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( elapsed <= maxElapsed ) addObjects();
		}
		
		override public function drawNode(renderer:RendererBase):void 
		{
			for (var directGPUObject:DirectGPUObject = directGPUObjectFirst; directGPUObject; directGPUObject = directGPUObject.next)
			{
				directGPUObject.rotationX += renderer.elapsed * 100;
				directGPUObject.rotationY += renderer.elapsed * 100;
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
				directGPUObject.rotationX = Math.random() * 360.0;
				directGPUObject.rotationY = Math.random() * 360.0;
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