package com.rabbitframework.utils 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author Thomas John (c) thomas.john@open-design.be
	 */
	public class DisplayObjectUtils 
	{
		
		public function DisplayObjectUtils() 
		{
			
		}
		
		public static function resizeAndKeepAspectRatio(displayObject:DisplayObject, width:Number, height:Number, useSmaller:Boolean = true):Number
		{
			var ratio:Number = getResizeRatio(displayObject, width, height, useSmaller);
			
			displayObject.width = displayObject.width * ratio;
			displayObject.height = displayObject.height * ratio;
			
			return ratio;
		}
		
		public static function getResizeRatio(displayObject:DisplayObject, width:Number, height:Number, useSmaller:Boolean = true):Number
		{
			var mWidth:Number = width / displayObject.width;
			var mHeight:Number = height / displayObject.height;
			var ratio:Number = mWidth;
			
			if ( useSmaller )
			{
				if ( mHeight < ratio ) ratio = mHeight;
			}
			else
			{
				if ( mHeight > ratio ) ratio = mHeight;
			}
			
			return ratio;
		}
		
		public static function unset3DTransformations(displayObject:DisplayObject):void
		{
			var pos:Point = new Point(displayObject.x, displayObject.y);
			displayObject.transform.matrix3D = null;
			displayObject.x = pos.x;
			displayObject.y = pos.y;
		}
		
		public static function removeAllChildrenBut(dOC:DisplayObjectContainer, children:Array = null):void
		{
			if ( children == null ) children = new Array();
			
			var i:int = 0;
			var n:int = dOC.numChildren;
			var child:DisplayObject;
			
			var childrenToRemove:Array = new Array();
			
			for (i = 0; i < n; i++) 
			{
				child = dOC.getChildAt(i);
				if (children.indexOf(child) < 0 ) childrenToRemove.push(child);
			}
			
			n = childrenToRemove.length;
			
			for (i = 0; i < n; i++) 
			{
				dOC.removeChild(childrenToRemove[i]);
			}
		}
		
		public static function callFunctionOnAllChildrenBut(dOC:DisplayObjectContainer, functionToCall:Function, children:Array = null):void
		{
			if ( children == null ) children = new Array();
			
			var i:int = 0;
			var n:int = dOC.numChildren;
			var child:DisplayObject;
			
			var childrenToCall:Array = new Array();
			
			for (i = 0; i < n; i++) 
			{
				child = dOC.getChildAt(i);
				if (children.indexOf(child) < 0 ) childrenToCall.push(child);
			}
			
			n = childrenToCall.length;
			
			for (i = 0; i < n; i++) 
			{
				//trace("callFunctionOnAllChildrenBut", childrenToCall[i]);
				functionToCall.apply(null, [childrenToCall[i]]);
			}
		}
		
		public static function setPerspectiveProjection(dO:DisplayObject, fieldOfView:Number = 45, projectionCenter:Point = null):void
		{
			if ( projectionCenter == null ) projectionCenter = new Point();
			var pp:PerspectiveProjection = new PerspectiveProjection();
			pp.fieldOfView = fieldOfView;
			pp.projectionCenter = projectionCenter;
			dO.transform.perspectiveProjection = pp;
		}
		
		public static function isChildOf(displayObject:DisplayObject, parent:DisplayObjectContainer):Boolean
		{
			if ( displayObject == null || parent == null ) return false;
			
			var currentParent:DisplayObjectContainer = displayObject.parent;
			
			while (currentParent != null)
			{
				if ( currentParent == parent ) return true;
				currentParent = currentParent.parent;
			}
			return false;
		}
		
		public static function orderChildrenOnZ(dispObject:DisplayObjectContainer):void
		{
			var a:Array = new Array();
			
			var i:int = 0;
			var n:int = dispObject.numChildren;
			
			for (i = 0; i < n; i++) 
			{
				a.push(dispObject.getChildAt(i));
			}
			
			a.sortOn(["z"], [Array.NUMERIC]);
			
			n = a.length;
			for (i = 0; i < n; i++) 
			{
				dispObject.setChildIndex(a[i], n-i-1);
			}
		}
		
		public static function getAllChildren(dispObject:DisplayObjectContainer):Array
		{
			var i:int = 0;
			var n:int = dispObject.numChildren;
			var a:Array = [];
			
			for (i = 0; i < n; i++) 
			{
				a.push(dispObject.getChildAt(i));
			}
			
			return a;
		}
		
		public static function getVisibleBounds(displayObject:DisplayObject):Rectangle
		{
			var bounds:Rectangle;
			var boundsDispO:Rectangle = displayObject.getBounds( displayObject );
			
			boundsDispO.x = Math.floor(boundsDispO.x);
			boundsDispO.y = Math.floor(boundsDispO.y);
			boundsDispO.width = Math.ceil(boundsDispO.width);
			boundsDispO.height = Math.ceil(boundsDispO.height);
			
			var bitmapData:BitmapData = new BitmapData(boundsDispO.width, boundsDispO.height, true, 0 );
			
			var matrix:Matrix = new Matrix();
			matrix.translate( -boundsDispO.x, -boundsDispO.y);
			
			bitmapData.draw( displayObject, matrix, new ColorTransform(1, 0, 0, 1, 255, -255, -255, 255 ) );
			
			bounds = bitmapData.getColorBoundsRect(0xFF000000, 0x00FFFFFF, false);
			bounds.x += boundsDispO.x;
			bounds.y += boundsDispO.y;
			
			bitmapData.dispose();
			return bounds;
		}
		
		public static function skew(displayObject:DisplayObject, x:Number, y:Number):void
		{
			var m:Matrix = new Matrix();
			m.b = x * Math.PI/180;
			m.c = y * Math.PI/180;
			m.concat(displayObject.transform.matrix);
			displayObject.transform.matrix = m;
		}
		
		/**
		 * FROM SENOCULAR
		 * http://www.senocular.com/flash/actionscript/?file=ActionScript_3.0/com/senocular/display/isFrontFacing.as
		 * @param	displayObject
		 * @return
		 */
		public static function isFrontFacing(displayObject:DisplayObject):Boolean
		{
			// define 3 arbitary points in the display object for a
			// global path to test winding
			var p1:Point = displayObject.localToGlobal(new Point(0,0));
			var p2:Point = displayObject.localToGlobal(new Point(100,0));
			var p3:Point = displayObject.localToGlobal(new Point(0,100));
			// use the cross-product for winding which will determine if
			// the front face is facing the viewer
			return Boolean((p2.x-p1.x)*(p3.y-p1.y) - (p2.y-p1.y)*(p3.x-p1.x) > 0);
		}
		
		public static function rotateAroundPoint(displayObject:DisplayObject, x:Number, y:Number, rotation:Number):void
		{
			// get matrix object
			var m:Matrix = displayObject.transform.matrix;
			
			// set the point around which you want to rotate your displayObject
			var point:Point = new Point(x, y);
			
			// get the position of the displayObject related to its origin and the point around which it needs to be rotated
			point = m.transformPoint(point);
			
			// set it
			m.translate( -point.x, -point.y);
			
			// rotate it of 30°
			m.rotate(rotation * (Math.PI / 180));
			
			// and get back to its “normal” position
			m.translate(point.x, point.y);
			
			// finally, set the displayObject transform matrix
			displayObject.transform.matrix = m;
			
			// or this
			//mc.x = m.tx;
			//mc.y = m.ty;
			//mc.rotation += 30;
		}
	}
	
}