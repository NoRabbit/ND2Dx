package de.nulldesign.nd2dx.components.ui 
{
	import com.rabbitframework.utils.StringUtils;
	import de.nulldesign.nd2dx.components.ComponentBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UIComponent extends ComponentBase implements IUIUpdatable
	{
		protected var _enabled:Boolean = true;
		protected var _isDroppableOn:Boolean = false;
		protected var _acceptedDroppableTypes:Array = null;
		
		public var minUIWidth:Number = 1.0;
		public var minUIHeight:Number = 1.0;
		
		public var uiWidth:Number = 0.0;
		public var uiHeight:Number = 0.0;
		
		public var uiOriginalWidth:Number = 0.0;
		public var uiOriginalHeight:Number = 0.0;
		
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
		
		private var _parentUIComponent:UIComponent;
		
		public function UIComponent() 
		{
			initUI();
		}
		
		override public function hitTest(x:Number, y:Number):Boolean 
		{
			return x >= 0.0 - node.hitTestMargin
				&& x <= uiWidth + node.hitTestMargin
				&& y >= 0.0 - node.hitTestMargin
				&& y <= uiHeight + node.hitTestMargin;
		}
		
		public function initUI():void
		{
			paddingTop = 0.0;
			paddingRight = 0.0;
			paddingBottom = 0.0;
			paddingLeft = 0.0;
			
			marginTop = 0.0;
			marginRight = 0.0;
			marginBottom = 0.0;
			marginLeft = 0.0;
		}
		
		override public function onAddedToNode():void 
		{
			updateUISize();
		}
		
		public function setUISize(width:Object = null, height:Object = null, forceUpdateUISize:Boolean = false, forceSize:Boolean = false):UIComponent
		{
			var widthToSet:Number = uiWidth;
			var heightToSet:Number = uiHeight;
			
			if( width is Number ) widthToSet = width as Number;
			if( height is Number ) heightToSet = height as Number;
			
			if ( !forceSize && widthToSet < minUIWidth ) widthToSet = minUIWidth;
			if ( !forceSize && heightToSet < minUIHeight ) heightToSet = minUIHeight;
			
			if ( forceUpdateUISize || widthToSet != uiWidth || heightToSet != uiHeight )
			{
				uiWidth = uiOriginalWidth = widthToSet;
				uiHeight = uiOriginalHeight = heightToSet;
				updateUISize();
			}
			
			var updateParentUISize:Boolean = false;
			
			if ( width is String )
			{
				uiWidthPrct = Number(StringUtils.getBefore(width as String, "%", true));
				updateParentUISize = true;
			}
			else
			{
				//uiWidthPrct = NaN;
			}
			
			if ( height is String )
			{
				uiHeightPrct = Number(StringUtils.getBefore(height as String, "%", true));
				updateParentUISize = true;
			}
			else
			{
				//uiHeightPrct = NaN;
			}
			
			if ( updateParentUISize && parentUIComponent ) parentUIComponent.updateUISize();
			
			return this;
		}
		
		public function setUISizeInPercent(width:Number = -1, height:Number = -1):UIComponent
		{
			uiWidthPrct = width;
			uiHeightPrct = height;
			
			if ( parentUIComponent ) parentUIComponent.updateUISize();
			
			return this;
		}
		
		public function unsetUISizeInPercent():UIComponent
		{
			return setUISizeInPercent();
		}
		
		override public function initFromPool():void 
		{
			super.initFromPool();
			initUI();
		}
		
		//override public function hitTest():Boolean 
		//{
			//return _mouseX >= 0.0 - hitTestMargin
				//&& _mouseX <= uiWidth + hitTestMargin
				//&& _mouseY >= 0.0 - hitTestMargin
				//&& _mouseY <= uiHeight + hitTestMargin;
		//}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			_parentUIComponent = null;
			uiWidthPrct = NaN;
			uiHeightPrct = NaN;
			uiWidth = minUIWidth;
			uiHeight = minUIHeight;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			_parentUIComponent = null;
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
		
		//public function onDrop(dragAndDropObject:DragAndDropObject):void 
		//{
			//
		//}
		//
		//public function onDropOver(dragAndDropObject:DragAndDropObject):void 
		//{
			//
		//}
		//
		//public function onDropOut(dragAndDropObject:DragAndDropObject):void 
		//{
			//
		//}
		
		/* INTERFACE de.nulldesign.nd2dx.components.ui.IUIUpdatable */
		
		public function updateUISize():void 
		{
			if ( !node ) return;
			
			var uiUpdatableComponent:IUIUpdatable;
			
			// loop through each node component
			for (var component:ComponentBase = node.componentFirst; component; component = component.next)
			{
				if ( component == this ) continue;
				
				uiUpdatableComponent = component as IUIUpdatable;
				if ( uiUpdatableComponent ) uiUpdatableComponent.updateUISize();
			}
		}
		
		public function get enabled():Boolean 
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void 
		{
			_enabled = value;
		}
		
		//public function get dataSource():Object 
		//{
			//return _dataSource;
		//}
		//
		//public function set dataSource(value:Object):void 
		//{
			//_dataSource = value;
		//}
		
		// PADDING
		
		public function get paddingTop():Number 
		{
			return _paddingTop;
		}
		
		public function set paddingTop(value:Number):void 
		{
			if ( _paddingTop == value ) return;
			_paddingTop = value;
			updateUISize();
		}
		
		public function get paddingBottom():Number 
		{
			return _paddingBottom;
		}
		
		public function set paddingBottom(value:Number):void 
		{
			if ( _paddingBottom == value ) return;
			_paddingBottom = value;
			updateUISize();
		}
		
		public function get paddingRight():Number 
		{
			return _paddingRight;
		}
		
		public function set paddingRight(value:Number):void 
		{
			if ( _paddingRight == value ) return;
			_paddingRight = value;
			updateUISize();
		}
		
		public function get paddingLeft():Number 
		{
			return _paddingLeft;
		}
		
		public function set paddingLeft(value:Number):void 
		{
			if ( _paddingLeft == value ) return;
			_paddingLeft = value;
			updateUISize();
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
			updateUISize();
		}
		
		public function get marginBottom():Number 
		{
			return _marginBottom;
		}
		
		public function set marginBottom(value:Number):void 
		{
			if ( _marginBottom == value ) return;
			_marginBottom = value;
			updateUISize();
		}
		
		public function get marginRight():Number 
		{
			return _marginRight;
		}
		
		public function set marginRight(value:Number):void 
		{
			if ( _marginRight == value ) return;
			_marginRight = value;
			updateUISize();
		}
		
		public function get marginLeft():Number 
		{
			return _marginLeft;
		}
		
		public function set marginLeft(value:Number):void 
		{
			if ( _marginLeft == value ) return;
			_marginLeft = value;
			updateUISize();
		}
		
		public function get padding():Number 
		{
			return _padding;
		}
		
		public function set padding(value:Number):void 
		{
			_padding = value;
			_paddingBottom = _paddingLeft = _paddingRight = _paddingTop = _padding;
			updateUISize();
		}
		
		public function get margin():Number 
		{
			return _margin;
		}
		
		public function set margin(value:Number):void 
		{
			_margin = value;
			_marginBottom = _marginLeft = _marginRight = _marginTop = _margin;
			updateUISize();
		}
		
		public function get parentUIComponent():UIComponent 
		{
			if ( !_parentUIComponent && node && node.parent && node.parent.uiComponent ) _parentUIComponent = node.parent.uiComponent;
			return _parentUIComponent;
		}
	}

}