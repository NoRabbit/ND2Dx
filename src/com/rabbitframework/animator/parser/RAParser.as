package com.rabbitframework.animator.parser 
{
	import com.rabbitframework.animator.managers.AnimatorManager;
	import com.rabbitframework.animator.nodes.RAObjectNode;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RAParser 
	{
		public var animatorManager:AnimatorManager = AnimatorManager.getInstance();
		
		public var targetClass:Class;
		
		public var vProperties:Vector.<RAParserProperty> = new Vector.<RAParserProperty>();
		
		public function RAParser() 
		{
			
		}
		
		public function createObjectNodeForTarget(target:Object):RAObjectNode
		{
			return null;
		}
	}

}