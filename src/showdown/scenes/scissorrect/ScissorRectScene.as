package showdown.scenes.scissorrect 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Scene2D;
	import de.nulldesign.nd2dx.utils.NodeUtils;
	import flash.display.Shape;
	import flash.geom.Rectangle;
	import showdown.assets.Assets;
	import showdown.scenes.common.Bug;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ScissorRectScene extends SceneBase
	{
		//public var shape:Shape = new Shape();
		
		public var node:Node2D;
		public var container:Node2D;
		
		public function ScissorRectScene() 
		{
			name = "Multiple ScissorRects (Scissor Rectangle)";
			
			node = NodeUtils.createSprite(Assets.assetsTexture.getSubTextureByName("RTS_Crate"));
			node.x = 580 * 0.5;
			node.y = 495 * 0.5;
			node.width = node.height = 380.0;
			addChild(node);
			
			container = createBugsInContainer(new Node2D(), 3, 0.25, 135.0, true);
			container.x = 0.5 * 580.0;
			container.y = 0.5 * 495.0;
			container.scissorRect = new Rectangle(-135, -135, 270, 270);
			addChild(container);
			
			node = NodeUtils.createSprite(Assets.assetsTexture.getSubTextureByName("fence"));
			node.x = 580 * 0.5;
			node.y = 495 * 0.5;
			node.width = node.height = 380.0;
			//(node.getComponentByClass(TexturedQuadRendererComponent) as TexturedQuadRendererComponent).uvScaleX = 0.1;
			//(node.getComponentByClass(TexturedQuadRendererComponent) as TexturedQuadRendererComponent).uvScaleY = 0.1;
			addChild(node);
			
			//node = NodeUtils.createSprite(Assets.assetsTexture.getSubTextureByName("RTS_Crate"));
			//node.x = 580 * 0.75;
			//node.y = 495 * 0.75;
			//node.alpha = 0.85;
			//node.name = "last";
			//addChild(node);
		}
		
		public function createBugsInContainer(container:Node2D, bugCount:int = 10, scale:Number = 0.5, spaceBetweenBugs:Number = 40.0, createNewBugsInBugs:Boolean = false, rotateBugs:Boolean = true):Node2D
		{
			var totalSize:Number = spaceBetweenBugs * (bugCount - 1);
			
			var i:int = 0;
			var n:int = bugCount;
			
			for (; i < n; i++) 
			{
				var j:int = 0;
				var m:int = bugCount;
				
				for (; j < m; j++) 
				{
					var node:Node2D = new Node2D();
					node.name = "nodeBug";
					node.x = -(totalSize * 0.5) + (spaceBetweenBugs * i);
					node.y = -(totalSize * 0.5) + (spaceBetweenBugs * j);
					if ( rotateBugs ) node.scissorRect = new Rectangle(-40, -40, 80, 80);
					container.addChild(node);
					
					var bug:Bug = new Bug();
					bug.name = "bug";
					bug.scaleX = bug.scaleY = scale;
					node.addChild(bug);
					
					if ( createNewBugsInBugs ) bug.addChild(createBugsInContainer(new Node2D(), 2, scale * 2.0, spaceBetweenBugs * 1.95, false, false));
				}
				
			}
			
			return container;
		}
		
		override public function step(elapsed:Number):void 
		{
			super.step(elapsed);
			
			if ( stage )
			{
				//if ( !shape.parent ) stage.addChild(shape);
				
				container.scissorRect.x = stage.mouseX - container.x;
				container.scissorRect.y = stage.mouseY - container.y;
				//container.x = stage.mouseX;
				//container.y = stage.mouseY;
				//s.scrollRect.x = stage.mouseX;
				//s.scrollRect.y = stage.mouseY;
				//container.invalidateMatrix = true;
				container.invalidateScissorRect = true;
			}
			
			
			//if ( s.worldScrollRect )
			//{
				//shape.graphics.clear();
				//shape.graphics.beginFill(0xff0000, 0.5);
				//shape.graphics.drawRect(s.worldScrollRect.x, s.worldScrollRect.y, s.worldScrollRect.width, s.worldScrollRect.height);
				//shape.graphics.endFill();
			//}
			
		}
	}

}