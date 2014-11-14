package showdown.scenes.dynamicshader 
{
	import de.nulldesign.nd2dx.components.renderers.DynamicShaderMeshRendererComponent;
	import de.nulldesign.nd2dx.components.renderers.properties.Vector1Property;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2D;
	import de.nulldesign.nd2dx.utils.NodeUtils;
	import showdown.assets.Assets;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DynamicShaderScene extends SceneBase
	{
		public var node:Node2D;
		public var dynamicShaderMeshRendererComponent:DynamicShaderMeshRendererComponent;
		public var speed:Vector1Property;
		public var fade:Vector1Property;
		
		public function DynamicShaderScene() 
		{
			name = "Dynamic Shader Mesh Renderer: assign any custom xml shader and easily modify its properties on the fly (textures and shader constants) - move your mouse around the scene"
			node = new Node2D();
			
			dynamicShaderMeshRendererComponent = new DynamicShaderMeshRendererComponent();
			dynamicShaderMeshRendererComponent.shader = Assets.shaderDynamic;
			dynamicShaderMeshRendererComponent.mesh = resourceManager.getResourceById("mesh_quad2d") as Mesh2D;
			
			speed = dynamicShaderMeshRendererComponent.getPropertyByAlias("speed") as Vector1Property;
			fade = dynamicShaderMeshRendererComponent.getPropertyByAlias("fade") as Vector1Property;
			
			node.addComponent(dynamicShaderMeshRendererComponent);
			
			node.x = 585 * 0.5;
			node.y = 480 * 0.5;
			
			addChild(node);
			
			// textures used in shader
			node = NodeUtils.createSprite(Assets.assetsTexture.getSubTextureByName("noise01"));
			node.width = node.height = 50.0;
			
			node.x = 585 * 0.5 - 52;
			node.y = 480 * 0.5 + 188;
			
			addChild(node);
			
			node = NodeUtils.createSprite(Assets.assetsTexture.getSubTextureByName("art01"));
			node.width = node.height = 50.0;
			
			node.x = 585 * 0.5 + 52;
			node.y = 480 * 0.5 + 188;
			
			addChild(node);
		}
		
		override public function step(elapsed:Number):void 
		{
			speed.x += elapsed * 2.0 * (stage.mouseX / stage.stageWidth);
			fade.x = (stage.mouseY / stage.stageHeight);
		}
	}

}