package de.nulldesign.nd2dx.support 
{
	import de.nulldesign.nd2dx.components.Mesh2DRendererComponent;
	import de.nulldesign.nd2dx.display.Camera2D;
	import de.nulldesign.nd2dx.display.Node2D;
	import flash.display3D.Context3D;
	import flash.geom.Matrix3D;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RenderSupportBase 
	{
		public var context:Context3D = null;
		public var camera:Camera2D = null;
		public var elapsed:Number = 0.0
		public var deviceWasLost:Boolean = false;
		public var viewProjectionMatrix:Matrix3D;
		public var isPrepared:Boolean = false;
		
		public var debugLog:String = "";
		
		public function RenderSupportBase() 
		{
			
		}
		
		public function prepare():void
		{
			isPrepared = true;
		}
		
		public function setScrollRect(node:Node2D):void
		{
			
		}
		
		public function drawMesh(meshRenderer:Mesh2DRendererComponent):void
		{
			
		}
		
		public function endDrawNode(node:Node2D):void
		{
			
		}
		
		public function finalize():void
		{
			
		}
	}

}