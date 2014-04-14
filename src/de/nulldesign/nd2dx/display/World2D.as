/*
 * ND2D - A Flash Molehill GPU accelerated 2D engine
 *
 * Author: Lars Gerckens
 * Copyright (c) nulldesign 2011
 * Repository URL: http://github.com/nulldesign/nd2d
 * Getting started: https://github.com/nulldesign/nd2d/wiki
 *
 *
 * Licence Agreement
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

package de.nulldesign.nd2dx.display 
{	
	import de.nulldesign.nd2dx.materials.shader.ShaderCache;
	import de.nulldesign.nd2dx.support.MainRenderSupport;
	import de.nulldesign.nd2dx.support.RenderSupportBase;
	import de.nulldesign.nd2dx.support.RenderSupportManager;
	import de.nulldesign.nd2dx.utils.Statistics;
	import de.nulldesign.nd2dx.utils.WorldUtil;
	import org.osflash.signals.Signal;

	import flash.display.Sprite;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DCompareMode;
	import flash.display3D.Context3DRenderMode;
	import flash.display3D.Context3DTriangleFace;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TouchEvent;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.getTimer;

	/**
	 * Dispatched when the World2D is initialized and the context3D is available.
	 * The flag 'isHardwareAccelerated' is available then
	 * @eventType flash.events.Event.INIT
	 */
	[Event(name="init", type="flash.events.Event")]

	/**
	 * <p>Baseclass for ND2D</p>
	 * Extend this class and add your own scenes and sprites
	 *
	 * Set up your project like this:
	 * <ul>
	 * <li>MyGameWorld2D</li>
	 * <li>- MyStartScene2D</li>
	 * <li>-- StartButtonSprite2D</li>
	 * <li>-- ...</li>
	 * <li>- MyGameScene2D</li>
	 * <li>-- GameSprites2D</li>
	 * <li>-- ...</li>
	 * </ul>
	 * <p>Put your game logic in the step() method of each scene / node</p>
	 *
	 * You can switch between scenes with the setActiveScene method of World2D.
	 * There can be only one active scene.
	 *
	 */
	public class World2D extends Sprite 
	{
		public var renderSupportManager:RenderSupportManager = RenderSupportManager.getInstance();
		
		public var antiAliasing:uint = 0;
		public var depthAndStencil:Boolean = false;
		public var enableErrorChecking:Boolean = true;

		public var timeSinceStartInSeconds:Number = 0.0;

		public var camera:Camera2D = new Camera2D(1, 1);
		public var context3D:Context3D;
		public var stageID:uint;
		protected var scene:Scene2D;
		protected var frameRate:uint;
		protected var isPaused:Boolean = false;
		public var bounds:Rectangle;
		protected var lastFramesTime:Number = 0.0;

		protected var renderMode:String;
		protected var profile:String = "baseline";
		protected var mousePosition:Vector3D = new Vector3D(0.0, 0.0, 0.0);
		protected var deviceInitialized:Boolean = false;
		public var deviceWasLost:Boolean = false;
		
		public var mouseInNode:Node2D = null;
		public var mouseDownInNode:Node2D = null;
		
		public var renderSupport:RenderSupportBase;
		
		public var onInit:Signal = new Signal(World2D);
		
		/**
		 * Constructor of class world
		 *
		 * @param renderMode Context3DRenderMode (auto, software)
		 * @param frameRate timer and the swf will be set to this framerate
		 * @param bounds the worlds boundaries
		 * @param stageID
		 */
		public function World2D(renderMode:String = Context3DRenderMode.AUTO, frameRate:uint = 60, bounds:Rectangle = null, stageID:uint = 0, renderSupport:RenderSupportBase = null)
		{
			WorldUtil.world2D = this;
			
			this.renderMode = renderMode;
			this.frameRate = frameRate;
			this.bounds = bounds;
			this.stageID = stageID;
			
			if ( !renderSupport ) renderSupport = renderSupportManager.mainRenderSupport;
			renderSupport.camera = camera;
			
			this.renderSupport = renderSupport;
			renderSupportManager.currentRenderSupport = this.renderSupport;
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}

		protected function addedToStage(event:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			
			WorldUtil.stage = stage;
			
			stage.addEventListener(Event.RESIZE, resizeStage);
			stage.frameRate = frameRate;
			
			checkForContext();

			Statistics.stage = stage;
		}
		
		public function checkForContext():void
		{
			if (stage.stage3Ds[stageID].context3D) 
			{				
				context3DCreated(null);
			}
			else
			{
				stage.stage3Ds[stageID].addEventListener(Event.CONTEXT3D_CREATE, context3DCreated);
				stage.stage3Ds[stageID].addEventListener(ErrorEvent.ERROR, context3DError);
				//stage.stage3Ds[stageID].requestContext3D(renderMode);
				
				var requestContext3D:Function = stage.stage3Ds[stageID].requestContext3D;
				
				if (requestContext3D.length == 1)
				{
					requestContext3D(renderMode);
				}
				else
				{
					requestContext3D(renderMode, profile);
					//requestContext3D(renderMode);
				}
			}
			
			listenForMouseDownEvent = false;
			listenForMouseMoveEvent = false;
			listenForMouseUpEvent = false;
			
			listenForMouseDownEvent = preListenForMouseDownEvent;
			listenForMouseMoveEvent = preListenForMouseMoveEvent;
			listenForMouseUpEvent = preListenForMouseUpEvent;
		}

		protected function context3DError(e:ErrorEvent):void 
		{			
			throw new Error("The SWF is not embedded properly. The 3D context can't be created. Wrong WMODE? Set it to 'direct'. For AIR it's renderMode = direct in the application descriptor");
		}

		protected function context3DCreated(e:Event):void 
		{
			context3D = stage.stage3Ds[stageID].context3D;
			context3D.enableErrorChecking = enableErrorChecking;
			context3D.setCulling(Context3DTriangleFace.NONE);
			context3D.setDepthTest(false, Context3DCompareMode.ALWAYS);
			
			renderSupport.context = context3D;
			
			Statistics.driverInfo = context3D.driverInfo;
			Statistics.isAccelerated = context3D.driverInfo.toLowerCase().indexOf("software") == -1;
			
			// limit to 30fps in software mode
			if (!Statistics.isAccelerated) 
			{
				frameRate = Math.min(30, frameRate);
				stage.frameRate = frameRate;
			}
			
			resizeStage();
			
			// means we got the Event.CONTEXT3D_CREATE for the second time, the device was lost. reinit everything
			if (deviceInitialized) 
			{				
				deviceWasLost = true;
				renderSupport.deviceWasLost = true;
			}
			
			deviceInitialized = true;
			
			if (scene) 
			{
				scene.setReferences(stage, camera, this, scene);
			}
			
			onInit.dispatch(this);
		}
		
		protected function mouseEventHandler(event:MouseEvent):void 
		{
			if ( scene && ( scene.mouseChildren || scene.mouseEnabled ) && stage && camera ) 
			{
				// transformation of normalized coordinates between -1 and 1
				mousePosition.x = (stage.mouseX - (bounds ? bounds.x : 0.0)) / camera.sceneWidth * 2.0 - 1.0;
				mousePosition.y = -((stage.mouseY - (bounds ? bounds.y : 0.0)) / camera.sceneHeight * 2.0 - 1.0);
				mousePosition.z = 0.0;
				mousePosition.w = 1.0;
				
				var mouseNode:Node2D = scene.processMouseEvent(mousePosition, event, camera.getViewProjectionMatrix());
				
				if ( mouseNode )
				{
					// update mouse position
					mouseNode.updateMousePosition(mousePosition, camera.getViewProjectionMatrix());
					
					if ( mouseInNode && mouseInNode != mouseNode )
					{
						dispatchMouseEventInNodeAndItsParents(mouseInNode, MouseEvent.MOUSE_OUT, null, event);
						mouseInNode = null;
					}
					
					if ( event.type == MouseEvent.MOUSE_MOVE )
					{
						if ( mouseInNode )
						{
							// mouse is moving inside node
							dispatchMouseEventInNodeAndItsParents(mouseNode, MouseEvent.MOUSE_MOVE, mouseNode, event);
						}
						else
						{
							// mouse just entered node
							dispatchMouseEventInNodeAndItsParents(mouseNode, MouseEvent.MOUSE_OVER, mouseNode, event);
							
							// and is also moving inside
							dispatchMouseEventInNodeAndItsParents(mouseNode, MouseEvent.MOUSE_MOVE, mouseNode, event);
						}
					}
					else
					{
						if ( event.type == MouseEvent.MOUSE_DOWN )
						{
							// mouse is down in node
							mouseDownInNode = mouseNode
							dispatchMouseEventInNodeAndItsParents(mouseNode, MouseEvent.MOUSE_DOWN, mouseNode, event);
						}
						else if ( event.type == MouseEvent.MOUSE_UP )
						{
							// check if mouse down on that node before
							if ( mouseDownInNode == mouseNode )
							{
								// dispatch mouse up
								dispatchMouseEventInNodeAndItsParents(mouseNode, MouseEvent.MOUSE_UP, mouseNode, event);
								
								// dispatch click
								dispatchMouseEventInNodeAndItsParents(mouseNode, MouseEvent.CLICK, mouseNode, event);
							}
							else
							{
								if ( mouseDownInNode )
								{
									dispatchMouseEventInNodeAndItsParents(mouseDownInNode, "releaseOutside", null, event);
								}
								
								// dispatch mouse up
								dispatchMouseEventInNodeAndItsParents(mouseNode, MouseEvent.MOUSE_UP, mouseNode, event);
							}
							
							mouseDownInNode = null;
						}
					}
					
					// mouse is currently inside this node
					mouseInNode = mouseNode;
				}
				else if ( event.type == MouseEvent.MOUSE_MOVE && mouseInNode )
				{
					dispatchMouseEventInNodeAndItsParents(mouseInNode, MouseEvent.MOUSE_OUT, null, event);
					mouseInNode = null;
				}
				else if ( event.type == MouseEvent.MOUSE_UP && mouseDownInNode )
				{
					dispatchMouseEventInNodeAndItsParents(mouseDownInNode, "releaseOutside", null, event);
					mouseDownInNode = null;
				}
			}
		}
		
		public function dispatchMouseEventInNodeAndItsParents(node:Node2D, type:String, target:Node2D, event:MouseEvent):void
		{
			node.onMouseEvent.dispatch(type, target, node, event);
			
			if ( !node.mousePropagate || !node.mousePropagateOnce )
			{
				node.mousePropagateOnce = true;
				return;
			}
			
			var parent:Node2D = node.parent;
			
			while (parent)
			{
				parent.onMouseEvent.dispatch(type, target, parent, event);
				
				if ( !parent.mousePropagate || !parent.mousePropagateOnce )
				{
					parent.mousePropagateOnce = true;
					return;
				}
				
				parent = parent.parent;
			}
		}

		public function resizeStage(e:Event = null):void {
			if(!context3D || context3D.driverInfo == "Disposed") {
				return;
			}

			var rect:Rectangle = bounds ? bounds : new Rectangle(0, 0, stage.stageWidth, stage.stageHeight);

			if(!rect.width || !rect.height) {
				return;
			}

			stage.stage3Ds[stageID].x = rect.x;
			stage.stage3Ds[stageID].y = rect.y;

			context3D.configureBackBuffer(rect.width, rect.height, antiAliasing, depthAndStencil);
			camera.resizeCameraStage(rect.width, rect.height);
		}

		protected function mainLoop(e:Event):void 
		{
			timeSinceStartInSeconds = getTimer() * 0.001;
			
			renderSupportManager.initRenderSupports();
			renderSupportManager.currentRenderSupport = renderSupport;
			
			renderSupport.elapsed = timeSinceStartInSeconds - lastFramesTime;
			
			if (scene && context3D && context3D.driverInfo != "Disposed") 
			{				
				context3D.clear(scene.br, scene.bg, scene.bb, scene.ba);
				
				if (deviceWasLost) 
				{
					ShaderCache.handleDeviceLoss();
					scene.handleDeviceLoss();
					
					Statistics.handleDeviceLoss();
					
					deviceWasLost = false;
				}
				
				Statistics.reset();
				
				renderSupport.viewProjectionMatrix = camera.getViewProjectionMatrix();
				renderSupport.prepare();
				
				scene.drawNode(renderSupport);
				
				//renderSupport.finalize();
				renderSupportManager.currentRenderSupport.finalize();
				
				context3D.present();
			}
			
			lastFramesTime = timeSinceStartInSeconds;
		}

		public function setActiveScene(value:Scene2D):void 
		{			
			if (scene) 
			{
				scene.setReferences(null, null, null, null);
			}
			
			scene = value;
			
			if (scene) 
			{
				scene.setReferences(stage, camera, this, scene);
				scene.step(0);
			}
		}
		
		public function get activeScene():Scene2D
		{
			return scene;
		}

		public function start():void 
		{
			wakeUp();
		}

		/**
		 * Pause all movement in your game. The drawing loop will still fire
		 */
		public function pause():void {
			isPaused = true;
		}

		/**
		 * Resume movement in your game.
		 */
		public function resume():void {
			isPaused = false;
		}

		/**
		 * Put everything to sleep, no drawing and step loop will be fired
		 */
		public function sleep():void 
		{
			removeEventListener(Event.ENTER_FRAME, mainLoop);

			if(context3D && scene) {
				context3D.clear(scene.br, scene.bg, scene.bb, scene.ba);
				context3D.present();
			}
		}

		/**
		 * wake up from sleep. draw / step loops will start to fire again
		 */
		public function wakeUp():void 
		{
			removeEventListener(Event.ENTER_FRAME, mainLoop);
			addEventListener(Event.ENTER_FRAME, mainLoop);
		}

		public function dispose():void 
		{			
			sleep();
			
			stage.removeEventListener(Event.RESIZE, resizeStage);
			
			for (var i:int = 0; i < stage.stage3Ds.length; i++) 
			{
				stage.stage3Ds[i].removeEventListener(Event.CONTEXT3D_CREATE, context3DCreated);
				stage.stage3Ds[i].removeEventListener(ErrorEvent.ERROR, context3DError);
			}
			
			listenForMouseDownEvent = false;
			listenForMouseMoveEvent = false;
			listenForMouseUpEvent = false;
			
			if (context3D) 
			{				
				context3D.dispose();
				context3D = null;
			}
			
			if (scene) 
			{				
				scene.dispose();
				scene = null;
			}
			
			camera = null;
		}
		
		private var _listenForMouseDownEvent:Boolean = false;
		private var preListenForMouseDownEvent:Boolean = true;
		
		private var _listenForMouseUpEvent:Boolean = false;
		private var preListenForMouseUpEvent:Boolean = true;
		
		private var _listenForMouseMoveEvent:Boolean = false;
		private var preListenForMouseMoveEvent:Boolean = false;
		
		public function get listenForMouseMoveEvent():Boolean 
		{
			return _listenForMouseMoveEvent;
		}
		
		public function set listenForMouseMoveEvent(value:Boolean):void 
		{
			if ( _listenForMouseMoveEvent == value ) return;
			
			if ( !stage )
			{
				preListenForMouseMoveEvent = value;
				return;
			}
			
			_listenForMouseMoveEvent = value;
			
			if ( _listenForMouseMoveEvent )
			{
				stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseEventHandler);
			}
		}
		
		public function get listenForMouseUpEvent():Boolean 
		{
			return _listenForMouseUpEvent;
		}
		
		public function set listenForMouseUpEvent(value:Boolean):void 
		{
			if ( _listenForMouseUpEvent == value ) return;
			_listenForMouseUpEvent = value;
			
			if ( !stage )
			{
				preListenForMouseUpEvent = value;
				return;
			}
			
			if ( _listenForMouseUpEvent )
			{
				stage.addEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_UP, mouseEventHandler);
			}
		}
		
		public function get listenForMouseDownEvent():Boolean 
		{
			return _listenForMouseDownEvent;
		}
		
		public function set listenForMouseDownEvent(value:Boolean):void 
		{
			if ( _listenForMouseDownEvent == value ) return;
			_listenForMouseDownEvent = value;
			
			if ( !stage )
			{
				preListenForMouseDownEvent = value;
				return;
			}
			
			if ( _listenForMouseDownEvent )
			{
				stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			}
			else
			{
				stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseEventHandler);
			}
		}
	}
}
