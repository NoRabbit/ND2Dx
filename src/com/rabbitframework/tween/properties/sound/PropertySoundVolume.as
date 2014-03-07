package com.rabbitframework.tween.properties.sound 
{
	import flash.media.SoundTransform;
	import com.rabbitframework.tween.properties.PropertyBase;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2009.
	 */
	public class PropertySoundVolume extends PropertyBase
	{
		private var soundTransform:SoundTransform = new SoundTransform();
		
		public var start:Number;
		public var change:Number;
		
		public function PropertySoundVolume(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			if ( startValue == null ) startValue = target.soundTransform.volume;
			if ( endValue == null ) endValue = startValue;
			
			start = startValue as Number;
			change = Number(endValue) - start;
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			soundTransform.volume = startValue + change * factor;
			target.soundTransform = soundTransform;
		}
		
	}
	
}