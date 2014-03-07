package com.rabbitframework.tween.properties.displayobject.movieclip 
{
	import com.rabbitframework.tween.properties.PropertyBase;
	import flash.display.MovieClip;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyMcBase extends PropertyBase
	{
		public var start:Number;
		public var change:Number;
		
		public var mc:MovieClip;
		
		public function PropertyMcBase(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			if ( startValue == null ) startValue = target[property];
			if ( endValue == null ) endValue = startValue;
			
			mc = target as MovieClip;
			
			start = startValue as Number;
			change = Number(endValue) - start;
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			
		}
	}
	
}