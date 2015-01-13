package de.nulldesign.nd2dx.components.renderers 
{
	import de.nulldesign.nd2dx.components.ComponentBase;
	import flash.display3D.Context3DBlendFactor;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RendererComponentBase extends ComponentBase
	{
		[WGM (position = -1500, label = "src", listId = "blendModes", listItems = "destinationAlpha,destinationColor,one,oneMinusDestinationAlpha,oneMinusDestinationColor,oneMinusSourceAlpha,oneMinusSourceColor,sourceAlpha,sourceColor,zero" )]
		public var blendModeSrc:String = Context3DBlendFactor.ONE;
		
		[WGM (position = -1400, label = "dst", listId = "blendModes")]
		public var blendModeDst:String = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
		
		public var isReadyToRender:Boolean = false;
		
		public function RendererComponentBase() 
		{
			
		}
	}

}