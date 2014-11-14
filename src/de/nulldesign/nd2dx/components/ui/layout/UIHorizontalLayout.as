package de.nulldesign.nd2dx.components.ui.layout 
{
	import de.nulldesign.nd2dx.components.ui.UIComponent;
	import de.nulldesign.nd2dx.display.Node2D;
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
		
		override public function positionChildren(node:Node2D, itemSpace:Number = 0.0, roundPositionValues:Boolean = false):void 
		{
			var uiComponent:UIComponent = node.uiComponent;
			var highestHeight:Number = uiComponent.uiHeight - uiComponent.paddingTop - uiComponent.paddingBottom;
			var currentPositionX:Number = uiComponent.paddingLeft;
			var currentPositionY:Number = uiComponent.paddingTop;
			var remainingSize:Number = uiComponent.uiWidth - (node.numChildren > 0 ? (node.numChildren - 1) * itemSpace : 0.0) - uiComponent.paddingLeft - uiComponent.paddingRight;
			var totalFixedSizes:Number = 0.0;
			var totalPercentSizes:Number = 0.0;
			
			var child:Node2D;
			var childUIComponent:UIComponent;
			
			// first pass to get total fixed sizes and total percent sizes separately
			for (child = node.childFirst; child; child = child.next)
			{
				childUIComponent = child.uiComponent;
				
				if ( childUIComponent )
				{
					if ( childUIComponent.uiWidthPrct < 0.0 )
					{
						// fixed size
						totalFixedSizes += childUIComponent.uiWidth;
					}
					else
					{
						// percent size
						totalPercentSizes += childUIComponent.uiWidthPrct;
					}
					
					totalFixedSizes += childUIComponent.marginLeft + childUIComponent.marginRight;
				}
			}
			
			remainingSize -= totalFixedSizes;
			
			// second pass to set sizes
			var widthToSet:Number = 0.0;
			var heightToSet:Number = 0.0;
			
			for (child = node.childFirst; child; child = child.next)
			{
				childUIComponent = child.uiComponent;
				
				if ( childUIComponent )
				{
					child.x = currentPositionX + childUIComponent.marginLeft;
					child.y = currentPositionY + childUIComponent.marginTop;
					
					if ( roundPositionValues )
					{
						child.x = Math.round(child.x);
						child.y = Math.round(child.y);
					}
					
					// width
					if ( childUIComponent.uiWidthPrct < 0.0 )
					{
						// fixed size
						widthToSet = childUIComponent.uiWidth;
					}
					else
					{
						// percent size
						widthToSet = (remainingSize / totalPercentSizes) * childUIComponent.uiWidthPrct;
					}
					
					// height
					if ( childUIComponent.uiHeightPrct < 0.0 )
					{
						// fixed size
						heightToSet = childUIComponent.uiHeight;
					}
					else
					{
						// percent size
						heightToSet = (uiComponent.uiHeight - uiComponent.paddingTop - uiComponent.paddingBottom) * childUIComponent.uiHeightPrct * 0.01;
					}
					
					// check if size is not too small
					if ( widthToSet < childUIComponent.minUIWidth ) widthToSet = childUIComponent.minUIWidth;
					if ( heightToSet < childUIComponent.minUIHeight ) heightToSet = childUIComponent.minUIHeight;
					
					// check height
					if ( heightToSet > highestHeight ) highestHeight = heightToSet;
					
					// set item size
					childUIComponent.setUISize(widthToSet, heightToSet, true);
					
					currentPositionX += childUIComponent.uiWidth + itemSpace + childUIComponent.marginLeft + childUIComponent.marginRight;
				}
			}
			
			// set uiContainerNode2D final size
			var finalUIWidht:Number = currentPositionX - itemSpace + uiComponent.paddingRight;
			var finalUIHeight:Number = currentPositionY + highestHeight + uiComponent.paddingBottom;
			
			if ( finalUIWidht > uiComponent.uiWidth ) uiComponent.uiWidth = finalUIWidht;
			if ( finalUIHeight > uiComponent.uiHeight ) uiComponent.uiHeight = finalUIHeight;
			if ( uiComponent.uiWidth < uiComponent.minUIWidth ) uiComponent.uiWidth = uiComponent.minUIWidth;
			if ( uiComponent.uiHeight < uiComponent.minUIHeight ) uiComponent.uiHeight = uiComponent.minUIHeight;
		}
	}

}