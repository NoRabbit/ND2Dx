package com.rabbitframework.tween.core 
{
	import flash.events.EventDispatcher;
	import com.rabbitframework.events.DataObjectEvent;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2009.
	 */
	public class RabbitTweenCore extends EventDispatcher
	{
		public static const EVENT_DURATION_CHANGE:String = "rabbit.tween.core.eventDurationChange";
		public static const EVENT_DELAY_CHANGE:String = "rabbit.tween.core.eventDelayChange";
		
		// previous and next nodes -> linked list of tween cores for timeline
		public var prevTimelineNode:RabbitTweenCore = null;
		public var nextTimelineNode:RabbitTweenCore = null;
		
		protected var _target:Object;
		protected var _progress:Number = -1.0;
		protected var _duration:Number = -1.0;
		protected var currentDuration:Number = -1.0;
		protected var _totalDuration:Number = -1.0;
		protected var currentTotalDuration:Number = -1.0;
		protected var factor:Number = -1.0;
		protected var _delay:Number = -1.0;
		
		public function RabbitTweenCore() 
		{
			
		}
		
		public function get target():Object { return _target; }
		
		public function set target(value:Object):void 
		{
			_target = value;
		}
		
		public function setTarget(value:Object):RabbitTweenCore 
		{
			target = value;
			return this;
		}
		
		public function get progress():Number { return _progress; }
		
		public function set progress(value:Number):void 
		{
			_progress = value;
		}
		
		public function setProgress(value:Number):RabbitTweenCore 
		{
			progress = value;
			return this;
		}
		
		public function get duration():Number { return _duration * 0.001; }
		
		public function set duration(value:Number):void 
		{
			value *= 1000;
			if ( _duration == value ) return;
			var o:Object = { object:this, newValue:value, oldValue:_duration };
			_duration = value;
			calculateTotalDuration();
			dispatchEvent(new DataObjectEvent(EVENT_DURATION_CHANGE, "", o));
		}
		
		public function setDuration(value:Number):RabbitTweenCore 
		{
			duration = value;
			return this;
		}
		
		public function get delay():Number { return _delay * 0.001; }
		
		public function set delay(value:Number):void 
		{
			value *= 1000;
			if ( _delay == value ) return;
			var o:Object = { object:this, newValue:value, oldValue:_delay };
			_delay = value;
			dispatchEvent(new DataObjectEvent(EVENT_DELAY_CHANGE, "", o));
		}
		
		public function setDelay(value:Number):RabbitTweenCore 
		{
			delay = value;
			return this;
		}
		
		public function calculateTotalDuration():void
		{
			_totalDuration = _duration;
		}
		
		public function get totalDuration():Number { return _totalDuration * 0.001; }
		
		public function set totalDuration(value:Number):void 
		{
			_totalDuration = value;
		}
	}
	
}