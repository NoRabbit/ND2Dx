package de.nulldesign.nd2dx.components.renderers 
{
	import de.nulldesign.nd2dx.components.renderers.RendererComponentBase;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import flash.display3D.Context3DBlendFactor;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TexturedMeshRendererComponent extends RendererComponentBase
	{
		private var _texture:Texture2D;
		
		public var uvOffsetX:Number = 0.0;
		public var uvOffsetY:Number = 0.0;
		public var uvScaleX:Number = 1.0;
		public var uvScaleY:Number = 1.0;
		
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
			renderer.drawTexturedQuad(texture, true, node.parent, node, node.x, node.y, node.z, node._scaleX, node._scaleY, node._scaleZ, node.rotationZ, node.rotationY, node.rotationX, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst, node.pivot.x, node.pivot.y);
		}
		
		public function get texture():Texture2D 
		{
			return _texture;
		}
		
		public function set texture(value:Texture2D):void 
		{
			if ( _texture == value ) return;
			
			_texture = value;
			
			setNodeSize();
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
	}

}