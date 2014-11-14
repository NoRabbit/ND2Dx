package de.nulldesign.nd2dx.components.renderers.properties 
{
	import de.nulldesign.nd2dx.components.renderers.DynamicShaderMeshRendererComponent;
	import de.nulldesign.nd2dx.resource.shader.Shader2DProperty;
	import flash.display3D.Context3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ConstantPropertyBase extends PropertyBase
	{
		public function ConstantPropertyBase(shader2DProperty:Shader2DProperty, dynamicShaderMeshRenderer:DynamicShaderMeshRendererComponent) 
		{
			super(shader2DProperty, dynamicShaderMeshRenderer);
		}
		
		public function prepareForRender(vProgramConstants:Vector.<Number>):void
		{
			
		}
	}

}