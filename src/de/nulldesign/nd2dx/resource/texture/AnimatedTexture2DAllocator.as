package de.nulldesign.nd2dx.resource.texture 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import de.nulldesign.nd2dx.resource.ResourceAllocatorBase;
	import de.nulldesign.nd2dx.resource.ResourceBase;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class AnimatedTexture2DAllocator extends ResourceAllocatorBase
	{
		public var animatedTexture:AnimatedTexture2D;
		
		public var aFrameNames:Array;
		
		public function AnimatedTexture2DAllocator(data:Object = null, freeLocalResourceAfterRemoteAllocation:Boolean = false) 
		{
			super(freeLocalResourceAfterRemoteAllocation);
			
			if ( data is Array )
			{
				aFrameNames = data as Array;
			}
			else if ( data is String )
			{
				aFrameNames = (data as String).split(",");
			}
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( animatedTexture.isAllocating ) return;
			if ( animatedTexture.isLocallyAllocated && !forceAllocation ) return;
			
			if ( aFrameNames )
			{
				TextureUtil.generateAnimatedTexture2DDataFromFrameNames(animatedTexture, aFrameNames);
				
				animatedTexture.isLocallyAllocated = true;
				
				if ( animatedTexture.isLocallyAllocated && freeLocalResourceAfterRemoteAllocation ) freeLocalResource();
			}
		}
		
		override public function freeLocalResource():void 
		{
			aFrameNames = null;
		}
		
		override public function get resource():ResourceBase 
		{
			return super.resource;
		}
		
		override public function set resource(value:ResourceBase):void 
		{
			super.resource = value;
			animatedTexture = value as AnimatedTexture2D;
		}
	}

}