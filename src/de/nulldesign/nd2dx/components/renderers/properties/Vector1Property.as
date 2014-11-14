package de.nulldesign.nd2dx.components.renderers.properties
{
	import de.nulldesign.nd2dx.components.renderers.DynamicShaderMeshRendererComponent;
	import de.nulldesign.nd2dx.resource.shader.Shader2DProperty;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Vector1Property extends ConstantPropertyBase
	{
		public static const CONSTANT_COUNT:uint = 1;
		
		public var x:Number = 0.0;
		
		public function Vector1Property(shader2DProperty:Shader2DProperty, dynamicShaderMeshRenderer:DynamicShaderMeshRendererComponent, x:Number = 0.0) 
		{
			super(shader2DProperty, dynamicShaderMeshRenderer);
			
			this.x = x;
		}
		
		override public function prepareForRender(vProgramConstants:Vector.<Number>):void 
		{
			vProgramConstants[shader2DProperty.constantIndex] = x;
		}
	}

}