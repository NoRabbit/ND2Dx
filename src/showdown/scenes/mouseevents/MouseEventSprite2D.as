package showdown.scenes.mouseevents 
{
	import de.nulldesign.nd2dx.components.renderers.TexturedMeshRendererComponent;
	import de.nulldesign.nd2dx.display.Node2D;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import showdown.assets.Assets;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class MouseEventSprite2D extends Node2D
	{
		public var aim:Node2D;
		
		public function MouseEventSprite2D() 
		{
			addComponent(new TexturedMeshRendererComponent(Assets.assetsTexture.getSubTextureByName("RTS_Crate")));
			
			aim = new Node2D();
			aim.addComponent(new TexturedMeshRendererComponent(Assets.assetsTexture.getSubTextureByName("aim")));
			
			addChild(aim);
			
			mouseEnabled = mouseChildren = true;
			
			//addSignalListener(MouseEvent.MOUSE_MOVE
		}
		
		//private function this_onMouseEventHandler(type:String, target:Node2D, currentTarget:Node2D, e:MouseEvent):void 
		//{
			//if ( type != MouseEvent.MOUSE_MOVE )
			//{
				//txt.text = "target: " + (target ? target.name : "no target") + "\ncurrentTarget: " + (currentTarget ? currentTarget.name : "no currentTarget") + "\ntype: " + type;
			//}
		//}
		
		override public function step(elapsed:Number):void 
		{
			if ( hitTest() )
			{
				aim.visible = true;
				aim.x = _mouseX;
				aim.y = _mouseY;
			}
			else
			{
				aim.visible = false;
			}
		}
		
	}

}