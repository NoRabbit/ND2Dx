package com.rabbitframework.animator.panels 
{
	import com.rabbitframework.animator.nodes.RANode;
	import com.rabbitframework.animator.style.RAStyle;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAPanel extends RANode
	{
		
		public function RAPanel() 
		{
			expanded = true;
			nodeX = -RAStyle.NODE_CHILD_OFFSET_X;
			nodeHeight = 0.0;
		}
		
	}

}