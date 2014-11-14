package showdown 
{
	import de.nulldesign.nd2dx.display.Scene2D;
	import de.nulldesign.nd2dx.display.World2D;
	import de.nulldesign.nd2dx.renderers.TexturedMesh3DCloudRenderer;
	import de.nulldesign.nd2dx.utils.Statistics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.ui.Keyboard;
	import net.hires.debug.Stats;
	import showdown.assets.Assets;
	import showdown.scenes.animatedtexture.AnimatedTextureScene;
	import showdown.scenes.animatedtextureparticle.AnimatedTextureParticleScene;
	import showdown.scenes.animatedtexturestresstest.AnimatedTextureStressTestScene;
	import showdown.scenes.cube3d.Cube3DScene;
	import showdown.scenes.directgpu3dstresstest.DirectGPU3DStressTestScene;
	import showdown.scenes.directgpustresstest.DirectGPUStressTestScene;
	import showdown.scenes.dynamicshader.DynamicShaderScene;
	import showdown.scenes.graph3dstresstest.Graph3DStressTestScene;
	import showdown.scenes.graphstresstest.GraphStressTestScene;
	import showdown.scenes.mouseevents.MouseEventsScene;
	import showdown.scenes.particlesystem.ParticleSystem2DScene;
	import showdown.scenes.scissorrect.ScissorRectScene;
	import showdown.scenes.uv.UVScene;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Main extends Sprite
	{
		public static var stats:Stats = new Stats();
		
		public var world:World2D;
		public var vScenes:Vector.<Scene2D> = new Vector.<Scene2D>();
		
		public var currentSceneIndex:int = 0;
		
		public var shape:Shape;
		public var txtTitle:TextField;
		
		public function Main() 
		{
			Assets.init();
			
			vScenes.push(new DynamicShaderScene());
			
			vScenes.push(new Cube3DScene());
			
			vScenes.push(new ParticleSystem2DScene());
			
			vScenes.push(new MouseEventsScene());
			vScenes.push(new ScissorRectScene());
			//vScenes.push(new UVScene());
			
			vScenes.push(new AnimatedTextureScene());
			
			vScenes.push(new GraphStressTestScene());
			vScenes.push(new DirectGPUStressTestScene());
			vScenes.push(new AnimatedTextureStressTestScene());
			
			vScenes.push(new Graph3DStressTestScene());
			vScenes.push(new DirectGPU3DStressTestScene());
			
			addChild(stats);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 60;
			
			world = new World2D(Context3DRenderMode.AUTO, 60, new Rectangle(0, 0, stage.stageWidth, 480));
			world.listenForMouseDownEvent = true;
			world.listenForMouseUpEvent = true;
			world.listenForMouseMoveEvent = true;
			world.addEventListener(Event.INIT, onWorldInit);
			addChild(world);
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onKeyDown(e:KeyboardEvent):void 
		{
			if ( e.keyCode == Keyboard.LEFT )
			{
				gotoPreviousScene();
			}
			else if ( e.keyCode == Keyboard.RIGHT )
			{
				gotoNextScene();
			}
		}
		
		private function onWorldInit(e:Event):void 
		{
			world.start();
			world.scene = vScenes[0];
			
			shape = new Shape();
			shape.graphics.beginFill(0x333333);
			shape.graphics.drawRect(0, 0, stage.stageWidth, 70.0);
			shape.graphics.endFill();
			shape.y = stage.stageHeight - 70.0;
			addChild(shape);
			
			var styleSheet:StyleSheet = new StyleSheet();
            styleSheet.setStyle("xml", {fontSize: '12px', fontFamily: '_sans', textAlign:'center', textIndent:'-20px'});
            styleSheet.setStyle("title", {color:"#FFFFFF"});
            styleSheet.setStyle("info", {color: "#ffc200"});
			
			txtTitle = new TextField();
			txtTitle.styleSheet = styleSheet;
			txtTitle.condenseWhite = true;
			txtTitle.multiline = true;
			txtTitle.wordWrap = true;
			txtTitle.x = 130.0;
			txtTitle.width = stage.stageWidth - 144;
			addChild(txtTitle);
			
			addChild(Assets.logo);
			Assets.logo.x = 16;
			Assets.logo.y = Math.round((stage.height - 70.0) - (Assets.logo.height - 70) * 0.5);
			
			setTitleText();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void 
		{
			stats.update(Statistics.drawCalls, Statistics.triangles, Statistics.sprites, 0, 0);
		}
		
		public function gotoNextScene():void
		{
			currentSceneIndex++;
			if ( currentSceneIndex >= vScenes.length ) currentSceneIndex = 0;
			world.scene = vScenes[currentSceneIndex];
			setTitleText();
		}
		
		public function gotoPreviousScene():void
		{
			currentSceneIndex--;
			if ( currentSceneIndex < 0 ) currentSceneIndex = vScenes.length - 1;
			world.scene = vScenes[currentSceneIndex];
			setTitleText();
		}
		
		public function setTitleText():void
		{
			var s:String = "use left and right arrow keys to switch between scenes";
			
			var xml:XML = <xml>
                <title>{world.scene.name}</title>
                <info>{s}</info>
            </xml>;
			
			txtTitle.htmlText = xml;
			
			txtTitle.autoSize = TextFieldAutoSize.CENTER;
			txtTitle.y = Math.round((stage.stageHeight - 70) - (txtTitle.height - 70) * 0.5);
			
		}
		
	}

}