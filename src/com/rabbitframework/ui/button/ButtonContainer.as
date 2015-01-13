package com.rabbitframework.ui.button 
{
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.layout.UIHorizontalLayout;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ButtonContainer extends UIContainer
	{
		public var bg:Sprite;
		
		public var onMouseDown:Signal = new Signal();
		public var onMouseUp:Signal = new Signal();
		public var onMouseClick:Signal = new Signal();
		
		public function ButtonContainer() 
		{
		}
		
		override public function init():void 
		{
			super.init();
			
			minUIWidth = 16.0;
			minUIHeight = 16.0;
			
			_paddingBottom = 4.0;
			_paddingLeft = 8.0;
			_paddingRight = 8.0;
			_paddingTop = 4.0;
			_itemSpace = 4.0;
			
			_layout = UIHorizontalLayout.reference;
			
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
			
			bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
			
			eManager.add(this, MouseEvent.MOUSE_DOWN, _onMouseDownHandler, eGroup);
			eManager.add(this, MouseEvent.CLICK, _onMouseClickHandler, eGroup);
		}
		
		private function _onMouseDownHandler(e:MouseEvent):void 
		{
			eManager.add(stage, MouseEvent.MOUSE_UP, _onMouseUpHandler, [eGroup, eGroup + ".up"]);
			onMouseDownHandler(e);
			onMouseDown.dispatchData(this);
		}
		
		private function _onMouseUpHandler(e:MouseEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".up");
			onMouseUpHandler(e);
			onMouseUp.dispatchData(this);
		}
		
		private function _onMouseClickHandler(e:MouseEvent):void 
		{
			onClickHandler(e);
			onMouseClick.dispatchData(this);
		}
		
		protected function onMouseDownHandler(e:MouseEvent):void 
		{
			bg.getChildAt(0).transform.colorTransform = UIStyles.getHighlightColorTransform();
		}
		
		protected function onMouseUpHandler(e:MouseEvent):void 
		{
			bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
		}
		
		protected function onClickHandler(e:MouseEvent):void
		{
			
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			super.draw();
			
			if ( uiWidth < bg.width ) uiWidth = bg.width;
			if ( uiHeight < bg.height ) uiHeight = bg.height;
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