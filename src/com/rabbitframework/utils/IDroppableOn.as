package com.rabbitframework.utils 
{
	import wgmeditor.managers.draganddrop.DragAndDropObject;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public interface IDroppableOn 
	{
		function get isDroppableOn():Boolean;
		function set isDroppableOn(value:Boolean):void;
		
		function get acceptedDroppableTypes():Array;
		function set acceptedDroppableTypes(aTypes:Array):void;
		
		function onDropOver(dragAndDropObject:DragAndDropObject):void
		function onDropOut(dragAndDropObject:DragAndDropObject):void
		function onDrop(dragAndDropObject:DragAndDropObject):void
	}
	
}