package de.nulldesign.nd2dx.text 
{
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import flash.display.BitmapData;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class BitmapFont2DStyleManager 
	{
		private static var instance:BitmapFont2DStyleManager = new BitmapFont2DStyleManager();
		
		public function BitmapFont2DStyleManager() 
		{
			if ( instance ) throw new Error( "BitmapFont2DStyleManager can only be accessed through BitmapFont2DStyleManager.getInstance()" );
			
		}
		
		public static function getInstance():BitmapFont2DStyleManager 
		{
			return instance;
		}
		
		public var vStyles:Vector.<BitmapFont2DStyle> = new Vector.<BitmapFont2DStyle>();
		
		public function createStyle(name:String, texture2D:Texture2D, xml:XML):BitmapFont2DStyle
		{
			// check if a style with the same name already exists
			if ( getStyleByName(name) ) return null;
			
			var bitmapFont2DStyle:BitmapFont2DStyle = new BitmapFont2DStyle(name, texture2D, xml);
			vStyles.push(bitmapFont2DStyle);
			
			return bitmapFont2DStyle;
		}
		
		public function getStyleByName(name:String):BitmapFont2DStyle
		{
			var i:int = 0;
			var n:int = vStyles.length;
			
			for (; i < n; i++) 
			{
				if ( vStyles[i].name == name ) return vStyles[i];
			}
			
			return null;
		}
	}
	
}