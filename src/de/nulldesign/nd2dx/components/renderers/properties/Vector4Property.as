package de.nulldesign.nd2dx.components.renderers.properties 
{
	import de.nulldesign.nd2dx.components.renderers.DynamicShaderMeshRendererComponent;
	import de.nulldesign.nd2dx.resource.shader.Shader2DProperty;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Vector4Property extends ConstantPropertyBase
	{
		public static const CONSTANT_COUNT:uint = 4;
		
		public var x:Number = 0.0;
		public var y:Number = 0.0;
		public var z:Number = 0.0;
		public var w:Number = 0.0;
		
		public function Vector4Property(shader2DProperty:Shader2DProperty, dynamicShaderMeshRenderer:DynamicShaderMeshRendererComponent, x:Number = 0.0, y:Number = 0.0, z:Number = 0.0, w:Number = 0.0) 
		{
			super(shader2DProperty, dynamicShaderMeshRenderer);
			
			this.x = x;
			this.y = y;
			this.z = z;
			this.w = w;
		}
		
		override public function prepareForRender(vProgramConstants:Vector.<Number>):void 
		{
			vProgramConstants[shader2DProperty.constantIndex] = x;
			vProgramConstants[shader2DProperty.constantIndex + 1] = y;
			vProgramConstants[shader2DProperty.constantIndex + 2] = z;
			vProgramConstants[shader2DProperty.constantIndex + 3] = w;
		}
	}

}