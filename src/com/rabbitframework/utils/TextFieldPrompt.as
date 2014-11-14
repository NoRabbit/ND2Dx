package com.rabbitframework.utils 
{
	import flash.events.FocusEvent;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TextFieldPrompt 
	{
		public var textField:TextField;
		public var prompt:String;
		
		public function TextFieldPrompt(textField:TextField, prompt:String) 
		{
			this.textField = textField;
			this.prompt = prompt;
			
			textField.addEventListener(FocusEvent.FOCUS_IN, textField_focusInHandler);
			textField.addEventListener(FocusEvent.FOCUS_OUT, textField_focusOutHandler);
			
			//textField_focusOutHandler(null);
		}
		
		private function textField_focusInHandler(e:FocusEvent):void 
		{
			if ( textField.text == "" || textField.text == prompt )
			{
				textField.text = "";
				//textField.alpha = 1.0;
			}
		}
		
		private function textField_focusOutHandler(e:FocusEvent):void 
		{
			if ( !textField.text || textField.length <= 0 )
			{
				textField.text = prompt;
				//textField.alpha = 1.0;
			}
		}
		
		public function setPrompt(prompt:String):void
		{
			if ( textField.text == this.prompt )
			{
				textField.text = prompt;
			}
			
			this.prompt = prompt;
		}
		
		public function setToPromptState():void
		{
			textField.text = prompt;
		}
		
		public static function setTextFieldPromp(textField:TextField, prompt:String):TextFieldPrompt
		{
			return new TextFieldPrompt(textField, prompt);
		}
		
	}

}