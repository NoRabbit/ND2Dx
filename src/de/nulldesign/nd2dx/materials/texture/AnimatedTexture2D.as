package de.nulldesign.nd2dx.materials.texture 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedTexture2D 
	{
		public var frames:Vector.<Texture2D> = new Vector.<Texture2D>();
		public var numFrames:int = 0;
		
		public function AnimatedTexture2D(frames:Vector.<Texture2D>) 
		{
			this.frames = frames;
			numFrames = frames.length;
		}
		
	}

}