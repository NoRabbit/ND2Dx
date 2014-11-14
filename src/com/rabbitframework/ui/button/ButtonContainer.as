package com.rabbitframework.ui.button 
{
	import com.rabbitframework.ui.groups.Group;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.UIBase;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ButtonContainer extends Group
	{
		public var bg:Sprite;
		
		public var onMouseDown:Signal = new Signal(ButtonContainer);
		public var onMouseUp:Signal = new Signal(ButtonContainer);
		public var onMouseClick:Signal = new Signal(ButtonContainer);
		
		public function ButtonContainer() 
		{
			minUIWidth = 16.0;
			minUIHeight = 16.0;
			
			_paddingBottom = 4.0;
			_paddingLeft = 8.0;
			_paddingRight = 8.0;
			_paddingTop = 4.0;
			_spaceSize = 4.0;
			_isHorizontal = true;
			
			mouseEnabled = true;
			useHandCursor = true;
			buttonMode = true;
			mouseChildren = false;
		}
		
		override public function init():void 
		{
			super.init();
			
			bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
			
			eManager.add(this, MouseEvent.MOUSE_DOWN, _onMouseDownHandler, eGroup);
			eManager.add(this, MouseEvent.CLICK, _onMouseClickHandler, eGroup);
		}
		
		private function _onMouseDownHandler(e:MouseEvent):void 
		{
			eManager.add(stage, MouseEvent.MOUSE_UP, _onMouseUpHandler, [eGroup, eGroup + ".up"]);
			onMouseDownHandler(e);
			onMouseDown.dispatch(this);
		}
		
		private function _onMouseUpHandler(e:MouseEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".up");
			onMouseUpHandler(e);
			onMouseUp.dispatch(this);
		}
		
		private function _onMouseClickHandler(e:MouseEvent):void 
		{
			onClickHandler(e);
			onMouseClick.dispatch(this);
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