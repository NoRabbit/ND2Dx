package de.nulldesign.nd2dx.components.renderers 
{
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.materials.MaterialBase;
	import de.nulldesign.nd2dx.materials.ParticleSystem2DMaterial;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2D;
	import de.nulldesign.nd2dx.resource.mesh.ParticleSystem2DMesh2D;
	import de.nulldesign.nd2dx.resource.shader.Shader2D;
	import de.nulldesign.nd2dx.resource.shader.ShaderProgram2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	import de.nulldesign.nd2dx.utils.ParticleSystem2DPreset;
	import de.nulldesign.nd2dx.utils.Statistics;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DProgramType;
	import flash.display3D.Context3DVertexBufferFormat;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ParticleSystem2DRendererComponent extends RendererComponentBase
	{
		public static const VERTEX_SHADER:String =
			"alias va0, position;" +
			"alias va1, uv;" +
			
			"alias va2.x, startTime;" +
			"alias va2.y, lifeTime;" +
			"alias va2.z, startSize;" +
			"alias va2.w, endSize;" +
			
			"alias va3.xy, velocity;" +
			"alias va3.zw, startPos;" +
			
			"alias va4, startColor;" +
			"alias va5, endColor;" +
			"alias va6, rotation;" +
			
			"alias vc0, viewProjection;" +
			"alias vc4, clipSpace;" +
			"alias vc8, uvSheet;" +
			"alias vc9, uvScroll;" +
			
			"alias vc10.xy, gravity;" +
			"alias vc10.z, currentTime;" +
			"alias vc10.w, CONST(0.0);" +
			"alias vc11, clipScaleOffset;" +
			"alias vc12, parentColor;" +
			
			// progress calculation
			// 		clamp( frac( (currentTime - startTime) / lifeTime ) )
			
			// test
			"temp0.x = startTime + lifeTime;" +
			"temp0.y = currentTime / temp0.x;" +
			"#if !BURST;" +
			"	temp0.y = frac(temp0.y);" +
			"#endif;" +
			"temp0.x *= temp0.y;" +
			"temp0.x -= startTime;" +
			"temp0.x /= lifeTime;" +
			"sge temp0.y, temp0.x, 0.0;" +
			"temp0.x = clamp(temp0.x);" +
			"alias temp0, progress;" +
			
			// original
			//"temp0.x = currentTime - startTime;" +
			//"temp0.x /= lifeTime;" +
			//"#if !BURST;" +
			//"	temp0.x = frac(temp0.x);" +
			//"#endif;" +
			//"temp0.x = clamp(temp0.x);" +
			//"alias temp0.x, progress.x;" +
			
			// velocity / gravity calculation
			// 		(velocity + (gravity * progress)) * progress
			"temp1.x = gravity.x * progress.x;" +
			"temp1.y = gravity.y * progress.x;" +
			"temp1.x = velocity.x + temp1.x;" +
			"temp1.y = velocity.y + temp1.y;" +
			"temp1.x *= progress.x;" +
			"temp1.y *= progress.x;" +
			
			"alias temp1, currentVelocity;" +
			
			// size calculation
			"temp2.x = endSize - startSize;" +
			"temp2.x *= progress.x;" +
			"temp2.x += startSize;" +
			"temp2.x *= progress.y;" +
			"alias temp2, currentSize;" +
			
			// size calculation -> float size = startSize * (1.0 - progress) + endSize * progress;
			//"temp2.x = 1.0 - progress.x;" +
			//"temp2.x *= startSize;" +
			//"temp2.y = endSize * progress.x;" +
			//"temp2.x += temp2.y;" +
			//"alias temp2, currentSize;" +
			
			// move
			// 		(position * currentSize) + startPos + currentVelocity
			//"mov temp3, position;" +
			"temp3 = position;" +
			"temp3.x *= clipScaleOffset.x;" +
			"temp3.y *= clipScaleOffset.y;" +
			"temp3.x *= currentSize.x;" +
			"temp3.y *= currentSize.x;" +
			"temp4.xy = clipScaleOffset.zw * currentSize.x;" +
			"temp3.xy += temp4.xy;" +
			
			// ####### ROTATION
			"mov vt6, va6;" +
			"mov vt7, va6;" +
			"mul vt6.y vt6.y, progress.x;" +
			"add vt6.x vt6.x, vt6.y;" +
			
			//x = (x * cos(a)) - (y * sin(a));
			//y = sin(a) * x + cos(a) * y;
			
			// x
			"cos vt7.x vt6.x;" +
			"mul vt7.x vt7.x, temp3.x;" +
			"sin vt7.y vt6.x;" +
			"mul vt7.y vt7.y, temp3.y;" +
			"sub temp4.x vt7.x, vt7.y;" +
			
			// y
			"sin vt7.x vt6.x;" +
			"mul vt7.x vt7.x, temp3.x;" +
			"cos vt7.y vt6.x;" +
			"mul vt7.y vt7.y, temp3.y;" +
			"add temp4.y vt7.x, vt7.y;" +
			
			"temp3.xy = temp4.xy;" +
			//"output = temp3;" +
			// ####### END ROTATION
			
			
			
			"temp3.xy += startPos.xy;" +
			
			"temp3.xy += currentVelocity.xy;" +
			
			"temp3 = mul4x4(temp3, clipSpace);" +
			"output = mul4x4(temp3, viewProjection);" +
			
			
			
			// mix colors
			// 		(startColor * (1.0 - progress)) + (endColor * progress)
			"temp4 = endColor - startColor;" +
			"temp4 *= progress.x;" +
			"temp4 += startColor;" +
			"temp4 *= parentColor;" +
			
			"#if PREMULTIPLIED_ALPHA;" +
			"	temp4.xyz *= temp4.w;" +
			//"	temp4.xyz *= parentColor.w;" +
			"#endif;" +
			
			// pass to fragment shader
			//"v0 = uv;" +
			"temp0 = applyUV(uv, uvScroll, uvSheet);" +
			"v0 = temp0;" +
			"v1 = temp4;";

		public static const FRAGMENT_SHADER:String =
			"alias v0, texCoord;" +
			"alias v1, colorMultiplier;" +
			"temp0 = sample(texCoord, texture0);" +
			"output = temp0 * colorMultiplier;";
			
		public static var shader:Shader2D;
		public static var shaderProgram:ShaderProgram2D;
		
		private var _texture:Texture2D;
		
		private var _preset:ParticleSystem2DPreset;
		private var _numParticles:uint = 50;
		private var _isBurst:Boolean = false;
		
		public var invalidateParticles:Boolean = true;
		
		public var gravityX:Number = 0.0;
		public var gravityY:Number = 0.0;
		public var currentTime:Number = 0.0;
		
		public var particleSystem2DMesh2D:ParticleSystem2DMesh2D;
		
		public var width:Number = 0.0;
		public var height:Number = 0.0;
		
		public var uvRect:Rectangle;
		
		public var uvOffsetX:Number = 0.0;
		public var uvOffsetY:Number = 0.0;
		public var uvScaleX:Number = 1.0;
		public var uvScaleY:Number = 1.0;
		
		public var frameOffsetX:Number = 0.0;
		public var frameOffsetY:Number = 0.0;
		
		private var programConstants:Vector.<Number>;
		
		public var mat:ParticleSystem2DMaterial = new ParticleSystem2DMaterial();
		
		public function ParticleSystem2DRendererComponent() 
		{
			if( !shader ) shader = ResourceManager.getInstance().getResourceById("shader_particlesystem2drenderer") as Shader2D;
			
			programConstants = new Vector.<Number>(20, true);
			
			particleSystem2DMesh2D = new ParticleSystem2DMesh2D();
			MeshUtil.generateMeshData(particleSystem2DMesh2D, 1, 1, 1, 1);
			preset = new ParticleSystem2DPreset();
		}
		
		public function get preset():ParticleSystem2DPreset 
		{
			return _preset;
		}
		
		public function set preset(value:ParticleSystem2DPreset):void 
		{
			if ( _preset == value ) return;
			_preset = value;
			invalidateParticles = true;
		}
		
		public function get numParticles():uint 
		{
			return _numParticles;
		}
		
		public function set numParticles(value:uint):void 
		{
			if ( numParticles == value ) return;
			_numParticles = value;
			invalidateParticles = true;
		}
		
		public function get isBurst():Boolean 
		{
			return _isBurst;
		}
		
		public function set isBurst(value:Boolean):void 
		{
			if ( _isBurst == value ) return;
			
			_isBurst = value;
			
			shaderProgram = null;
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
				uvRect = _texture.uvRect;
				
				width = _texture.bitmapWidth;
				height = _texture.bitmapHeight;
				
				frameOffsetX = _texture.frameOffsetX;
				frameOffsetY = _texture.frameOffsetY;
				
				shaderProgram = null;
			}
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( invalidateParticles ) updateParticles();
			
			node.checkAndUpdateMatrixIfNeeded();
			
			mat.node = node;
			mat.texture = texture;
			mat.mesh = particleSystem2DMesh2D;
			
			currentTime += elapsed * 1000;
			
			if ( isBurst && currentTime > particleSystem2DMesh2D.totalDuration )
			{
				isActive = false;
			}
		}
		
		override public function draw(renderer:RendererBase):void 
		{
			renderer.draw();
			
			var context:Context3D = renderer.context;
			
			if ( particleSystem2DMesh2D.needUploadVertexBuffer ) particleSystem2DMesh2D.uploadBuffers(context);
			if ( !shaderProgram ) shaderProgram = shader.getShaderProgram(context, texture, ["BURST", isBurst]);
			
			context.setProgram(shaderProgram.program);
			
			context.setBlendFactors(blendModeSrc, blendModeDst);
			
			context.setTextureAt(0, texture.getTexture(context));
			
			if( renderer.scissorRect ) context.setScissorRectangle(renderer.scissorRect);
			
			context.setVertexBufferAt(0, particleSystem2DMesh2D.vertexBuffer, 0, Context3DVertexBufferFormat.FLOAT_2); // vertex
			context.setVertexBufferAt(1, particleSystem2DMesh2D.vertexBuffer, 2, Context3DVertexBufferFormat.FLOAT_2); // uv
			context.setVertexBufferAt(2, particleSystem2DMesh2D.vertexBuffer, 4, Context3DVertexBufferFormat.FLOAT_4); // misc (starttime, life, startsize, endsize
			context.setVertexBufferAt(3, particleSystem2DMesh2D.vertexBuffer, 8, Context3DVertexBufferFormat.FLOAT_4); // velocity / startpos
			context.setVertexBufferAt(4, particleSystem2DMesh2D.vertexBuffer, 12, Context3DVertexBufferFormat.FLOAT_4); // startcolor
			context.setVertexBufferAt(5, particleSystem2DMesh2D.vertexBuffer, 16, Context3DVertexBufferFormat.FLOAT_4); // endcolor
			context.setVertexBufferAt(6, particleSystem2DMesh2D.vertexBuffer, 20, Context3DVertexBufferFormat.FLOAT_2); // rotation
			
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 0, renderer.viewProjectionMatrix, true);
			context.setProgramConstantsFromMatrix(Context3DProgramType.VERTEX, 4, node.worldModelMatrix, true);
			
			programConstants[0] = uvRect.x;
			programConstants[1] = uvRect.y;
			programConstants[2] = uvRect.width;
			programConstants[3] = uvRect.height;
			
			programConstants[4] = uvOffsetX;
			programConstants[5] = uvOffsetY;
			programConstants[6] = uvScaleX;
			programConstants[7] = uvScaleY;
			
			programConstants[8] = gravityX;
			programConstants[9] = gravityY;
			programConstants[10] = currentTime;
			programConstants[11] = 0.0;
			
			programConstants[12] = width;
			programConstants[13] = height;
			programConstants[14] = frameOffsetX;
			programConstants[15] = frameOffsetY;
			
			programConstants[16] = node.combinedTintRed;
			programConstants[17] = node.combinedTintGreen;
			programConstants[18] = node.combinedTintBlue;
			programConstants[19] = node._alpha;
			
			context.setProgramConstantsFromVector(Context3DProgramType.VERTEX, 8, programConstants);
			
			context.drawTriangles(particleSystem2DMesh2D.indexBuffer, 0, particleSystem2DMesh2D.numTriangles);
			
			Statistics.drawCalls++;
			Statistics.triangles += particleSystem2DMesh2D.numTriangles;
			Statistics.sprites += particleSystem2DMesh2D.numParticles;
			
			// clear
			context.setTextureAt(0, null);
			context.setVertexBufferAt(0, null);
			context.setVertexBufferAt(1, null);
			context.setVertexBufferAt(2, null);
			context.setVertexBufferAt(3, null);
			context.setVertexBufferAt(4, null);
			context.setVertexBufferAt(5, null);
			context.setVertexBufferAt(6, null);
			context.setScissorRectangle(null);
		}
		
		public function updateParticles():void
		{
			particleSystem2DMesh2D.mVertexBuffer = null;
			particleSystem2DMesh2D.needUploadVertexBuffer = true;
			particleSystem2DMesh2D.numParticles = _numParticles;
			particleSystem2DMesh2D.preset = _preset;
			particleSystem2DMesh2D.prepareBuffersData();
			invalidateParticles = false;
		}
		
	}

}