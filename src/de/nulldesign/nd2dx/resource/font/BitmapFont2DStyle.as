package de.nulldesign.nd2dx.resource.font 
{
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class BitmapFont2DStyle extends ResourceBase
	{
		public var name:String = "";
		
		public var texture:Texture2D;
		
		public var face:String = "";
		public var size:uint = 0;
		public var bold:Boolean = false;
		public var italic:Boolean = false;
		public var charset:String = "";
		public var unicode:Boolean = false;
		public var stretchH:int = 0;
		public var smooth:int = 0;
		public var aa:int = 0;
		public var paddingUp:Number = 0.0;
		public var paddingRight:Number = 0.0;
		public var paddingDown:Number = 0.0;
		public var paddingLeft:Number = 0.0;
		public var spacingHorizontal:Number = 0.0;
		public var spacingVertical:Number = 0.0;
		public var outline:Boolean = false;
		public var lineHeight:Number = 0.0;
		public var base:Number = 0.0;
		public var scaleW:Number = 0.0;
		public var scaleH:Number = 0.0;
		
		public var scaleFactor:Number = 1.0;
		
		public var dIdForGlyph:Dictionary = new Dictionary();
		
		public function BitmapFont2DStyle(allocator:ResourceAllocatorBase, name:String = "") 
		{
			super(allocator);
			this.name = name;
		}
		
		public function getGlyphForId(id:uint):BitmapFont2DGlyph
		{
			if ( dIdForGlyph[id] ) return dIdForGlyph[id];
			return null;
		}
		
	}

}