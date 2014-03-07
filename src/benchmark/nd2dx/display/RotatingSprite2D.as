package benchmark.nd2dx.display 
{
	import de.nulldesign.nd2dx.display.Sprite2D;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RotatingSprite2D extends Sprite2D
	{
		private var duration:Number = 0.0;
		public static const RAD_2_DEG:Number = 180 / Math.PI;
		
		public function RotatingSprite2D(texture2D:Texture2D = null) 
		{
			super(texture2D);
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