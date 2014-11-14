package showdown.scenes.graph3dstresstest 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.World2D;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.renderers.TexturedMesh3DCloudRenderer;
	import flash.display3D.Context3DCompareMode;
	import showdown.scenes.common.Bug;
	import showdown.scenes.common.Bug3D;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Graph3DStressTestScene extends SceneBase
	{
		public var maxElapsed:Number = 1 / 60;
		
		public var texturedMesh3DCloudRenderer:TexturedMesh3DCloudRenderer = new TexturedMesh3DCloudRenderer();
		public var previousRenderer:RendererBase;
		
		public var worldRef:World2D;
		
		public function Graph3DStressTestScene() 
		{
			name = "Scene Graph 3D Stress Test";
		}
		
		override protected function onAddedToStageHandler():void 
		{
			removeAllChildren();
			
			worldRef = world;
			
			previousRenderer = world.renderer;
			world.renderer = texturedMesh3DCloudRenderer;
			//world.context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
		}
		
		override protected function onRemovedFromStageHandler():void 
		{
			removeAllChildren();
			
			worldRef.renderer = previousRenderer;
			//worldRef.context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
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
			var texturedQuadRenderer:TexturedMeshRendererComponent;
			
			for (; i < n; i++) 
			{
				node = new Bug3D();
				
				node.x = Math.random() * stage.stageWidth;
				node.y = Math.random() * 480;
				node.rotationX = Math.random() * 360.0;
				node.rotationY = Math.random() * 360.0;
				node.rotationZ = Math.random() * 360.0;
				node.scaleX = node.scaleY = 0.125;
				
				this.addChild(node);
			}
		}
	}

}