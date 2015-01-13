package com.rabbitframework.ui.icon 
{
	import com.rabbitframework.ui.UIBase;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Icon extends UIBase
	{
		public var bitmap:Bitmap;
		
		public function Icon() 
		{
			
		}
		
		override public function init():void 
		{
			super.init();
			
			_horizontalAlign = UIBase.HORIZONTAL_ALIGN_CENTER;
			_verticalAlign = UIBase.VERTICAL_ALIGN_MIDDLE;
		}
		
		override public function draw():void 
		{
			if ( bitmap ) bitmap.visible = false;
			if ( !_dataSource ) return;
			
			var bitmapData:BitmapData = dataProviderManager.getDataSourceIcon(_dataSource);
			
			if ( bitmapData )
			{
				if ( !bitmap )
				{
					bitmap = new Bitmap();
					addChild(bitmap);
				}
				
				bitmap.bitmapData = bitmapData;
				bitmap.smoothing = true;
				bitmap.width = uiWidth;
				bitmap.height = uiHeight;
				
				if ( bitmap.scaleX > 1.0 ) bitmap.scaleX = 1.0;
				if ( bitmap.scaleY > 1.0 ) bitmap.scaleY = 1.0;
				
				bitmap.x = Math.round((uiWidth - bitmap.width) * 0.5);
				bitmap.y = Math.round((uiHeight - bitmap.height) * 0.5);
				
				bitmap.visible = true;
				
				this.cacheAsBitmap = true;
			}
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			if ( value == _dataSource ) return;
			super.dataSource = value;
			draw();
		}
	}

}