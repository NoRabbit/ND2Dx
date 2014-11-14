package de.nulldesign.nd2dx.renderers 
{
	import de.nulldesign.nd2dx.display.Camera2D;
	import de.nulldesign.nd2dx.display.Node2D;
	import de.nulldesign.nd2dx.managers.resource.ResourceManager;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.utils.Vertex3D;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DBlendFactor;
	import flash.geom.Matrix3D;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RendererBase 
	{
		public var resourceManager:ResourceManager = ResourceManager.getInstance();
		
		public var context:Context3D = null;
		public var camera:Camera2D = null;
		public var elapsed:Number = 0.0
		public var deviceWasLost:Boolean = false;
		public var viewProjectionMatrix:Matrix3D;
		
		public var scissorRect:Rectangle;
		public var vScissorRects:Vector.<Rectangle> = new Vector.<Rectangle>();
		
		public var isInited:Boolean = false;
		
		public function RendererBase() 
		{
			
		}
		
		public function init(context:Context3D, camera:Camera2D):void
		{
			if ( isInited ) return;
			isInited = true;
			
			this.context = context;
			this.camera = camera;
		}
		
		public function handleDeviceLoss(context:Context3D):void
		{
			this.context = context;
		}
		
		public function activate():void
		{
			//if ( !isInited ) return;
		}
		
		public function prepare():void
		{
			viewProjectionMatrix = camera.getViewProjectionMatrix();
		}
		
		public function drawTexturedMesh(texture:Texture2D, useTextureSize:Boolean, vertices:Vector.<Vertex3D>, indices:Vector.<uint>, parent:Node2D, node:Node2D = null, x:Number = 0.0, y:Number = 0.0, z:Number = 0.0, scaleX:Number = 1.0, scaleY:Number = 1.0, scaleZ:Number = 1.0, rotationZ:Number = 0.0, rotationY:Number = 0.0, rotationX:Number = 0.0, r:Number = 1.0, g:Number = 1.0, b:Number = 1.0, a:Number = 1.0, uvOffsetX:Number = 0.0, uvOffsetY:Number = 0.0, uvScaleX:Number = 1.0, uvScaleY:Number = 1.0, blendModeSrc:String = Context3DBlendFactor.ONE, blendModeDst:String = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA, pivotX:Number = 0.0, pivotY:Number = 0.0):void
		{
			
		}
		
		public function drawTexturedQuad(texture:Texture2D, useTextureSize:Boolean, parent:Node2D, node:Node2D = null, x:Number = 0.0, y:Number = 0.0, z:Number = 0.0, scaleX:Number = 1.0, scaleY:Number = 1.0, scaleZ:Number = 1.0, rotationZ:Number = 0.0, rotationY:Number = 0.0, rotationX:Number = 0.0, r:Number = 1.0, g:Number = 1.0, b:Number = 1.0, a:Number = 1.0, uvOffsetX:Number = 0.0, uvOffsetY:Number = 0.0, uvScaleX:Number = 1.0, uvScaleY:Number = 1.0, blendModeSrc:String = Context3DBlendFactor.ONE, blendModeDst:String = Context3DBlendFactor.ONE_MINUS_SOURCE_ALPHA, pivotX:Number = 0.0, pivotY:Number = 0.0):void
		{
			
		}
		
		public function setScissorRect(node:Node2D):void
		{
			draw();
			
			scissorRect = node.worldScissorRect;
			vScissorRects.push(scissorRect);
		}
		
		public function releaseScissorRect(node:Node2D):void
		{
			draw();
			
			var i:int = vScissorRects.indexOf(scissorRect);
			if ( i >= 0 ) vScissorRects.splice(i, 1);
			
			if ( vScissorRects.length )
			{
				scissorRect = vScissorRects[vScissorRects.length - 1];
			}
			else
			{
				scissorRect = null;
			}
		}
		
		public function draw():void
		{
			
		}
	}

}