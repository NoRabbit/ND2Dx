package com.rabbitframework.tween.properties.displayobject 
{
	import com.carlcalderon.arthropod.Debug;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2009.
	 */
	public class PropertyDoMatrixRotation extends PropertyDoBase
	{
		public var matrix:Matrix;
		public var point:Point = new Point();
		//public var lastRotation:Number = 0.0;
		public var rotation:Number = 0.0;
		//public var currentRotation:Number = 0.0;
		
		public function PropertyDoMatrixRotation(target:Object, property:String, startValue:Object, endValue:Object) 
		{
			super(target, property, startValue, endValue);
		}
		
		/**
		 * Init values
		 */
		override public function init():void
		{
			//trace("start 1", startValue, "end", endValue);
			
			matrix = target.transform.matrix;
			
			point.x = 0;
			point.y = 1;
			point = matrix.deltaTransformPoint(point);
			
			if ( startValue == null )
			{
				startValue = ((180 / Math.PI) * Math.atan2(point.y, point.x) - 90);
			}
			
			//trace("start 2", startValue, "end", endValue);
			
			super.init();
			matrix = displayObject.transform.matrix;
			
			//Debug.log("start = " + startValue + ", " + displayObject.rotation + ", " + ((180 / Math.PI) * Math.atan2(point.y, point.x) - 90) + ", " + matrix);
		}
		
		/**
		 * Update property
		 */
		override public function update(factor:Number):void
		{
			//var newMatrix:Matrix = new Matrix();
			//matrix = displayObject.transform.matrix;
			
			point.x = matrix.tx;
			point.y = matrix.ty;
			
			rotation = start + change * factor;
			//currentRotation = rotation - lastRotation;
			//lastRotation = rotation;
			
			rotation = rotation / (180 / Math.PI);
			
			matrix.identity();
			matrix.rotate(rotation);
			matrix.tx = point.x;
			matrix.ty = point.y;
			
			//matrix.concat(newMatrix);
			
			//Debug.log(factor + ", " + currentRotation + ", " + matrix);
			
			//displayObject.transform.matrix.rotate( -lastRotation);
			
			//matrix.concat(displayObject.transform.matrix);
			
			//if( lastRotation != 0.0 ) matrix.rotate(-lastRotation);
			
			//matrix.rotate(-a);
			
			displayObject.transform.matrix = matrix;
		}
	}
	
}