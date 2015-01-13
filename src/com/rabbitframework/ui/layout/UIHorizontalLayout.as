package com.rabbitframework.ui.layout 
{
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainer;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIHorizontalLayout extends UILayoutBase
	{
		public static var reference:UIHorizontalLayout = new UIHorizontalLayout();
		
		public function UIHorizontalLayout() 
		{
			
		}
		
		override public function positionItems(uiContainer:UIContainer):void 
		{
			//trace(this, "positionItems", uiContainer, uiContainer.name, uiContainer.vItems.length);
			
			var vItems:Vector.<UIBase> = uiContainer.vItems;
			
			var i:int = 0;
			var n:int = vItems.length;
			
			var item:UIBase;
			var highestHeight:Number = uiContainer.uiHeight - uiContainer.paddingTop - uiContainer.paddingBottom;
			var currentPositionX:Number = uiContainer.paddingLeft;
			var currentPositionY:Number = uiContainer.paddingTop;
			var remainingSize:Number = uiContainer.uiWidth - (vItems.length > 0 ? (vItems.length - 1) * uiContainer.itemSpace : 0.0) - uiContainer.paddingLeft - uiContainer.paddingRight;
			var totalFixedSizes:Number = 0.0;
			var totalPercentSizes:Number = 0.0;
			
			// first pass to get total fixed sizes and total percent sizes separately
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				if ( item.uiWidthPrct < 0.0 )
				{
					// fixed size
					totalFixedSizes += item.uiWidth;
				}
				else
				{
					// percent size
					totalPercentSizes += item.uiWidthPrct;
				}
				
				totalFixedSizes += item._marginLeft + item._marginRight;
			}
			
			remainingSize -= totalFixedSizes;
			
			// second pass to set sizes and position
			var widthToSet:Number = 0.0;
			var heightToSet:Number = 0.0;
			var remainingSpaceForAlign:Number = 0.0;
			
			i = 0;
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				// width
				if ( item.uiWidthPrct < 0.0 )
				{
					// fixed size
					widthToSet = item.uiWidth;
				}
				else
				{
					// percent size
					widthToSet = (remainingSize / totalPercentSizes) * item.uiWidthPrct;
				}
				
				// height
				if ( item.uiHeightPrct < 0.0 )
				{
					// fixed size
					heightToSet = item.uiHeight;
				}
				else
				{
					// percent size
					heightToSet = (uiContainer.uiHeight - uiContainer.paddingTop - uiContainer.paddingBottom) * item.uiHeightPrct * 0.01;
				}
				
				// check if size is not too small
				if ( widthToSet < item.minUIWidth ) widthToSet = item.minUIWidth;
				if ( heightToSet < item.minUIHeight ) heightToSet = item.minUIHeight;
				
				// check height
				if ( heightToSet > highestHeight ) highestHeight = heightToSet;
				
				//trace(this, "setting size of item", i, item, item.x, item.y, item.uiWidth, item.uiHeight, item.uiWidthPrct, item.uiHeightPrct, widthToSet, heightToSet, currentPositionX);
				
				// set item size
				item.setSize(widthToSet, heightToSet, true);// , uiContainer.forceSize);
				
				// set item position based on container alignment
				if ( uiContainer._verticalAlign == UIBase.VERTICAL_ALIGN_MIDDLE )
				{
					remainingSpaceForAlign = (uiContainer.uiHeight - uiContainer.paddingTop - uiContainer.paddingBottom) - heightToSet - item._marginTop - item._marginBottom;
					remainingSpaceForAlign *= 0.5;
				}
				else if ( uiContainer._verticalAlign == UIBase.VERTICAL_ALIGN_BOTTOM )
				{
					remainingSpaceForAlign = (uiContainer.uiHeight - uiContainer.paddingTop - uiContainer.paddingBottom) - heightToSet - item._marginTop - item._marginBottom;
				}
				
				
				item.x = currentPositionX + item._marginLeft;
				item.y = currentPositionY + item._marginTop + remainingSpaceForAlign;
				
				if ( uiContainer.roundPositionValues )
				{
					item.x = Math.round(item.x);
					item.y = Math.round(item.y);
				}
				
				// set next position
				currentPositionX += widthToSet + uiContainer.itemSpace + item._marginLeft + item._marginRight;
			}
			
			// set uiContainer final size
			var finalUIWidht:Number = currentPositionX - uiContainer.itemSpace + uiContainer.paddingRight;
			var finalUIHeight:Number = currentPositionY + highestHeight + uiContainer.paddingBottom;
			
			if ( uiContainer.extendUIWidthToTotalItemsWidth ) 
			{
				if ( finalUIWidht > uiContainer.uiWidth ) uiContainer.uiWidth = finalUIWidht;
				if ( uiContainer.uiWidth < uiContainer.minUIWidth ) uiContainer.uiWidth = uiContainer.minUIWidth;
			}
			
			if ( uiContainer.extendUIHeightToTotalItemsHeight ) 
			{
				if ( finalUIHeight > uiContainer.uiHeight ) uiContainer.uiHeight = finalUIHeight;
				if ( uiContainer.uiHeight < uiContainer.minUIHeight ) uiContainer.uiHeight = uiContainer.minUIHeight;
			}
		}
	}

}