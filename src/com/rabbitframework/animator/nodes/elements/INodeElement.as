package com.rabbitframework.animator.nodes.elements 
{
	import flash.display.DisplayObject;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public interface INodeElement
	{
		function set elementWidth(value:Number):void;
		function get elementWidth():Number;
		
		function set fixed(value:Boolean):void;
		function get fixed():Boolean;
	}
	
}