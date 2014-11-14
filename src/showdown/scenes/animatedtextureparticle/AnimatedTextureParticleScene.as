package showdown.scenes.animatedtextureparticle 
{
	import de.nulldesign.nd2dx.components.AnimatedTextureComponent;
	import de.nulldesign.nd2dx.components.renderers.ParticleSystem2DRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Sprite2D;
	import de.nulldesign.nd2dx.materials.BlendModePresets;
	import de.nulldesign.nd2dx.materials.Texture2DMaterial;
	import de.nulldesign.nd2dx.support.RenderSupportBase;
	import de.nulldesign.nd2dx.utils.ParticleSystem2DPreset;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import showdown.assets.Assets;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedTextureParticleScene extends SceneBase
	{
		public var animatedTextureComponent:AnimatedTextureComponent;
		public var particleSystem2DRenderComponent:ParticleSystem2DRendererComponent;
		
		public function AnimatedTextureParticleScene() 
		{
			name = "Animated Textures on ParticleSystem2D";
			
			var container:Node2D;
			
			var halfWidth:Number = 580 * 0.5;
			var halfHeight:Number = 495 * 0.5;
			
			
			container = new Node2D();
			
			particleSystem2DRenderComponent = new ParticleSystem2DRendererComponent();
			particleSystem2DRenderComponent.particleSystem2DMaterial.texture = Assets.atlas01Texture2D;
			particleSystem2DRenderComponent.particleSystem2DMaterial.blendMode = BlendModePresets.ADD;
			
			particleSystem2DRenderComponent.numParticles = 2000;
			particleSystem2DRenderComponent.preset = new ParticleSystem2DPreset();
			//particleSystem2DRenderComponent.preset.startColor = 0xFFFFFF;
			//particleSystem2DRenderComponent.preset.startColorVariance = 0xFFFFCC;
			particleSystem2DRenderComponent.preset.endColor = 0xFF6600;
			particleSystem2DRenderComponent.preset.endColorVariance = 0xFF0000;
			particleSystem2DRenderComponent.preset.minSpeed = 50.0;
			particleSystem2DRenderComponent.preset.maxSpeed = 85.0;
			particleSystem2DRenderComponent.preset.minLife = 1250.0;
			particleSystem2DRenderComponent.preset.maxLife = 1750.0;
			particleSystem2DRenderComponent.preset.spawnDelay = 1000.0;
			particleSystem2DRenderComponent.preset.minStartPosition.x = -halfWidth * 1;
			particleSystem2DRenderComponent.preset.minStartPosition.y = -halfHeight * 1;
			particleSystem2DRenderComponent.preset.maxStartPosition.x = halfWidth * 1;
			particleSystem2DRenderComponent.preset.maxStartPosition.y = halfHeight * 1;
			particleSystem2DRenderComponent.preset.endAlpha = 0.0;
			particleSystem2DRenderComponent.preset.minStartSize = 0.005;
			particleSystem2DRenderComponent.preset.maxStartSize = 0.0075;
			particleSystem2DRenderComponent.preset.minEndSize = 0.125;
			particleSystem2DRenderComponent.preset.maxEndSize = 0.25;
			//particleSystem2DRenderComponent.preset.minEmitAngle = 180 - 30;
			//particleSystem2DRenderComponent.preset.maxEmitAngle = 180 + 30;
			
			container.addComponent(particleSystem2DRenderComponent);
			
			animatedTextureComponent = new AnimatedTextureComponent();
			animatedTextureComponent.source = particleSystem2DRenderComponent.material;
			animatedTextureComponent.animatedTexture2D = Assets.animatedTexture2DMeteor;
			animatedTextureComponent.fps = 30;
			container.addComponent(animatedTextureComponent);
			
			addChild(container);
			container.x = 0.5 * 580.0;
			container.y = 0.5 * 495.0;
			
			
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( stage )
			{
				particleSystem2DRenderComponent.particleSystem2DMaterial.gravityX = (stage.mouseX - (580 * 0.5)) * 0.5;
				particleSystem2DRenderComponent.particleSystem2DMaterial.gravityY = (stage.mouseY - (495 * 0.5)) * 0.5;
			}
		}
	}

}