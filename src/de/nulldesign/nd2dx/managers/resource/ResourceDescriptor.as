package de.nulldesign.nd2dx.managers.resource 
{
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ResourceDescriptor 
	{
		public static const BITMAP_TEXTURE:String = "bitmap_texture";
		public static const ATF_TEXTURE:String = "atf_texture";
		public static const TEXTURE_ATLAS:String = "texture_atlas";
		public static const TEXTURE_ATLAS_SLICED_NODE2D:String = "texture_atlas_sliced_node2d";
		public static const BITMAP_FONT_STYLE:String = "bitmap_font_style";
		public static const ANIMATED_TEXTURE:String = "animated_texture";
		public static const MESH:String = "mesh";
		public static const SHADER:String = "shader";
		
		public var name:String;
		public var resourceClass:Class;
		public var aExtensions:Array;
		
		public function ResourceDescriptor(name:String, resourceClass:Class, aExtensions:Array) 
		{
			this.name = name;
			this.resourceClass = resourceClass;
			this.aExtensions = aExtensions;
		}
		
		public function createResource(allocator:ResourceAllocatorBase):ResourceBase
		{
			return new resourceClass(allocator) as ResourceBase;
		}
	}

}