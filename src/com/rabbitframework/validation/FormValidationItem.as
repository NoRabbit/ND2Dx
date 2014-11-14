package com.rabbitframework.validation 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class FormValidationItem 
	{
		public var object:Object = null;
		public var checkTypes:Array = new Array();
		public var highlightFormObjects:Array = new Array();
		public var checkOptions:Array = new Array();
		public var resultsIfTrue:Array = new Array();
		public var resultsIfFalse:Array = new Array();
		public var checkResult:Boolean = false;
		
		public function FormValidationItem() 
		{
			
		}
		
	}

}