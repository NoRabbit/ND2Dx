package com.rabbitframework.ui.groups 
{
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainerBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Group extends UIContainerBase
	{
		protected var _forceSize:Boolean = false;
		protected var _spaceSize:Number = 8.0;
		protected var _extendOppositeSizeToMaximum:Boolean = true;
		protected var _isHorizontal:Boolean = false;
		
		protected var _paddingTop:Number = 0.0;
		protected var _paddingBottom:Number = 0.0;
		protected var _paddingRight:Number = 0.0;
		protected var _paddingLeft:Number = 0.0;
		
		protected var _hideChildren:Boolean = false;
		
		protected var _extendUIWidthToTotalItemsWidth:Boolean = true;
		protected var _extendUIHeightToTotalItemsHeight:Boolean = true;
		
		public function Group() 
		{
			
		}
		
		override public function draw():void 
		{
			var i:int = 0;
			var n:int = vItems.length;
			
			for (; i < n; i++) 
			{
				if ( _hideChildren )
				{
					vItems[i].visible = false;
				}
				else
				{
					vItems[i].visible = true;
				}
			}
			
			if ( !_hideChildren )
			{
				if ( _isHorizontal )
				{
					drawHGroup(this);
				}
				else
				{
					drawVGroup(this);
				}
			}
			
			if ( uiWidth < minUIWidth ) uiWidth = minUIWidth;
			if ( uiHeight < minUIHeight ) uiHeight = minUIHeight;
		}
		
		public static function drawHGroup(group:Group):void
		{
			var vItems:Vector.<UIBase> = group.vItems;
			var i:int = 0;
			var n:int = vItems.length;
			var item:UIBase;
			var highestHeight:Number = group.uiHeight - group.paddingTop - group.paddingBottom;
			var currentPositionX:Number = group.paddingLeft;
			var currentPositionY:Number = group.paddingTop;
			var remainingSize:Number = group.uiWidth - (vItems.length > 0 ? (vItems.length - 1) * group.spaceSize : 0.0) - group.paddingLeft - group.paddingRight;
			var totalFixedSizes:Number = 0.0;
			var totalPercentSizes:Number = 0.0;
			
			// first pass to get total fixed sizes and total percent sizes separately
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				if ( isNaN(item.uiWidthPrct) )
				{
					// fixed size
					totalFixedSizes += item.uiWidth;
				}
				else
				{
					// percent size
					totalPercentSizes += item.uiWidthPrct;
				}
			}
			
			remainingSize -= totalFixedSizes;
			
			// second pass to set sizes and get highest height
			i = 0;
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				item.x = currentPositionX;
				item.y = currentPositionY;
				
				if ( isNaN(item.uiWidthPrct) )
				{
					// fixed size
					item.setSize(item.uiWidth, highestHeight, group.forceSize);
				}
				else
				{
					// percent size
					item.setSize((remainingSize / totalPercentSizes) * item.uiWidthPrct, highestHeight, group.forceSize);
				}
				
				currentPositionX += item.uiWidth + group.spaceSize;
				
				// check height
				if ( item.uiHeight > highestHeight ) highestHeight = item.uiHeight;
			}
			
			if ( group.extendOppositeSizeToMaximum )
			{
				// third pass to set definitive size
				i = 0;
				for (; i < n; i++) 
				{
					item = vItems[i];
					
					item.setSize(item.uiWidth, highestHeight, group.forceSize);
				}
			}
			
			// set this ui object final size
			if ( group.extendUIWidthToTotalItemsWidth ) group.uiWidth = currentPositionX - group.spaceSize + group.paddingRight;
			if ( group.extendUIHeightToTotalItemsHeight )group.uiHeight = currentPositionY + highestHeight + group.paddingBottom;
		}
		
		public static function drawVGroup(group:Group):void
		{
			var vItems:Vector.<UIBase> = group.vItems;
			var i:int = 0;
			var n:int = vItems.length;
			var item:UIBase;
			var highestWidth:Number = group.uiWidth - group.paddingLeft - group.paddingRight;
			var currentPositionX:Number = group.paddingLeft;
			var currentPositionY:Number = group.paddingTop;
			var remainingSize:Number = group.uiHeight - (vItems.length > 0 ? (vItems.length - 1) * group.spaceSize : 0.0) - group.paddingTop - group.paddingBottom;
			var totalFixedSizes:Number = 0.0;
			var totalPercentSizes:Number = 0.0;
			
			// first pass to get total fixed sizes and total percent sizes separately
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				if ( isNaN(item.uiHeightPrct) )
				{
					// fixed size
					totalFixedSizes += item.uiHeight;
				}
				else
				{
					// percent size
					totalPercentSizes += item.uiHeightPrct;
				}
			}
			
			remainingSize -= totalFixedSizes;
			
			// second pass to set sizes and check highest width
			i = 0;
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				item.x = currentPositionX;
				item.y = currentPositionY;
				
				if ( isNaN(item.uiHeightPrct) )
				{
					// fixed size
					item.setSize(highestWidth, item.uiHeight, group.forceSize);
				}
				else
				{
					// percent size
					item.setSize(highestWidth, (remainingSize / totalPercentSizes) * item.uiHeightPrct, group.forceSize);
				}
				
				currentPositionY += item.uiHeight + group.spaceSize;
				
				// check width
				if ( item.uiWidth > highestWidth ) highestWidth = item.uiWidth;
			}
			
			if ( group.extendOppositeSizeToMaximum )
			{
				// third pass to set definitive size
				i = 0;
				for (; i < n; i++) 
				{
					item = vItems[i];
					
					item.setSize(highestWidth, item.uiHeight, group.forceSize);
				}
			}
			
			// set this ui object final size
			if ( group.extendUIWidthToTotalItemsWidth ) group.uiWidth = highestWidth + group.paddingLeft + group.paddingRight;
			if ( group.extendUIHeightToTotalItemsHeight ) group.uiHeight = currentPositionY - group.spaceSize + group.paddingBottom;
		}
		
		public function get isHorizontal():Boolean 
		{
			return _isHorizontal;
		}
		
		public function set isHorizontal(value:Boolean):void 
		{
			if ( _isHorizontal == value ) return;
			_isHorizontal = value;
			draw();
		}
		
		public function get extendOppositeSizeToMaximum():Boolean 
		{
			return _extendOppositeSizeToMaximum;
		}
		
		public function set extendOppositeSizeToMaximum(value:Boolean):void 
		{
			if ( _extendOppositeSizeToMaximum == value ) return;
			_extendOppositeSizeToMaximum = value;
			draw();
		}
		
		public function get spaceSize():Number 
		{
			return _spaceSize;
		}
		
		public function set spaceSize(value:Number):void 
		{
			if ( _spaceSize == value ) return;
			_spaceSize = value;
			draw();
		}
		
		public function get forceSize():Boolean 
		{
			return _forceSize;
		}
		
		public function set forceSize(value:Boolean):void 
		{
			if ( _forceSize == value ) return;
			_forceSize = value;
			draw();
		}
		
		public function get paddingTop():Number 
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void 
		{
			if ( _paddingTop == value ) return;
			_paddingTop = value;
			draw();
		}
		
		public function get paddingBottom():Number 
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void 
		{
			if ( _paddingBottom == value ) return;
			_paddingBottom = value;
			draw();
		}
		
		public function get paddingRight():Number 
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void 
		{
			if ( _paddingRight == value ) return;
			_paddingRight = value;
			draw();
		}
		
		public function get paddingLeft():Number 
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void 
		{
			if ( _paddingLeft == value ) return;
			_paddingLeft = value;
			draw();
		}
		
		public function get hideChildren():Boolean 
		{
			return _hideChildren;
		}
		
		public function set hideChildren(value:Boolean):void 
		{
			if ( _hideChildren == value ) return;
			_hideChildren = value;
			draw();
		}
		
		public function get extendUIWidthToTotalItemsWidth():Boolean 
		{
			return _extendUIWidthToTotalItemsWidth;
		}
		
		public function set extendUIWidthToTotalItemsWidth(value:Boolean):void 
		{
			if ( _extendUIWidthToTotalItemsWidth == value ) return;
			_extendUIWidthToTotalItemsWidth = value;
			draw();
		}
		
		public function get extendUIHeightToTotalItemsHeight():Boolean 
		{
			return _extendUIHeightToTotalItemsHeight;
		}
		
		public function set extendUIHeightToTotalItemsHeight(value:Boolean):void 
		{
			if ( _extendUIHeightToTotalItemsHeight == value ) return;
			_extendUIHeightToTotalItemsHeight = value;
			draw();
		}
	}

}