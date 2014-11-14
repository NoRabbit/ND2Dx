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
		public var blendModeSrc:String = Context3DBlendFactor.ONE;
		public var blendModeDst:String = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
		
		public function RendererComponentBase() 
		{
			
		}
		
	}

}