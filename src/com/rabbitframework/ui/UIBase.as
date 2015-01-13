package com.rabbitframework.ui 
{
	import com.rabbitframework.managers.events.EventsManager;
	import com.rabbitframework.managers.pool.PoolManager;
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.dataprovider.DataProviderManager;
	import com.rabbitframework.utils.IDroppableOn;
	import com.rabbitframework.utils.StringUtils;
	import flash.display.Sprite;
	import com.rabbitframework.utils.IDisposable;
	import com.rabbitframework.utils.IPoolable;
	import com.rabbitframework.managers.draganddrop.DragAndDropManager;
	import com.rabbitframework.managers.draganddrop.DragAndDropObject;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIBase extends Sprite implements IPoolable, IDroppableOn
	{
		public static const HORIZONTAL_ALIGN_LEFT:String = "HORIZONTAL_ALIGN_LEFT";
		public static const HORIZONTAL_ALIGN_CENTER:String = "HORIZONTAL_ALIGN_CENTER";
		public static const HORIZONTAL_ALIGN_RIGHT:String = "HORIZONTAL_ALIGN_RIGHT";
		
		public static const VERTICAL_ALIGN_TOP:String = "VERTICAL_ALIGN_TOP";
		public static const VERTICAL_ALIGN_MIDDLE:String = "VERTICAL_ALIGN_MIDDLE";
		public static const VERTICAL_ALIGN_BOTTOM:String = "VERTICAL_ALIGN_BOTTOM";
		
		protected var eManager:EventsManager = EventsManager.getInstance();
		protected var eGroup:String = "";
		
		protected var poolManager:PoolManager = PoolManager.getInstance();
		protected var dataProviderManager:DataProviderManager = DataProviderManager.getInstance();
		protected var dragAndDropManager:DragAndDropManager = DragAndDropManager.getInstance();
		
		protected var _enabled:Boolean = true;
		protected var _isDroppableOn:Boolean = false;
		protected var _acceptedDroppableTypes:Array = null;
		protected var _uiParent:UIContainer;
		
		public var minUIWidth:Number = 1.0;
		public var minUIHeight:Number = 1.0;
		
		public var uiWidth:Number = 0.0;
		public var uiHeight:Number = 0.0;
		
		public var uiWidthPrct:Number = -1;
		public var uiHeightPrct:Number = -1;
		
		private var _padding:Number = 0.0;
		public var _paddingTop:Number = 0.0;
		public var _paddingRight:Number = 0.0;
		public var _paddingBottom:Number = 0.0;
		public var _paddingLeft:Number = 0.0;
		
		private var _margin:Number = 0.0;
		public var _marginTop:Number = 0.0;
		public var _marginRight:Number = 0.0;
		public var _marginBottom:Number = 0.0;
		public var _marginLeft:Number = 0.0;
		
		public var _horizontalAlign:String = HORIZONTAL_ALIGN_LEFT;
		public var _verticalAlign:String = VERTICAL_ALIGN_TOP;
		
		protected var _dataSource:Object;
		
		public var onChange:Signal = new Signal();
		public var onChangeStart:Signal = new Signal();
		public var onChangeComplete:Signal = new Signal();
		public var onChangeCancel:Signal = new Signal();
		public var onDragAndDrop:Signal = new Signal();
		
		public function UIBase() 
		{
			eGroup = eManager.getUniqueGroupId();
			init();
		}
		
		public function init():void
		{
			_paddingTop = 0.0;
			_paddingRight = 0.0;
			_paddingBottom = 0.0;
			_paddingLeft = 0.0;
			
			_marginTop = 0.0;
			_marginRight = 0.0;
			_marginBottom = 0.0;
			_marginLeft = 0.0;
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
		
		public function setSizeInPercent(width:Number = -1, height:Number = -1):UIBase
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
			//trace(this, "DISPOSE FOR POOL", eGroup);
			
			eManager.removeAllFromGroup(eGroup);
			
			if ( parent ) parent.removeChild(this);
			
			uiParent = null;
			uiWidthPrct = -1;
			uiHeightPrct = -1;
			uiWidth = minUIWidth;
			uiHeight = minUIHeight;
			
			_padding = 0.0;
			_paddingBottom = 0.0;
			_paddingLeft = 0.0;
			_paddingRight = 0.0;
			_paddingTop = 0.0;
			_margin = 0.0;
			_marginBottom = 0.0;
			_marginLeft = 0.0;
			_marginRight = 0.0;
			_marginTop = 0.0;
			
			_horizontalAlign = HORIZONTAL_ALIGN_LEFT;
			_verticalAlign = VERTICAL_ALIGN_TOP;
			
			_acceptedDroppableTypes = null;
			_enabled = true;
			_isDroppableOn = false;
			
			onChange.removeAll();
			onChangeStart.removeAll();
			onChangeComplete.removeAll();
			onChangeCancel.removeAll();
			
			_dataSource = null;
		}
		
		public function dispose():void 
		{
			//trace(this, "DISPOSE", eGroup);
			
			eManager.removeAllFromGroup(eGroup);
			eManager.releaseGroupId(eGroup);
			
			if ( parent ) parent.removeChild(this);
			
			uiParent = null;
			
			onChange.removeAll();
			onChangeStart.removeAll();
			onChangeComplete.removeAll();
			onChangeCancel.removeAll();
			
			onChange = null;
			onChangeStart = null;
			onChangeComplete = null;
			onChangeCancel = null;
			_dataSource = null;
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
		
		public function get uiParent():UIContainer 
		{
			return _uiParent;
		}
		
		public function set uiParent(value:UIContainer):void 
		{
			_uiParent = value;
		}
		
		// PADDING
		
		public function get paddingTop():Number 
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void 
		{
			if ( _paddingTop == value ) return;
			_paddingTop = value;
			draw();
		}
		
		public function get paddingBottom():Number 
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void 
		{
			if ( _paddingBottom == value ) return;
			_paddingBottom = value;
			draw();
		}
		
		public function get paddingRight():Number 
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void 
		{
			if ( _paddingRight == value ) return;
			_paddingRight = value;
			draw();
		}
		
		public function get paddingLeft():Number 
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void 
		{
			if ( _paddingLeft == value ) return;
			_paddingLeft = value;
			draw();
		}
		
		// MARGIN
		
		public function get marginTop():Number 
		{
			return _marginTop;
		}
		
		public function set marginTop(value:Number):void 
		{
			if ( _marginTop == value ) return;
			_marginTop = value;
			draw();
		}
		
		public function get marginBottom():Number 
		{
			return _marginBottom;
		}
		
		public function set marginBottom(value:Number):void 
		{
			if ( _marginBottom == value ) return;
			_marginBottom = value;
			draw();
		}
		
		public function get marginRight():Number 
		{
			return _marginRight;
		}
		
		public function set marginRight(value:Number):void 
		{
			if ( _marginRight == value ) return;
			_marginRight = value;
			draw();
		}
		
		public function get marginLeft():Number 
		{
			return _marginLeft;
		}
		
		public function set marginLeft(value:Number):void 
		{
			if ( _marginLeft == value ) return;
			_marginLeft = value;
			draw();
		}
		
		public function get padding():Number 
		{
			return _padding;
		}
		
		public function set padding(value:Number):void 
		{
			_padding = value;
			_paddingBottom = _paddingLeft = _paddingRight = _paddingTop = _padding;
			draw();
		}
		
		public function get margin():Number 
		{
			return _margin;
		}
		
		public function set margin(value:Number):void 
		{
			_margin = value;
			_marginBottom = _marginLeft = _marginRight = _marginTop = _margin;
			draw();
		}
		
		public function get horizontalAlign():String 
		{
			return _horizontalAlign;
		}
		
		public function set horizontalAlign(value:String):void 
		{
			if ( _horizontalAlign == value ) return;
			_horizontalAlign = value;
			draw();
		}
		
		public function get verticalAlign():String 
		{
			return _verticalAlign;
		}
		
		public function set verticalAlign(value:String):void 
		{
			if ( _verticalAlign == value ) return;
			_verticalAlign = value;
			draw();
		}
	}

}