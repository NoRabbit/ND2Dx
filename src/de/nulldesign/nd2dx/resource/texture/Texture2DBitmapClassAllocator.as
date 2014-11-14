package de.nulldesign.nd2dx.resource.texture 
{
	import com.rabbitframework.managers.assets.AssetGroup;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Texture2DBitmapClassAllocator extends Texture2DAllocator
	{
		public var bitmapClass:Class;
		
		public function Texture2DBitmapClassAllocator(bitmapClass:Class, freeLocalResourceAfterAllocated:Boolean = false) 
		{
			super(freeLocalResourceAfterAllocated);
			this.bitmapClass = bitmapClass;
		}
		
		override public function allocateLocalResource(assetGroup:AssetGroup = null, forceAllocation:Boolean = false):void 
		{
			if ( bitmapClass )
			{
				var bitmap:Bitmap = new bitmapClass() as Bitmap;
				
				if ( bitmap )
				{
					bitmapData = bitmap.bitmapData;
				}
			}
			
			super.allocateLocalResource(assetGroup);
		}
		
	}

}