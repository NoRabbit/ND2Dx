package showdown.scenes.mouseevents 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Scene2D;
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	import showdown.assets.Assets;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class MouseEventsScene extends SceneBase
	{
		public function MouseEventsScene() 
		{
			name = "MouseEvents propagation";
			
			var s:MouseEventSprite2D = new MouseEventSprite2D();
			addChild(s);
			s.x = 580 * 0.5;
			s.y = (480 * 0.5) - 80;
			s.scaleX = s.scaleY = 0.85;
			s.name = "parent";
			
			s = s.addChild(new MouseEventSprite2D()) as MouseEventSprite2D;
			s.rotation = 25.0;
			s.x = -102.5;
			s.y = 102.5;
			s.scaleX = s.scaleY = 0.65;
			s.name = "child";
			s.alpha = 0.85;
			
			s = s.addChild(new MouseEventSprite2D()) as MouseEventSprite2D;
			s.rotation = -50.0;
			s.x = s.y = 140.0;
			s.scaleX = s.scaleY = 0.85;
			s.name = "child of child";
		}
	}

}