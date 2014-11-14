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
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2D;
	import de.nulldesign.nd2dx.resource.shader.Shader2D;
	import de.nulldesign.nd2dx.resource.shader.ShaderProgram2D;
	import de.nulldesign.nd2dx.utils.IIdentifiable;
	import de.nulldesign.nd2dx.utils.NodeBlendMode;
	import de.nulldesign.nd2dx.utils.Statistics;
	import flash.display3D.Context3DBlendFactor;
	import flash.display3D.Program3D;

	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;

	public class MaterialBase implements IIdentifiable
	{
		public var resourceManager:ResourceManager = ResourceManager.getInstance();
		
		public var viewProjectionMatrix:Matrix3D;
		public var clipSpaceMatrix:Matrix3D = new Matrix3D();
		public var invalidateClipSpace:Boolean = true;
		
		public var scissorRect:Rectangle;
		
		public var blendModeSrc:String = Context3DBlendFactor.ONE;
		public var blendModeDst:String = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA;
		
		public var isReadyForRender:Boolean = false;
		
		protected var _shader:Shader2D;
		public var shaderProgram:ShaderProgram2D;
		
		public var mesh:Mesh2D;
		
		protected var _width:Number = 0.0;
		protected var _height:Number = 0.0;
		
		protected var _node:Node2D;
		
		protected var _id:String;
		
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
			invalidateClipSpace = true;
		}
		
		public function get height():Number 
		{
			return _height;
		}
		
		public function set height(value:Number):void 
		{
			_height = value;
			if ( _node ) _node._height = _height;
			invalidateClipSpace = true;
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
		
		public function set blendMode(value:NodeBlendMode):void 
		{
			blendModeSrc = value.src;
			blendModeDst = value.dst;
		}
		
		public function get shader():Shader2D 
		{
			return _shader;
		}
		
		public function set shader(value:Shader2D):void 
		{
			if ( _shader == value ) return;
			
			//if ( _shader ) _shader.unlinkMaterial(this);
			
			_shader = value;
			shaderProgram = null;
			
			if ( _shader )
			{
				//_shader.linkMaterial(this);
				updateShaderProperties();
			}
			
			checkIfReadyForRender();
		}

		public function render(context:Context3D):void 
		{
			if ( !isReadyForRender ) return;
			
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
		
		protected function prepareForRender(context:Context3D):void 
		{
			if ( invalidateClipSpace || _node.matrixUpdated ) updateClipSpace();
			context.setBlendFactors(blendModeSrc, blendModeDst);
			updateProgram(context);
		}
		
		public function updateClipSpace():void
		{
			clipSpaceMatrix.identity();
			clipSpaceMatrix.append(_node.worldModelMatrix);
			invalidateClipSpace = false;
		}
		
		protected function updateProgram(context:Context3D):void
		{
			if ( !shaderProgram || !shaderProgram.program )
			{
				initProgram(context);
			}
			
			if( shaderProgram ) context.setProgram(shaderProgram.program);
		}
		
		protected function initProgram(context:Context3D):void 
		{
			// implement in concrete material
			throw new Error("You have to implement initProgram for your material");
		}
		
		public function updateShaderProperties():void
		{
			
		}
		
		public function checkIfReadyForRender():void
		{
			isReadyForRender = false;
		}
		
		public function handleDeviceLoss():void 
		{
			shaderProgram = null;
		}
		
		public function dispose():void 
		{
			blendMode = null;
			shader = null;
			shaderProgram = null;
			scissorRect = null;
			node = null;
			
			clipSpaceMatrix = null;
			viewProjectionMatrix = null;
		}
		
		/* INTERFACE de.nulldesign.nd2dx.utils.IIdentifiable */
		
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
	}
}
