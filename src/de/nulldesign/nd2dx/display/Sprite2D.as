package de.nulldesign.nd2dx.display 
{
	import de.nulldesign.nd2dx.components.Mesh2DRendererComponent;
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.materials.texture.Texture2D;
	import de.nulldesign.nd2dx.materials.Texture2DMaterial;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Sprite2D extends Node2D
	{
		// static quad mesh that we can use for every Sprite2D
		public static var quadMesh2D:Mesh2D = MeshUtil.generateMesh2D(1, 1, 1, 1);
		
		public var mesh2DRendererComponent:Mesh2DRendererComponent;
		public var texture2DMaterial:Texture2DMaterial;
			
		public function Sprite2D(texture:Texture2D = null) 
		{
			mesh2DRendererComponent = new Mesh2DRendererComponent();
			mesh2DRendererComponent.mesh = quadMesh2D;
			addComponent(mesh2DRendererComponent);
			
			setTexture(texture);
		}
		
		public function setTexture(texture:Texture2D):void
		{
			if ( !texture2DMaterial ) texture2DMaterial = new Texture2DMaterial();
			
			texture2DMaterial.setTexture(texture);
			
			if( texture2DMaterial.texture )
			{
				mesh2DRendererComponent.material = texture2DMaterial;
			}
			else
			{
				mesh2DRendererComponent.material = null;
			}
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			mesh2DRendererComponent = null;
			texture2DMaterial = null;
		}
		
		override public function releaseForPooling(disposeComponents:Boolean = true, disposeChildren:Boolean = true):void 
		{
			// dispose everything except for mesh2DRendererComponent
			removeComponent(mesh2DRendererComponent);
			super.releaseForPooling(disposeComponents, disposeChildren);
			addComponent(mesh2DRendererComponent);
		}
	}

}