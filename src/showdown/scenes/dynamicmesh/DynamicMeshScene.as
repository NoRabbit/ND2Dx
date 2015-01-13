package showdown.scenes.dynamicmesh 
{
	import com.rabbitframework.easing.Expo;
	import com.rabbitframework.easing.Quad;
	import com.rabbitframework.tween.RabbitTween;
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.managers.resource.ResourceDescriptor;
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2D;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2DStepsAllocator;
	import de.nulldesign.nd2dx.signals.MouseSignal;
	import de.nulldesign.nd2dx.utils.MeshUtil;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.setTimeout;
	import showdown.assets.Assets;
	import showdown.scenes.common.Bug;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DynamicMeshScene extends SceneBase
	{
		public var node:Node2D;
		public var mesh:Mesh2D;
		
		public var clonedVertexList:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		
		public var isOpen:Boolean = true;
		public var isTweening:Boolean = false;
		
		public function DynamicMeshScene() 
		{
			name = "Dynamic Mesh rendering, click anywhere on the screen. Bugs are there to show that everything is being batched together. The crate is made up of 400 squares / 800 triangles.";
			
			node = new Node2D();
			mesh = resourceManager.createResource(ResourceDescriptor.MESH, new Mesh2DStepsAllocator(20, 20, 1.0, 1.0)) as Mesh2D;
			
			// clone vertices, to keep original values
			var i:int = 0;
			var n:int = mesh.vertexList.length;
			
			for (; i < n; i++) 
			{
				clonedVertexList.push(mesh.vertexList[i].clone());
			}
			
			// create our component that will render our mesh
			var texturedMeshRendererComponent:TexturedMeshRendererComponent = new TexturedMeshRendererComponent();
			
			// set texture
			texturedMeshRendererComponent.texture = Assets.assetsTexture.getSubTextureByName("RTS_Crate");
			
			// set our custom mesh
			texturedMeshRendererComponent.mesh = mesh;
			
			// specify that it needs to render our mesh based on texture size (so our mesh is supposedly normalized, between -0.5 and 0.5)
			texturedMeshRendererComponent.useTextureSize = true;
			
			node.addComponent(texturedMeshRendererComponent);
			
			addChild(node);
			
			node.x = 585 * 0.5;
			node.y = 480 * 0.5;
			
			node.mouseEnabled = true;
			mouseEnabled = true;
			
			i = 0;
			n = 20;
			var bug:Node2D;
			
			for (; i < n; i++) 
			{
				bug = addChild(new Bug());
				bug.scaleX = bug.scaleY = 0.25;
				bug.x = 585 * Math.random();
				bug.y = 480 * Math.random();
			}
			
			this.addSignalListener(MouseEvent.CLICK, onClick);
		}
		
		private function onClick(mouseSignal:MouseSignal):void 
		{
			if ( isTweening ) return;
			isTweening = true;
			
			var mouseXScaled:Number = node.mouseX / node.width;
			var mouseYScaled:Number = node.mouseY / node.height;
			
			var pFrom:Point = new Point();
			var pTo:Point = new Point(mouseXScaled, mouseYScaled);
			
			var i:int = 0;
			var n:int = 0;
			var delay:Number = 0;
			var maxDelay:Number = 0;
			//var random:Number = (Math.random() > 0.5 ? 0.0 : 1.0);
			var random:Number = 1.0;
			
			if ( isOpen )
			{
				// then "close" it
				n = mesh.vertexList.length
				
				for (; i < n; i++) 
				{
					pFrom.x = mesh.vertexList[i].x;
					pFrom.y = mesh.vertexList[i].y;
					
					delay = Point.distance(pFrom, pTo);
					if ( delay > maxDelay ) maxDelay = delay;
					
					new RabbitTween().initTween(mesh.vertexList[i], 0.5, delay * (random < 1.0 ? Math.random() : 1.0) )
					.setProperty("overwrite", null, RabbitTween.OVERWRITE_ALL)
					.setProperty("x", null, mouseXScaled)
					.setProperty("y", null, mouseYScaled)
					.setProperty("ease", null, Expo.easeOut)
					.start();
				}
				
				isOpen = false;
			}
			else
			{
				// re-open it
				n = mesh.vertexList.length
				
				for (; i < n; i++) 
				{
					pFrom.x = clonedVertexList[i].x;
					pFrom.y = clonedVertexList[i].y;
					
					mesh.vertexList[i].x = mouseXScaled;
					mesh.vertexList[i].y = mouseYScaled;
					
					delay = 1.25 - Point.distance(pFrom, pTo);
					
					delay *= i / n;
					if ( delay > maxDelay ) maxDelay = delay;
					
					new RabbitTween().initTween(mesh.vertexList[i], 0.5, delay * (random < 1.0 ? Math.random() : 1.0))
					.setProperty("overwrite", null, RabbitTween.OVERWRITE_ALL)
					.setProperty("x", mouseXScaled, clonedVertexList[i].x)
					.setProperty("y", mouseYScaled, clonedVertexList[i].y)
					.setProperty("ease", null, Expo.easeOut)
					.start();
				}
				
				isOpen = true;
			}
			
			setTimeout(onTweensComplete, maxDelay * 1000);
		}
		
		private function onTweensComplete():void 
		{
			isTweening = false;
		}
		
	}

}