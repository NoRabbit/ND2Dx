package showdown.scenes.graphstresstest 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import showdown.assets.Assets;
	import showdown.scenes.common.Bug;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class GraphStressTestScene extends SceneBase
	{
		public var maxElapsed:Number = 1 / 60;
		
		public function GraphStressTestScene() 
		{
			name = "Scene Graph Stress Test";
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
			var texturedQuadRenderer:TexturedMeshRendererComponent;
			
			for (; i < n; i++) 
			{
				node = new Bug();
				
				node.x = Math.random() * stage.stageWidth;
				node.y = Math.random() * 480;
				//node.rotationX = Math.random() * 360.0;
				//node.rotationY = Math.random() * 360.0;
				node.rotationZ = Math.random() * 360.0;
				node.scaleX = node.scaleY = 0.125;
				
				this.addChild(node);
			}
		}
	}

}