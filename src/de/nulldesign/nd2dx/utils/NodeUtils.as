package de.nulldesign.nd2dx.utils 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class NodeUtils 
	{
		
		public function NodeUtils() 
		{
			
		}
		
		
		public static function createSprite(texture:Texture2D):Node2D
		{
			var node:Node2D = new Node2D();
			node.addComponent(new TexturedMeshRendererComponent(texture));
			return node;
		}
	}

}