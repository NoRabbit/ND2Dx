package de.nulldesign.nd2dx.components 
{
	import com.atommica.plum.geom.Parametric;
	import de.nulldesign.nd2dx.components.renderers.RendererComponentBase;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.display.Scene2D;
	import de.nulldesign.nd2dx.display.World2D;
	import com.atommica.plum.geom.CubicBezier;
	import de.nulldesign.nd2dx.display.Camera2D;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.utils.Vector2D;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	import flash.display.Graphics;
	import flash.display.Stage;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class CurveRenderer extends RendererComponentBase
	{
		public var p1:Point = new Point(50, 50);
		public var p2:Point = new Point(485, 50);
		public var p3:Point = new Point(485, 50);
		public var p4:Point = new Point(200, 400);
		
		public var curve:CubicBezier = new CubicBezier(p1, p2, p3, p4, Parametric.ARC_LENGTH);
		//public var curve:CubicBezier = new CubicBezier(p1, p2, p3, p4, Parametric.UNIFORM);
		
		public var precision:int = 5;
		
		public var vPoints:Vector.<Point> = new Vector.<Point>();
		public var vVertices:Vector.<Vertex3D> = new Vector.<Vertex3D>();
		public var vIndices:Vector.<uint> = new Vector.<uint>();
		
		public var thickness:Number = 20.0;
		
		public var texture:Texture2D;
		
		public function CurveRenderer() 
		{
			updateMesh();
		}
		
		override public function draw(renderer:RendererBase):void 
		{
			//renderer.drawTexturedMesh(texture, false, vVertices, vIndices, node.parent, node.x, node.y, node._scaleX, node._scaleY, node.rotation, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha);
		}
		
		public function updateMesh():void
		{
			curve.reset();
			curve.points.push(p1);
			curve.points.push(p2);
			curve.points.push(p3);
			curve.points.push(p4);
			
			if ( vPoints.length ) vPoints.splice(0, vPoints.length);
			if ( vVertices.length ) vVertices.splice(0, vVertices.length);
			if ( vIndices.length ) vIndices.splice(0, vIndices.length);
			
			// get points along the curve
			var i:int = 0;
			var n:int = precision;
			
			for (; i <= n; i++) 
			{
				vPoints.push(curve.getPoint(i / n));
			}
			
			// get points around curve based on thickness
			i = 0;
			n = vPoints.length - 1;
			
			var startPoint:Point;
			var endPoint:Point;
			
			var segment:Vector2D = new Vector2D();
			var leftNormalizedSegment:Vector2D;
			var rightNormalizedSegment:Vector2D;
			
			var previousSegment:Vector2D;
			var previousLeftNormalizedSegment:Vector2D;
			var previousRightNormalizedSegment:Vector2D;
			
			var vertex:Vertex3D;
			
			for (; i < n; i++) 
			{
				startPoint = vPoints[i];
				endPoint = vPoints[i + 1];
				segment.setVectorFromPoints(startPoint.x, startPoint.y, endPoint.x, endPoint.y);
				leftNormalizedSegment = segment.lNormal.cross(thickness).clone();
				rightNormalizedSegment = segment.rNormal.cross(thickness).clone();
				
				if ( previousSegment )
				{
					leftNormalizedSegment.substract(previousLeftNormalizedSegment).cross(0.5).add(previousLeftNormalizedSegment);
					rightNormalizedSegment.substract(previousRightNormalizedSegment).cross(0.5).add(previousRightNormalizedSegment);
				}
				
				vertex = new Vertex3D(startPoint.x + leftNormalizedSegment.x, startPoint.y + leftNormalizedSegment.y, 0.0, i / n, 0.0);
				vVertices.push(vertex);
				
				vertex = new Vertex3D(startPoint.x + rightNormalizedSegment.x, startPoint.y + rightNormalizedSegment.y, 0.0, i / n, 1.0);
				vVertices.push(vertex);
				
				previousSegment = segment;
				//segment.bIsLeftNormalUpdated = segment.bIsRightNormalUpdated = false;
				previousLeftNormalizedSegment = segment.lNormal;
				previousRightNormalizedSegment = segment.rNormal;
			}
			
			vertex = new Vertex3D(endPoint.x + previousLeftNormalizedSegment.x, endPoint.y + previousLeftNormalizedSegment.y, 0.0, 1.0, 0.0);
			vVertices.push(vertex);
			
			vertex = new Vertex3D(endPoint.x + previousRightNormalizedSegment.x, endPoint.y + previousRightNormalizedSegment.y, 0.0, 1.0, 1.0);
			vVertices.push(vertex);
			
			i = 0;
			n = (vVertices.length - 2) / 2;
			var indiceIndex:int = 0;
			
			for (; i < n; i++) 
			{
				vIndices.push(indiceIndex + 0);
				vIndices.push(indiceIndex + 1);
				vIndices.push(indiceIndex + 2);
				vIndices.push(indiceIndex + 1);
				vIndices.push(indiceIndex + 2);
				vIndices.push(indiceIndex + 3);
				
				indiceIndex += 2;
			}
		}
		
		public function drawPoints(graphics:Graphics):void
		{
			var i:int = 0;
			var n:int = vVertices.length;
			var vertex:Vertex3D;
			
			graphics.beginFill(0xff0000);
			
			for (; i < n; i++) 
			{
				vertex = vVertices[i];
				graphics.drawCircle(vertex.x, vertex.y, 3);
			}
			
			var p:Point;
			
			i = 0;
			n = vPoints.length;
			
			graphics.endFill();
			graphics.beginFill(0xff0000);
			
			for (; i < n; i++) 
			{
				//graphics.beginFill(0xff0000);
				
				p = vPoints[i];
				graphics.drawCircle(p.x, p.y, 5);
			}
			
			graphics.endFill();
			graphics.lineStyle(1.0, 0x00ff00);
			
			i = 0;
			n = vPoints.length;
			
			for (; i < n; i++) 
			{
				p = vPoints[i];
				
				if ( i == 0 )
				{
					graphics.moveTo(p.x, p.y);
				}
				else
				{
					graphics.lineTo(p.x, p.y);
				}
			}
			
			graphics.endFill();
		}
	}

}