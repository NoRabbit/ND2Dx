package de.nulldesign.nd2dx.utils 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Vertex3D 
	{
		public var x:Number;
		public var y:Number;
		public var z:Number;
		
		public var u:Number;
		public var v:Number;
		
		/**
		 * the color must be in ARGB format.
		 */
		public var color:uint = 0xFFFFFFFF;

		public var bufferIdx:int = -1;
		
		public function Vertex3D(x:Number = 0.0, y:Number = 0.0, z:Number = 0.0, u:Number = 0.0, v:Number = 0.0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
			this.u = u;
			this.v = v;
		}
		
		public function get a():Number 
		{
			return ((color >> 24) & 0xFF) / 0xFF;
		}

		public function get r():Number 
		{
			return ((color >> 16) & 0xFF) / 0xFF;
		}

		public function get g():Number 
		{
			return ((color >> 8) & 0xFF) / 0xFF;
		}

		public function get b():Number 
		{
			return (color & 0xFF) / 0xFF;
		}

		public function clone():Vertex3D
		{
			var vertex:Vertex3D = new Vertex3D(x, y, u, v);
			vertex.color = color;
			return vertex;
		}
		
		public function toString():String 
		{
			return "Vertex3D: " + x + ", " + y + " (" + u + "/" + v + ")";
		}
	}

}