package de.nulldesign.nd2dx.fsm.actions 
{
	import com.rabbitframework.easing.Linear;
	import de.nulldesign.nd2dx.fsm.FSMStateAction;
	import de.nulldesign.nd2dx.fsm.FSMEvent;
	import de.nulldesign.nd2dx.utils.FSMTargetUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TweenNumberAction extends FSMStateAction
	{
		public var target:Object;
		public var property:String = "";
		public var originalFrom:Number = 0.0;
		public var from:Number = 0.0;
		public var originalTo:Number = 0.0;
		public var to:Number = 0.0;
		public var duration:Number = 0.0;
		public var delay:Number = 0.0;
		public var ease:Function = Linear.easeNone;
		public var yoyo:int = 0;
		public var sendEvent:FSMEvent;
		
		private var targetObject:Object;
		private var currentDuration:Number = 0.0;
		private var currentDurationWithDelay:Number = 0.0;
		private var progress:Number = 0.0;
		private var currentValue:Number = 0.0;
		private var currentYoyoCountLeft:int = 0;
		
		public function TweenNumberAction(target:Object = null, property:String = "", from:Number = 0.0, to:Number = 0.0, duration:Number = 0.0, delay:Number = 0.0, sendEvent:FSMEvent = null, ease:Function = null, yoyo:int = 0) 
		{
			this.target = target;
			this.property = property;
			this.originalFrom = from;
			this.originalTo = to;
			this.duration = duration;
			this.delay = delay;
			this.sendEvent = sendEvent;
			if( ease != null ) this.ease = ease;
			this.yoyo = yoyo;
		}
		
		override public function onActivate():void 
		{
			targetObject = FSMTargetUtil.getTargetObject(target, this);
			
			from = originalFrom;
			to = originalTo;
			currentDuration = 0.0;
			currentValue = from;
			currentYoyoCountLeft = yoyo;
		}
		
		override public function step(elapsed:Number):void 
		{
			currentDuration += elapsed;
			currentDurationWithDelay = currentDuration - delay;
			if ( currentDurationWithDelay < 0.0 ) currentDurationWithDelay = 0.0;
			if ( currentDurationWithDelay > duration ) currentDurationWithDelay = duration;
			
			progress = ease(currentDurationWithDelay, 0, 1, duration);
			currentValue = from + (to - from) * progress;
			
			targetObject[property] = currentValue;
			
			if ( currentDurationWithDelay >= duration )
			{
				// check first if we have yoyo
				if ( currentYoyoCountLeft > 0 )
				{
					// inverse values
					var tmp:Number = from;
					from = to;
					to = tmp;
					
					// reset current duration
					currentDuration = 0.0;
					
					currentYoyoCountLeft--;
				}
				else if ( sendEvent )
				{
					dispatchEvent(sendEvent);
				}
				
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			target = null;
			targetObject = null;
			ease = null;
			sendEvent = null;
		}
	}

}