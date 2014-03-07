package com.rabbitframework.tween.properties.displayobject.movieclip 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyMcFrame extends PropertyMcBase
	{
		
		public function PropertyMcFrame(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		override public function init():void
		{
			mc = target as MovieClip;
			
			if ( startValue == null ) startValue = mc.currentFrame;
			if ( endValue == null ) endValue = startValue;
			
			start = startValue as Number;
			change = Number(endValue) - start;
		}
		
		override public function update(factor:Number):void
		{
			mc.gotoAndStop(int(start + change * factor)); 
		}
	}
	
}