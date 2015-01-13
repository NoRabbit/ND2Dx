package de.nulldesign.nd2dx.components.renderers 
{
	import com.rabbitframework.utils.XMLUtils;
	import de.nulldesign.nd2dx.components.renderers.properties.ColorProperty;
	import de.nulldesign.nd2dx.components.renderers.properties.ConstantPropertyBase;
	import de.nulldesign.nd2dx.components.renderers.properties.PropertyBase;
	import de.nulldesign.nd2dx.components.renderers.properties.TextureProperty;
	import de.nulldesign.nd2dx.components.renderers.properties.Vector1Property;
	import de.nulldesign.nd2dx.components.renderers.properties.Vector4Property;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2D;
	import de.nulldesign.nd2dx.resource.shader.Shader2D;
	import de.nulldesign.nd2dx.resource.shader.Shader2DProperty;
	import de.nulldesign.nd2dx.resource.shader.ShaderProgram2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.utils.Statistics;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DynamicShaderMeshRendererComponent extends RendererComponentBase
	{
		public var vTextureProperties:Vector.<TextureProperty> = new Vector.<TextureProperty>();
		public var vConstantProperties:Vector.<ConstantPropertyBase> = new Vector.<ConstantPropertyBase>();
		
		protected var vVertexProgramConstants:Vector.<Number>;
		
		private var _shader:Shader2D;
		public var shaderProgram:ShaderProgram2D;
		
		private var _mesh:Mesh2D;
		public var clipSpaceMatrix:Matrix3D = new Matrix3D();
		
		public var width:Number = 0.0;
		public var height:Number = 0.0;
		
		public function DynamicShaderMeshRendererComponent() 
		{
			
		}
		
		public function updateClipSpace():void
		{
			clipSpaceMatrix.identity();
			clipSpaceMatrix.appendScale(width, height, 1.0);
			clipSpaceMatrix.append(node.worldModelMatrix);
		}
		
		public function updateShaderProperties():void 
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
		
		public function updateSize():void
		{
			var i:int = 0;
			var n:int = vTextureProperties.length;
			var textureProperty:TextureProperty;
			
			width = height = 0.0;
			
			for (; i < n; i++) 
			{
				textureProperty = vTextureProperties[i];
				
				if ( textureProperty.texture )
				{
					if ( textureProperty.texture.bitmapWidth > width ) width = textureProperty.texture.bitmapWidth;
					if ( textureProperty.texture.bitmapHeight > height ) height = textureProperty.texture.bitmapHeight;
				}
			}
		}
		
		override public function draw(renderer:RendererBase):void 
		{
			// prepare data
			var context:Context3D = renderer.context;
			
			node.checkAndUpdateMatrixIfNeeded();
			
			if ( node.matrixUpdated ) updateClipSpace();
			
			// upload mesh buffers if needed
			if ( !_mesh.isRemotelyAllocated ) _mesh.allocator.allocateRemoteResource(renderer.context);
			
			// colors
			vVertexProgramConstants[0] = node.combinedTintRed;
			vVertexProgramConstants[1] = node.combinedTintGreen;
			vVertexProgramConstants[2] = node.combinedTintBlue;
			vVertexProgramConstants[3] = node.combinedAlpha;
			
			// textures
			var i:int = 0;
			var n:int = vTextureProperties.length;
			var textureProperty:TextureProperty;
			
			for (; i < n; i++) 
			{
				textureProperty = vTextureProperties[i];
				textureProperty.prepareForRender(context, i, vVertexProgramConstants);
			}
			
			// shader
			if ( !shaderProgram ) shaderProgram = _shader.getShaderProgram(context);
			
			context.setProgram(shaderProgram.program);
			
			// blend factors
			context.setBlendFactors(blendModeSrc, blendModeDst);
			
			// vertex buffers
			context.setVertexBufferAt(0, _mesh.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, _mesh.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			
			// scissor rect
			if (node.useScissorRect) context.setScissorRectangle(node.worldScissorRect);
			
			// program constants
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, renderer.viewProjectionMatrix, true);
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
			
			// draw
			context.drawTriangles(_mesh.indexBuffer, 0, _mesh.numTriangles);
			
			Statistics.drawCalls++;
			Statistics.triangles += _mesh.numTriangles;
			Statistics.sprites++;
			
			// clear data
			
			// textures
			i = 0;
			n = vTextureProperties.length;
			
			for (; i < n; i++) 
			{
				context.setTextureAt(i, null);
			}
			
			// buffers and scissor rect
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setScissorRectangle(null);
		}
		
		public function getPropertyByAlias(alias:String):PropertyBase
		{
			var i:int = 0;
			var n:int = vConstantProperties.length;
			
			for (; i < n; i++) 
			{
				if ( vConstantProperties[i].shader2DProperty.alias == alias ) return vConstantProperties[i];
			}
			
			i = 0;
			n = vTextureProperties.length;
			
			for (; i < n; i++) 
			{
				if ( vTextureProperties[i].shader2DProperty.alias == alias ) return vTextureProperties[i];
			}
			
			return null;
		}
		
		public function get shader():Shader2D 
		{
			return _shader;
		}
		
		public function set shader(value:Shader2D):void 
		{
			if ( _shader == value ) return;
			
			_shader = value;
			
			updateShaderProperties();
		}
		
		public function get mesh():Mesh2D 
		{
			return _mesh;
		}
		
		public function set mesh(value:Mesh2D):void 
		{
			if ( _mesh == value ) return;
			
			_mesh = value;
		}
	}

}