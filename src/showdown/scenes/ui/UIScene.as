package showdown.scenes.ui 
{
	import de.nulldesign.nd2dx.display.ui.button.UIButtonNode2D;
	import de.nulldesign.nd2dx.display.ui.icon.UIIconNode2D;
	import de.nulldesign.nd2dx.display.ui.label.UILabelNode2D;
	import de.nulldesign.nd2dx.display.ui.layout.UIContainerHorizontalLayout;
	import de.nulldesign.nd2dx.display.ui.layout.UIContainerVerticalLayout;
	import de.nulldesign.nd2dx.display.ui.UIContainerNode2D;
	import flash.display.Shape;
	import flash.geom.Point;
	import showdown.assets.Assets;
	import showdown.scenes.SceneBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIScene extends SceneBase
	{
		public var container:UIContainerNode2D;
		
		public var label:UILabelNode2D;
		public var icon:UIIconNode2D;
		public var icon02:UIIconNode2D;
		public var button:UIButtonNode2D;
		
		public var shape:Shape;
		
		public function UIScene() 
		{
			name = "User Interface";
			
			container = new UIContainerNode2D();
			container.layout = UIContainerVerticalLayout.reference;
			label = new UILabelNode2D();
			icon = new UIIconNode2D();
			icon02 = new UIIconNode2D();
			button = new UIButtonNode2D();
			
			button.label.tint = 0x333333;
			button.minUIWidth = 138;
			button.minUIHeight = 50;
			button.paddingTop = 16.0;
			button.paddingLeft = 16.0;
			button.backgroundTexture = Assets.atlas01Texture2D.getSubTextureByName("buttonlike");
			button.dataSource = { label:"Hello tout le monde comment vas tu", labelStyle:Assets.fontBNPSansCond36Style };
			
			
			label.bitmapFont2D.style = Assets.fontBNPSansCond36Style;
			label.dataSource = "hello tout le monde";
			
			icon.dataSource = Assets.atlas01Texture2D.getSubTextureByName("square_test");
			icon02.dataSource = Assets.atlas01Texture2D.getSubTextureByName("star");
			
			container.addItem(label.setUISize("100%", 34), false);
			container.addItem(icon.setUISize(24, 24), false);
			container.addItem(button.setUISize("100%", "100%"), false);
			container.addItem(icon02.setUISize(16, "100%"), false);
			
			addChild(container);
			container.setUISize(300, 16);
			
			container.x = 120.0;
			container.y = 100.0;
		}
		
		override public function step(elapsed:Number):void 
		{
			if ( stage )
			{
				var w:Number = container.uiWidth;
				var h:Number = container.uiHeight;
				if ( stage.mouseX > container.x + 50.0 ) w = stage.mouseX - container.x;
				if ( stage.mouseY > container.y + 20.0 ) h = stage.mouseY - container.y;
				container.setUISize(w, h);
				
				if ( !shape )
				{
					shape = new Shape();
					stage.addChild(shape);
				}
				
				var p:Point = new Point(button.label.bitmapFont2D.x, button.label.bitmapFont2D.y);
				p = button.label.localToGlobal(p);
				
				shape.graphics.clear();
				shape.graphics.beginFill(0xff0000, 0.25);
				shape.graphics.drawRect(p.x, p.y, button.label.bitmapFont2D.textWidth, button.label.bitmapFont2D.textHeight);
			}
		}
	}

}