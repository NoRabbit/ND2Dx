package de.nulldesign.nd2dx.components.renderers 
{
	import de.nulldesign.nd2dx.components.renderers.RendererComponentBase;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.resource.mesh.Mesh2D;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.display3D.Context3DBlendFactor;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TexturedMeshRendererComponent extends RendererComponentBase
	{
		private var _mesh:Mesh2D;
		
		[WGM (position = -1100, label = "mesh")]
		public function get mesh():Mesh2D 
		{
			return _mesh;
		}
		
		public function set mesh(value:Mesh2D):void 
		{
			_mesh = value;
			
			if ( _mesh )
			{
				isUsingMesh = true;
			}
			else
			{
				isUsingMesh = false;
			}
		}
		
		private var _texture:Texture2D;
		
		[WGM (position = -1000, label = "texture")]
		public function get texture():Texture2D 
		{
			return _texture;
		}
		
		public function set texture(value:Texture2D):void 
		{
			if ( _texture == value ) return;
			
			_texture = value;
			
			checkIfReadyToRender();
			
			setNodeSize();
		}
		
		[WGM (position = -900, groupId = "uvOffset", groupPosition = 1, groupLabel = "UV Offset", label = "x")]
		public var uvOffsetX:Number = 0.0;
		
		[WGM (position = -900, groupId = "uvOffset", groupPosition = 2, groupLabel = "UV Offset", label = "y")]
		public var uvOffsetY:Number = 0.0;
		
		[WGM (position = -800, groupId = "uvScale", groupPosition = 1, groupLabel = "UV Scale", label = "x")]
		public var uvScaleX:Number = 1.0;
		
		[WGM (position = -800, groupId = "uvScale", groupPosition = 2, groupLabel = "UV Scale", label = "y")]
		public var uvScaleY:Number = 1.0;
		
		[WGM (position = -700)]
		public var useTextureSize:Boolean = true;
		
		private var isUsingMesh:Boolean = false;
		
		public function TexturedMeshRendererComponent(texture:Texture2D = null) 
		{
			this.texture = texture;
		}
		
		override public function onAddedToNode():void 
		{
			super.onAddedToNode();
			setNodeSize();
		}
		
		override public function draw(renderer:RendererBase):void 
		{
			if ( !isReadyToRender ) return;
			
			if ( isUsingMesh )
			{
				renderer.drawTexturedMesh(texture, useTextureSize, _mesh.vertexList, _mesh.indexList, node.parent, node, node.x, node.y, node.z, node._scaleX, node._scaleY, node._scaleZ, node.rotationZ, node.rotationY, node.rotationX, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst, node.pivot.x, node.pivot.y);
			}
			else
			{
				renderer.drawTexturedQuad(texture, true, node.parent, node, node.x, node.y, node.z, node._scaleX, node._scaleY, node._scaleZ, node.rotationZ, node.rotationY, node.rotationX, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst, node.pivot.x, node.pivot.y);
			}
		}
		
		private function setNodeSize():void
		{
			if ( node )
			{
				if ( _texture )
				{
					node._width = _texture.bitmapWidth;
					node._height = _texture.bitmapHeight;
				}
				else
				{
					node._width = 0.0;
					node._height = 0.0;
				}
			}
		}
		
		public function checkIfReadyToRender():void
		{
			isReadyToRender = true;
			
			if ( !_texture ) isReadyToRender = false;
		}
		
		override public function hitTest(x:Number, y:Number):Boolean 
		{
			if ( !texture ) return false;
			
			var halfWidth:Number = texture.bitmapWidth >> 1;
			var halfHeight:Number = texture.bitmapHeight >> 1;
			
			return x >= -halfWidth - node.hitTestMargin
				&& x <= halfWidth + node.hitTestMargin
				&& y >= -halfHeight - node.hitTestMargin
				&& y <= halfHeight + node.hitTestMargin;
		}
	}

}