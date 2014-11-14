package de.nulldesign.nd2dx.components 
{
	import de.nulldesign.nd2dx.display.Node2D;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DepthSortComponent extends ComponentBase
	{
		public var m:Matrix3D = new Matrix3D();
		public var v:Vector3D = new Vector3D();
		
		public var aChildren:Array = [];
		
		public function DepthSortComponent() 
		{
			
		}
		
		override public function step(elapsed:Number):void 
		{
			/*if ( node && node.numChildren )
			{
				node.checkAndUpdateMatrixIfNeeded();
				
				aChildren.splice(0);
				
				for (var child:Node2D = node.childFirst; child; child = child.next)
				{
					getDepthForChild(child);
					aChildren.push(child);
				}
				
				//trace("debugTraceChildren A");
				//debugTraceChildren();
				
				aChildren.sortOn("worldRelativeZ", Array.NUMERIC | Array.DESCENDING);
				
				//trace("debugTraceChildren B");
				//debugTraceChildren();
				
				node.removeAllChildren();
				
				var i:int = 0;
				var n:int = aChildren.length;
				
				for (; i < n; i++) 
				{
					node.addChild(aChildren[i] as Node2D);
				}
			}*/
		}
		
		public function getDepthForChild(child:Node2D):void
		{
			child.checkAndUpdateMatrixIfNeeded();
			
			m.identity();
			m.append(child.worldModelMatrix);
			m.append(camera.getViewProjectionMatrix());
			
			v.setTo(child.x, child.y, 0.0);
			v = m.transformVector(v);
			
			child.worldRelativeZ = v.z;
		}
		
		public function debugTraceChildren():void
		{
			var i:int = 0;
			var n:int = aChildren.length;
			
			for (; i < n; i++) 
			{
				trace((aChildren[i] as Node2D).name, (aChildren[i] as Node2D).worldRelativeZ);
			}
		}
	}

}