package showdown.scenes.uv 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.utils.NodeUtils;
	import showdown.assets.Assets;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UVScene extends SceneBase
	{
		public var node:Node2D;
		public var texturedQuadRendererComponent:TexturedMeshRendererComponent;
		
		public function UVScene() 
		{
			name = "Texture UV Offsets";
			
			node = new Node2D();
			node.x = 580 * 0.5;
			node.y = 480 * 0.5;
			
			texturedQuadRendererComponent = new TexturedMeshRendererComponent(Assets.assetsTexture.getSubTextureByName("RTS_Crate"));
			node.addComponent(texturedQuadRendererComponent);
			
			addChild(node);
		}
		
		override public function step(elapsed:Number):void 
		{
			texturedQuadRendererComponent.uvOffsetX = stage.mouseX / stage.stageWidth;
			texturedQuadRendererComponent.uvOffsetY = stage.mouseY / stage.stageHeight;
		}
		
	}

}