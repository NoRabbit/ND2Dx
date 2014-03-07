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

package de.nulldesign.nd2dx.materials.texture.parser {

	import de.nulldesign.nd2dx.materials.texture.Texture2D;

	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class AtlasParserSparrow extends AtlasParserBase {

		public var xmlData:XML;

		public function AtlasParserSparrow(xmlData:XML) {
			this.xmlData = xmlData;
		}

		override public function parse(texture:Texture2D):void {
			if(!xmlData.SubTexture) {
				throw new Error("Unrecognised XML Format");
			}

			var idx:uint = 0;

			for each(var subTexture:XML in xmlData.SubTexture) {
				var name:String = subTexture.attribute("name");
				var x:Number = subTexture.attribute("x");
				var y:Number = subTexture.attribute("y");
				var width:Number = subTexture.attribute("width");
				var height:Number = subTexture.attribute("height");
				var frameX:Number = subTexture.attribute("frameX");
				var frameY:Number = subTexture.attribute("frameY");
				var frameWidth:Number = subTexture.attribute("frameWidth");
				var frameHeight:Number = subTexture.attribute("frameHeight");

				frameNames.push(name);
				frameNameToIndex[name] = idx++;

				frames.push(new Rectangle(
					x, y, width, height));
					
				//uvRects.push(texture.getUVRectFromDimensions(x, y, width, height));
				
				uvRects.push(new Rectangle(
					x / texture.textureWidth,
					y / texture.textureHeight,
					width / texture.textureWidth,
					height / texture.textureHeight));
				
				originalFrames.push(new Rectangle(frameX, frameY, frameWidth, frameHeight));
				
				if(frameWidth > 0 && frameHeight > 0) {
					offsets.push(new Point(
						-((frameWidth - width) >> 1) - frameX,
						-((frameHeight - height) >> 1) - frameY));
				} else {
					offsets.push(new Point());
				}
			}
		}

		override public function dispose():void {
			xmlData = null;

			super.dispose();
		}
	}
}
