package de.nulldesign.nd2dx.utils 
{
	import com.rabbitframework.easing.Linear;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class CloudParticleSystemPreset 
	{
		// start position
		public var startX:Number = 0.0;
		public var startXRandom:Number = 0.0;
		
		public var startY:Number = 0.0;
		public var startYRandom:Number = 0.0;
		
		// start angle
		public var startAngle:Number = 0.0;
		public var startAngleRandom:Number = 360.0;
		
		// duration
		public var duration:Number = 1.0;
		public var durationRandom:Number = 1.0;
		
		// delay
		public var delay:Number = 1.0;
		public var delayRandom:Number = 1.0;
		
		// distance to move the particle of in pixel
		public var distance:Number = 25.0;
		public var distanceRandom:Number = 25.0;
		
		// alpha
		public var startAlpha:Number = 1.0;
		//public var startAlphaRandom:Number = 0.0;
		
		public var endAlpha:Number = 0.0;
		//public var endAlphaRandom:Number = 0.0;
		
		// rotations (start/end)
		public var startRotationX:Number = 0.0;
		public var startRotationXRandom:Number = 0.0;
		
		public var endRotationX:Number = 0.0;
		public var endRotationXRandom:Number = 0.0;
		
		public var startRotationY:Number = 0.0;
		public var startRotationYRandom:Number = 0.0;
		
		public var endRotationY:Number = 0.0;
		public var endRotationYRandom:Number = 0.0;
		
		public var startRotationZ:Number = 0.0;
		public var startRotationZRandom:Number = 0.0;
		
		public var endRotationZ:Number = 0.0;
		public var endRotationZRandom:Number = 360.0;
		
		// scales (start/end)
		public var startScaleX:Number = 0.1;
		public var startScaleXRandom:Number = 0.25;
		
		public var endScaleX:Number = 1.0;
		public var endScaleXRandom:Number = 0.0;
		
		public var startScaleY:Number = 0.1;
		public var startScaleYRandom:Number = 0.25;
		
		public var endScaleY:Number = 1.0;
		public var endScaleYRandom:Number = 0.0;
		
		// colors
		public var startColor:Number = 0xFFFFFF;
		public var startColorRandom:Number = 0xFFFFFF;
		
		public var endColor:Number = 0x000000;
		public var endColorRandom:Number = 0x000000;
		
		public var ease:Function = Linear.easeNone;
		
		public function CloudParticleSystemPreset() 
		{
			
		}
		
	}

}