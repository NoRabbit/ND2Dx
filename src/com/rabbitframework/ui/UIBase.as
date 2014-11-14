package com.rabbitframework.ui 
{
	import com.rabbitframework.managers.events.EventsManager;
	import com.rabbitframework.ui.dataprovider.DataProviderManager;
	import com.rabbitframework.utils.IDroppableOn;
	import com.rabbitframework.utils.StringUtils;
	import flash.display.Sprite;
	import com.rabbitframework.utils.IDisposable;
	import com.rabbitframework.utils.IPoolable;
	import wgmeditor.managers.draganddrop.DragAndDropManager;
	import wgmeditor.managers.draganddrop.DragAndDropObject;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIBase extends Sprite implements IPoolable, IDroppableOn
	{
		protected var eManager:EventsManager = EventsManager.getInstance();
		protected var eGroup:String = "";
		
		protected var dataProviderManager:DataProviderManager = DataProviderManager.getInstance();
		protected var dragAndDropManager:DragAndDropManager = DragAndDropManager.getInstance();
		
		protected var _enabled:Boolean = true;
		protected var _isDroppableOn:Boolean = false;
		protected var _acceptedDroppableTypes:Array = null;
		protected var _uiParent:UIContainerBase;
		
		public var minUIWidth:Number = 1.0;
		public var minUIHeight:Number = 1.0;
		
		public var uiWidth:Number = 0.0;
		public var uiHeight:Number = 0.0;
		
		public var uiWidthPrct:Number = NaN;
		public var uiHeightPrct:Number = NaN;
		
		protected var _dataSource:Object;
		
		public function UIBase() 
		{
			eGroup = eManager.getUniqueGroupId();
			init();
		}
		
		public function init():void
		{
			
		}
		
		public function setSize(width:Object = null, height:Object = null, forceSize:Boolean = false):UIBase
		{
			var widthToSet:Number = uiWidth;
			var heightToSet:Number = uiHeight;
			
			if( width is Number ) widthToSet = width as Number;
			if( height is Number ) heightToSet = height as Number;
			
			if ( !forceSize && widthToSet < minUIWidth ) widthToSet = minUIWidth;
			if ( !forceSize && heightToSet < minUIHeight ) heightToSet = minUIHeight;
			
			if ( widthToSet != uiWidth || heightToSet != uiHeight )
			{
				uiWidth = widthToSet;
				uiHeight = heightToSet;
				draw();
			}
			
			var drawParent:Boolean = false;
			
			if ( width is String )
			{
				uiWidthPrct = Number(StringUtils.getBefore(width as String, "%", true));
				drawParent = true;
			}
			else
			{
				//uiWidthPrct = NaN;
			}
			
			if ( height is String )
			{
				uiHeightPrct = Number(StringUtils.getBefore(height as String, "%", true));
				drawParent = true;
			}
			else
			{
				//uiHeightPrct = NaN;
			}
			
			if ( uiParent && drawParent ) uiParent.draw();
			
			return this;
		}
		
		public function setSizeInPercent(width:Number = NaN, height:Number = NaN):UIBase
		{
			uiWidthPrct = width;
			uiHeightPrct = height;
			
			if ( uiParent ) uiParent.draw();
			
			return this;
		}
		
		public function unsetSizeInPercent():UIBase
		{
			return setSizeInPercent();
		}
		
		public function draw():void
		{
			
		}
		
		/* INTERFACE com.rabbitframework.utils.IPoolable */
		
		public function initFromPool():void 
		{
			init();
		}
		
		public function disposeForPool():void 
		{
			eManager.removeAllFromGroup(eGroup);
			if ( parent ) parent.removeChild(this);
			uiParent = null;
			uiWidthPrct = NaN;
			uiHeightPrct = NaN;
			uiWidth = minUIWidth;
			uiHeight = minUIHeight;
		}
		
		public function dispose():void 
		{
			eManager.removeAllFromGroup(eGroup);
			eManager.releaseGroupId(eGroup);
			if ( parent ) parent.removeChild(this);
			uiParent = null;
		}
		
		/* INTERFACE com.rabbitframework.utils.IDroppableOn */
		
		public function get isDroppableOn():Boolean 
		{
			return _isDroppableOn;
		}
		
		public function set isDroppableOn(value:Boolean):void 
		{
			_isDroppableOn = value;
		}
		
		public function get acceptedDroppableTypes():Array 
		{
			return _acceptedDroppableTypes;
		}
		
		public function set acceptedDroppableTypes(value:Array):void 
		{
			_acceptedDroppableTypes = value;
		}
		
		public function onDrop(dragAndDropObject:DragAndDropObject):void 
		{
			
		}
		
		public function onDropOver(dragAndDropObject:DragAndDropObject):void 
		{
			
		}
		
		public function onDropOut(dragAndDropObject:DragAndDropObject):void 
		{
			
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		public function get dataSource():Object 
		{
			return _dataSource;
		}
		
		public function set dataSource(value:Object):void 
		{
			_dataSource = value;
		}
		
		public function get uiParent():UIContainerBase 
		{
			return _uiParent;
		}
		
		public function set uiParent(value:UIContainerBase):void 
		{
			_uiParent = value;
		}
		
	}

}