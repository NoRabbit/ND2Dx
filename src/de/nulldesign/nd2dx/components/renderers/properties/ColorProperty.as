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
	public class ColorProperty extends ConstantPropertyBase
	{
		public static const CONSTANT_COUNT:uint = 4;
		
		public var r:Number = 1.0;
		public var g:Number = 1.0;
		public var b:Number = 1.0;
		public var a:Number = 1.0;
		
		public function ColorProperty(shader2DProperty:Shader2DProperty, dynamicShaderMeshRenderer:DynamicShaderMeshRendererComponent, r:Number = 1.0, g:Number = 1.0, b:Number = 1.0, a:Number = 1.0) 
		{
			super(shader2DProperty, dynamicShaderMeshRenderer);
			
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}
		
		override public function prepareForRender(vProgramConstants:Vector.<Number>):void 
		{
			vProgramConstants[shader2DProperty.constantIndex] = r;
			vProgramConstants[shader2DProperty.constantIndex + 1] = g;
			vProgramConstants[shader2DProperty.constantIndex + 2] = b;
			vProgramConstants[shader2DProperty.constantIndex + 3] = a;
		}
		
		override public function toString():String 
		{
			return super.toString() + ", colors:" + r + ", " + g + ", " + b + ", " + a;
		}
	}

}