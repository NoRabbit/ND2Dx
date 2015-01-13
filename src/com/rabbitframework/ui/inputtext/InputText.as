package com.rabbitframework.ui.inputtext 
{
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.UIBase;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.text.TextField;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class InputText extends UIBase
	{
		public var bg:Sprite;
		public var txt:TextField;
		
		public var previousValue:String;
		
		public function InputText(value:String = "") 
		{
			dataSource = value;
		}
		
		override public function init():void 
		{
			super.init();
			
			minUIWidth = 20.0;
			minUIHeight = 20.0;
			
			eManager.add(txt, Event.CHANGE, txt_changeHandler, eGroup);
			eManager.add(txt, FocusEvent.FOCUS_IN, txt_focusInHandler, eGroup);
			eManager.add(txt, FocusEvent.FOCUS_OUT, txt_focusOutHandler, eGroup);
			eManager.add(txt, KeyboardEvent.KEY_DOWN, txt_keyDownHandler, eGroup);
		}
		
		protected function txt_changeHandler(e:Event):void 
		{
			onChange.dispatchData(txt.text);
		}
		
		private function txt_focusInHandler(e:FocusEvent):void 
		{
			previousValue = txt.text;
			onChangeStart.dispatchData(previousValue);
		}
		
		private function txt_focusOutHandler(e:FocusEvent):void 
		{
			if ( txt.text != previousValue )
			{
				// send a change complete event
				onChangeComplete.dispatchData(txt.text);
			}
			else
			{
				onChangeCancel.dispatchData(previousValue);
			}
		}
		
		private function txt_keyDownHandler(e:KeyboardEvent):void 
		{
			if ( e.keyCode == Keyboard.ESCAPE )
			{
				// cancel text modification
				txt.text = previousValue;
				stage.focus = null;
				onChange.dispatchData(previousValue);
				onChangeCancel.dispatchData(previousValue);
			}
			else if ( e.keyCode == Keyboard.ENTER )
			{
				// send a change complete event
				onChangeComplete.dispatchData(txt.text);
			}
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			txt.width = uiWidth - 4;
			txt.x = 2;
			txt.y = Math.round((uiHeight - txt.height) * 0.5) + 1;
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
			
			txt.text = dataProviderManager.getDataSourceLabel(_dataSource);
			onChange.dispatchData(txt.text);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			bg = null;
			txt = null;
		}
	}

}