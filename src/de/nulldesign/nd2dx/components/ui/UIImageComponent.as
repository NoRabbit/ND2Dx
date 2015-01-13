package de.nulldesign.nd2dx.components.ui 
{
	import de.nulldesign.nd2dx.components.renderers.RendererComponentBase;
	import de.nulldesign.nd2dx.renderers.RendererBase;
	import de.nulldesign.nd2dx.resource.texture.Texture2D;
	import de.nulldesign.nd2dx.utils.TextureUtil;
	import de.nulldesign.nd2dx.utils.UIUtils;
	import flash.display3D.Context3DBlendFactor;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIImageComponent extends RendererComponentBase implements IUIUpdatable
	{
		private var _texture:Texture2D;
		
		private var tl:SlicedObject;
		private var tm:SlicedObject;
		private var tr:SlicedObject;
		
		private var ml:SlicedObject;
		private var mm:SlicedObject;
		private var mr:SlicedObject;
		
		private var bl:SlicedObject;
		private var bm:SlicedObject;
		private var br:SlicedObject;
		
		private var slicesType:int = TextureUtil.SLICE_TYPE_NONE;
		
		private var width:Number = 0.0;
		private var height:Number = 0.0;
		
		public var keepOriginalSize:Boolean = false;
		
		private var _hAlign:uint = UIUtils.ALIGN_HORIZONTAL_CENTER;
		private var _vAlign:uint = UIUtils.ALIGN_VERTICAL_CENTER;
		
		public var uvOffsetX:Number = 0.0;
		public var uvOffsetY:Number = 0.0;
		public var uvScaleX:Number = 1.0;
		public var uvScaleY:Number = 1.0;
		
		public function UIImageComponent(texture:Texture2D) 
		{
			this.texture = texture;
		}
		
		/* INTERFACE de.nulldesign.nd2dx.components.ui.IUIUpdatable */
		
		public function updateUISize():void 
		{
			if ( !node || !node.uiComponent ) return;
			
			var paddingLeft:Number = 0.0;// node.uiComponent.paddingLeft;
			var paddingRight:Number = 0.0;// node.uiComponent.paddingRight;
			var paddingTop:Number = 0.0;// node.uiComponent.paddingTop;
			var paddingBottom:Number = 0.0;// node.uiComponent.paddingBottom;
			var uiWidth:Number = node.uiComponent.uiWidth - paddingLeft - paddingRight;
			var uiHeight:Number = node.uiComponent.uiHeight - paddingTop - paddingBottom;
			
			if ( slicesType == TextureUtil.SLICE_TYPE_1 || keepOriginalSize )
			{
				if ( keepOriginalSize )
				{
					tl.scaleX = 1.0;
					tl.scaleY = 1.0;
				}
				else
				{
					tl.width = uiWidth;
					tl.height = uiHeight;
				}
				
				tl.x = paddingLeft + tl.width * 0.5;
				tl.y = paddingTop + tl.height * 0.5;
				
				if ( hAlign == UIUtils.ALIGN_LEFT )
				{
					// do nothing
				}
				else if ( hAlign == UIUtils.ALIGN_HORIZONTAL_CENTER )
				{
					tl.x += (uiWidth - tl.width) * 0.5;
				}
				else if ( hAlign == UIUtils.ALIGN_RIGHT )
				{
					tl.x += uiWidth - tl.width;
				}
				
				if ( vAlign == UIUtils.ALIGN_TOP )
				{
					// do nothing
				}
				else if ( vAlign == UIUtils.ALIGN_VERTICAL_CENTER )
				{
					tl.y += (uiHeight - tl.height) * 0.5;
				}
				else if ( vAlign == UIUtils.ALIGN_BOTTOM )
				{
					tl.y += uiHeight - tl.height;
				}
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_3_HORIZONTAL )
			{
				
				tl.height = tm.height = tr.height = uiHeight;
				
				tl.scaleX = 1.0;
				tr.scaleX = 1.0;
				
				tm.width = uiWidth - tl.texture.bitmapWidth - tr.texture.bitmapWidth;
				
				// top left positionning
				tl.x = paddingLeft + tl.width * 0.5;
				tl.y = paddingTop + tl.height * 0.5;
				tm.x = paddingLeft + tl.width + tm.width * 0.5;
				tm.y = paddingTop + tm.height * 0.5;
				tr.x = tm.x + ((tm.width + tr.width) * 0.5);
				tr.y = paddingTop + tr.height * 0.5;
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_3_VERTICAL )
			{
				// top left positionning
				tl.width = ml.width = bl.width = uiWidth;
				
				tl.scaleY = bl.scaleY = 1.0;
				
				ml.height = uiHeight - tl.height - bl.height;
				
				tl.x = paddingLeft + tl.width * 0.5;
				tl.y = paddingTop + tl.height * 0.5;
				ml.x = tl.x
				ml.y = paddingTop + tl.height + ml.height * 0.5;
				bl.x = tl.x
				bl.y = ml.y + (ml.height + bl.height) * 0.5;
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_9 )
			{
				// top left positionning
				tl.scaleX = tl.scaleY = 1.0;
				tr.scaleX = tr.scaleY = 1.0;
				tm.scaleY = 1.0;
				bm.scaleY = 1.0
				ml.scaleX = 1.0;
				mr.scaleX = 1.0;
				bl.scaleX = bl.scaleY = 1.0;
				br.scaleX = br.scaleY = 1.0;
				
				tm.width = mm.width = bm.width = uiWidth - ml.width - mr.width;
				ml.height = mm.height = mr.height = uiHeight - tm.height - bm.height;
				
				tl.x = paddingLeft + tl.width * 0.5;
				tl.y = paddingTop + tl.height * 0.5;
				
				tm.x = paddingLeft + tl.width + tm.width * 0.5;
				tm.y = tl.y;
				
				tr.x = paddingLeft + tl.width + tm.width + tr.width * 0.5;
				tr.y = tl.y;
				
				ml.x = tl.x;
				ml.y = paddingTop + tl.height + ml.height * 0.5;
				
				mm.x = tm.x;
				mm.y = ml.y;
				
				mr.x = tr.x;
				mr.y = ml.y;
				
				bl.x = tl.x;
				bl.y = paddingTop + tl.height + ml.height + bl.height * 0.5;
				
				bm.x = tm.x;
				bm.y = bl.y;
				
				br.x = tr.x;
				br.y = bl.y;
			}
		}
		
		override public function draw(renderer:RendererBase):void 
		{
			if ( !_texture ) return;
			
			if ( slicesType == TextureUtil.SLICE_TYPE_1 || keepOriginalSize )
			{
				if ( keepOriginalSize )
				{
					renderer.drawTexturedQuad(_texture, true, node, null, tl.x, tl.y, 0.0, tl.scaleX, tl.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				}
				else
				{
					renderer.drawTexturedQuad(tl.texture, true, node, null, tl.x, tl.y, 0.0, tl.scaleX, tl.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				}
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_3_HORIZONTAL )
			{
				renderer.drawTexturedQuad(tl.texture, true, node, null, tl.x, tl.y, 0.0, tl.scaleX, tl.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(tm.texture, true, node, null, tm.x, tm.y, 0.0, tm.scaleX, tm.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(tr.texture, true, node, null, tr.x, tr.y, 0.0, tr.scaleX, tr.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_3_VERTICAL )
			{
				renderer.drawTexturedQuad(tl.texture, true, node, null, tl.x, tl.y, 0.0, tl.scaleX, tl.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(ml.texture, true, node, null, ml.x, ml.y, 0.0, ml.scaleX, ml.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(bl.texture, true, node, null, bl.x, bl.y, 0.0, bl.scaleX, bl.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_9 )
			{
				renderer.drawTexturedQuad(tl.texture, true, node, null, tl.x, tl.y, 0.0, tl.scaleX, tl.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(tm.texture, true, node, null, tm.x, tm.y, 0.0, tm.scaleX, tm.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(tr.texture, true, node, null, tr.x, tr.y, 0.0, tr.scaleX, tr.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				
				renderer.drawTexturedQuad(ml.texture, true, node, null, ml.x, ml.y, 0.0, ml.scaleX, ml.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(mm.texture, true, node, null, mm.x, mm.y, 0.0, mm.scaleX, mm.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(mr.texture, true, node, null, mr.x, mr.y, 0.0, mr.scaleX, mr.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				
				renderer.drawTexturedQuad(bl.texture, true, node, null, bl.x, bl.y, 0.0, bl.scaleX, bl.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(bm.texture, true, node, null, bm.x, bm.y, 0.0, bm.scaleX, bm.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
				renderer.drawTexturedQuad(br.texture, true, node, null, br.x, br.y, 0.0, br.scaleX, br.scaleY, 1.0, 0.0, 0.0, 0.0, node.combinedTintRed, node.combinedTintGreen, node.combinedTintBlue, node.combinedAlpha, uvOffsetX, uvOffsetY, uvScaleX, uvScaleY, blendModeSrc, blendModeDst);
			}
		}
		
		public function get texture():Texture2D 
		{
			return _texture;
		}
		
		public function set texture(value:Texture2D):void 
		{
			if ( _texture == value ) return;
			
			//if( _texture ) _texture.onSlicesChanged.remove(updateSlices);
			
			_texture = value;
			
			//if ( _texture ) _texture.onSlicesChanged.add(updateSlices);
			
			updateSlices();
		}
		
		public function get hAlign():uint 
		{
			return _hAlign;
		}
		
		public function set hAlign(value:uint):void 
		{
			if ( _hAlign == value ) return;
			_hAlign = value;
			updateUISize();
		}
		
		public function get vAlign():uint 
		{
			return _vAlign;
		}
		
		public function set vAlign(value:uint):void 
		{
			if ( _vAlign == value ) return;
			_vAlign = value;
			updateUISize();
		}
		
		public function updateSlices():void
		{
			if ( !_texture ) return;
			
			slicesType = TextureUtil.getSlicesType(_texture);
			
			width = 0.0;
			height = 0.0;
			
			if ( slicesType == TextureUtil.SLICE_TYPE_3_HORIZONTAL )
			{
				tl = prepareSlice(tl, TextureUtil.getSlice(_texture, "3h_tl"));
				tm = prepareSlice(tm, TextureUtil.getSlice(_texture, "3h_tm"));
				tr = prepareSlice(tr, TextureUtil.getSlice(_texture, "3h_tr"));
				
				width = tl.texture.bitmapWidth + tm.texture.bitmapWidth + tr.texture.bitmapWidth;
				height = tl.texture.bitmapHeight;
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_3_VERTICAL )
			{
				tl = prepareSlice(tl, TextureUtil.getSlice(_texture, "3v_tl"));
				ml = prepareSlice(tm, TextureUtil.getSlice(_texture, "3v_ml"));
				bl = prepareSlice(tr, TextureUtil.getSlice(_texture, "3v_bl"));
				
				width = tl.texture.bitmapWidth;
				height = tl.texture.bitmapHeight + ml.texture.bitmapHeight + bl.texture.bitmapHeight;
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_9 )
			{
				tl = prepareSlice(tl, TextureUtil.getSlice(_texture, "9_tl"));
				tm = prepareSlice(tm, TextureUtil.getSlice(_texture, "9_tm"));
				tr = prepareSlice(tr, TextureUtil.getSlice(_texture, "9_tr"));
				
				ml = prepareSlice(ml, TextureUtil.getSlice(_texture, "9_ml"));
				mm = prepareSlice(mm, TextureUtil.getSlice(_texture, "9_mm"));
				mr = prepareSlice(mr, TextureUtil.getSlice(_texture, "9_mr"));
				
				bl = prepareSlice(bl, TextureUtil.getSlice(_texture, "9_bl"));
				bm = prepareSlice(bm, TextureUtil.getSlice(_texture, "9_bm"));
				br = prepareSlice(br, TextureUtil.getSlice(_texture, "9_br"));
				
				width = tl.texture.bitmapWidth + tm.texture.bitmapWidth + tr.texture.bitmapWidth;
				height = tl.texture.bitmapHeight + ml.texture.bitmapHeight + bl.texture.bitmapHeight;
			}
			else if ( slicesType == TextureUtil.SLICE_TYPE_1 )
			{
				tl = prepareSlice(tl, _texture);
				
				width = tl.texture.bitmapWidth;
				height = tl.texture.bitmapHeight;
			}
			else
			{
				width = 0.0;
				height = 0.0;
			}
		}
		
		private function prepareSlice(slicedObject:SlicedObject, texture:Texture2D):SlicedObject
		{
			if ( !slicedObject ) slicedObject = new SlicedObject();
			
			slicedObject.texture = texture;
			slicedObject.name = TextureUtil.getSliceType(texture.id);
			
			return slicedObject;
		}
		
	}
}

import de.nulldesign.nd2dx.resource.texture.Texture2D;

class SlicedObject
{
	public var texture:Texture2D;
	public var name:String;
	public var x:Number;
	public var y:Number;
	public var scaleX:Number;
	public var scaleY:Number;
	public var pivotX:Number;
	public var pivotY:Number;
	
	public function SlicedObject()
	{
		
	}
	
	public function get width():Number 
	{
		return texture.bitmapWidth * scaleX;
	}
	
	public function set width(value:Number):void 
	{
		scaleX = value / texture.bitmapWidth;
	}
	
	public function get height():Number 
	{
		return texture.bitmapHeight * scaleY;
	}
	
	public function set height(value:Number):void 
	{
		scaleY = value / texture.bitmapHeight;
	}
}