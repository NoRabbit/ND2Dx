package showdown.assets 
{
	import de.nulldesign.nd2dx.managers.resource.ResourceDescriptor;
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DStyle;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DStyleAllocator;
	import de.nulldesign.nd2dx.resource.shader.Shader2D;
	import de.nulldesign.nd2dx.resource.shader.Shader2DAllocator;
	import de.nulldesign.nd2dx.resource.shader.Shader2DXMLAllocator;
	import de.nulldesign.nd2dx.resource.texture.AnimatedTexture2D;
	import de.nulldesign.nd2dx.resource.texture.AnimatedTexture2DAllocator;
	import de.nulldesign.nd2dx.resource.texture.Atlas;
	import de.nulldesign.nd2dx.resource.texture.AtlasAllocator;
	import de.nulldesign.nd2dx.resource.texture.AtlasSlicedNode2D;
	import de.nulldesign.nd2dx.resource.texture.AtlasSlicedNode2DAllocator;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2DBitmapClassAllocator;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Assets 
	{
		[Embed(source="../../../assets/nd2dx/logo.png")]
		public static var logoData:Class;
		
		[Embed(source="../../../assets/nd2dx/assets.png")]
		public static var assetsData:Class;
		
		[Embed(source = "../../../assets/nd2dx/assets.xml", mimeType = "application/octet-stream")]
		public static var assetsXMLData:Class;
		
		[Embed(source="../../../assets/nd2dx/shaderPixelDeformation.xml", mimeType = "application/octet-stream")]
		public static var shaderXMLData:Class;
		
		[Embed(source = "../../../assets/nd2dx/art01.png")]
		public static var art01Data:Class;
		
		[Embed(source = "../../../assets/nd2dx/noise01.png")]
		public static var noise01Data:Class;
		
		public static var logo:Bitmap;
		
		public static var assetsTexture:Texture2D;
		public static var assetsAtlas:Atlas;
		
		public static var art01Texture:Texture2D;
		public static var noise01Texture:Texture2D;
		
		public static var buttonBlue01:AtlasSlicedNode2D;
		public static var tooltipSmall:AtlasSlicedNode2D;
		public static var toolbarvBlue01:AtlasSlicedNode2D;
		public static var panel01:AtlasSlicedNode2D;
		
		public static var animatedTexture2DMeteor:AnimatedTexture2D;
		
		public static var shaderXML:XML;
		public static var shaderDynamic:Shader2D;
		
		public static function init():void
		{
			var resourceManager:ResourceManager = ResourceManager.getInstance();
			
			logo = new logoData() as Bitmap;
			
			// create textures
			assetsTexture = resourceManager.createResource(ResourceDescriptor.BITMAP_TEXTURE, new Texture2DBitmapClassAllocator(assetsData), "assets") as Texture2D;
			art01Texture = resourceManager.createResource(ResourceDescriptor.BITMAP_TEXTURE, new Texture2DBitmapClassAllocator(art01Data), "art01") as Texture2D;
			noise01Texture = resourceManager.createResource(ResourceDescriptor.BITMAP_TEXTURE, new Texture2DBitmapClassAllocator(noise01Data), "noise01") as Texture2D;
			
			// create atlas from texture
			assetsAtlas = resourceManager.createResource(ResourceDescriptor.TEXTURE_ATLAS, new AtlasAllocator(new XML(new assetsXMLData()), "assets"), "assetsAtlas") as Atlas;
			
			// create sliced texture
			buttonBlue01 = resourceManager.createResource(ResourceDescriptor.TEXTURE_ATLAS_SLICED_NODE2D, new AtlasSlicedNode2DAllocator("assets.button_blue01", 0.36, 0.78), "buttonBlue01") as AtlasSlicedNode2D;
			tooltipSmall = resourceManager.createResource(ResourceDescriptor.TEXTURE_ATLAS_SLICED_NODE2D, new AtlasSlicedNode2DAllocator("assets.tooltip_small", 0.15, 0.64, 0.25, 0.64, TextureUtil.SLICE_TYPE_9), "tooltipSmall") as AtlasSlicedNode2D;
			toolbarvBlue01 = resourceManager.createResource(ResourceDescriptor.TEXTURE_ATLAS_SLICED_NODE2D, new AtlasSlicedNode2DAllocator("assets.toolbarv_blue01", 0.0, 0.0, 0.36, 0.65, TextureUtil.SLICE_TYPE_3_VERTICAL), "toolbarvBlue01") as AtlasSlicedNode2D;
			panel01 = resourceManager.createResource(ResourceDescriptor.TEXTURE_ATLAS_SLICED_NODE2D, new AtlasSlicedNode2DAllocator("assets.panel01", 0.27, 0.80, 0.36, 0.71, TextureUtil.SLICE_TYPE_9), "panel01") as AtlasSlicedNode2D;
			
			animatedTexture2DMeteor = TextureUtil.generateAnimatedTexture2DDataFromFrameNames(new AnimatedTexture2D(), TextureUtil.getTexture2DResourceIdArrayFromFrameName(assetsTexture, "meteor_short_"));
			
			shaderXML = new XML(new shaderXMLData());
			shaderDynamic = resourceManager.createResource(ResourceDescriptor.SHADER, new Shader2DXMLAllocator(shaderXML), "shaderDynamic") as Shader2D;
		}
		
	}

}
