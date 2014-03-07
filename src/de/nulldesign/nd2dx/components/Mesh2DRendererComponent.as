package de.nulldesign.nd2dx.components 
{
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.materials.MaterialBase;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.support.RenderSupportBase;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Mesh2DRendererComponent extends ComponentBase
	{
		private var _mesh:Mesh2D = null;
		private var _material:MaterialBase = null;
		
		public function Mesh2DRendererComponent() 
		{
			
		}
		
		public function get mesh():Mesh2D 
		{
			return _mesh;
		}
		
		public function set mesh(value:Mesh2D):void 
		{
			_mesh = value;
			checkForReferences();
		}
		
		public function get material():MaterialBase 
		{
			return _material;
		}
		
		public function set material(value:MaterialBase):void 
		{
			_material = value;
			checkForReferences();
		}
		
		override public function onAddedToNode():void 
		{
			checkForReferences();
		}
		
		public function checkForReferences():void
		{
			if ( _material && node ) _material.node = node;
			if ( _material && _mesh ) _material.mesh = _mesh;
		}
		
		override public function handleDeviceLoss():void 
		{
			if ( material ) material.handleDeviceLoss();
			if ( mesh ) mesh.handleDeviceLoss();
		}
		
		override public function draw(renderSupport:RenderSupportBase):void 
		{
			if ( mesh.needUploadVertexBuffer ) mesh.uploadBuffers(renderSupport.context);
			
			renderSupport.drawMesh(this);
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			mesh = null;
			material = null;
		}
	}

}