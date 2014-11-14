package de.nulldesign.nd2dx.components.renderers.properties 
{
	import de.nulldesign.nd2dx.components.renderers.DynamicShaderMeshRendererComponent;
	import de.nulldesign.nd2dx.resource.shader.Shader2DProperty;
	import flash.display3D.Context3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class PropertyBase 
	{
		public var shader2DProperty:Shader2DProperty;
		public var dynamicShaderMeshRenderer:DynamicShaderMeshRendererComponent;
		
		public function PropertyBase(shader2DProperty:Shader2DProperty, dynamicShaderMeshRenderer:DynamicShaderMeshRendererComponent) 
		{
			this.shader2DProperty = shader2DProperty;
			this.dynamicShaderMeshRenderer = dynamicShaderMeshRenderer;
		}
		
		public function toString():String
		{
			return shader2DProperty.label + ", " + shader2DProperty.name + ", " + shader2DProperty.alias + ", " + shader2DProperty.register + ", " + shader2DProperty.constantIndex + ", [" + shader2DProperty.value + "]";
		}
	}

}