package com.rabbitframework.ui.button 
{
	import com.rabbitframework.signals.Signal;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ButtonDrag extends Button
	{
		public var rectDrag:Rectangle = new Rectangle();
		
		public var onStartDrag:Signal = new Signal();
		public var onStopDrag:Signal = new Signal();
		
		public function ButtonDrag() 
		{
			
		}
		
		override protected function onMouseDownHandler(e:MouseEvent):void 
		{
			super.onMouseDownHandler(e);
			startDrag(false, rectDrag);
			onStartDrag.dispatchData(this);
		}
		
		override protected function onMouseUpHandler(e:MouseEvent):void 
		{
			super.onMouseUpHandler(e);
			stopDrag();
			onStopDrag.dispatchData(this);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			onStartDrag.removeAll();
			onStopDrag.removeAll();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			onStartDrag.removeAll();
			onStopDrag.removeAll();
			onStartDrag = null;
			onStopDrag = null;
			rectDrag = null;
		}
	}

}