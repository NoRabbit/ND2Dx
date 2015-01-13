package com.rabbitframework.ui.frame 
{
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.icon.Icon;
	import com.rabbitframework.ui.label.Label;
	import com.rabbitframework.ui.layout.UIHorizontalLayout;
	import com.rabbitframework.ui.layout.UIVerticalLayout;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainer;
	import com.rabbitframework.utils.DisplayObjectUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Frame extends UIContainer
	{
		public var toolbar:UIContainer = new UIContainer();
		public var arrow:Icon = new Icon();
		public var label:Label = new Label();
		
		protected var _isOpen:Boolean = true;
		
		public var onOpenClose:Signal = new Signal();
		
		public var vItemsInFrame:Vector.<UIBase> = new Vector.<UIBase>();
		
		public function Frame(dataSource:Object = null) 
		{
			toolbar.verticalAlign = UIBase.VERTICAL_ALIGN_MIDDLE;
			arrow.mouseEnabled = arrow.buttonMode = arrow.useHandCursor = true;
			arrow.dataSource = UIStyles.getBitmapDataForClassName("bullet_toggle_minus.png");
			arrow.setSize(16, 16);
			label.setSize("100%", 16);
			
			this.dataSource = dataSource;
		}
		
		override public function init():void 
		{
			super.init();
			
			eManager.add(arrow, MouseEvent.CLICK, arrow_clickHandler, eGroup);
			
			_layout = UIVerticalLayout.reference;
			_itemSpace = 4.0;
			_extendUIHeightToTotalItemsHeight = true;
			
			toolbar.layout = UIHorizontalLayout.reference;
			toolbar.addItem(arrow);
			toolbar.addItem(label);
			toolbar.setSize("100%", 16);
			addItem(toolbar);
		}
		
		private function arrow_clickHandler(e:MouseEvent):void 
		{
			if ( _isOpen )
			{
				isOpen = false;
			}
			else
			{
				isOpen = true;
			}
		}
		
		override public function draw():void 
		{
			if ( _isOpen )
			{
				arrow.dataSource = UIStyles.getBitmapDataForClassName("bullet_toggle_minus.png");
				addItemsInFrame();
			}
			else
			{
				arrow.dataSource = UIStyles.getBitmapDataForClassName("bullet_toggle_plus.png");
				removeItemsInFrame();
				uiHeight = 16.0;
			}
			
			super.draw();
		}
		
		private function removeItemsInFrame():void
		{
			while (numItems > 1)
			{
				vItemsInFrame.push(getItemAt(1));
				removeItemAt(1, false);
			}
		}
		
		private function addItemsInFrame():void
		{
			var i:int = 0;
			var n:int = vItemsInFrame.length;
			
			for (; i < n; i++) 
			{
				addItem(vItemsInFrame[i], false);
			}
			
			if ( vItemsInFrame.length ) vItemsInFrame.splice(0, vItemsInFrame.length);
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
			label.dataSource = value;
		}
		
		public function get isOpen():Boolean 
		{
			return _isOpen;
		}
		
		public function set isOpen(value:Boolean):void 
		{
			if ( _isOpen == value ) return;
			
			_isOpen = value;
			onOpenClose.dispatchData(value);
			draw();
			
			var p:UIContainer = uiParent;
			
			while ( p )
			{
				p.draw();
				
				if ( p.uiParent )
				{
					p = p.uiParent;
				}
				else
				{
					break;
				}
			}
			
			if ( p )
			{
				p.draw();
			}
		}
		
		override public function disposeForPool():void 
		{
			toolbar.removeAllItems(false);
			removeItem(toolbar, false);
			
			super.disposeForPool();
			
			_isOpen = true;
			label.dataSource = "";
			
			if ( vItemsInFrame.length ) vItemsInFrame.splice(0, vItemsInFrame.length);
			
			trace(this, "disposeForPool", vItems, toolbar.vItems);
		}
		
		override public function dispose():void 
		{
			vItemsInFrame = null;
			super.dispose();
		}
	}

}