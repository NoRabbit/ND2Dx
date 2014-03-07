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

package de.nulldesign.nd2dx.display {

	import de.nulldesign.nd2dx.components.ComponentBase;
	import de.nulldesign.nd2dx.geom.Vector2D;
	import de.nulldesign.nd2dx.support.RenderSupportBase;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import org.osflash.signals.Signal;

	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;

	/**
	 * <p>Base 2D object. All drawable objects must extend Node2D</p>
	 * A Node2D has two methods that are called during rendering:
	 * <ul>
	 * <li>step - Update the node's position here</li>
	 * <li>draw - Your rendering code goes here</li>
	 * </ul>
	 */
	public class Node2D
	{
		public var id:String = "";
		public var name:String = "";
		
		public var performMatrixCalculations:Boolean = true;
		public var localModelMatrix:Matrix3D = new Matrix3D();
		public var worldModelMatrix:Matrix3D = new Matrix3D();
		
		public var invalidateMatrix:Boolean = true;
		public var invalidateColors:Boolean = true;
		
		public var _numChildren:uint = 0;
		public var childFirst:Node2D = null;
		public var childLast:Node2D = null;
		
		public var prev:Node2D = null;
		public var next:Node2D = null;
		
		// components
		public var numComponents:int = 0;
		public var componentFirst:ComponentBase = null;
		public var componentLast:ComponentBase = null;
		
		public var camera:Camera2D;
		
		protected var _mouseEnabled:Boolean = false;
		
		public function get mouseEnabled():Boolean 
		{
			return _mouseEnabled;
		}
		
		public function set mouseEnabled(value:Boolean):void 
		{
			_mouseEnabled = value;
			mouseInNode = false;
		}
		
		protected var _mouseChildren:Boolean = true;
		
		public function get mouseChildren():Boolean 
		{
			return _mouseChildren;
		}
		
		public function set mouseChildren(value:Boolean):void 
		{
			_mouseChildren = value;
		}
		
		public var mouseInNode:Boolean = false;
		private var localMouse:Vector3D;
		private var localMouseMatrix:Matrix3D = new Matrix3D();
		
		protected var _stage:Stage;
		
		public function get stage():Stage
		{
			return _stage;
		}
		
		/**
		 * [read-only] Use addChild() instead
		 */
		public var parent:Node2D;
		
		public var world:World2D;
		
		public var scene:Scene2D;
		
		public var _width:Number;
		
		public function get width():Number
		{
			return Math.abs(_width * _scaleX);
		}
		
		public function set width(value:Number):void
		{
			scaleX = value / _width;
		}
		
		public var _height:Number;
		
		public function get height():Number
		{
			return Math.abs(_height * _scaleY);
		}
		
		public function set height(value:Number):void{
			scaleY = value / _height;
		}
		
		protected var _visible:Boolean = true;
		
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			if (_visible != value)
			{
				_visible = value;
				
				if (value)
				{
					invalidateMatrix = true;
				}
			}
		}
		
		public var _alpha:Number = 1.0;
		public var combinedAlpha:Number = 1.0;
		
		public function set alpha(value:Number):void
		{
			if (_alpha != value)
			{
				_alpha = value;
				invalidateColors = true;
				visible = (_alpha > 0.0);
			}
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		protected var _tintRed:Number = 1.0;
		protected var _tintGreen:Number = 1.0;
		protected var _tintBlue:Number = 1.0;
		
		public var combinedTintRed:Number = 1.0;
		public var combinedTintGreen:Number = 1.0;
		public var combinedTintBlue:Number = 1.0;
		
		public function get tintRed():Number 
		{
			return _tintRed;
		}
		
		public function set tintRed(value:Number):void 
		{
			_tintRed = value;
			invalidateColors = true;
		}
		
		public function get tintGreen():Number 
		{
			return _tintGreen;
		}
		
		public function set tintGreen(value:Number):void 
		{
			_tintGreen = value;
			invalidateColors = true;
		}
		
		public function get tintBlue():Number 
		{
			return _tintBlue;
		}
		
		public function set tintBlue(value:Number):void 
		{
			_tintBlue = value;
			invalidateColors = true;
		}
		
		protected var _tint:uint = 0xFFFFFF;
		
		public function get tint():uint 
		{			
			return _tint;
		}
		
		public function set tint(value:uint):void 
		{
			if (_tint != value)
			{
				_tint = value;
				
				_tintRed = (_tint >> 16 & 255) / 255.0;
				_tintGreen = (_tint >> 8 & 255) / 255.0;
				_tintBlue = (_tint & 255) / 255.0;
				
				invalidateColors = true;
			}
		}
		
		protected var _scaleX:Number = 1.0;
		
		public function set scaleX(value:Number):void
		{
			if (_scaleX != value)
			{
				_scaleX = value;
				invalidateMatrix = true;
			}
		}
		
		public function get scaleX():Number
		{
			return _scaleX;
		}
		
		protected var _scaleY:Number = 1.0;
		
		public function set scaleY(value:Number):void
		{
			if (_scaleY != value)
			{
				_scaleY = value;
				invalidateMatrix = true;
			}
		}
		
		public function get scaleY():Number
		{
			return _scaleY;
		}

		protected var _x:Number = 0.0;

		public function set x(value:Number):void
		{
			if (_x != value)
			{
				_x = value;
				invalidateMatrix = true;
			}
		}
		
		public function get x():Number
		{
			return _x;
		}

		protected var _y:Number = 0.0;

		public function set y(value:Number):void
		{
			if (_y != value)
			{
				_y = value;
				invalidateMatrix = true;
			}
		}
		
		public function get y():Number
		{
			return _y;
		}
		
		protected var _z:Number = 0.0;
		
		public function set z(value:Number):void
		{
			if (_z != value)
			{
				_z = value;
				invalidateMatrix = true;
			}
		}
		
		public function get z():Number
		{
			return _z;
		}
		
		protected var _pivot:Point = new Point(0.0, 0.0);
		
		public function get pivot():Point
		{
			return _pivot;
		}
		
		public function set pivot(value:Point):void
		{
			if (_pivot.x != value.x || _pivot.y != value.y)
			{
				_pivot.x = value.x;
				_pivot.y = value.y;
				invalidateMatrix = true;
			}
		}
		
		public var localScrollRect:Rectangle;
		
		public var worldScrollRect:Rectangle;
		
		public function get scrollRect():Rectangle
		{
			return localScrollRect;
		}
		
		public function set scrollRect(value:Rectangle):void
		{
			if (!localScrollRect || localScrollRect.x != value.x || localScrollRect.y != value.y || localScrollRect.width != value.width || localScrollRect.height != value.height)
			{
				localScrollRect = value;
				invalidateMatrix = true;
			}
		}
		
		public function set rotation(value:Number):void
		{
			if (_rotationZ != value)
			{
				_rotationZ = value;
				invalidateMatrix = true;
			}
		}
		
		public function get rotation():Number
		{
			return _rotationZ;
		}
		
		protected var _rotationX:Number = 0.0;
		
		public function set rotationX(value:Number):void
		{
			if (_rotationX != value)
			{
				_rotationX = value;
				invalidateMatrix = true;
			}
		}
		
		public function get rotationX():Number
		{
			return _rotationX;
		}
		
		protected var _rotationY:Number = 0.0;
		
		public function set rotationY(value:Number):void
		{
			if (_rotationY != value)
			{
				_rotationY = value;
				invalidateMatrix = true;
			}
		}
		
		public function get rotationY():Number
		{
			return _rotationY;
		}
		
		protected var _rotationZ:Number = 0.0;
		
		public function set rotationZ(value:Number):void
		{
			if (_rotationZ != value)
			{
				_rotationZ = value;
				invalidateMatrix = true;
			}
		}
		
		public function get rotationZ():Number
		{
			return _rotationZ;
		}
		
		protected var _mouseX:Number = 0.0;
		
		public function get mouseX():Number
		{
			return _mouseX;
		}
		
		protected var _mouseY:Number = 0.0;
		
		public function get mouseY():Number
		{
			return _mouseY;
		}
		
		public function get numChildren():uint
		{
			return _numChildren;
		}
		
		private var _onComponentAdded:Signal;
		private var _onComponentRemoved:Signal;
		
		private var _onMouseEvent:Signal;
		private var _onAddedToStage:Signal;
		private var _onRemovedFromStage:Signal;
		
		public function get onComponentAdded():Signal 
		{
			if ( !_onComponentAdded ) _onComponentAdded = new Signal(ComponentBase);
			return _onComponentAdded;
		}
		
		public function get onComponentRemoved():Signal 
		{
			if ( !_onComponentRemoved ) _onComponentRemoved = new Signal(ComponentBase);
			return _onComponentRemoved;
		}
		
		public function get onMouseEvent():Signal 
		{
			if ( !_onMouseEvent ) _onMouseEvent = new Signal(String, Node2D, MouseEvent);
			return _onMouseEvent;
		}
		
		public function get onAddedToStage():Signal 
		{
			if ( !_onAddedToStage ) _onAddedToStage = new Signal(Node2D);
			return _onAddedToStage;
		}
		
		public function get onRemovedFromStage():Signal 
		{
			if ( !_onRemovedFromStage ) _onRemovedFromStage = new Signal(Node2D);
			return _onRemovedFromStage;
		}
		
		public function Node2D()
		{
			
		}
		
		public function updateLocalMatrix():void
		{
			invalidateMatrix = false;
			
			if ( _scaleX == 0 ) _scaleX = 0.000000000000001;
			if ( _scaleY == 0 ) _scaleY = 0.000000000000001;
			
			localModelMatrix.identity();
			localModelMatrix.appendTranslation(-_pivot.x, -_pivot.y, 0);
			localModelMatrix.appendScale(_scaleX, _scaleY, 1.0);
			localModelMatrix.appendRotation(_rotationZ, Vector3D.Z_AXIS);
			//localModelMatrix.appendRotation(_rotationY, Vector3D.Y_AXIS);
			//localModelMatrix.appendRotation(_rotationX, Vector3D.X_AXIS);
			localModelMatrix.appendTranslation(_x, _y, _z);
			localModelMatrix.appendTranslation(_pivot.x, _pivot.y, 0);
		}
		
		public function updateWorldMatrix():void
		{
			worldModelMatrix.identity();
			worldModelMatrix.append(localModelMatrix);
			
			if (parent)
			{
				worldModelMatrix.append(parent.worldModelMatrix);
			}
			
			updateScrollRect();
		}
		
		public function updateScrollRect():void
		{
			if (localScrollRect) 
			{
				var pos:Point = localToWorld(new Point(-localScrollRect.width >> 1, -localScrollRect.height >> 1));
				worldScrollRect = localScrollRect.clone();
				worldScrollRect.x = pos.x;
				worldScrollRect.y = pos.y;
				
				if (parent && parent.worldScrollRect)
				{
					worldScrollRect = worldScrollRect.intersection(parent.worldScrollRect);
				}
				
			}
			else if (parent && parent.worldScrollRect)
			{
				worldScrollRect = parent.worldScrollRect.clone();
			}
			
			if (localScrollRect)
			{
				worldModelMatrix.prependTranslation(-localScrollRect.x, -localScrollRect.y, 0);
			}
		}
		
		public function processMouseEvent(mousePosition:Vector3D, event:MouseEvent, cameraViewProjectionMatrix:Matrix3D):Node2D
		{
			var result:Node2D = null;
			
			if (event)
			{
				// if we have children, check first if we hit one of them
				if ( _mouseChildren && _numChildren > 0 )
				{
					// check from last to first
					var childMouseNode:Node2D;
					
					for (var child:Node2D = childLast; child; child = child.prev)
					{
						childMouseNode = child.processMouseEvent(mousePosition, event, cameraViewProjectionMatrix);
						
						if ( childMouseNode )
						{
							// we have a hit, keep that one
							result = childMouseNode;
							break;
						}
					}
				}
				
				if ( _mouseEnabled && !result )
				{
					// no children, that means this node is the front most node of its hierarchy
					updateMousePosition(mousePosition, cameraViewProjectionMatrix);
					
					if ( hitTest() ) result = this;
				}
			}
			
			return result;
		}
		
		public function updateMousePosition(mousePosition:Vector3D, cameraViewProjectionMatrix:Matrix3D):void
		{
			updateLocalMatrix();
			updateWorldMatrix();
			
			// transform mousepos to local coordinate system
			localMouseMatrix.identity();
			localMouseMatrix.append(worldModelMatrix);
			localMouseMatrix.append(cameraViewProjectionMatrix);
			localMouseMatrix.invert();
			
			localMouse = localMouseMatrix.transformVector(mousePosition);
			
			_mouseX = localMouse.x;
			_mouseY = localMouse.y;
		}
		
		/**
		 * Overwrite and do your own hitTest if you like
		 * @return
		 */
		public function hitTest():Boolean
		{
			// even faster isNaN()	http://jacksondunstan.com/articles/983
			if (_width != _width || _height != _height)
			{
				return false;
			}
			
			var halfWidth:Number = _width >> 1;
			var halfHeight:Number = _height >> 1;
			
			return _mouseX >= -halfWidth
				&& _mouseX <= halfWidth
				&& _mouseY >= -halfHeight
				&& _mouseY <= halfHeight;
		}
		
		internal function setReferences(stage:Stage, camera:Camera2D, world:World2D, scene:Scene2D):void
		{
			var propagate:Boolean = false;
			
			if (this.camera != camera)
			{
				propagate = true;
				this.camera = camera;
			}
			
			if (this.world != world)
			{
				propagate = true;
				this.world = world;
			}
			
			if (this.scene != scene)
			{
				propagate = true;
				this.scene = scene;
			}
			
			if (_stage != stage)
			{
				propagate = true;
				
				if (stage)
				{
					_stage = stage;
					onAddedToStage.dispatch(this);
				}
				else
				{
					onRemovedFromStage.dispatch(this);
					_stage = stage;
				}
			}
			
			if (propagate)
			{
				// first components
				for (var component:ComponentBase = componentFirst; component; component = component.next)
				{
					component.setReferences(stage, camera, world, scene, this);
				}
				
				// then child nodes
				for (var child:Node2D = childFirst; child; child = child.next)
				{
					child.setReferences(stage, camera, world, scene);
				}
			}
		}
		
		public function drawNode(renderSupport:RenderSupportBase):void 
		{
			// step components first
			for (var component:ComponentBase = componentFirst; component; component = component.next)
			{
				if( component.isActive ) component.step(renderSupport.elapsed);
			}
			
			step(renderSupport.elapsed);
			
			if ( invalidateColors || (parent && parent.invalidateColors) )
			{
				combinedTintRed = _tintRed;
				combinedTintGreen = _tintGreen;
				combinedTintBlue = _tintBlue;
				combinedAlpha = _alpha;
				
				if ( parent )
				{
					combinedTintRed *= parent.combinedTintRed;
					combinedTintGreen *= parent.combinedTintGreen;
					combinedTintBlue *= parent.combinedTintBlue;
					combinedAlpha *= parent.combinedAlpha;
				}
				
				invalidateColors = true;
			}
			
			// perform matrix calculations and draw only if visible
			if ( _visible )
			{
				if (performMatrixCalculations && (invalidateMatrix || (parent && parent.invalidateMatrix)))
				{
					if (invalidateMatrix)
					{
						updateLocalMatrix();
					}
					
					updateWorldMatrix();
					
					invalidateMatrix = true;
				}
				
				draw(renderSupport);
				
				for (var child:Node2D = childFirst; child; child = child.next)
				{
					child.drawNode(renderSupport);
				}
			}
			
			invalidateMatrix = false;
			invalidateColors = false;
		}
		
		public function step(elapsed:Number):void 
		{			
			// override in extended classes
		}
		
		public function draw(renderSupport:RenderSupportBase):void 
		{
			// draw components
			for (var component:ComponentBase = componentFirst; component; component = component.next)
			{
				if( component.isActive ) component.draw(renderSupport);
			}
		}
		
		protected function unlinkChild(child:Node2D):void
		{
			if (child.prev)
			{
				child.prev.next = child.next;
			}
			else
			{
				childFirst = child.next;
			}
			
			if (child.next)
			{
				child.next.prev = child.prev;
			}
			else
			{
				childLast = child.prev;
			}
			
			child.prev = null;
			child.next = null;
		}
		
		public function addChild(child:Node2D):Node2D
		{
			if (child.parent)
			{
				child.parent.removeChild(child);
			}
			
			child.parent = this;
			child.setReferences(_stage, camera, world, scene);
			
			if (childLast)
			{
				child.prev = childLast;
				childLast.next = child;
				childLast = child;
			}
			else
			{
				childFirst = child;
				childLast = child;
			}
			
			_numChildren++;
			
			return child;
		}

		public function removeChild(child:Node2D):void
		{
			if (child.parent != this)
			{
				return;
			}
			
			unlinkChild(child);
			
			child.parent = null;
			child.invalidateMatrix = true;
			child.setReferences(null, null, null, null);
			
			_numChildren--;
		}
		
		/**
		 * Insert or move child1 before child2
		 * @return
		 */
		public function insertChildBefore(child1:Node2D, child2:Node2D):void
		{
			if (child2.parent != this)
			{
				return;
			}
			
			if (child1.parent && child1.parent != this)
			{
				child1.parent.removeChild(child1);
			}
			
			unlinkChild(child1);
			
			if (child2.prev)
			{
				child2.prev.next = child1;
			}
			else
			{
				childFirst = child1;
			}
			
			child1.prev = child2.prev;
			child1.next = child2;
			child2.prev = child1;
		}
		
		/**
		 * Insert or move child1 after child2
		 * @return
		 */
		public function insertChildAfter(child1:Node2D, child2:Node2D):void
		{
			if (child2.parent != this)
			{
				return;
			}
			
			if (child1.parent != this)
			{
				addChild(child1);
			}
			
			unlinkChild(child1);
			
			if (child2.next)
			{
				child2.next.prev = child1;
			}
			else
			{
				childLast = child1;
			}
			
			child1.prev = child2;
			child1.next = child2.next;
			child2.next = child1;
		}
		
		public function setChildIndex(node:Node2D, index:int):int
		{
			if ( index >= _numChildren )
			{
				addChild(node);
				return _numChildren - 1;
			}
			
			var child:Node2D = childFirst;
			var currentIndex:int = 0;
			
			while ( child )
			{
				if ( currentIndex == index )
				{
					insertChildBefore(node, child);
					return currentIndex;
				}
				
				child = child.next;
				currentIndex ++;
			}
			
			return -1;
		}
		
		public function getChildIndex(node:Node2D):int
		{
			var child:Node2D = childFirst;
			var currentIndex:int = 0;
			
			while ( child )
			{
				if ( child == node )
				{
					return currentIndex;
				}
				
				child = child.next;
				currentIndex ++;
			}
			
			return -1;
		}

		public function swapChildren(child1:Node2D, child2:Node2D):void
		{
			if (child1.parent != this || child2.parent != this)
			{
				return;
			}
			
			if (child1.prev)
			{
				child1.prev.next = child2;
			}
			else
			{
				childFirst = child2;
			}
			
			if (child2.prev)
			{
				child2.prev.next = child1;
			}
			else
			{
				childFirst = child1;
			}
			
			if (child1.next)
			{
				child1.next.prev = child2;
			}
			else
			{
				childLast = child2;
			}
			
			if (child2.next)
			{
				child2.next.prev = child1;
			}
			else
			{
				childLast = child1;
			}
			
			var swap:Node2D;
			
			swap = child1.prev;
			child1.prev = child2.prev;
			child2.prev = swap;
			
			swap = child1.next;
			child1.next = child2.next;
			child2.next = swap;
		}
		
		public function removeAllChildren():void
		{
			while (childLast)
			{
				removeChild(childLast);
			}
		}
		
		public function getChildAt(index:int):Node2D
		{
			var currentIndex:int = 0;
			
			for (var child:Node2D = childFirst; child; child = child.next)
			{
				if ( index == currentIndex ) return child;
				currentIndex++;
			}
			
			return null;
		}
		
		// COMPONENTS
		public function addComponent(component:ComponentBase):ComponentBase 
		{
			if (component.node) 
			{				
				component.node.removeComponent(component);
			}
			
			if (componentLast) 
			{
				component.prev = componentLast;
				componentLast.next = component;
				componentLast = component;
			}
			else
			{
				componentFirst = component;
				componentLast = component;
			}
			
			numComponents++;
			
			component.setReferences(stage, camera, world, scene, this);
			component.onAddedToNode();
			
			onComponentAdded.dispatch(component);
			
			onComponentAdded.add(component.onComponentAddedToParentNode);
			onComponentRemoved.add(component.onComponentRemovedFromParentNode);
			
			return component;
		}

		public function removeComponent(component:ComponentBase):void 
		{			
			if (component.node != this) 
			{				
				return;
			}
			
			unlinkComponent(component);
			
			numComponents--;
			
			component.setReferences(null, null, null, null, null);
			
			onComponentAdded.remove(component.onComponentAddedToParentNode);
			onComponentRemoved.remove(component.onComponentRemovedFromParentNode);
			
			component.onRemovedFromNode();
			
			onComponentRemoved.dispatch(component);
		}
		
		protected function unlinkComponent(component:ComponentBase):void 
		{			
			if (component.prev) 
			{
				component.prev.next = component.next;
			}
			else
			{
				componentFirst = component.next;
			}
			
			if (component.next) 
			{
				component.next.prev = component.prev;
			}
			else
			{
				componentLast = component.prev;
			}
			
			component.prev = null;
			component.next = null;
		}
		
		public function getComponent(componentClass:Class):*
		{
			for (var component:ComponentBase = componentFirst; component; component = component.next)
			{
				if ( component is componentClass ) return component;
			}
			
			return null;
		}
		
		/**
		 * transforms a point from the nodes local coordinate system into global
		 * space
		 * @param p
		 * @return
		 */
		public function localToGlobal(p:Point):Point
		{
			var clipSpaceMat:Matrix3D = new Matrix3D();
			clipSpaceMat.append(worldModelMatrix);
			clipSpaceMat.append(camera.getViewProjectionMatrix());
			
			var v:Vector3D = clipSpaceMat.transformVector(new Vector3D(p.x, p.y, 0.0));
			
			return new Point((v.x + 1.0) * 0.5 * camera.sceneWidth, (-v.y + 1.0) * 0.5 * camera.sceneHeight);
		}
		
		/**
		 * transforms a point into the nodes local coordinate system
		 * @param p
		 * @return
		 */
		public function globalToLocal(p:Point):Point
		{
			var clipSpaceMat:Matrix3D = new Matrix3D();
			clipSpaceMat.append(worldModelMatrix);
			clipSpaceMat.append(camera.getViewProjectionMatrix());
			clipSpaceMat.invert();
			
			var from:Vector3D = new Vector3D(p.x / camera.sceneWidth * 2.0 - 1.0,
				-(p.y / camera.sceneHeight * 2.0 - 1.0),
				0.0, 1.0);
				
			var v:Vector3D = clipSpaceMat.transformVector(from);
			v.w = 1.0 / v.w;
			v.x /= v.w;
			v.y /= v.w;
			//v.z /= v.w;
			
			return new Point(v.x, v.y);
		}
		
		/**
		 * transforms a point into world coordinates
		 * @param p
		 * @return the transformed point
		 */
		public function localToWorld(p:Point):Point
		{
			var clipSpaceMat:Matrix3D = new Matrix3D();
			clipSpaceMat.append(worldModelMatrix);
			
			var v:Vector3D = clipSpaceMat.transformVector(new Vector3D(p.x, p.y, 0.0));
			
			return new Point(v.x, v.y);
		}
		
		public function handleDeviceLoss():void
		{
			// first tell components
			for (var component:ComponentBase = componentFirst; component; component = component.next)
			{
				component.handleDeviceLoss();
			}
			
			// then all children
			for (var child:Node2D = childFirst; child; child = child.next)
			{
				child.handleDeviceLoss();
			}
		}
		
		public function dispose():void
		{
			// components first
			for (var component:ComponentBase = componentFirst; component; component = component.next)
			{
				component.dispose();
			}
			
			// then children
			while (childLast)
			{
				childLast.dispose();
			}
			
			if (parent)
			{
				parent.removeChild(this);
			}
			
			_pivot = null;
			localScrollRect = null;
			worldScrollRect = null;
			localModelMatrix = null;
			worldModelMatrix = null;
			localMouseMatrix = null;
			
			if ( _onMouseEvent ) _onMouseEvent.removeAll();
			if ( _onAddedToStage ) _onAddedToStage.removeAll();
			if ( _onComponentAdded ) _onComponentAdded.removeAll();
			if ( _onComponentRemoved ) _onComponentRemoved.removeAll();
			if ( _onRemovedFromStage ) _onRemovedFromStage.removeAll();
			
			_onMouseEvent = null;
			_onAddedToStage = null;
			_onComponentAdded = null;
			_onComponentRemoved = null;
			_onRemovedFromStage = null;
		}
		
		public function releaseForPooling(disposeComponents:Boolean = true, disposeChildren:Boolean = true):void
		{
			if (disposeComponents)
			{
				while (componentLast)
				{
					componentLast.dispose();
				}
			}
			
			if ( disposeChildren )
			{
				while (childLast)
				{
					childLast.dispose();
				}
			}
			
			if (parent)
			{
				parent.removeChild(this);
			}
			
			alpha = 1.0;
			_x = _y = _rotationZ = 0.0;
			_scaleX = _scaleY = 1.0;
			tint = 0xFFFFFF;
			invalidateColors = true;
			invalidateMatrix = true;
			
			if ( _onMouseEvent ) _onMouseEvent.removeAll();
			if ( _onAddedToStage ) _onAddedToStage.removeAll();
			if ( _onComponentAdded ) _onComponentAdded.removeAll();
			if ( _onComponentRemoved ) _onComponentRemoved.removeAll();
			if ( _onRemovedFromStage ) _onRemovedFromStage.removeAll();
			
			_onMouseEvent = null;
			_onAddedToStage = null;
			_onComponentAdded = null;
			_onComponentRemoved = null;
			_onRemovedFromStage = null;
		}
		
		public function getBounds(targetSpace:Node2D = null, checkChildren:Boolean = true, identityMatrices:Boolean = false):Rectangle
		{
			if ( identityMatrices )
			{
				localModelMatrix.identity();
				worldModelMatrix.identity();
			}
			else
			{
				updateLocalMatrix();
				updateWorldMatrix();
			}
			
			var pTL:Point = new Point(-_width * 0.5, -_height * 0.5);
			var pTR:Point = new Point(_width * 0.5, -_height * 0.5);
			var pBR:Point = new Point(_width * 0.5, _height * 0.5);
			var pBL:Point = new Point( -_width * 0.5, _height * 0.5);
			
			if ( isNaN(pTL.x) ) pTL.x = 0.0;
			if ( isNaN(pTL.y) ) pTL.y = 0.0;
			if ( isNaN(pTR.x) ) pTR.x = 0.0;
			if ( isNaN(pTR.y) ) pTR.y = 0.0;
			if ( isNaN(pBR.x) ) pBR.x = 0.0;
			if ( isNaN(pBR.y) ) pBR.y = 0.0;
			if ( isNaN(pBL.x) ) pBL.x = 0.0;
			if ( isNaN(pBL.y) ) pBL.y = 0.0;
			
			pTL = localToGlobal(pTL);
			pTR = localToGlobal(pTR);
			pBR = localToGlobal(pBR);
			pBL = localToGlobal(pBL);
			
			if ( targetSpace )
			{
				pTL = targetSpace.globalToLocal(pTL);
				pTR = targetSpace.globalToLocal(pTR);
				pBR = targetSpace.globalToLocal(pBR);
				pBL = targetSpace.globalToLocal(pBL);
			}
			
			var minP:Point = new Point();
			var maxP:Point = new Point();
			
			// min
			minP.x = Math.min(pTL.x, pTR.x);
			minP.x = Math.min(minP.x, pBR.x);
			minP.x = Math.min(minP.x, pBL.x);
			
			minP.y = Math.min(pTL.y, pTR.y);
			minP.y = Math.min(minP.y, pBR.y);
			minP.y = Math.min(minP.y, pBL.y);
			
			// max
			maxP.x = Math.max(pTL.x, pTR.x);
			maxP.x = Math.max(maxP.x, pBR.x);
			maxP.x = Math.max(maxP.x, pBL.x);
			
			maxP.y = Math.max(pTL.y, pTR.y);
			maxP.y = Math.max(maxP.y, pBR.y);
			maxP.y = Math.max(maxP.y, pBL.y);
			
			
			if ( checkChildren )
			{
				var child:Node2D = childFirst;
				var r:Rectangle;
				
				while ( child )
				{
					r = child.getBounds(targetSpace);
					
					minP.x = Math.min(minP.x, r.x);
					minP.y = Math.min(minP.y, r.y);
					maxP.x = Math.max(maxP.x, r.x + r.width);
					maxP.y = Math.max(maxP.y, r.y + r.height);
					
					child = child.next;
				}
			}
			
			return new Rectangle(minP.x, minP.y, maxP.x - minP.x, maxP.y - minP.y);
		}
	}
}
