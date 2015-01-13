package com.rabbitframework.ui.checkbox 
{
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.button.Button;
	import com.rabbitframework.ui.styles.UIStyles;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class CheckBox extends Button
	{
		public var icon:Sprite;
		
		private var _selected:Boolean = false;
		
		public var onSelect:Signal = new Signal();
		
		public function CheckBox() 
		{
			icon.visible = false;
			icon.mouseChildren = icon.mouseEnabled = false;
		}
		
		override public function initFromPool():void 
		{
			super.initFromPool();
			
			selected = false;
			uiWidth = minUIWidth = 14.0;
			uiHeight = minUIHeight = 14.0;
		}
		
		override public function draw():void 
		{
			bg.width = bg.height = uiHeight;
			icon.x = icon.y = uiHeight * 0.5;
		}
		
		override protected function onMouseDownHandler(e:MouseEvent):void 
		{
			bg.getChildAt(0).transform.colorTransform = UIStyles.getSelectHighlightColorTransform();
		}
		
		override protected function onMouseUpHandler(e:MouseEvent):void 
		{
			bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
		}
		
		override protected function onClickHandler(e:MouseEvent):void 
		{
			selected = !selected;
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if ( _selected == value ) return;
			
			_selected = value;
			
			if ( _selected )
			{
				icon.visible = true;
			}
			else
			{
				icon.visible = false;
			}
			
			onSelect.dispatchData(_selected);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			
			onSelect.removeAll();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			onSelect.removeAll();
			onSelect = null;
		}
	}

}