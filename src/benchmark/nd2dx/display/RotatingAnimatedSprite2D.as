package benchmark.nd2dx.display 
{
	import de.nulldesign.nd2dx.components.AnimatedTextureComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Sprite2D;
	import de.nulldesign.nd2dx.materials.texture.AnimatedTexture2D;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RotatingAnimatedSprite2D extends Sprite2D
	{
		public var animatedTextureComponent:AnimatedTextureComponent;
		
		public function RotatingAnimatedSprite2D(animatedTexture2D:AnimatedTexture2D) 
		{
			super(animatedTexture2D.frames[0]);
			
			animatedTextureComponent = new AnimatedTextureComponent();
			animatedTextureComponent.animatedTexture2D = animatedTexture2D;
			animatedTextureComponent.fps = 30;
			addComponent(animatedTextureComponent);
			
			scaleX = scaleY = 0.25;
			performMatrixCalculations = false;
		}
		
		override public function step(elapsed:Number):void 
		{
			//duration += elapsed;
			_rotationZ += 40.0 * elapsed;
			//_alpha = Math.abs(Math.sin(duration) * RAD_2_DEG) / 58;
			//invalidateColors = true;
			invalidateMatrix = true;
		}
		
	}

}