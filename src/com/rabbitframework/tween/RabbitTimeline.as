package com.rabbitframework.tween 
{
	import flash.events.Event;
	import com.rabbitframework.events.DataObjectEvent;
	import com.rabbitframework.tween.core.RabbitTweenCore;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2009.
	 */
	public class RabbitTimeline extends RabbitTweenCore
	{
		public var firstTimelineNode:RabbitTweenCore = null;
		public var lastTimelineNode:RabbitTweenCore = null;
		public var currentTimelineNode:RabbitTweenCore = null;
		
		public function RabbitTimeline() 
		{
			
		}
		
		public function addChild(child:RabbitTweenCore):RabbitTimeline
		{
			// add it to the linked list
			if ( lastTimelineNode )
			{
				lastTimelineNode.nextTimelineNode = child;
				child.prevTimelineNode = lastTimelineNode;
				lastTimelineNode = child;
			}
			else
			{
				firstTimelineNode = lastTimelineNode = child;
			}
			
			if ( child.totalDuration + child.delay > duration )
			{
				duration = child.totalDuration + child.delay;
			}
			
			child.addEventListener(RabbitTweenCore.EVENT_DURATION_CHANGE, child_durationAndDelayChangeHandler);
			child.addEventListener(RabbitTweenCore.EVENT_DELAY_CHANGE, child_durationAndDelayChangeHandler);
			
			return this;
		}
		
		private function child_durationAndDelayChangeHandler(e:DataObjectEvent):void 
		{
			//var child:RabbitTweenCore = e.object.object as RabbitTweenCore;
			
			//if ( child.totalDuration + child.delay > duration )
			//{
				calculateDuration();
			//}
		}
		
		public function removeChild(child:RabbitTweenCore):RabbitTimeline
		{
			// remove it from linked list
			if ( child.prevTimelineNode ) child.prevTimelineNode.nextTimelineNode = child.nextTimelineNode;
			if ( child.nextTimelineNode ) child.nextTimelineNode.prevTimelineNode = child.prevTimelineNode;
			
			if ( firstTimelineNode == child ) firstTimelineNode = child.nextTimelineNode;
			if ( lastTimelineNode == child ) lastTimelineNode = child.prevTimelineNode;
			
			child.prevTimelineNode = null;
			child.nextTimelineNode = null;
			
			child.removeEventListener(RabbitTweenCore.EVENT_DURATION_CHANGE, child_durationAndDelayChangeHandler);
			child.removeEventListener(RabbitTweenCore.EVENT_DELAY_CHANGE, child_durationAndDelayChangeHandler);
			
			if ( child.duration + child.delay > duration )
			{
				calculateDuration();
			}
			
			return this;
		}
		
		public function removeAllChildren():RabbitTimeline
		{
			currentTimelineNode = firstTimelineNode = lastTimelineNode = null;
			return this;
		}
		
		public function calculateDuration():void
		{
			currentTimelineNode = firstTimelineNode;
			
			_duration = 0.0;
			
			var d:Number = 0.0;
			
			while ( currentTimelineNode )
			{
				// use of next in case of current node gets removed
				nextTimelineNode = currentTimelineNode.nextTimelineNode;
				
				if ( currentTimelineNode.totalDuration + currentTimelineNode.delay > d )
				{
					d = currentTimelineNode.totalDuration + currentTimelineNode.delay;
				}
				
				currentTimelineNode = nextTimelineNode;
			}
			
			duration = d;
			
		}
		
		override public function get progress():Number { return _progress; }
		
		override public function set progress(value:Number):void 
		{
			if ( value == _progress ) return;
			
			_progress = value;
			
			currentDuration = _progress * duration;
			
			currentTimelineNode = lastTimelineNode;
			
			while ( currentTimelineNode )
			{
				// use of next in case of current node gets removed
				nextTimelineNode = currentTimelineNode.prevTimelineNode;
				
				if ( currentDuration < currentTimelineNode.delay )
				{
					// set it to its start
					currentTimelineNode.progress = 0.0;
				}
				else if ( currentDuration > currentTimelineNode.totalDuration + currentTimelineNode.delay )
				{
					// set it to its end
					currentTimelineNode.progress = 1.0;
				}
				else
				{
					//if( currentTimelineNode.target ) dTargets[currentTimelineNode.target] = true;
					currentTimelineNode.progress = (currentDuration - currentTimelineNode.delay) / currentTimelineNode.totalDuration;
				}
				
				currentTimelineNode = nextTimelineNode;
			}
			
		}
	}
	
}