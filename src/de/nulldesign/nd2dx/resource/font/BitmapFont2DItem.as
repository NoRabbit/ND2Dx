package de.nulldesign.nd2dx.resource.font 
{
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DItem 
	{
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		
		public var width:Number = 0.0;
		public var height:Number = 0.0;
		
		public var texture:Texture2D;
		
		public var style:BitmapFont2DStyle;
		public var tintRed:Number = 1.0;
		public var tintGreen:Number = 1.0;
		public var tintBlue:Number = 1.0;
		public var tintAlpha:Number = 1.0;
		
		public var index:int = -1;
		
		public var lineY:Number = 0.0;
		
		public var xInText:Number = 0.0;
		public var yInText:Number = 0.0;
		
		public function BitmapFont2DItem() 
		{
			
		}
		
	}

}