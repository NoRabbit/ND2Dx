package de.nulldesign.nd2dx.resource.texture 
{
	import com.rabbitframework.events.AssetEvent;
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.assets.AssetUrlLoader;
	import de.nulldesign.nd2dx.resource.texture.parser.AtlasParserBase;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.resource.texture.parser.AtlasParserSparrow;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AtlasAllocator extends ResourceAllocatorBase
	{
		public var atlas:Atlas;
		
		public var textureObject:Object;
		public var texture:Texture2D;
		public var xml:XML;
		public var parserClass:Class;
		
		public function AtlasAllocator(xml:XML, texture:Object, parserClass:Class = null, freeLocalResourceAfterAllocated:Boolean = false) 
		{
			super(freeLocalResourceAfterAllocated);
			
			this.xml = xml;
			this.parserClass = parserClass;
			this.textureObject = texture;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( !texture && textureObject )
			{
				if ( textureObject is Texture2D )
				{
					texture = textureObject as Texture2D;
				}
				else if ( textureObject is String )
				{
					texture = resourceManager.getTextureById(textureObject as String);
				}
			}
			
			if ( texture && xml )
			{
				if ( !parserClass ) parserClass = AtlasParserSparrow;
				var parser:AtlasParserBase = new parserClass(xml);
				TextureUtil.transformTexture2DIntoAtlas(texture, parser);
				atlas.texture = texture;
				atlas.isLocallyAllocated = true;
				atlas.onLocallyAllocated.dispatch();
			}
			
			if ( atlas.isLocallyAllocated && freeLocalResourceAfterAllocated ) freeLocalResource();
		}
		
		override public function freeLocalResource():void 
		{
			xml = null;
			atlas.isLocallyAllocated = false;
		}
		
		override public function get resource():ResourceBase 
		{
			return super.resource;
		}
		
		override public function set resource(value:ResourceBase):void 
		{
			super.resource = value;
			atlas = value as Atlas;
		}
	}

}