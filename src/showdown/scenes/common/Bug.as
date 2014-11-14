package showdown.scenes.common 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import showdown.assets.Assets;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Bug extends Node2D
	{
		public var speed:Number = 1.0;
		
		public function Bug() 
		{
			addComponent(new TexturedMeshRendererComponent(Assets.assetsTexture.getSubTextureByName("bug01")));
			_scaleX = _scaleY = 0.25;
			speed = 0.5 + Math.random();
		}
		
		override public function step(elapsed:Number):void 
		{
			_rotationZ += 90.0 * elapsed * speed;
			invalidateMatrix = true;
		}
	}

}