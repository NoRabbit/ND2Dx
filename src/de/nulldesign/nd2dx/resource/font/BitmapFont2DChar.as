package de.nulldesign.nd2dx.resource.font 
{
	import de.nulldesign.nd2dx.display.Sprite2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DChar 
	{
		public var char:String = "";
		public var positionX:Number = 0.0;
		public var glyph:BitmapFont2DGlyph = null;
		
		public var index:int = -1;
		public var sprite2D:Sprite2D;
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		public var lineY:Number = 0.0;
		
		public function BitmapFont2DChar() 
		{
			
		}
		
	}

}