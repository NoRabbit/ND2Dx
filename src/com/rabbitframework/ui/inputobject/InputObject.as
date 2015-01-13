package com.rabbitframework.ui.inputobject 
{
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.utils.DragAndDropUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import com.rabbitframework.managers.draganddrop.DragAndDropObject;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class InputObject extends UIBase
	{
		public var bg:Sprite;
		public var txt:TextField;
		
		public function InputObject(value:Object = null, acceptedDroppableTypes:Array = null) 
		{
			dataSource = value;
			this.acceptedDroppableTypes = acceptedDroppableTypes;
			isDroppableOn = true;
		}
		
		override public function init():void 
		{
			super.init();
			
			minUIWidth = 20.0;
			minUIHeight = 20.0;
			
			txt.text = "";
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			txt.width = uiWidth - 20;
			txt.x = 2;
			txt.y = Math.round((uiHeight - txt.height) * 0.5) + 1;
		}
		
		override public function onDropOver(dragAndDropObject:DragAndDropObject):void 
		{
			//trace("onDropOver", dragAndDropObject.initiator, dragAndDropObject.object, DragAndDropUtils.isObjectOfAcceptedDroppableTypes(dragAndDropObject.object, _acceptedDroppableTypes));
			
			if ( DragAndDropUtils.isObjectOfAcceptedDroppableTypes(dragAndDropObject.object, _acceptedDroppableTypes) )
			{
				this.filters = [new GlowFilter(0x43E95B, 1.0, 2.0, 2.0, 2, 3, true)];
			}
			else
			{
				this.filters = [new GlowFilter(0xEC4040, 1.0, 2.0, 2.0, 2, 3, true)];
			}
		}
		
		override public function onDropOut(dragAndDropObject:DragAndDropObject):void 
		{
			this.filters = [];
		}
		
		override public function onDrop(dragAndDropObject:DragAndDropObject):void 
		{
			dataSource = dragAndDropObject.object;
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			if ( !DragAndDropUtils.isObjectOfAcceptedDroppableTypes(value, _acceptedDroppableTypes) ) return;
			
			super.dataSource = value;
			txt.text = dataProviderManager.getDataSourceLabel(_dataSource);
			onChange.dispatchData(value);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			txt.text = "";
		}
		
		override public function dispose():void 
		{
			super.dispose();
			bg = null;
			txt = null;
		}
	}

}