package com.rabbitframework.utils 
{
	import com.rabbitframework.debug.RabbitDebug;
	import com.rabbitframework.managers.events.EventsManager;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class XmlTimedParser
	{
		private var eManager:EventsManager = EventsManager.getInstance();
		private var eGroup:String;
		
		public var xmlList:XMLList;
		public var nodeName:String;
		public var currentIndex:int;
		
		public var timer:Timer = new Timer(50);
		
		public var selectHandler:Function;
		public var completeHandler:Function;
		
		public var aArgs:Array;
		
		public function XmlTimedParser() 
		{
			eGroup = eManager.getUniqueGroupId();
		}
		
		public function startParsingXml(xmlList:XMLList, nodeName:String, timerDelay:int = 100, selectHandler:Function = null, completeHandler:Function = null, ...args):void
		{
			eManager.removeAllFromGroup(eGroup);
			
			this.xmlList = xmlList;
			this.nodeName = nodeName;
			this.selectHandler = selectHandler;
			this.completeHandler = completeHandler;
			this.aArgs = args;
			
			currentIndex = -1;
			
			RabbitDebug.log("XmlTimedParser", "startParsingXml", nodeName, xmlList[nodeName].length());
			
			if ( xmlList[nodeName].length() <= 0 )
			{
				onComplete();
				return;
			}
			
			eManager.add(timer, TimerEvent.TIMER, timer_timerHandler, eGroup);
			
			timer.reset();
			timer.delay = timerDelay;
			
			getNextItem();
		}
		
		public function getNextItem():void
		{
			if ( currentIndex >= xmlList[nodeName].length() - 1 )
			{
				onComplete();
			}
			else
			{
				timer.start();
			}
		}
		
		private function timer_timerHandler(e:TimerEvent):void 
		{
			timer.stop();
			
			currentIndex++;
			
			var a:Array = new Array();
			a.push(xmlList[nodeName][currentIndex]);
			a.push(this);
			if ( aArgs ) a = a.concat(aArgs);
			
			selectHandler.apply(null, a);
		}
		
		public function onComplete():void
		{
			var a:Array = new Array();
			a.push(this);
			if ( aArgs ) a = a.concat(aArgs);
			
			completeHandler.apply(null, a);
			
			timer.stop();
		}
	}

}