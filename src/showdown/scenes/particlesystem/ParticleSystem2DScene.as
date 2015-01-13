package showdown.scenes.particlesystem 
{
	import de.nulldesign.nd2dx.components.renderers.ParticleSystem2DRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Scene2D;
	import de.nulldesign.nd2dx.utils.NodeUtils;
	import de.nulldesign.nd2dx.utils.ParticleSystem2DPreset;
	import flash.display3D.Context3DBlendFactor;
	import showdown.assets.Assets;
	import showdown.scenes.common.Bug;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ParticleSystem2DScene extends SceneBase
	{
		public var container:Node2D;
		public var particleSystem2DRenderComponent:ParticleSystem2DRendererComponent;
		
		public function ParticleSystem2DScene() 
		{
			name = "ParticleSystem2D: single draw call, all computations on GPU, particles can rotate. Particle animations are defined by a preset system. Gravity values can be changed on the fly.";
			
			var halfWidth:Number = 580 * 0.5;
			var halfHeight:Number = 480 * 0.5;
			
			particleSystem2DRenderComponent = new ParticleSystem2DRendererComponent();
			particleSystem2DRenderComponent.texture = Assets.assetsTexture.getSubTextureByName("bug01");
			particleSystem2DRenderComponent.blendModeSrc = Context3DBlendFactor.ONE;
			particleSystem2DRenderComponent.blendModeDst = Context3DBlendFactor.ONE;
			
			particleSystem2DRenderComponent.numParticles = 10000;
			particleSystem2DRenderComponent.preset = new ParticleSystem2DPreset();
			particleSystem2DRenderComponent.preset.startColor = 0x000000;
			particleSystem2DRenderComponent.preset.startColorVariance = 0xFFFFFF;
			particleSystem2DRenderComponent.preset.endColor = 0xFFFFFF;
			particleSystem2DRenderComponent.preset.endColorVariance = 0xAAAAFF;
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
			particleSystem2DRenderComponent.preset.minStartSize = 0.015;
			particleSystem2DRenderComponent.preset.maxStartSize = 0.0175;
			particleSystem2DRenderComponent.preset.minEndSize = 0.125;
			particleSystem2DRenderComponent.preset.maxEndSize = 0.15;
			//particleSystem2DRenderComponent.preset.minEmitAngle = 180 - 30;
			//particleSystem2DRenderComponent.preset.maxEmitAngle = 180 + 30;
			
			container = new Node2D();
			container.addComponent(particleSystem2DRenderComponent);
			addChild(container);
			container.x = 0.5 * 580.0;
			container.y = 0.5 * 480.0;
			
			//container.addChild(NodeUtils.createSprite(Assets.assetsTexture.getSubTextureByName("bug01")));
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( stage )
			{
				particleSystem2DRenderComponent.gravityX += (((stage.mouseX - (580 * 0.5)) * 1.75) - particleSystem2DRenderComponent.gravityX) * 0.0525;
				particleSystem2DRenderComponent.gravityY += (((stage.mouseY - (480 * 0.5)) * 1.75) - particleSystem2DRenderComponent.gravityY) * 0.0525;
				
				//container.x = (580 * 0.5) - particleSystem2DRenderComponent.gravityX * 0.25;
				//container.y = (480 * 0.5) - particleSystem2DRenderComponent.gravityY * 0.25;
			}
		}
	}

}