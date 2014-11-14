package de.nulldesign.nd2dx.utils 
{
	import com.rabbitframework.managers.events.EventsManager;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TextUtil 
	{
		public static var inputTextField:TextField;
		public static var inputTextFieldEGroup:String = "";
		public static var inputTextField_onInputCallback:Function = null;
		public static var inputTextField_onLostFocusCallback:Function = null;
		
		public static function setFocusOnInputTextField(stage:Stage, text:String = "", caretIndex:int = 0, onInputCallback:Function = null, onLostFocusCallback:Function = null):TextField
		{
			var eManager:EventsManager = EventsManager.getInstance();
			
			if ( !inputTextFieldEGroup ) inputTextFieldEGroup = eManager.getUniqueGroupId();
			
			if ( !inputTextField )
			{
				inputTextField = new TextField();
				//inputTextField.visible  = false;
				inputTextField.type = TextFieldType.INPUT;
				inputTextField.textColor = 0xffffff;
				inputTextField.border = true;
				inputTextField.x = 100.0;
				inputTextField.y = 300.0;
				inputTextField.width = 200.0;
				inputTextField.height = 50.0;
				stage.addChildAt(inputTextField, 0);
			}
			
			eManager.removeAllFromGroup(inputTextFieldEGroup);
			
			inputTextField_onInputCallback = onInputCallback;
			inputTextField_onLostFocusCallback = onLostFocusCallback;
			
			inputTextField.text = text;
			inputTextField.setSelection(caretIndex, caretIndex);
			inputTextField.needsSoftKeyboard = true;
			inputTextField.requestSoftKeyboard();
			
			eManager.add(inputTextField, Event.CHANGE, inputTextField_changeHandler, inputTextFieldEGroup);
			eManager.add(inputTextField, FocusEvent.FOCUS_OUT, inputTextField_focusOutHandler, inputTextFieldEGroup);
			
			return inputTextField;
		}
		
		static private function inputTextField_changeHandler(e:Event):void 
		{
			if ( inputTextField_onInputCallback ) inputTextField_onInputCallback.call();
		}
		
		static private function inputTextField_focusOutHandler(e:FocusEvent):void 
		{
			if ( inputTextField_onLostFocusCallback ) inputTextField_onLostFocusCallback.call();
			
			EventsManager.getInstance().removeAllFromGroup(inputTextFieldEGroup);
			inputTextField_onInputCallback = null;
			inputTextField_onLostFocusCallback = null;
		}
		
		public static function isAlphabetic(s:String):Boolean
		{
			var pattern:RegExp = /(A-Z)(a-z)/;
			return pattern.test(s);
		}
		
		// taken from http://snipplr.com/view/27807/
		public static function isNumeric(s:String):Boolean
		{
			var pattern:RegExp = /^[-+]?\d*\.?\d+(?:[eE][-+]?\d+)?$/;
			return pattern.test(s);
		}
		
		public static function isAlphaNumeric(s:String):Boolean
		{
			if ( isAlphabetic(s) || isNumeric(s) ) return true;
			return false;
		}
		
		// taken from http://snipplr.com/view/27807/
		public static function trim(s:String):String
		{
			return s.replace(/^\s+|\s+$/g, '');
		}
		
		// taken from http://snipplr.com/view/27807/
		public static function trimLeft(s:String):String
		{
			return s.replace(/^\s+/, '');
		}
		
		// taken from http://snipplr.com/view/27807/
		public static function trimRight(s:String):String
		{
			return s.replace(/\s+$/, '');
		}
		
		
	}

}