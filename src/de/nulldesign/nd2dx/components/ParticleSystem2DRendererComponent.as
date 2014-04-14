package de.nulldesign.nd2dx.components 
{
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.geom.ParticleSystem2DMesh2D;
	import de.nulldesign.nd2dx.materials.MaterialBase;
	import de.nulldesign.nd2dx.materials.ParticleSystem2DMaterial;
	import de.nulldesign.nd2dx.support.MainRenderSupport;
	import de.nulldesign.nd2dx.support.RenderSupportBase;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	import de.nulldesign.nd2dx.utils.ParticleSystem2DPreset;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ParticleSystem2DRendererComponent extends Mesh2DRendererComponent
	{
		public var particleSystem2DMaterial:ParticleSystem2DMaterial;
		public var particleSystem2DMesh2D:ParticleSystem2DMesh2D;
		private var _preset:ParticleSystem2DPreset;
		private var _numParticles:uint = 50;
		
		public var invalidateParticles:Boolean = true;
		public var mainRenderSupport:MainRenderSupport;
		
		public function ParticleSystem2DRendererComponent() 
		{
			mainRenderSupport = renderSupportManager.mainRenderSupport;
			material = new ParticleSystem2DMaterial();
			mesh = MeshUtil.generateMesh2D(1, 1, 1, 1, ParticleSystem2DMesh2D);
			preset = new ParticleSystem2DPreset();
		}
		
		override public function set material(value:MaterialBase):void 
		{
			super.material = value;
			particleSystem2DMaterial = value as ParticleSystem2DMaterial;
		}
		
		override public function set mesh(value:Mesh2D):void 
		{
			super.mesh = value;
			particleSystem2DMesh2D = value as ParticleSystem2DMesh2D;
			invalidateParticles = true;
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
		
		override public function step(elapsed:Number):void 
		{
			if ( invalidateParticles ) updateParticles();
			particleSystem2DMaterial.currentTime += elapsed * 1000;
			
			if ( particleSystem2DMaterial.isBurst && particleSystem2DMaterial.currentTime > particleSystem2DMesh2D.totalDuration )
			{
				isActive = false;
			}
		}
		
		override public function draw(renderSupport:RenderSupportBase):void 
		{
			if ( _mesh.needUploadVertexBuffer ) _mesh.uploadBuffers(renderSupport.context);
			
			renderSupport.finalize();
			
			mainRenderSupport.elapsed = renderSupport.elapsed;
			mainRenderSupport.camera = renderSupport.camera;
			mainRenderSupport.viewProjectionMatrix = renderSupport.viewProjectionMatrix;
			mainRenderSupport.context = renderSupport.context;
			mainRenderSupport.deviceWasLost = renderSupport.deviceWasLost;
			
			mainRenderSupport.drawMesh(this);
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