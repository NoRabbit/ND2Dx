package de.nulldesign.nd2dx.support 
{
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class RenderSupportManager 
	{
		private static var instance:RenderSupportManager = new RenderSupportManager();
		
		public function RenderSupportManager() 
		{
			if ( instance ) throw new Error( "RenderSupportManager can only be accessed through RenderSupportManager.getInstance()" );
			
			vRenderSupports.push(new MainRenderSupport());
			vRenderSupports.push(new Texture2DMaterialBatchRenderSupport());
			vRenderSupports.push(new Texture2DMaterialCloudRenderSupport());
			
			mainRenderSupport = vRenderSupports[0] as MainRenderSupport;
		}
		
		public static function getInstance():RenderSupportManager 
		{
			return instance;
		}
		
		public var mainRenderSupport:MainRenderSupport;
		
		public var vRenderSupports:Vector.<RenderSupportBase> = new Vector.<RenderSupportBase>();
		public var currentRenderSupport:RenderSupportBase;
		
		public function setCurrentRenderSupport(renderSupport:RenderSupportBase, newRenderSupport:RenderSupportBase):RenderSupportBase
		{
			newRenderSupport.elapsed = renderSupport.elapsed;
			newRenderSupport.camera = renderSupport.camera;
			newRenderSupport.viewProjectionMatrix = renderSupport.viewProjectionMatrix;
			newRenderSupport.context = renderSupport.context;
			newRenderSupport.deviceWasLost = renderSupport.deviceWasLost;
			
			renderSupport.finalize();
			
			currentRenderSupport = newRenderSupport;
			
			if ( !currentRenderSupport.isPrepared ) currentRenderSupport.prepare();
			
			return currentRenderSupport;
		}
		
		public function initRenderSupports():void
		{
			var i:int = 0;
			var n:int = vRenderSupports.length;
			
			for (; i < n; i++) 
			{
				vRenderSupports[i].isPrepared = false;
			}
		}
	}
	
}