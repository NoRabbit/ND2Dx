package com.rabbitframework.ui.panel 
{
	import com.rabbitframework.ui.groups.Group;
	import com.rabbitframework.ui.scrollbar.VScrollBar;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainerBase;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Panel extends Group
	{
		public var bg:Sprite;
		public var bgTitle:Sprite;
		public var txt:TextField;
		public var buttonResize:Sprite;
		
		public var pDrag:Point = new Point();
		public var pDragStartSize:Point = new Point();
		
		public var itemsContainerMask:Shape;
		public var itemsVScrollBar:VScrollBar;
		
		public function Panel(title:String = "") 
		{
			itemsContainer = new Sprite();
			addChild(itemsContainer);
			
			itemsContainerMask = new Shape();
			addChild(itemsContainerMask);
			itemsContainer.mask = itemsContainerMask;
			
			itemsVScrollBar = new VScrollBar();
			addChild(itemsVScrollBar);
			itemsVScrollBar.enabled = false;
			itemsVScrollBar.visible = false;
			
			minUIWidth = 50.0;
			minUIHeight = 40.0;
			
			super();
			
			dataSource = title;
			
			_paddingTop = 34.0;
			_paddingBottom = 8.0;
			_paddingLeft = 8.0;
			_paddingRight = 8.0;
			
			_extendUIWidthToTotalItemsWidth = false;
			_extendUIHeightToTotalItemsHeight = false;
			
			bgTitle.mouseEnabled = bgTitle.useHandCursor = bgTitle.buttonMode = true;
			buttonResize.mouseEnabled = buttonResize.useHandCursor = buttonResize.buttonMode = true;
			txt.mouseEnabled = false;
		}
		
		override public function init():void 
		{
			super.init();
			
			eManager.add(bgTitle, MouseEvent.MOUSE_DOWN, bgTitle_mouseDownHandler, eGroup);
			eManager.add(buttonResize, MouseEvent.MOUSE_DOWN, buttonResize_mouseDownHandler, eGroup);
			
			itemsVScrollBar.onChange.add(itemsVScrollBar_onChangeHandler);
			
			eManager.add(this, MouseEvent.MOUSE_WHEEL, mouseWheelHandler, eGroup);
		}
		
		private function mouseWheelHandler(e:MouseEvent):void 
		{
			if ( !itemsVScrollBar.enabled ) return;
			itemsVScrollBar.value += (e.delta / 3) * 16.0;
		}
		
		private function itemsVScrollBar_onChangeHandler(value:Number):void 
		{
			itemsContainer.y = value;
		}
		
		private function buttonResize_mouseDownHandler(e:MouseEvent):void 
		{
			pDrag.x = stage.mouseX;
			pDrag.y = stage.mouseY;
			
			pDragStartSize.x = uiWidth;
			pDragStartSize.y = uiHeight;
			
			eManager.add(buttonResize, Event.ENTER_FRAME, buttonResize_enterFrameHandler, [eGroup, eGroup + ".drag"]);
			eManager.add(stage, MouseEvent.MOUSE_UP, stage_mouseUpHandler, [eGroup, eGroup + ".drag"]);
		}
		
		private function buttonResize_enterFrameHandler(e:Event):void 
		{
			setSize(pDragStartSize.x + (stage.mouseX - pDrag.x), pDragStartSize.y + (stage.mouseY - pDrag.y));
		}
		
		private function bgTitle_mouseDownHandler(e:MouseEvent):void 
		{
			startDragPanel();
		}
		
		public function startDragPanel():void
		{
			if ( uiParent ) return;
			
			pDrag.x = mouseX;
			pDrag.y = mouseY;
			
			if ( uiParent )
			{
				var s:Stage = stage;
				uiParent.removeItem(this);
				s.addChild(this);
			}
			
			if ( parent ) parent.setChildIndex(this, parent.numChildren - 1);
			
			eManager.add(bgTitle, Event.ENTER_FRAME, bgTitle_enterFrameHandler, [eGroup, eGroup + ".drag"]);
			eManager.add(stage, MouseEvent.MOUSE_UP, stage_mouseUpHandler, [eGroup, eGroup + ".drag"]);
		}
		
		protected function bgTitle_enterFrameHandler(e:Event):void 
		{
			onDrag();
		}
		
		protected function stage_mouseUpHandler(e:MouseEvent):void 
		{
			stopDragPanel();
		}
		
		public function stopDragPanel():void
		{
			eManager.removeAllFromGroup(eGroup + ".drag");
		}
		
		protected function onDrag():void 
		{
			var p:Point = new Point(stage.mouseX, stage.mouseY);
			p = parent.globalToLocal(p);
			x = p.x - pDrag.x;
			y = p.y - pDrag.y;
		}
		
		override public function draw():void 
		{
			var currentUIWidth:Number = uiWidth;
			var currentUIHeight:Number = uiHeight;
			
			super.draw();
			
			//if ( uiWidth < currentUIWidth ) uiWidth = currentUIWidth;
			//if ( uiHeight < currentUIHeight ) uiHeight = currentUIHeight;
			
			bg.x = 0.0;
			bg.y = 0.0;
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			bgTitle.x = 0.0;
			bgTitle.y = 0.0;
			bgTitle.width = uiWidth;
			bgTitle.height = 24.0;
			
			txt.x = 8.0;
			txt.y = 6.0;
			txt.width = uiWidth - 16.0;
			
			buttonResize.x = uiWidth - buttonResize.width;
			buttonResize.y = uiHeight - buttonResize.height;
			
			itemsContainerMask.graphics.clear();
			itemsContainerMask.graphics.beginFill(0xff0000, 0.25);
			itemsContainerMask.graphics.drawRect(0.0, 0.0, uiWidth - _paddingRight - _paddingLeft, uiHeight - _paddingBottom - _paddingTop);
			itemsContainerMask.graphics.endFill();
			itemsContainerMask.x = _paddingLeft;
			itemsContainerMask.y = _paddingTop;
			
			if ( itemsContainer.height > itemsContainerMask.height )
			{
				itemsVScrollBar.enabled = itemsVScrollBar.visible = true;
				paddingRight = 30.0;
				
				itemsVScrollBar.setSize(14.0, itemsContainerMask.height);
				itemsVScrollBar.x = uiWidth - 14.0 - 8.0;
				itemsVScrollBar.y = _paddingTop;
				
				itemsVScrollBar.minimum = 0.0;
				itemsVScrollBar.maximum = -(itemsContainer.height - itemsContainerMask.height);
			}
			else if ( itemsVScrollBar.enabled )
			{
				itemsVScrollBar.enabled = itemsVScrollBar.visible = false;
				itemsContainer.y = 0.0;
				paddingRight = 8.0;
			}
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
			txt.text = dataProviderManager.getDataSourceLabel(_dataSource);
		}
		
		override public function get uiParent():UIContainerBase 
		{
			return super.uiParent;
		}
		
		override public function set uiParent(value:UIContainerBase):void 
		{
			super.uiParent = value;
			
			if ( _uiParent )
			{
				buttonResize.visible = false;
				filters = [];
			}
			else
			{
				buttonResize.visible = true;
				UIStyles.setPanelDropShadowFilter(this);
			}
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			
			itemsVScrollBar.onChange.removeAll();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			
			itemsVScrollBar.onChange.removeAll();
		}
	}

}