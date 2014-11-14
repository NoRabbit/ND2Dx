/*
 * ND2D - A Flash Molehill GPU accelerated 2D engine
 *
 * Author: Lars Gerckens
 * Copyright de.nulldesign.nd2dx.resource.texture.parser.AtlasParserSparrowsign/nd2d
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

package de.nulldesign.nd2dx.resource.texture.parser 
{
	import com.rabbitframework.utils.StringUtils;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class AtlasParserSparrow extends AtlasParserBase
	{
		
		public function AtlasParserSparrow(xmlData:XML)
		{
			super(xmlData);
		}
		
		override public function parse(texture:Texture2D):void
		{
			if (!xmlData.SubTexture)
			{
				throw new Error("Unrecognised XML Format");
			}
			
			var idx:uint = 0;
			
			for each(var subTexture:XML in xmlData.SubTexture)
			{
				var name:String = StringUtils.cleanMasterString(subTexture.attribute("name"));
				var x:Number = Number(StringUtils.cleanMasterString(subTexture.attribute("x")));
				var y:Number = Number(StringUtils.cleanMasterString(subTexture.attribute("y")));
				var width:Number = Number(StringUtils.cleanMasterString(subTexture.attribute("width")));
				var height:Number = Number(StringUtils.cleanMasterString(subTexture.attribute("height")));
				var frameX:Number = Number(StringUtils.cleanMasterString(subTexture.attribute("frameX")));
				var frameY:Number = Number(StringUtils.cleanMasterString(subTexture.attribute("frameY")));
				var frameWidth:Number = Number(StringUtils.cleanMasterString(subTexture.attribute("frameWidth")));
				var frameHeight:Number = Number(StringUtils.cleanMasterString(subTexture.attribute("frameHeight")));
				
				// take into account offsets from previous atlas (if there is)
				if ( texture.originalFrameRect )
				{
					x += texture.originalFrameRect.x;
					y += texture.originalFrameRect.y;
					
					frameX += texture.originalFrameRect.x;
					frameY += texture.originalFrameRect.y;
				}
				
				if ( frameWidth <= 0 ) frameWidth = width;
				if ( frameHeight <= 0 ) frameHeight = height;
				
				frameNames.push(name);
				frameNameToIndex[name] = idx++;
				
				frames.push(new Rectangle(
					x, y, width, height));
					
				//trace(this, "parse", name, x, y, width, height);
					
				uvRects.push(texture.getUVRectFromDimensions(x, y, width, height));
				
				//uvRects.push(new Rectangle(
					//x / texture.textureWidth,
					//y / texture.textureHeight,
					//width / texture.textureWidth,
					//height / texture.textureHeight));
				
				originalFrames.push(new Rectangle(frameX, frameY, frameWidth, frameHeight));
				
				if (frameWidth > 0 && frameHeight > 0)
				{
					offsets.push(new Point(
						-((frameWidth - width) >> 1) - frameX,
						-((frameHeight - height) >> 1) - frameY));
				}
				else
				{
					offsets.push(new Point());
				}
			}
		}
	}
}
