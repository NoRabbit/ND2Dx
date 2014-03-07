package de.nulldesign.nd2dx.geom 
{
	/**
	 * ...
	 * @author Thomas John (thomas.john@open-design.be) www.open-design.be
	 */
	public class Vector2D 
	{
		private var _x:Number = 0;
		private var _y:Number = 0;
		
		private var _normalized:Vector2D;
		private var _rNormal:Vector2D;
		private var _lNormal:Vector2D;
		private var _length:Number;
		
		private var bIsLengthUpdated:Boolean = false;
		private var bIsNormalizedUpdated:Boolean = false;
		private var bIsRightNormalUpdated:Boolean = false;
		private var bIsLeftNormalUpdated:Boolean = false;
		
		public function Vector2D(x:Number = 0, y:Number = 0) 
		{
			_x = x;
			_y = y;
		}
		
		public function clone():Vector2D
		{
			return new Vector2D(_x, _y);
		}
		
		/**
		 * Set vector values
		 * @param	x
		 * @param	y
		 */
		public function setVectorValues(x:Number, y:Number):void
		{
			this.x = x;
			this.y = y;
		}
		
		/**
		 * Calculate vector values from two points
		 * @param	x1
		 * @param	y1
		 * @param	x2
		 * @param	y2
		 */
		public function setVectorFromPoints(x1:Number, y1:Number, x2:Number, y2:Number):void
		{
			x = x2 - x1;
			y = y2 - y1;
		}
		
		/**
		 * Calculate dot product of this vector and vector v
		 * @param	v
		 * @return dot product
		 */
		public function dotProduct(v:Vector2D):Number
		{
			return _x * v.x + _y * v.y;
		}
		
		/**
		 * Calculate cross product of this vector and number n.
		 * @param	n
		 * @return cross product
		 */
		public function cross(n:Number):Vector2D
		{
			setVectorValues(_x * n, _y * n);
			return this;
		}
		
		public function crossClone(n:Number):Vector2D
		{
			return new Vector2D(_x * n, _y * n);
		}
		
		/**
		 * Add vector v to this vector
		 * @param	v
		 * @return new vector with added x and y
		 */
		public function add(v:Vector2D):Vector2D
		{
			setVectorValues(_x + v.x, _y + v.y);
			return this;
		}
		
		public function addClone(v:Vector2D):Vector2D
		{
			return new Vector2D(_x + v.x, _y + v.y);
		}
		
		/**
		 * Substract vector v to this vector
		 * @param	v
		 * @return new vector.
		 */
		public function substract(v:Vector2D):Vector2D
		{
			setVectorValues(_x - v.x, _y - v.y);
			return this;
		}
		
		public function substractClone(v:Vector2D):Vector2D
		{
			return new Vector2D(_x - v.x, _y - v.y);
		}
		
		/**
		 * Invert this vector
		 */
		public function invert():void
		{
			_x *= -1;
			_y *= -1;
			
			bIsRightNormalUpdated = false;
			bIsLeftNormalUpdated = false;
			bIsNormalizedUpdated = false;
		}
		
		public function getInverted():Vector2D
		{
			var v:Vector2D = this.clone();
			v.invert();
			return v;
		}
		
		/**
		 * Normalize this vector
		 */
		public function normalize():void
		{
			if ( _length == 0 )
			{
				_x = 0;
				_y = 0;
			}
			else
			{
				_x /= length;
				_y /= length;
			}
			
			bIsLengthUpdated = false;
		}
		
		public function toString():String
		{
			return "vector: " + _x + "," + _y +
			", length: " + length +
			", r normal: " + rNormal.x + "," + rNormal.y +
			", l normal: " + lNormal.x + "," + lNormal.y +
			", normalized: " + normalized.x + "," + normalized.y;	
		}
	
		/**
		 * PRIVATE
		 */
		
		private function invalidateLengthAndNormals():void
		{
			bIsLengthUpdated = false;
			bIsNormalizedUpdated = false;
			bIsRightNormalUpdated = false;
			bIsLeftNormalUpdated = false;
		}
		
		/**
		 * GETTERS / SETTERS
		 */
		
		public function get x():Number { return _x; }
		
		public function set x(value:Number):void 
		{
			if ( value != _x ) invalidateLengthAndNormals();
			_x = value;
		}
		
		public function get y():Number { return _y; }
		
		public function set y(value:Number):void 
		{
			if ( value != _y ) invalidateLengthAndNormals();
			_y = value;
		}
		
		public function get rNormal():Vector2D 
		{ 
			bIsRightNormalUpdated = false;
			if ( !bIsRightNormalUpdated )
			{
				bIsRightNormalUpdated = true;
				
				_rNormal = new Vector2D();
				
				if ( length == 0 )
				{
					_rNormal.x = 0;
					_rNormal.y = 0;
				}
				else
				{
					bIsLengthUpdated = false;
					_rNormal.x = -_y/length;
					_rNormal.y = _x/length;
				}
			}
			
			return _rNormal;
		}
		
		public function set rNormal(value:Vector2D):void 
		{
			_rNormal = value;
		}
		
		public function get lNormal():Vector2D
		{
			bIsLeftNormalUpdated = false;
			if ( !bIsLeftNormalUpdated )
			{
				bIsLeftNormalUpdated = true;
				
				_lNormal = new Vector2D();
				
				if ( length == 0 )
				{
					_lNormal.x = 0;
					_lNormal.y = 0;
				}
				else
				{
					bIsLengthUpdated = false;
					_lNormal.x = _y/length;
					_lNormal.y = -_x/length;
				}
			}
			
			return _lNormal;
		}
		
		public function set lNormal(value:Vector2D):void 
		{
			_lNormal = value;
		}
		
		public function get length():Number 
		{
			if ( !bIsLengthUpdated )
			{
				bIsLengthUpdated = true;
				_length = Math.sqrt(_x*_x + _y*_y);
			}
			
			return _length;
		}
		
		public function set length(value:Number):void 
		{
			_length = value;
		}
		
		public function get normalized():Vector2D
		{
			if ( !bIsNormalizedUpdated )
			{
				bIsNormalizedUpdated = true;
				
				_normalized = this.clone();
				_normalized.normalize();
			}
			
			return _normalized;
		}
		
		public function set normalized(value:Vector2D):void 
		{
			_normalized = value;
		}
		
	}
	
}