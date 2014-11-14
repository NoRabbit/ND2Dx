package com.rabbitframework.ui.tabbedbuttonsview 
{
	import com.rabbitframework.ui.button.ButtonText;
	import com.rabbitframework.ui.styles.UIStyles;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TabbedButton extends ButtonText
	{
		private var _selected:Boolean = false;
		
		public function TabbedButton() 
		{
			
		}
		
		override protected function onMouseDownHandler(e:MouseEvent):void 
		{
			//if ( !_selected ) bg.getChildAt(0).transform.colorTransform = UIStyles.getSelectHighlightColorTransform();
			if ( !_selected ) bg.getChildAt(0).transform.colorTransform = UIStyles.getHighlightColorTransform();
		}
		
		override protected function onMouseUpHandler(e:MouseEvent):void 
		{
			if ( !_selected ) bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
		}
		
		override protected function onClickHandler(e:MouseEvent):void 
		{
			
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			_selected = value;
			
			if ( _selected )
			{
				bg.getChildAt(0).transform.colorTransform = UIStyles.getHighlightColorTransform();
			}
			else
			{
				bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
			}
		}
	}

}