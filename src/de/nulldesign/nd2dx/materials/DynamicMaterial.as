package de.nulldesign.nd2dx.materials 
{
	import com.rabbitframework.utils.XMLUtils;
	import de.nulldesign.nd2dx.components.renderers.properties.ColorProperty;
	import de.nulldesign.nd2dx.components.renderers.properties.ConstantPropertyBase;
	import de.nulldesign.nd2dx.components.renderers.properties.PropertyBase;
	import de.nulldesign.nd2dx.components.renderers.properties.TextureProperty;
	import de.nulldesign.nd2dx.materials.properties.Vector1Property;
	import de.nulldesign.nd2dx.materials.properties.Vector4Property;
	import de.nulldesign.nd2dx.resource.shader.Shader2D;
	import de.nulldesign.nd2dx.resource.shader.Shader2DProperty;
	import de.nulldesign.nd2dx.resource.shader.ShaderProgram2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DynamicMaterial extends MaterialBase
	{
		public var vTextureProperties:Vector.<TextureProperty> = new Vector.<TextureProperty>();
		public var vConstantProperties:Vector.<ConstantPropertyBase> = new Vector.<ConstantPropertyBase>();
		
		protected var vVertexProgramConstants:Vector.<Number>;
		
		private var _texture:Texture2D;
		
		public function DynamicMaterial() 
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
			
			width = _texture.bitmapWidth;
			height = _texture.bitmapHeight;
		}
		
		override public function updateClipSpace():void 
		{
			clipSpaceMatrix.identity();
			clipSpaceMatrix.appendScale(_width, _height, 1.0);
			clipSpaceMatrix.append(_node.worldModelMatrix);
			invalidateClipSpace = false;
		}
		
		override protected function prepareForRender(context:Context3D):void 
		{
			// colors first
			vVertexProgramConstants[0] = _node.combinedTintRed;
			vVertexProgramConstants[1] = _node.combinedTintGreen;
			vVertexProgramConstants[2] = _node.combinedTintBlue;
			vVertexProgramConstants[3] = _node.combinedAlpha;
			
			// then textures
			var i:int = 0;
			var n:int = vTextureProperties.length;
			var textureProperty:TextureProperty;
			
			for (; i < n; i++) 
			{
				textureProperty = vTextureProperties[i];
				textureProperty.prepareForRender(context, i, vVertexProgramConstants);
			}
			
			// then clipspace, blend mode and shader program
			super.prepareForRender(context);
			
			// then the rest
			context.setVertexBufferAt(0, mesh.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, mesh.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			
			if (node.useScissorRect) 
			{
				context.setScissorRectangle(node.worldScissorRect);
			}
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, viewProjectionMatrix, true);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, clipSpaceMatrix, true);
			
			i = 0;
			n = vConstantProperties.length;
			var constantProperty:ConstantPropertyBase;
			
			for (; i < n; i++) 
			{
				constantProperty = vConstantProperties[i];
				constantProperty.prepareForRender(vVertexProgramConstants);
			}
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, vVertexProgramConstants);
		}
		
		override protected function clearAfterRender(context:Context3D):void 
		{
			// textures
			var i:int = 0;
			var n:int = vTextureProperties.length;
			
			for (; i < n; i++) 
			{
				context.setTextureAt(i, null);
			}
			
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setScissorRectangle(null);
		}
		
		override protected function initProgram(context:Context3D):void 
		{
			shaderProgram = _shader.getShaderProgram(context, _texture);
		}
		
		override public function updateShaderProperties():void 
		{
			if ( vTextureProperties.length ) vTextureProperties.splice(0, vTextureProperties.length);
			if ( vConstantProperties.length ) vConstantProperties.splice(0, vConstantProperties.length);
			
			if ( !_shader ) return;
			
			var i:int = 0;
			var n:int = _shader.vShader2DProperties.length;
			var shader2DProperty:Shader2DProperty;
			var a:Array;
			var constantCount:int = 4;
			
			for (; i < n; i++) 
			{
				shader2DProperty = shader.vShader2DProperties[i];
				
				constantCount += shader2DProperty.constantCount;
				
				switch ( shader2DProperty.name ) 
				{
					case "texture2d":
						{
							vTextureProperties.push(new TextureProperty(shader2DProperty, this, shader2DProperty.value));
							break;
						}
						
					case "color":
						{
							a = shader2DProperty.value.split(",");
							vConstantProperties.push(new ColorProperty(shader2DProperty, this, XMLUtils.getCleanNumber(a[0]), XMLUtils.getCleanNumber(a[1]), XMLUtils.getCleanNumber(a[2]), XMLUtils.getCleanNumber(a[3])));
							break;
						}
						
					case "vector1":
						{
							vConstantProperties.push(new Vector1Property(shader2DProperty, this, XMLUtils.getCleanNumber(shader2DProperty.value)));
							break;
						}
						
					case "vector4":
						{
							a = shader2DProperty.value.split(",");
							vConstantProperties.push(new Vector4Property(shader2DProperty, this, XMLUtils.getCleanNumber(a[0]), XMLUtils.getCleanNumber(a[1]), XMLUtils.getCleanNumber(a[2]), XMLUtils.getCleanNumber(a[3])));
							break;
						}
						
					default:
				}
			}
			
			// to make sure there are always 4 constants for each register (constant count = multiple of 4)
			constantCount += 4 - (constantCount % 4);
			
			vVertexProgramConstants = new Vector.<Number>(constantCount, true);
		}
		
		override public function checkIfReadyForRender():void 
		{
			isReadyForRender = true;
			
			if ( !_shader )
			{
				isReadyForRender = false;
				return;
			}
			
			// textures
			var i:int = 0;
			var n:int = vTextureProperties.length;
			var textureProperty:TextureProperty;
			
			for (; i < n; i++) 
			{
				textureProperty = vTextureProperties[i];
				
				if ( !textureProperty.texture )
				{
					isReadyForRender = false;
					return;
				}
				
				if ( !textureProperty.texture.isLocallyAllocated || textureProperty.texture.isRemotellyAllocated )
				{
					isReadyForRender = false;
					return;
				}
			}
		}
	}

}