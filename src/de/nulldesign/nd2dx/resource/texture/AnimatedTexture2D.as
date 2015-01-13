package de.nulldesign.nd2dx.resource.texture 
{
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedTexture2D extends ResourceBase
	{
		private var _frames:Vector.<Texture2D> = new Vector.<Texture2D>();
		public var numFrames:int = 0;
		
		public function AnimatedTexture2D(allocator:ResourceAllocatorBase = null) 
		{
			super(allocator);
		}
		
		public function updateNumFrames():void
		{
			if ( _frames )
			{
				numFrames = _frames.length;
			}
			else
			{
				numFrames = 0;
			}
		}
		
		public function get frames():Vector.<Texture2D> 
		{
			return _frames;
		}
		
		public function set frames(value:Vector.<Texture2D>):void 
		{
			_frames = value;
			updateNumFrames();
		}
		
	}

}