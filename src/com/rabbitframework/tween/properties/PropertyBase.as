package com.rabbitframework.tween.properties 
{
	import com.rabbitframework.tween.RabbitTween;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 */
	public class PropertyBase 
	{
		public var previousPropertyNode:PropertyBase = null;
		public var nextPropertyNode:PropertyBase = null;
		
		public var bRemoveOnComplete:Boolean = false;
		
		public var target:Object;
		public var property:String;
		public var startValue:Object;
		public var endValue:Object;
		
		public function PropertyBase(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			this.target = target;
			this.property = property;
			this.startValue = startValue;
			this.endValue = endValue;
		}
		
		public function init():void
		{
			
		}
		
		public function update(factor:Number):void
		{
			
		}
		
		public function removeProperty():void
		{
			
		}
		
	}
	
}