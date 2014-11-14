package com.rabbitframework.ui.inputtext 
{
	import com.rabbitframework.ui.UIBase;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class InputText extends UIBase
	{
		public var bg:Sprite;
		public var txt:TextField;
		
		public var onChange:Signal = new Signal(String);
		
		public function InputText(value:String = "") 
		{
			dataSource = value;
			setSize(100, 20);
		}
		
		override public function init():void 
		{
			super.init();
			
			minUIWidth = 20.0;
			minUIHeight = 20.0;
			
			eManager.add(txt, Event.CHANGE, txt_changeHandler, eGroup);
		}
		
		protected function txt_changeHandler(e:Event):void 
		{
			onChange.dispatch(txt.text);
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
			onChange.dispatch(txt.text);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			onChange.removeAll();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			bg = null;
			txt = null;
			onChange.removeAll();
			onChange = null;
		}
	}

}