package de.nulldesign.nd2dx.resource.font 
{
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DGlyph 
	{
		public var id:uint = 0;
		public var bitmapRect:Rectangle = new Rectangle(0.0, 0.0, 0.0, 0.0);
		public var offsetX:Number = 0.0;
		public var offsetY:Number = 0.0;
		public var advanceX:Number = 0.0;
		
		public var texture:Texture2D;
		
		public var dGlyphIdToAmount:Dictionary = new Dictionary();
		
		public function BitmapFont2DGlyph() 
		{
			
		}
		
		public function getAmountForGlyphId(id:uint):Number
		{
			if ( dGlyphIdToAmount[id] ) return dGlyphIdToAmount[id];
			return 0.0;
		}
	}

}