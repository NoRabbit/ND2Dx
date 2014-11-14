package de.nulldesign.nd2dx.resource.texture 
{
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Atlas extends ResourceBase
	{
		public var texture:Texture2D;
		
		public function Atlas(allocator:ResourceAllocatorBase) 
		{
			super(allocator);
		}
		
	}

}