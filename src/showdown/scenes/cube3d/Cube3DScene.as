package showdown.scenes.cube3d {
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.World2D;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.renderers.TexturedMesh3DCloudRenderer;
	import flash.display3D.Context3DCompareMode;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Cube3DScene extends SceneBase
	{
		public var node:Node2D;
		
		public var texturedMesh3DCloudRenderer:TexturedMesh3DCloudRenderer = new TexturedMesh3DCloudRenderer();
		public var previousRenderer:RendererBase;
		
		public var worldRef:World2D;
		
		public function Cube3DScene() 
		{
			name = "3D objects in scene: all Node2D objects now have 3d transformation properties. No need for a special object or container. 2D and 3D objects are all batched together.";
			
			node = new Node2D();
			addChild(node);
			
			var cube:Cube3D;
			
			var i:int = 0;
			var n:int = 4;
			
			for (; i < n; i++) 
			{
				var j:int = 0;
				var m:int = 4;
				
				for (; j < m; j++) 
				{
					cube = new Cube3D();
					node.addChild(cube);
					
					cube.x = (j * 80) - ((m - 1) * 40);
					cube.y = (i * 80) - ((n - 1) * 40);
				}
			}
		}
		
		override protected function onAddedToStageHandler():void 
		{
			worldRef = world;
			
			node.x = stage.stageWidth * 0.5;
			node.y = 480.0 * 0.5;
			
			previousRenderer = world.renderer;
			world.renderer = texturedMesh3DCloudRenderer;
			world.context3D.setDepthTest(true, Context3DCompareMode.LESS_EQUAL);
		}
		
		override protected function onRemovedFromStageHandler():void 
		{
			worldRef.renderer = previousRenderer;
			worldRef.context3D.setDepthTest(true, Context3DCompareMode.ALWAYS);
		}
		
		override public function step(elapsed:Number):void 
		{
			node.rotationX += (((stage.mouseY / stage.stageHeight) * 360.0) - node.rotationX) * 0.125;
			node.rotationY += (((stage.mouseX / stage.stageWidth) * 360.0) - node.rotationY) * 0.125;
		}
		
	}

}