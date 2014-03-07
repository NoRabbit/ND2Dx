package benchmark.assets 
{
	import de.nulldesign.nd2dx.materials.texture.parser.AtlasParserSparrow;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Assets 
	{
		[Embed(source = "../../../import/atlas01.png")]
		public static var atlas01Bitmap:Class;
		
		[Embed(source = "../../../import/atlas01.xml", mimeType = "application/octet-stream")]
		public static var atlas01XML:Class;
		
		public static var bitmap:Bitmap;
		
		public static var atlas01Texture2D:Texture2D;
		
		public static function init():void
		{
			bitmap = new atlas01Bitmap() as Bitmap;
			
			atlas01Texture2D = TextureUtil.textureFromBitmapData(bitmap.bitmapData);
			atlas01Texture2D = TextureUtil.atlasTexture2DFromParser(atlas01Texture2D, new AtlasParserSparrow(XML(new atlas01XML())));
		}
		
	}

}