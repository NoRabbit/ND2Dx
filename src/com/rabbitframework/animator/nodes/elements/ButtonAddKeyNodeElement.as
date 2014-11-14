package com.rabbitframework.animator.nodes.elements 
{
	import com.rabbitframework.animator.style.RAStyle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class ButtonAddKeyNodeElement extends NodeElementSprite
	{
		public function ButtonAddKeyNodeElement() 
		{
			mouseEnabled = buttonMode = useHandCursor = true;
		}
		
		override public function setPositionAndGetNextPosition(x:Number):Number 
		{
			this.x = RAStyle.element_space_left - 2.0 + x + 8.0;
			return this.x + 8.0 + RAStyle.element_space_right;
		}
	}

}