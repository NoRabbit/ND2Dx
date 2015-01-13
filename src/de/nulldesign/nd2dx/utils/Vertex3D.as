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
		
		public var a:Number;
		public var r:Number;
		public var g:Number;
		public var b:Number;
		
		public function Vertex3D(x:Number = 0.0, y:Number = 0.0, z:Number = 0.0, u:Number = 0.0, v:Number = 0.0, r:Number = 1.0, g:Number = 1.0, b:Number = 1.0, a:Number = 1.0) 
		{
			this.x = x;
			this.y = y;
			this.z = z;
			
			this.u = u;
			this.v = v;
			
			this.r = r;
			this.g = g;
			this.b = b;
			this.a = a;
		}

		public function clone():Vertex3D
		{
			return  new Vertex3D(x, y, z, u, v, r, g, b, a);
		}
		
		public function toString():String 
		{
			return "Vertex3D: " + x + ", " + y + ", " + z + " (" + u + "/" + v + ") (" + r + ", " + g + ", " + b + ", " + a + ")";
		}
	}

}