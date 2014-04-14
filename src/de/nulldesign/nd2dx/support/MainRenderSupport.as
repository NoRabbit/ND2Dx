package de.nulldesign.nd2dx.support 
{
	import de.nulldesign.nd2dx.components.Mesh2DRendererComponent;
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.materials.MaterialBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class MainRenderSupport extends RenderSupportBase
	{
		public var material:MaterialBase;
		
		public function MainRenderSupport() 
		{
			
		}
		
		override public function drawMesh(meshRenderer:Mesh2DRendererComponent):void 
		{
			meshRenderer.node.checkAndUpdateMatrixIfNeeded();
			material = meshRenderer.material;
			material.viewProjectionMatrix = viewProjectionMatrix;
			material.render(context);
		}
	}

}