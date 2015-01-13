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
	import flash.display3D.Context3D;
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
		
		public function AtlasAllocator(xml:XML, texture:Object, parserClass:Class = null, freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
			
			this.xml = xml;
			this.parserClass = parserClass;
			this.textureObject = texture;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( atlas.isAllocating ) return;
			
			if ( atlas.isLocallyAllocated && !forceAllocation )
			{
				// try to allocate it remotely
				allocateRemoteResource(null);
				
				return;
			}
			
			// try to allocate it remotely
			allocateRemoteResource(null);
			
			atlas.isLocallyAllocated = true;
			
			
		}
		
		override public function allocateRemoteResource(context:Context3D, forceAllocation:Boolean = false):void 
		{
			if ( atlas.isRemotelyAllocated && !forceAllocation ) return;
			
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
				atlas.isRemotelyAllocated = true;
				
				if ( atlas.isLocallyAllocated && freeLocalResourceAfterRemoteAllocation ) freeLocalResource();
			}
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