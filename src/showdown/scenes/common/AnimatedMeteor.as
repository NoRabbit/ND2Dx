package showdown.scenes.common 
{
	import de.nulldesign.nd2dx.components.AnimatedTextureComponent;
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import showdown.assets.Assets;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedMeteor extends Node2D
	{
		public var texturedMeshRendererComponent:TexturedMeshRendererComponent;
		public var animatedTextureComponent:AnimatedTextureComponent;
		public var speed:Number = 1.0;
		
		public function AnimatedMeteor() 
		{
			texturedMeshRendererComponent = new TexturedMeshRendererComponent(Assets.assetsTexture.getSubTextureByName("meteor_short_00000"));
			addComponent(texturedMeshRendererComponent);
			
			animatedTextureComponent = new AnimatedTextureComponent();
			animatedTextureComponent.source = texturedMeshRendererComponent;
			animatedTextureComponent.animatedTexture2D = Assets.animatedTexture2DMeteor;
			animatedTextureComponent.fps = 30;
			addComponent(animatedTextureComponent);
			
			speed = 0.5 + Math.random();
		}
		
		override public function step(elapsed:Number):void 
		{
			_rotationZ += 45.0 * elapsed * speed;
			invalidateMatrix = true;
		}
	}

}