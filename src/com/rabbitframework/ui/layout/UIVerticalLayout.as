package com.rabbitframework.ui.layout 
{
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainer;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIVerticalLayout extends UILayoutBase
	{
		public static var reference:UIVerticalLayout = new UIVerticalLayout();
		
		public function UIVerticalLayout() 
		{
			
		}
		
		override public function positionItems(uiContainer:UIContainer):void 
		{
			//trace(this, "positionItems", uiContainer, uiContainer.name, uiContainer.vItems.length);
			
			var vItems:Vector.<UIBase> = uiContainer.vItems;
			var i:int = 0;
			var n:int = vItems.length;
			var item:UIBase;
			var highestWidth:Number = uiContainer.uiWidth - uiContainer.paddingLeft - uiContainer.paddingRight;
			var currentPositionX:Number = uiContainer.paddingLeft;
			var currentPositionY:Number = uiContainer.paddingTop;
			var remainingSize:Number = uiContainer.uiHeight - (vItems.length > 0 ? (vItems.length - 1) * uiContainer.itemSpace : 0.0) - uiContainer.paddingTop - uiContainer.paddingBottom;
			var totalFixedSizes:Number = 0.0;
			var totalPercentSizes:Number = 0.0;
			
			// first pass to get total fixed sizes and total percent sizes separately
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				if ( item.uiHeightPrct < 0.0 )
				{
					// fixed size
					totalFixedSizes += item.uiHeight;
				}
				else
				{
					// percent size
					totalPercentSizes += item.uiHeightPrct;
				}
				
				totalFixedSizes += item._marginTop + item._marginBottom;
			}
			
			remainingSize -= totalFixedSizes;
			
			// second pass to set sizes and check highest width
			var widthToSet:Number = 0.0;
			var heightToSet:Number = 0.0;
			
			i = 0;
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				item.x = currentPositionX + item._marginLeft;
				item.y = currentPositionY + item._marginTop;
				
				if ( uiContainer.roundPositionValues )
				{
					item.x = Math.round(item.x);
					item.y = Math.round(item.y);
				}
				
				// width
				if ( item.uiWidthPrct < 0.0 )
				{
					// fixed size
					widthToSet = item.uiWidth;
				}
				else
				{
					// percent size
					widthToSet = (uiContainer.uiWidth - uiContainer.paddingLeft - uiContainer.paddingRight) * item.uiWidthPrct * 0.01;
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
					heightToSet = (remainingSize / totalPercentSizes) * item.uiHeightPrct;
				}
				
				// check if size is not too small
				if ( widthToSet < item.minUIWidth ) widthToSet = item.minUIWidth;
				if ( heightToSet < item.minUIHeight ) heightToSet = item.minUIHeight;
				
				currentPositionY += heightToSet + uiContainer.itemSpace + item._marginTop + item._marginBottom;
				
				// check width
				if ( widthToSet > highestWidth ) highestWidth = widthToSet;
				
				//trace(this, "setting size of item", i, item, item.x, item.y, widthToSet, heightToSet, currentPositionY);
				
				// set item size
				item.setSize(widthToSet, heightToSet, true);// , uiContainer.forceSize);
			}
			
			// set uiContainer final size
			var finalUIWidht:Number = currentPositionX + highestWidth + uiContainer.paddingRight;
			var finalUIHeight:Number = currentPositionY - uiContainer.itemSpace + uiContainer.paddingBottom;
			
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