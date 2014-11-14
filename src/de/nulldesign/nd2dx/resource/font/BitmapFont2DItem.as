package de.nulldesign.nd2dx.resource.font 
{
	import de.nulldesign.nd2dx.display.Sprite2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DItem 
	{
		public var width:Number = 0.0;
		public var totalWidth:Number = 0.0;
		
		public var style:BitmapFont2DStyle;
		public var tintRed:Number = 1.0;
		public var tintGreen:Number = 1.0;
		public var tintBlue:Number = 1.0;
		public var tintAlpha:Number = 1.0;
		
		public var index:int = -1;
		public var sprite2D:Sprite2D;
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		public var lineY:Number = 0.0;
		
		public function BitmapFont2DItem() 
		{
			
		}
		
	}

}