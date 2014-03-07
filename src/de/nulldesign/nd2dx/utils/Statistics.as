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

/* Based and inspired by Mr.doob's Hi-ReS! Stats
 *
 * Released under MIT license:
 * http://www.opensource.org/licenses/mit-license.php
 */

package de.nulldesign.nd2dx.utils {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.system.System;
	import flash.text.StyleSheet;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	import flash.utils.Endian;
	import flash.utils.getTimer;

	/**
	 * ND2D Performance Statistics
	 *
	 * <p>Displays a small widget with general performance relevant information
	 * like frames per second, memory usage, number of textures loaded and
	 * video memory usage, draw calls, sprite count and total triangles.</p>
	 *
	 * <listing>
	 * // show stats
	 * Statistics.enabled = true;
	 *
	 * // if you want them in the top left corner
	 * Statistics.alignRight = false;
	 * </listing>
	 */
	public class Statistics extends Sprite {

		/**
		 * @private
		 */
		public static var stage:Stage;

		/**
		 * Information about render device.
		 *
		 * <p>DirectX9 (Direct blitting), Software (Blitting), etc.</p>
		 */
		public static var driverInfo:String;

		/**
		 * If <code>true</code> hardware acceleration is available.
		 */
		public static var isAccelerated:Boolean;

		/**
		 * Current frames per second.
		 *
		 * <p>Updates more frequent than the actual statistics display.</p>
		 */
		public static var fps:Number = 0;

		/**
		 * Total textures used by the GPU.
		 */
		public static var textures:uint = 0;

		/**
		 * Total GPU video memory in megabytes used by textures.
		 */
		public static var texturesMem:uint = 0;

		/**
		 * Total drawn sprites.
		 */
		public static var sprites:uint = 0;

		/**
		 * Total culled sprites.
		 */
		public static var spritesCulled:uint = 0;

		/**
		 * Total drawn tringles. Mostly 2 triangles per sprite.
		 */
		public static var triangles:uint = 0;

		/**
		 * Total drawcalls send to the GPU.
		 */
		public static var drawCalls:uint = 0;

		private static var compileTime:Date;
		private static var instance:Statistics;
		private static var rightSide:Boolean = true;

		private var text:TextField;
		private var graph:Bitmap;
		private var graphUpdateRect:Rectangle;
		private var driverInfoToggle:Boolean = false;

		public function Statistics() {
		}

		/**
		 * Show or hide the statistics.
		 */
		public static function get enabled():Boolean {
			return (instance != null);
		}

		public static function set enabled(value:Boolean):void {
			if(!stage) {
				return;
			}

			if(value && !instance) {
				instance = new Statistics();
				stage.addChild(instance);

				instance.init();
			} else if(!value && instance) {
				stage.removeChild(instance);

				instance = null;
			}
		}

		/**
		 * If <code>true</code> will align the statistics to the top right corner
		 * of the screen.
		 */
		public static function get alignRight():Boolean {
			return rightSide;
		}

		public static function set alignRight(value:Boolean):void {
			rightSide = value;

			if(instance) {
				instance.resize(null);
			}
		}

		private function init():void {
			graphics.beginFill(0x000000, 0.5);
			graphics.drawRoundRect(0, 0, 90, 120, 10);
			graphics.endFill();

			resize(null);
			stage.addEventListener(Event.RESIZE, resize);

			addEventListener(MouseEvent.CLICK, click);
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(Event.REMOVED_FROM_STAGE, destroy);

			// graph
			graph = new Bitmap(new BitmapData(width, 50, true, 0x00000000));
			graph.y = height - graph.bitmapData.height;
			graphUpdateRect = new Rectangle(width - 1, 0, 1, graph.bitmapData.height);

			addChild(graph);

			// text
			var style:StyleSheet = new StyleSheet();
			style.setStyle("xml", {fontSize: '9px', fontFamily: '_sans', leading: '-2px'});
			style.setStyle("fps", {color: '#FFD700'});
			style.setStyle("mem", {color: '#FF4500'});
			style.setStyle("textures", {color: '#ADFF2F'});
			style.setStyle("sprites", {color: '#B0C4DE'});
			style.setStyle("draws", {color: '#FF9900'});
			style.setStyle("tris", {color: '#87CEFA'});

			text = new TextField();
			text.width = width;
			text.wordWrap = true;
			text.styleSheet = style;
			text.autoSize = TextFieldAutoSize.LEFT;

			addChild(text);
		}

		private function click(event:MouseEvent):void {
			driverInfoToggle = !driverInfoToggle;
			graph.visible = !driverInfoToggle;
		}

		private function resize(event:Event):void {
			if(rightSide) {
				x = stage.stageWidth - width;
			} else {
				x = 0;
			}
		}

		private var time:int;
		private var timeLast:int;
		private var timeUpdate:int;

		private var frameSum:int;
		private var frameTime:int;
		private var frameCount:int;

		private var fpsDisplay:Number = 0;
		private var memoryDisplay:Number = 0;
		private var textureDisplay:Number = 0;

		private function update(event:Event):void {
			time = getTimer();
			frameTime = time - timeLast;

			if(timeLast) {
				frameSum += frameTime;
				frameCount++;

				// mean of 10 frames
				if(frameCount >= 10) {
					fps = 1000 / (frameSum / frameCount);

					frameSum = 0;
					frameCount = 0;
				}
			}

			timeLast = time;

			if(time >= timeUpdate + 1000) {
				timeUpdate = time;

				memoryDisplay = NumberUtil.round(System.totalMemory * 0.000000954, 2);
				textureDisplay = NumberUtil.round(texturesMem * 0.000000954, 2);

				fpsDisplay = NumberUtil.round(fps, 1);

				var fpsGraph:int = Math.min(graph.height, (fps / stage.frameRate) * graph.height);
				var memGraph:int = Math.min(graph.height, Math.sqrt(Math.sqrt(memoryDisplay * 5000))) - 2;

				graph.bitmapData.scroll(-1, 0);
				graph.bitmapData.fillRect(graphUpdateRect, 0x00000000);

				graph.bitmapData.setPixel32(graph.width - 1, graph.height - fpsGraph, 0xFFFFD700);
				graph.bitmapData.setPixel32(graph.width - 1, graph.height - memGraph, 0xFFFF4500);

				fps = 0;
			}

			if(driverInfoToggle) {
				text.htmlText =
					"<xml>" +
					"<mem>Device:</mem>" +
					"<mem>" + driverInfo + "</mem>" +

					"<sprites>Date:</sprites>" +
					"<sprites>" + getCompileTime() + "</sprites>" +
					"</xml>";
			} else {
				text.htmlText =
					"<xml>" +
					"<fps>fps: " + fpsDisplay + " / " + stage.frameRate + "</fps>" +
					"<mem>mem: " + memoryDisplay + "</mem>" +
					"<textures>tex: " + textures + " (" + textureDisplay + ")</textures>" +
					"<draws>draws: " + drawCalls + "</draws>" +
					"<sprites>sprites: " + sprites + (spritesCulled ? " / " + (sprites + spritesCulled) : "") + "</sprites>" +
					"<tris>tris: " + triangles + "</tris>" +
					"</xml>";
			}
		}

		/**
		 * Parses SWF bytecode and extracts creation or compile time.
		 *
		 * @return		SWF creation or compile time.
		 */
		public static function getCompileTime():Date {
			if(compileTime) {
				return compileTime;
			}

			if(!stage) {
				return null;
			}

			var swf:ByteArray = stage.loaderInfo.bytes;

			swf.endian = Endian.LITTLE_ENDIAN;
			swf.position = Math.ceil(((swf[8] >> 3) * 4 - 3) / 8) + 13;

			while(swf.position != swf.length) {
				var tagHeader:uint = swf.readUnsignedShort();

				if(tagHeader >> 6 == 41) {
					swf.position += 18;

					compileTime = new Date();
					compileTime.setTime(swf.readUnsignedInt() + swf.readUnsignedInt() * 4294967296);

					return compileTime;
				} else {
					swf.position += (tagHeader & 63) != 63 ? (tagHeader & 63) : swf.readUnsignedInt() + 4;
				}
			}

			return null;
		}

		/**
		 * @private
		 */
		public static function reset():void {
			sprites = 0;
			triangles = 0;
			drawCalls = 0;
			spritesCulled = 0;
		}

		/**
		 * @private
		 */
		public static function handleDeviceLoss():void {
			reset();

			textures = 0;
			texturesMem = 0;
		}

		private function destroy(event:Event):void {
			removeChildren();

			graph.bitmapData.dispose();
			graph.bitmapData = null;
			graph = null;

			graphics.clear();

			stage.removeEventListener(Event.RESIZE, resize);

			removeEventListener(MouseEvent.CLICK, click);
			removeEventListener(Event.ENTER_FRAME, update);
			removeEventListener(Event.REMOVED_FROM_STAGE, destroy);
		}
	}
}
