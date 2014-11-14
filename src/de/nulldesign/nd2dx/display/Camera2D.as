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
	import de.nulldesign.nd2dx.utils.VectorUtil;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/**
	 * Camera2D
	 * <p>The World2D object contains an instance of a Camera2D. Use the cameras
	 * x,y, zoom, rotation properties to zoom and pan over your scene.
	 * The camera instance is passed to each active scene.</p>
	 */
	public class Camera2D 
	{		
		protected var renderMatrixOrtho:Matrix3D = new Matrix3D();
		protected var renderMatrixPerspective:Matrix3D = new Matrix3D();
		
		protected var perspectiveProjectionMatrix:Matrix3D = new Matrix3D();
		protected var orthoProjectionMatrix:Matrix3D = new Matrix3D();
		protected var viewMatrix:Matrix3D = new Matrix3D();
		
		protected var _sceneWidth:Number;
		protected var _sceneHeight:Number;
		
		public var invalidate:Boolean = true;
		
		/**
		 * @private
		 */
		public var invalidateCount:uint;
		
		public function Camera2D(w:Number, h:Number)
		{
			resizeCameraStage(w, h);
		}
		
		public function resizeCameraStage(width:Number, height:Number):void
		{
			if (width == _sceneWidth && height == _sceneHeight)
			{
				return;
			}
			
			invalidate = true;
			
			_sceneWidth = width;
			_sceneHeight = height;
			
			orthoProjectionMatrix = makeOrtographicMatrix(0, width, 0, height);
			
			var fovDegree:Number = 60.0;
			var magicNumber:Number = Math.tan(VectorUtil.deg2rad(fovDegree * 0.5));
			var projMat:Matrix3D = makeProjectionMatrix(0.1, 2000.0, fovDegree, width / height);
			var lookAtPosition:Vector3D = new Vector3D(0.0, 0.0, 0.0);
			
			// zEye distance from origin: sceneHeight * 0.5 / tan(a) 
			var eye:Vector3D = new Vector3D(0, 0, -(_sceneHeight * 0.5) / magicNumber);
			var lookAtMat:Matrix3D = lookAt(lookAtPosition, eye);
			
			lookAtMat.append(projMat);
			perspectiveProjectionMatrix = lookAtMat;
		}
		
		protected function lookAt(lookAt:Vector3D, position:Vector3D):Matrix3D
		{
			var up:Vector3D = new Vector3D();
			up.x = Math.sin(0.0);
			up.y = -Math.cos(0.0);
			up.z = 0;
			
			var forward:Vector3D = new Vector3D();
			forward.x = lookAt.x - position.x;
			forward.y = lookAt.y - position.y;
			forward.z = lookAt.z - position.z;
			forward.normalize();
			
			var right:Vector3D = up.crossProduct(forward);
			right.normalize();
			
			up = right.crossProduct(forward);
			up.normalize();
			
			var rawData:Vector.<Number> = new Vector.<Number>();
			rawData.push(-right.x, -right.y, -right.z, 0,
				up.x, up.y, up.z, 0,
				-forward.x, -forward.y, -forward.z, 0,
				0, 0, 0, 1);
				
			var mat:Matrix3D = new Matrix3D(rawData);
			mat.prependTranslation( -position.x, -position.y, -position.z);
			
			return mat;
		}
		
		protected function makeProjectionMatrix(zNear:Number, zFar:Number, fovDegrees:Number, aspect:Number):Matrix3D
		{
			var yval:Number = zNear * Math.tan(fovDegrees * (Math.PI / 360.0));
			var xval:Number = yval * aspect;
			
			return makeFrustumMatrix(-xval, xval, -yval, yval, zNear, zFar);
		}
		
		protected function makeFrustumMatrix(left:Number, right:Number, top:Number, bottom:Number, zNear:Number, zFar:Number):Matrix3D
		{
			return new Matrix3D(Vector.<Number>([
				(2 * zNear) / (right - left),
				0,
				(right + left) / (right - left),
				0,
				
				0,
				(2 * zNear) / (top - bottom),
				(top + bottom) / (top - bottom),
				0,
				
				0,
				0,
				zFar / (zNear - zFar),
				-1,
				
				0,
				0,
				(zNear * zFar) / (zNear - zFar),
				0
				]));
		}
		
		protected function makeOrtographicMatrix(left:Number, right:Number, top:Number, bottom:Number, zNear:Number = 0, zFar:Number = 1):Matrix3D
		{
			return new Matrix3D(Vector.<Number>([
				2 / (right - left), 0, 0, 0,
				0, 2 / (top - bottom), 0, 0,
				0, 0, 1 / (zFar - zNear), 0,
				0, 0, zNear / (zNear - zFar), 1
				]));
		}

		public function getViewProjectionMatrix(useOrthoMatrix:Boolean = false):Matrix3D
		{
			if (invalidate)
			{
				invalidate = false;
				invalidateCount++;
				
				viewMatrix.identity();
				viewMatrix.appendTranslation(-sceneWidth * 0.5 - _x - _offsetX, -sceneHeight * 0.5 - _y - _offsetY, 0.0);
				viewMatrix.appendScale(_zoom, _zoom, 1.0);
				viewMatrix.appendRotation(_rotation, Vector3D.Z_AXIS);
				
				renderMatrixOrtho.identity();
				renderMatrixOrtho.append(viewMatrix);
				
				renderMatrixPerspective.identity();
				renderMatrixPerspective.append(viewMatrix);
				
				renderMatrixOrtho.append(orthoProjectionMatrix);
				renderMatrixPerspective.append(perspectiveProjectionMatrix);
			}
			
			return useOrthoMatrix ? renderMatrixOrtho : renderMatrixPerspective;
		}
		
		public function reset():void
		{
			x = y = rotation = 0;
			zoom = 1;
		}
		
		protected var _x:Number = 0.0;
		
		public function get x():Number
		{
			return _x;
		}
		
		public function set x(value:Number):void
		{
			if (_x != value)
			{
				_x = value;
				invalidate = true;
			}
		}
		
		protected var _y:Number = 0.0;
		
		public function get y():Number
		{
			return _y;
		}
		
		public function set y(value:Number):void
		{
			if (_y != value)
			{
				_y = value;
				invalidate = true;
			}
		}
		
		/*
		 * 
		*/
		protected var _offsetX:Number = 0.0;
		
		public function get offsetX():Number
		{
			return _offsetX;
		}
		
		public function set offsetX(value:Number):void
		{
			if (_offsetX != value)
			{
				_offsetX = value;
				invalidate = true;
			}
		}
		
		protected var _offsetY:Number = 0.0;
		
		public function get offsetY():Number
		{
			return _offsetY;
		}
		
		public function set offsetY(value:Number):void
		{
			if (_offsetY != value)
			{
				_offsetY = value;
				invalidate = true;
			}
		}
		
		protected var _zoom:Number = 1.0;
		
		public function get zoom():Number
		{
			return _zoom;
		}
		
		public function set zoom(value:Number):void
		{
			if (_zoom != value)
			{
				_zoom = value;
				invalidate = true;
			}
		}
		
		protected var _rotation:Number = 0.0;
		
		public function get rotation():Number
		{
			return _rotation;
		}
		
		public function set rotation(value:Number):void
		{
			if (_rotation != value)
			{
				_rotation = value;
				invalidate = true;
			}
		}
		
		public function get sceneWidth():Number
		{
			return _sceneWidth;
		}
		
		public function get sceneHeight():Number
		{
			return _sceneHeight;
		}
	}
}
