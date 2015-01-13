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

	import com.rabbitframework.managers.pool.PoolManager;
	import com.rabbitframework.utils.IPoolable;
	import de.nulldesign.nd2dx.components.ComponentBase;
	import de.nulldesign.nd2dx.components.renderers.RendererComponentBase;
	import de.nulldesign.nd2dx.components.ui.UIComponent;
	import com.rabbitframework.signals.SignalDispatcher;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.signals.SignalTypes;
	import de.nulldesign.nd2dx.utils.IIdentifiable;
	import de.nulldesign.nd2dx.utils.NumberUtil;
	import de.nulldesign.nd2dx.utils.Vector2D;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;

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
	public class Node2D extends SignalDispatcher implements IPoolable, IIdentifiable
	{
		WGM::IS_EDITOR
		public var callStepInEditor:Boolean = false;
		
		public var poolManager:PoolManager = PoolManager.getInstance();
		
		public var localModelMatrix:Matrix3D = new Matrix3D();
		public var worldModelMatrix:Matrix3D = new Matrix3D();
		
		public var matrixUpdated:Boolean = false;
		public var scissorRectUpdated:Boolean = false;
		public var invalidateMatrix:Boolean = true;
		public var invalidateScissorRect:Boolean = true;
		public var useScissorRect:Boolean = false;
		public var invalidateColors:Boolean = true;
		
		public var _numChildren:uint = 0;
		public var childFirst:Node2D = null;
		public var childLast:Node2D = null;
		
		public var prev:Node2D = null;
		public var next:Node2D = null;
		
		public var worldRelativeZ:Number = 0.0;
		
		// components
		public var numComponents:int = 0;
		public var componentFirst:ComponentBase = null;
		public var componentLast:ComponentBase = null;
		public var hasRendererComponent:Boolean = false;
		
		public var uiComponent:UIComponent;
		
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
		
		public var forceBlockMouseChildren:Boolean = false;
		
		public var mouseInNode:Boolean = false;
		protected var localMouse:Vector3D;
		protected var localMouseMatrix:Matrix3D = new Matrix3D();
		
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
		
		// ID, NAME & CUSTOM CLASS
		public var _id:String = "";
		
		/* INTERFACE de.nulldesign.nd2dx.utils.IIdentifiable */
		
		[WGM (position = -1000, isEditable = false)]
		public function set id(value:String):void 
		{
			_id = value;
		}
		
		public function get id():String 
		{
			return _id;
		}
		
		[WGM (position = -900)]
		public var name:String = "";
		
		[WGM (position = -800)]
		public var customClass:String = "";
		
		// POSITION
		
		protected var _x:Number = 0.0;
		
		[WGM (position = -700, groupId = "position", groupPosition = 1, groupLabel = "position")]
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
		
		[WGM (position = -700, groupId = "position", groupPosition = 2)]
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
		
		[WGM (position = -700, groupId = "position", groupPosition = 3)]
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
		
		// SCALE
		
		public var _scaleX:Number = 1.0;
		
		[WGM (position = -600, groupId = "scale", groupPosition = 1, groupLabel = "scale", label = "x")]
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
		
		public var _scaleY:Number = 1.0;
		
		[WGM (position = -600, groupId = "scale", groupPosition = 2, label = "y")]
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
		
		public var _scaleZ:Number = 1.0;
		
		[WGM (position = -600, groupId = "scale", groupPosition = 3, label = "z")]
		public function set scaleZ(value:Number):void
		{
			if (_scaleZ != value)
			{
				_scaleZ = value;
				invalidateMatrix = true;
			}
		}
		
		public function get scaleZ():Number
		{
			return _scaleZ;
		}
		
		// SIZE
		
		public var _width:Number = 0.0;
		
		[WGM (isSerializable = false, position = -500, groupId = "size", groupPosition = 1, groupLabel = "size", label = "w")]
		public function get width():Number
		{
			return Math.abs(_width * _scaleX);
		}
		
		public function set width(value:Number):void
		{
			scaleX = value / _width;
		}
		
		public var _height:Number = 0.0;
		
		[WGM (isSerializable = false, position = -500, groupId = "size", groupPosition = 2, label = "h")]
		public function get height():Number
		{
			return Math.abs(_height * _scaleY);
		}
		
		public function set height(value:Number):void{
			scaleY = value / _height;
		}
		
		// TINT
		
		protected var _tintRed:Number = 1.0;
		protected var _tintGreen:Number = 1.0;
		protected var _tintBlue:Number = 1.0;
		
		public var combinedTintRed:Number = 1.0;
		public var combinedTintGreen:Number = 1.0;
		public var combinedTintBlue:Number = 1.0;
		
		[WGM (position = -400, groupId = "tint", groupPosition = 1, groupLabel = "tint", label = "r")]
		public function get tintRed():Number 
		{
			return _tintRed;
		}
		
		public function set tintRed(value:Number):void 
		{
			_tintRed = value;
			invalidateColors = true;
		}
		
		[WGM (position = -400, groupId = "tint", groupPosition = 2, label = "g")]
		public function get tintGreen():Number 
		{
			return _tintGreen;
		}
		
		public function set tintGreen(value:Number):void 
		{
			_tintGreen = value;
			invalidateColors = true;
		}
		
		[WGM (position = -400, groupId = "tint", groupPosition = 3, label = "b")]
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
		
		// VISIBILITY
		
		protected var _visible:Boolean = true;
		
		[WGM]
		public function get visible():Boolean
		{
			return _visible;
		}
		
		public function set visible(value:Boolean):void
		{
			if (_visible != value)
			{
				_visible = value;
				invalidateMatrix = true;
			}
		}
		
		public var _alpha:Number = 1.0;
		public var combinedAlpha:Number = 1.0;
		
		[WGM]
		public function set alpha(value:Number):void
		{
			if (_alpha != value)
			{
				_alpha = value;
				invalidateColors = true;
				
				//if ( _alpha <= 0.0 && _visible )
				//{
					//visible = false;
				//}
				//else if ( _alpha > 0.0 && !_visible )
				//{
					//visible = true;
				//}
			}
		}
		
		public function get alpha():Number
		{
			return _alpha;
		}
		
		
		
		protected var _pivot:Vector3D = new Vector3D(0.0, 0.0, 0.0);
		
		public function get pivot():Vector3D
		{
			return _pivot;
		}
		
		public function set pivot(value:Vector3D):void
		{
			if (_pivot.x != value.x || _pivot.y != value.y || _pivot.z != value.z)
			{
				_pivot.x = value.x;
				_pivot.y = value.y;
				_pivot.z = value.z;
				invalidateMatrix = true;
			}
		}
		
		public var localScissorRect:Rectangle;
		
		public var worldScissorRect:Rectangle;
		
		public function get scissorRect():Rectangle
		{
			return localScissorRect;
		}
		
		public function set scissorRect(value:Rectangle):void
		{
			if ( (localScissorRect && value == null) || !localScissorRect || localScissorRect.x != value.x || localScissorRect.y != value.y || localScissorRect.width != value.width || localScissorRect.height != value.height)
			{
				localScissorRect = value;
				invalidateScissorRect = true;
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
		
		// ROTATION
		
		protected var _rotationX:Number = 0.0;
		
		[WGM (position = -300, groupId = "rotation", groupPosition = 1, groupLabel = "rotation", label = "x")]
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
		
		[WGM (position = -300, groupId = "rotation", groupPosition = 2, groupLabel = "rotation", label = "y")]
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
		
		[WGM (position = -300, groupId = "rotation", groupPosition = 3, groupLabel = "rotation", label = "z")]
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
		
		public var hitTestMargin:Number = 0.0;
		
		public function get numChildren():uint
		{
			return _numChildren;
		}
		
		public function Node2D()
		{
			
		}
		
		public function updateLocalMatrix():void
		{
			invalidateMatrix = false;
			
			if ( _scaleX == 0 ) _scaleX = 0.000000000000001;
			if ( _scaleY == 0 ) _scaleY = 0.000000000000001;
			if ( _scaleZ == 0 ) _scaleZ = 0.000000000000001;
			
			localModelMatrix.identity();
			localModelMatrix.appendTranslation(-_pivot.x, -_pivot.y, -_pivot.z);
			localModelMatrix.appendScale(_scaleX, _scaleY, _scaleZ);
			localModelMatrix.appendRotation(_rotationZ, Vector3D.Z_AXIS);
			localModelMatrix.appendRotation(_rotationY, Vector3D.Y_AXIS);
			localModelMatrix.appendRotation(_rotationX, Vector3D.X_AXIS);
			localModelMatrix.appendTranslation(_x, _y, _z);
			localModelMatrix.appendTranslation(_pivot.x, _pivot.y, _pivot.z);
		}
		
		public function updateWorldMatrix():void
		{
			worldModelMatrix.identity();
			worldModelMatrix.append(localModelMatrix);
			
			if ( parent )
			{
				worldModelMatrix.append(parent.worldModelMatrix);
			}
		}
		
		public function updateScissorRect():void
		{
			invalidateScissorRect = false;
			
			if ( localScissorRect ) 
			{
				var pos:Point = localToGlobal(new Point(localScissorRect.x, localScissorRect.y));
				worldScissorRect = localScissorRect.clone();
				worldScissorRect.x = pos.x;
				worldScissorRect.y = pos.y;
				pos.x = localScissorRect.x + localScissorRect.width;
				pos.y = localScissorRect.y + localScissorRect.height;
				pos = localToGlobal(pos);
				worldScissorRect.width = pos.x - worldScissorRect.x;
				worldScissorRect.height = pos.y - worldScissorRect.y;
				
				if ( parent && parent.useScissorRect )
				{
					worldScissorRect = worldScissorRect.intersection(parent.worldScissorRect);
				}
				
				useScissorRect = true;
				
				var w:Number = world.bounds ? world.bounds.width : stage.stageWidth;
				var h:Number = world.bounds ? world.bounds.height : stage.stageHeight;
				
				if ( worldScissorRect.width < 1 || worldScissorRect.height < 1 || worldScissorRect.x + worldScissorRect.width < 1 || worldScissorRect.x >= w || worldScissorRect.y + worldScissorRect.height < 1 || worldScissorRect.y >= h )
				{
					//useScissorRect = false;
					worldScissorRect.x = 0;
					worldScissorRect.y = 0;
					worldScissorRect.width = 1;
					worldScissorRect.height = 1;
				}
			}
			else if ( parent && parent.useScissorRect )
			{
				worldScissorRect = parent.worldScissorRect.clone();
				useScissorRect = true;
			}
			else
			{
				useScissorRect = false;
				localScissorRect = null;
				worldScissorRect = null;
			}
		}
		
		public function processMouseEvent(mousePosition:Vector3D, event:MouseEvent, cameraViewProjectionMatrix:Matrix3D):Node2D
		{
			var result:Node2D = null;
			
			if ( event && _visible )
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
					
					if ( hitTest(_mouseX, _mouseY) ) result = this;
				}
			}
			
			return result;
		}
		
		public function updateMousePosition(mousePosition:Vector3D, cameraViewProjectionMatrix:Matrix3D):void
		{
			updateLocalMatrix();
			updateWorldMatrix();
			
			localMouseMatrix.identity();
			localMouseMatrix.append(worldModelMatrix);
			localMouseMatrix.append(cameraViewProjectionMatrix);
			localMouseMatrix.invert();

			localMouse = localMouseMatrix.transformVector(mousePosition);
			localMouse.w = 1.0 / localMouse.w;
			localMouse.x /= localMouse.w;
			localMouse.y /= localMouse.w;
			localMouse.z /= localMouse.w;

			_mouseX = localMouse.x;
			_mouseY = localMouse.y;
		}
		
		/**
		 * Overwrite and do your own hitTest if you like
		 * @return
		 */
		public function hitTest(x:Number, y:Number):Boolean
		{
			if ( uiComponent )
			{
				return uiComponent.hitTest(x, y);
			}
			else
			{
				for (var component:ComponentBase = componentFirst; component; component = component.next)
				{
					if( component.hitTest(x, y) ) return true;
				}
			}
			
			return false;
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
					dispatchSignal(Event.ADDED_TO_STAGE);
				}
				else
				{
					_stage = stage;
					dispatchSignal(Event.REMOVED_FROM_STAGE);
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
		
		public function drawNode(renderer:RendererBase):void 
		{
			// step components first
			for (var component:ComponentBase = componentFirst; component; component = component.next)
			{
				// don't step in wgm editor unless it is asked to
				WGM::IS_EDITOR
				{
					if( component._isActive && component.callStepInEditor ) component.step(renderer.elapsed);
				}
				WGM::IS_RELEASE
				{
					if( component._isActive ) component.step(renderer.elapsed);
				}
				
			}
			
			// don't step in wgm editor unless it is asked to
			WGM::IS_EDITOR
			{
				if( callStepInEditor ) step(renderer.elapsed);
			}
			WGM::IS_RELEASE
			{
				step(renderer.elapsed);
			}
			
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
				
				// set this to true so children can update their values as well
				invalidateColors = true;
			}
			
			// perform matrix calculations and draw only if visible
			if ( _visible )
			{
				// update matrices only if needed
				if ( _numChildren || localScissorRect )
				{
					checkAndUpdateMatrixIfNeeded();
				}
				
				// set scissor rect if needed
				if ( localScissorRect ) renderer.setScissorRect(this);
				
				// draw node if we have one or more renderer components
				if ( hasRendererComponent ) draw(renderer);
				
				// draw children
				for (var child:Node2D = childFirst; child; child = child.next)
				{
					child.drawNode(renderer);
				}
				
				// release scissor rect
				if ( localScissorRect ) renderer.releaseScissorRect(this);
				
				if ( matrixUpdated )
				{
					matrixUpdated = false;
					invalidateMatrix = false;
					
				}
				
				if ( scissorRectUpdated )
				{
					scissorRectUpdated = false;
					invalidateScissorRect = false;
				}
				
				invalidateColors = false;
			}
		}
		
		public function checkAndUpdateMatrixIfNeeded():void
		{
			if ( !matrixUpdated && (invalidateMatrix || (parent && parent.invalidateMatrix)) )
			{
				if (invalidateMatrix)
				{
					updateLocalMatrix();
				}
				
				updateWorldMatrix();
				
				updateScissorRect();
				
				// set this to true so children can update their values as well
				invalidateMatrix = true;
				invalidateScissorRect = true;
				
				// so we don't update matrix more than needed
				matrixUpdated = true;
			}
			else if ( !scissorRectUpdated && (invalidateScissorRect || (parent && parent.invalidateScissorRect)) )
			{
				updateScissorRect();
				invalidateScissorRect = true;
			}
		}
		
		public function step(elapsed:Number):void 
		{			
			// override in extended classes
		}
		
		public function draw(renderer:RendererBase):void 
		{
			// draw components
			for (var component:ComponentBase = componentFirst; component; component = component.next)
			{
				if( component._isActive ) component.draw(renderer);
			}
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
		
		/*public function addChildAt(child:Node2D, index:int):Node2D
		{
			if ( child.parent && child.parent != this )
			{
				child.parent.removeChild(child);
				child.parent = this;
				child.setReferences(_stage, camera, world, scene);
			}
			
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
		}*/

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
		
		public function removeChildAt(index:int):void
		{
			var currentIndex:int = 0;
			var child:Node2D;
			
			for (child = childFirst; child; child = child.next)
			{
				if ( index == currentIndex ) break;
				currentIndex++;
			}
			
			if ( child ) removeChild(child);
		}
		
		/**
		 * Insert or move child1 before child2
		 * @return
		 */
		public function insertChildBefore(child1:Node2D, child2:Node2D):void
		{
			if ( child2.parent != this ) return;
			
			if ( child1.parent && child1.parent != this )
			{
				child1.parent.removeChild(child1);
				
				unlinkChild(child1);
				
				child1.parent = this;
				child1.setReferences(_stage, camera, world, scene);
			}
			else if ( !child1.parent )
			{
				addChild(child1);
				
				unlinkChild(child1);
			}
			else
			{
				unlinkChild(child1);
			}
			
			if ( child2.prev )
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
		/*public function insertChildAfter(child1:Node2D, child2:Node2D):void
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
		}*/
		
		/*public function setChildIndex(node:Node2D, index:int):int
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
		}*/
		
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
		
		/*public function swapChildren(child1:Node2D, child2:Node2D):void
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
		}*/
		
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
			if ( component.node ) 
			{
				component.node.removeComponent(component);
			}
			
			if ( componentLast ) 
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
			
			if ( component is RendererComponentBase ) hasRendererComponent = true;
			
			if ( component is UIComponent ) uiComponent = component as UIComponent;
			
			component.setReferences(stage, camera, world, scene, this);
			component.onAddedToNode();
			
			dispatchSignal(SignalTypes.COMPONENT_ADDED_TO_NODE, component);
			
			addSignalListener(SignalTypes.COMPONENT_ADDED_TO_NODE, component.onComponentAddedToNode);
			addSignalListener(SignalTypes.COMPONENT_REMOVED_FROM_NODE, component.onComponentRemovedFromNode);
			
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
			
			hasRendererComponent = false;
			
			// go through all remaining component and check if one of them is a mesh2drenderercomponent
			for (var componentInList:ComponentBase = componentFirst; componentInList; componentInList = componentInList.next)
			{
				if ( componentInList is RendererComponentBase )
				{
					hasRendererComponent = true;
					break;
				}
			}
			
			if ( component == uiComponent ) uiComponent = null;
			
			component.setReferences(null, null, null, null, null);
			
			
			
			removeSignalListener(SignalTypes.COMPONENT_ADDED_TO_NODE, component.onComponentAddedToNode);
			removeSignalListener(SignalTypes.COMPONENT_REMOVED_FROM_NODE, component.onComponentRemovedFromNode);
			
			component.onRemovedFromNode();
			
			dispatchSignal(SignalTypes.COMPONENT_REMOVED_FROM_NODE, component);
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
		
		public function getComponentByClass(componentClass:Class):*
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
			//checkAndUpdateMatrixIfNeeded();
			
			var clipSpaceMat:Matrix3D = new Matrix3D();
			clipSpaceMat.append(worldModelMatrix);
			clipSpaceMat.append(camera.getViewProjectionMatrix(true));
			
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
			//checkAndUpdateMatrixIfNeeded();
			
			var clipSpaceMat:Matrix3D = new Matrix3D();
			clipSpaceMat.append(worldModelMatrix);
			clipSpaceMat.append(camera.getViewProjectionMatrix(true));
			clipSpaceMat.invert();
			
			var from:Vector3D = new Vector3D(p.x / camera.sceneWidth * 2.0 - 1.0,
				-(p.y / camera.sceneHeight * 2.0 - 1.0),
				0.0, 1.0);
				
			var v:Vector3D = clipSpaceMat.transformVector(from);
			v.w = 1.0 / v.w;
			v.x /= v.w;
			v.y /= v.w;
			v.z /= v.w;
			
			return new Point(v.x, v.y);
		}
		
		/**
		 * transforms a point into world coordinates
		 * @param p
		 * @return the transformed point
		 */
		public function localToWorld(p:Point):Point
		{
			//updateLocalMatrix();
			//updateWorldMatrix();
			
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
		
		/* INTERFACE com.rabbitframework.utils.IPoolable */
		
		public function initFromPool():void 
		{
			
		}
		
		public function disposeForPool():void 
		{
			var currentComponent:ComponentBase
			
			while (componentLast)
			{
				currentComponent = componentLast;
				removeComponent(currentComponent);
				poolManager.releaseObject(currentComponent);
			}
			
			var currentChild:Node2D
			
			while (childLast)
			{
				currentChild = childLast;
				removeChild(currentChild);
				poolManager.releaseObject(currentChild);
			}
			
			alpha = 1.0;
			_x = _y = _rotationZ = 0.0;
			_scaleX = _scaleY = 1.0;
			tint = 0xFFFFFF;
			invalidateColors = true;
			invalidateMatrix = true;
			
			parent = null;
			
			removeAllSignalListeners();
		}
		
		public function dispose():void 
		{
			var currentComponent:ComponentBase
			
			while (componentLast)
			{
				currentComponent = componentLast;
				removeComponent(currentComponent);
				currentComponent.dispose();
			}
			
			var currentChild:Node2D
			
			while (childLast)
			{
				currentChild = childLast;
				removeChild(currentChild);
				currentChild.dispose();
			}
			
			parent = null;
			_pivot = null;
			localScissorRect = null;
			worldScissorRect = null;
			localModelMatrix = null;
			worldModelMatrix = null;
			localMouseMatrix = null;
			
			removeAllSignalListeners();
		}
	}
}
