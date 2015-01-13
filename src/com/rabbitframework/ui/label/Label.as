package com.rabbitframework.ui.label 
{
	import com.rabbitframework.ui.UIBase;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Label extends UIBase
	{
		public var txt:TextField;
		private var _autoSize:Boolean = false;
		
		public function Label(value:String = "") 
		{
			dataSource = value;
		}
		
		override public function init():void 
		{
			minUIHeight = 20.0;
		}
		
		override public function draw():void 
		{
			var tf:TextFormat = txt.getTextFormat();
			
			txt.autoSize = (tf.align ? tf.align : TextFormatAlign.LEFT);
			txt.x = 0.0;
			//txt.y = 0.0;
			
			if ( _autoSize )
			{
				uiWidth = txt.width;
			}
			else
			{
				txt.width = uiWidth;
			}
			
			//txt.height = uiHeight;
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
		}
		
		public function get autoSize():Boolean 
		{
			return _autoSize;
		}
		
		public function set autoSize(value:Boolean):void 
		{
			_autoSize = value;
			draw();
		}
	}

}