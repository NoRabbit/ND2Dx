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

package de.nulldesign.nd2dx.materials 
{	
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.geom.Mesh2D;
	import de.nulldesign.nd2dx.materials.shader.Shader2D;
	import de.nulldesign.nd2dx.utils.NodeBlendMode;
	import de.nulldesign.nd2dx.utils.Statistics;

	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;

	public class MaterialBase 
	{
		public var viewProjectionMatrix:Matrix3D;
		public var clipSpaceMatrix:Matrix3D = new Matrix3D();
		public var invalidateClipSpace:Boolean = true;
		
		public var scrollRect:Rectangle;
		
		public var blendMode:NodeBlendMode = BlendModePresets.NORMAL;
		
		public var shaderData:Shader2D;
		public var invalidateProgram:Boolean = true;
		
		public var mesh:Mesh2D;
		
		protected var _width:Number = 0.0;
		protected var _height:Number = 0.0;
		
		protected var _node:Node2D;
		
		public function MaterialBase() 
		{
			
		}
		
		public function get width():Number 
		{
			return _width;
		}
		
		public function set width(value:Number):void 
		{
			_width = value;
			if ( _node ) _node._width = _width;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		public function set height(value:Number):void 
		{
			_height = value;
			if ( _node ) _node._height = _height;
		}
		
		public function get node():Node2D 
		{
			return _node;
		}
		
		public function set node(value:Node2D):void 
		{
			_node = value;
			if ( _node )
			{
				_node._width = _width;
				_node._height = _height;
			}
		}
		
		public function updateClipSpace():void
		{
			clipSpaceMatrix.identity();
			clipSpaceMatrix.append(_node.worldModelMatrix);
			invalidateClipSpace = false;
		}
		
		protected function prepareForRender(context:Context3D):void 
		{
			if ( invalidateClipSpace || _node.invalidateMatrix ) updateClipSpace();
			context.setBlendFactors(blendMode.src, blendMode.dst);
			updateProgram(context);
		}

		public function render(context:Context3D):void 
		{
			prepareForRender(context);
			
			context.drawTriangles(mesh.indexBuffer, 0, mesh.numTriangles);
			
			Statistics.drawCalls++;
			Statistics.triangles += mesh.numTriangles;
			Statistics.sprites++;
			
			clearAfterRender(context);
		}
		
		protected function clearAfterRender(context:Context3D):void 
		{
			// implement in concrete material
			throw new Error("You have to implement clearAfterRender for your material");
		}
		
		protected function updateProgram(context:Context3D):void
		{
			if (!shaderData || invalidateProgram)
			{
				shaderData = null;
				initProgram(context);
			}
			
			context.setProgram(shaderData.shader);
		}
		
		protected function initProgram(context:Context3D):void 
		{
			// implement in concrete material
			throw new Error("You have to implement initProgram for your material");
		}
		
		public function handleDeviceLoss():void 
		{
			shaderData = null;
		}
		
		public function dispose():void 
		{
			blendMode = null;
			shaderData = null;
			scrollRect = null;
			node = null;
			
			clipSpaceMatrix = null;
			viewProjectionMatrix = null;
		}
	}
}
