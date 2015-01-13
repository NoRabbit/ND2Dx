package com.rabbitframework.ui.button 
{
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.UIBase;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Button extends UIBase
	{
		public var bg:Sprite;
		
		public var onMouseDown:Signal = new Signal();
		public var onMouseUp:Signal = new Signal();
		public var onMouseClick:Signal = new Signal();
		
		public function Button() 
		{
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
		}
		
		override public function init():void 
		{
			super.init();
			
			if( bg ) bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
			
			eManager.add(this, MouseEvent.MOUSE_DOWN, _onMouseDownHandler, eGroup);
			eManager.add(this, MouseEvent.CLICK, _onMouseClickHandler, eGroup);
		}
		
		private function _onMouseDownHandler(e:MouseEvent):void 
		{
			eManager.add(stage, MouseEvent.MOUSE_UP, _onMouseUpHandler, [eGroup, eGroup + ".up"]);
			onMouseDownHandler(e);
			onMouseDown.dispatch();
		}
		
		private function _onMouseUpHandler(e:MouseEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".up");
			onMouseUpHandler(e);
			onMouseUp.dispatch();
		}
		
		private function _onMouseClickHandler(e:MouseEvent):void 
		{
			onClickHandler(e);
			onMouseClick.dispatch();
		}
		
		protected function onMouseDownHandler(e:MouseEvent):void 
		{
			if( bg ) bg.getChildAt(0).transform.colorTransform = UIStyles.getHighlightColorTransform();
		}
		
		protected function onMouseUpHandler(e:MouseEvent):void 
		{
			if( bg ) bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
		}
		
		protected function onClickHandler(e:MouseEvent):void
		{
			
		}
		
		override public function draw():void 
		{
			if ( bg ) 
			{
				bg.width = uiWidth;
				bg.height = uiHeight;
			}
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			onMouseDown.removeAll();
			onMouseUp.removeAll();
			onMouseClick.removeAll();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			onMouseDown.removeAll();
			onMouseUp.removeAll();
			onMouseClick.removeAll();
			onMouseDown = null;
			onMouseUp = null;
			onMouseClick = null;
			bg = null;
		}
	}

}