package de.nulldesign.nd2dx.resource.font 
{
	import de.nulldesign.nd2dx.display.Sprite2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DItemIcon extends BitmapFont2DItem
	{
		public var texture:Texture2D;
		
		// (width already exists in sub class)
		public var height:Number = 0.0;
		
		public var paddingLeft:Number = 0.0;
		public var paddingRight:Number = 0.0;
		public var paddingTop:Number = 0.0;
		public var paddingBottom:Number = 0.0;
		
		public function BitmapFont2DItemIcon() 
		{
			
		}
		
	}

}