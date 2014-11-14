package de.nulldesign.nd2dx.components.renderers.properties 
{
	import de.nulldesign.nd2dx.components.renderers.DynamicShaderMeshRendererComponent;
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.resource.shader.Shader2DProperty;
	import de.nulldesign.nd2dx.resource.shader.Shader2DTextureProperty;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.display3D.Context3D;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TextureProperty extends PropertyBase
	{
		public static const CONSTANT_COUNT:uint = 4;
		
		public var resourceManager:ResourceManager = ResourceManager.getInstance();
		
		public var shader2DTextureProperty:Shader2DTextureProperty;
		
		private var _texture:Texture2D;
		public var uvRectX:Number = 0.0;
		public var uvRectY:Number = 0.0;
		public var uvRectWidth:Number = 0.0;
		public var uvRectHeight:Number = 0.0;
		
		public function TextureProperty(shader2DProperty:Shader2DProperty, dynamicShaderMeshRenderer:DynamicShaderMeshRendererComponent, textureId:String = null) 
		{
			super(shader2DProperty, dynamicShaderMeshRenderer);
			
			shader2DTextureProperty = shader2DProperty as Shader2DTextureProperty;
			texture = resourceManager.getTextureById(textureId);
		}
		
		public function prepareForRender(context:Context3D, index:int, vProgramConstants:Vector.<Number>):Boolean 
		{
			if ( !_texture ) return false;
			
			context.setTextureAt(index, texture.getTexture(context));
			
			vProgramConstants[shader2DTextureProperty.uvRectConstantIndex] = uvRectX;
			vProgramConstants[shader2DTextureProperty.uvRectConstantIndex + 1] = uvRectY;
			vProgramConstants[shader2DTextureProperty.uvRectConstantIndex + 2] = uvRectWidth;
			vProgramConstants[shader2DTextureProperty.uvRectConstantIndex + 3] = uvRectHeight;
			
			return true;
		}
		
		public function clearAfterRender():void
		{
			
		}
		
		public function get texture():Texture2D 
		{
			return _texture;
		}
		
		public function set texture(value:Texture2D):void 
		{
			if ( _texture == value ) return;
			
			_texture = value;
			
			if ( _texture )
			{
				setTextureData();
			}
		}
		
		public function setTextureData():void
		{
			if ( _texture )
			{
				uvRectX = _texture.uvRect.x;
				uvRectY = _texture.uvRect.y;
				uvRectWidth = _texture.uvRect.width;
				uvRectHeight = _texture.uvRect.height;
			}
			else
			{
				uvRectX = 0.0;
				uvRectY = 0.0;
				uvRectWidth = 0.0;
				uvRectHeight = 0.0;
			}
			
			dynamicShaderMeshRenderer.updateSize();
		}
	}

}