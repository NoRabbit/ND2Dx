package de.nulldesign.nd2dx.managers.resource 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import com.rabbitframework.managers.assets.AssetLoader;
	import com.rabbitframework.managers.events.EventsManager;
	import com.rabbitframework.signals.RabbitSignal;
	import com.rabbitframework.utils.StringUtils;
	import de.nulldesign.nd2dx.components.renderers.ParticleSystem2DRendererComponent;
	import de.nulldesign.nd2dx.materials.ParticleSystem2DMaterial;
	import de.nulldesign.nd2dx.materials.Texture2DMaterial;
	import de.nulldesign.nd2dx.renderers.TexturedMeshCloudRenderer;
	import de.nulldesign.nd2dx.resource.font.BitmapFont2DStyle;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2D;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2DAllocator;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.resource.shader.Shader2D;
	import de.nulldesign.nd2dx.resource.shader.Shader2DAllocator;
	import de.nulldesign.nd2dx.resource.shader.Shader2DXMLFileAllocator;
	import de.nulldesign.nd2dx.resource.texture.AnimatedTexture2D;
	import de.nulldesign.nd2dx.resource.texture.Atlas;
	import de.nulldesign.nd2dx.resource.texture.AtlasFileAllocator;
	import de.nulldesign.nd2dx.resource.texture.AtlasSlicedNode2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2DBitmapFileAllocator;
	import flash.utils.Dictionary;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class ResourceManager 
	{
		private static var instance:ResourceManager;// = new ResourceManager();
		
		private var eManager:EventsManager = EventsManager.getInstance();
		private var eGroup:String;
		
		public var vResourceDescriptors:Vector.<ResourceDescriptor> = new Vector.<ResourceDescriptor>();
		public var vResources:Vector.<ResourceBase> = new Vector.<ResourceBase>();
		public var dResourcesForDescriptoName:Dictionary = new Dictionary();
		
		public var dIdPrefixForResourceDescriptor:Dictionary = new Dictionary();
		
		public var onResourceCreated:RabbitSignal = new RabbitSignal();
		public var onChange:RabbitSignal = new RabbitSignal();
		
		// unique ids
		private var dIds:Dictionary = new Dictionary();
		
		public var contentScaleFactor:Number = 1.0;
		public var contentScaleFactorFileExtension:String = "";
		
		public function ResourceManager() 
		{
			if ( instance ) throw new Error( "ResourceManager can only be accessed through ResourceManager.getInstance()" );
		}
		
		public static function getInstance():ResourceManager 
		{
			if ( !instance )
			{
				instance = new ResourceManager();
				
				instance.eGroup = instance.eManager.getUniqueGroupId();
				
				instance.createAndAddResourceDescriptor(ResourceDescriptor.BITMAP_TEXTURE, Texture2D, ["png", "jpg", "jpeg", "gif"], "tex_");
				instance.createAndAddResourceDescriptor(ResourceDescriptor.MESH, Mesh2D, ["mesh2d"], "mesh_");
				instance.createAndAddResourceDescriptor(ResourceDescriptor.TEXTURE_ATLAS, Atlas, ["xml", "plist"], "texatlas_");
				instance.createAndAddResourceDescriptor(ResourceDescriptor.TEXTURE_ATLAS_SLICED_NODE2D, AtlasSlicedNode2D, ["xml", "plist"], "texatlasslicednode2d_");
				instance.createAndAddResourceDescriptor(ResourceDescriptor.BITMAP_FONT_STYLE, BitmapFont2DStyle, ["xml", "fnt"], "bitmapfont2dstyle_");
				instance.createAndAddResourceDescriptor(ResourceDescriptor.ANIMATED_TEXTURE, AnimatedTexture2D, ["xml"], "animtex_");
				instance.createAndAddResourceDescriptor(ResourceDescriptor.SHADER, Shader2D, ["xml"], "shader_");
				
				instance.createResource(ResourceDescriptor.MESH, new Mesh2DAllocator(null, 1, 1, 1, 1), "mesh_quad2d", "Quad Mesh 2D", true, null, true);
				instance.createResource(ResourceDescriptor.SHADER, new Shader2DAllocator(null, TexturedMeshCloudRenderer.VERTEX_SHADER, TexturedMeshCloudRenderer.FRAGMENT_SHADER), "shader_TexturedMeshCloudRenderer", "TexturedMeshCloudRenderer Shader", true, null, true);
				instance.createResource(ResourceDescriptor.SHADER, new Shader2DAllocator(null, ParticleSystem2DRendererComponent.VERTEX_SHADER, ParticleSystem2DRendererComponent.FRAGMENT_SHADER), "shader_particlesystem2drenderer", "ParticleSystem2DRenderer Shader", true, null, true);
				instance.createResource(ResourceDescriptor.SHADER, new Shader2DAllocator(null, ParticleSystem2DMaterial.VERTEX_SHADER, ParticleSystem2DMaterial.FRAGMENT_SHADER), "shader_particlesystem2dmaterial", "ParticleSystem2DMaterial Shader", true, null, true);
			}
			
			return instance;
		}
		
		// CONTENT SCALE FACTOR
		
		public function getResourceFilePathWithContentScaleFactorFileExtension(filePath:String):String
		{
			if ( !contentScaleFactorFileExtension ) return filePath;
			
			var filePathA:String = StringUtils.getBefore(filePath, ".", true);
			var filePathB:String = StringUtils.getAfter(filePath, ".", true);
			
			return filePathA + contentScaleFactorFileExtension + "." + filePathB;
		}
		
		// UNIQUE ID
		
		public function getUniqueId(length:int = 4):String
		{
			var id:String = "";
			var i:int = 100;
			
			while (i--)
			{
				id = StringUtils.generateRandomString(length);
				
				if ( dIds[id] == null )
				{
					registerUniqueId(id);
					break;
				}
			}
			
			return id;
		}
		
		public function registerUniqueId(id:String):void
		{
			// TODO: check whether another resource is already using that id...
			dIds[id] = true;
		}
		
		public function releaseId(id:String):void
		{
			delete dIds[id];
		}
		
		public function clearAllIds():void
		{
			dIds = new Dictionary();
		}
		
		// HANDLE DEVICE LOSS
		
		public function handleDeviceLoss():void
		{
			
		}
		
		// RESOURCE DESCRIPTORS
		
		public function createAndAddResourceDescriptor(name:String, resourceClass:Class, aExtensions:Array, idPrefix:String):ResourceDescriptor
		{
			var descriptor:ResourceDescriptor = new ResourceDescriptor(name, resourceClass, aExtensions);
			vResourceDescriptors.push(descriptor);
			dIdPrefixForResourceDescriptor[name] = idPrefix;
			return descriptor;
		}
		
		public function getResourceDescriptorForName(name:String):ResourceDescriptor
		{
			var i:int = 0;
			var n:int = vResourceDescriptors.length;
			var descriptor:ResourceDescriptor;
			
			for (; i < n; i++) 
			{
				descriptor = vResourceDescriptors[i];
				if ( descriptor.name == name ) return descriptor;
			}
			
			return null;
		}
		
		public function getResourceDescriptorForFileExtension(extension:String):ResourceDescriptor
		{
			var i:int = 0;
			var n:int = vResourceDescriptors.length;
			var descriptor:ResourceDescriptor;
			
			for (; i < n; i++) 
			{
				descriptor = vResourceDescriptors[i];
				if ( descriptor.aExtensions.indexOf(StringUtils.getExtension(extension)) >= 0 ) return descriptor;
			}
			
			return null;
		}
		
		public function getResourceDescriptorForResource(resource:ResourceBase):ResourceDescriptor
		{
			var i:int = 0;
			var n:int = vResourceDescriptors.length;
			var descriptor:ResourceDescriptor;
			
			for (; i < n; i++) 
			{
				descriptor = vResourceDescriptors[i];
				if ( resource is descriptor.resourceClass ) return descriptor;
			}
			
			return null;
		}
		
		public function getResourceDescriptorForNameOrFileExtension(name:String, extension:String):ResourceDescriptor
		{
			var descriptor:ResourceDescriptor = getResourceDescriptorForName(name);
			if ( !descriptor ) descriptor = getResourceDescriptorForFileExtension(extension);
			return descriptor;
		}
		
		// RESOURCES
		
		public function createResource(descriptorName:String, allocator:ResourceAllocatorBase, resourceId:String = "", resourceName:String = "", allocateResourceDirectly:Boolean = true, assetGroup:AssetGroup = null, isCore:Boolean = false):ResourceBase
		{
			var descriptor:ResourceDescriptor = getResourceDescriptorForName(descriptorName);
			
			if ( !descriptor ) return null;
			
			var resource:ResourceBase = addResource(descriptor.createResource(allocator), resourceId, resourceName, allocateResourceDirectly, assetGroup);
			resource.isCore = isCore;
			return resource;
		}
		
		public function addResource(resource:ResourceBase, resourceId:String = "", resourceName:String = "", allocateResourceDirectly:Boolean = true, assetGroup:AssetGroup = null):ResourceBase
		{
			//trace("addResource", resource, resourceId, resourceName, allocateResourceDirectly, assetGroup);
			
			var descriptor:ResourceDescriptor = getResourceDescriptorForResource(resource);
			
			if ( resourceId.length > 0 )
			{
				// TOTO: check for redundant resourceId
				registerUniqueId(resourceId);
			}
			else
			{
				resourceId = dIdPrefixForResourceDescriptor[descriptor.name] + getUniqueId();
			}
			
			resource.resourceId = resourceId;
			resource.resourceName = resourceName;
			
			vResources.push(resource);
			
			getResourcesForDescriptorName(descriptor.name).push(resource);
			
			if ( allocateResourceDirectly )
			{
				//trace("addResource allocating res directly");
				resource.allocator.allocateLocalResource(assetGroup);
			}
			
			return resource;
		}
		
		public function getResourceById(resourceId:String):ResourceBase
		{
			var i:int = 0;
			var n:int = vResources.length;
			var resource:ResourceBase;
			
			for (; i < n; i++) 
			{
				resource = vResources[i];
				if ( resource.resourceId == resourceId ) return resource;
			}
			
			return null;
		}
		
		public function getResourceForFilePath(filePath:String):ResourceBase
		{
			var i:int = 0;
			var n:int = vResources.length;
			var resource:ResourceBase;
			
			for (; i < n; i++) 
			{
				resource = vResources[i];
				if ( resource.allocator.filePath == filePath ) return resource;
			}
			
			return null;
		}
		
		public function getResourcesForDescriptorName(descriptorName:String):Array
		{
			if ( !dResourcesForDescriptoName[descriptorName] ) dResourcesForDescriptoName[descriptorName] = [];
			return dResourcesForDescriptoName[descriptorName] as Array;
		}
		
		public function getTextureById(resourceId:String):Texture2D
		{
			var aIds:Array = resourceId.split(".");
			
			var i:int = 0;
			var n:int = aIds.length;
			var texture:Texture2D;
			
			for (; i < n; i++) 
			{
				if ( !texture )
				{
					texture = getResourceById(aIds[i] as String) as Texture2D;
					
					if ( !texture ) return null;
				}
				else
				{
					texture = texture.getSubTextureByName(aIds[i] as String);
					
					if ( !texture ) return null;
				}
			}
			
			return texture;
		}
		
		public function getBitmapFont2DStyleById(resourceId:String):BitmapFont2DStyle
		{
			return getResourceById(resourceId) as BitmapFont2DStyle;
		}
	}
	
}