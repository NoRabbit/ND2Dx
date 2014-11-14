package showdown.scenes.cube3d {
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import showdown.assets.Assets;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Cube3D extends Node2D
	{
		public var speedX:Number = 0.0;
		public var speedY:Number = 0.0;
		public var speedZ:Number = 0.0;
		
		public function Cube3D() 
		{
			scaleX = scaleY = scaleZ = 0.18;
			
			addChild(createFaceAt("back", 0.0, 0.0, 125.0, 0.0, 0.0, 0.0));
			addChild(createFaceAt("front", 0.0, 0.0, -125.0, 0.0, 180.0, 0.0));
			addChild(createFaceAt("right", 125.0, 0.0, 0.0, 0.0, 90.0, 0.0));
			addChild(createFaceAt("left", -125.0, 0.0, 0.0, 0.0, -90.0, 0.0));
			addChild(createFaceAt("bottom", 0.0, 125.0, 0.0, -90.0, 0.0, 0.0));
			addChild(createFaceAt("top", 0.0, -125.0, 0.0, 90.0, 0.0, 0.0));
			
			speedX = 20.0 + Math.random() * 20.0;
			speedY = 20.0 + Math.random() * 20.0;
			speedZ = 20.0 + Math.random() * 20.0;
		}
		
		override public function step(elapsed:Number):void 
		{
			rotationX += elapsed * speedX;
			rotationY += elapsed * speedY;
			rotationZ += elapsed * speedZ;
		}
		
		public function createFaceAt(name:String, x:Number, y:Number, z:Number, rotationX:Number, rotationY:Number, rotationZ:Number):Node2D
		{
			var n:Node2D = new Node2D();
			n.name = name;
			n.addComponent(new TexturedMeshRendererComponent(Assets.assetsTexture.getSubTextureByName("RTS_Crate")));
			n.x = x;
			n.y = y;
			n.z = z;
			n.rotationX = rotationX;
			n.rotationY = rotationY;
			n.rotationZ = rotationZ;
			
			return n;
		}
		
	}

}