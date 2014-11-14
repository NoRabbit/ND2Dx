package com.rabbitframework.ui.button 
{
	import flash.display.Sprite;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ButtonText extends Button
	{
		public var txt:TextField;
		
		public function ButtonText(dataSource:Object = null) 
		{
			txt.mouseEnabled = false;
			
			this.dataSource = dataSource;
			
			minUIWidth = 20.0;
			minUIHeight = 20.0;
			
			setSize(100, 24);
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			txt.width = uiWidth;
			txt.x = 0;
			txt.y = Math.round((uiHeight - txt.height) * 0.5);
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
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			txt = null;
		}
	}

}