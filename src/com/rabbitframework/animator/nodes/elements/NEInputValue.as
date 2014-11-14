package com.rabbitframework.animator.nodes.elements 
{
	import com.rabbitframework.animator.style.RAStyle;
	import com.rabbitframework.utils.StringUtils;
	import flash.events.Event;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class NEInputValue extends NodeElementSprite
	{
		public var txt:TextField;
		
		public function NEInputValue() 
		{
			txt.text = StringUtils.generateRandomString(Math.round(Math.random() * 3), "0123456789") + ".0";
			txt.addEventListener(Event.CHANGE, txt_changeHandler);
			elementWidth = RAStyle.ELEMENT_INPUT_VALUE_MIN_WIDTH;
		}
		
		private function txt_changeHandler(e:Event):void 
		{
			dispatchEvent(e);
		}
		
		public function get value():Number 
		{
			return Number(txt.text);
		}
		
		public function set value(value:Number):void 
		{
			txt.text = value.toString();
		}
		
		override public function set elementWidth(value:Number):void 
		{
			if ( value == _elementWidth ) return;
			if ( value < RAStyle.ELEMENT_INPUT_VALUE_MIN_WIDTH ) value = RAStyle.ELEMENT_INPUT_VALUE_MIN_WIDTH;
			super.elementWidth = value;
			txt.width = elementWidth - 8;
		}
	}

}