package de.nulldesign.nd2dx.resource.texture 
{
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class SlicedTexture2D extends ResourceBase
	{
		public var texture:Texture2D;
		
		public var sliceLeft:Number = 0.2;
		public var sliceRight:Number = 0.8;
		public var sliceTop:Number = 0.2;
		public var sliceBottom:Number = 0.8;
		
		public var sliceType:int = TextureUtil.SLICE_TYPE_3_HORIZONTAL;
		
		public function SlicedTexture2D(allocator:ResourceAllocatorBase) 
		{
			super(allocator);
		}
		
	}

}