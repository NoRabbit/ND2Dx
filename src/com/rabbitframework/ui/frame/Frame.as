package com.rabbitframework.ui.frame 
{
	import com.rabbitframework.ui.groups.Group;
	import com.rabbitframework.ui.icon.Icon;
	import com.rabbitframework.ui.label.Label;
	import com.rabbitframework.ui.styles.UIStyles;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.ui.UIContainerBase;
	import com.rabbitframework.utils.DisplayObjectUtils;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class Frame extends Group
	{
		public var mainGroup:Group = new Group();
		public var arrow:Icon = new Icon();
		public var label:Label = new Label();
		
		protected var _isOpen:Boolean = true;
		
		public var onOpenClose:Signal = new Signal(Boolean);
		public var vItemsToKeep:Vector.<UIBase> = new Vector.<UIBase>();
		
		public function Frame(dataSource:Object = null) 
		{
			vItemsToKeep.push(arrow);
			vItemsToKeep.push(label);
			
			addChild(mainGroup);
			
			mainGroup.isHorizontal = true;
			mainGroup.spaceSize = 4.0;
			
			arrow.dataSource = UIStyles.getBitmapDataForClassName("bullet_toggle_minus.png");
			arrow.setSize(16, 16);
			label.setSize("100%");
			
			mainGroup.addItem(arrow);
			mainGroup.addItem(label);
			
			this.dataSource = dataSource;
			
			arrow.mouseEnabled = arrow.buttonMode = arrow.useHandCursor = true;
			_paddingTop = 22.0;
		}
		
		override public function init():void 
		{
			super.init();
			
			eManager.add(arrow, MouseEvent.CLICK, arrow_clickHandler, eGroup);
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
			mainGroup.setSize(uiWidth, 16, true);
			
			if ( _isOpen )
			{
				_hideChildren = false;
				arrow.dataSource = UIStyles.getBitmapDataForClassName("bullet_toggle_minus.png");
				//arrow.bitmap.transform.matrix = new Matrix();
				//DisplayObjectUtils.rotateAroundPoint(arrow.bitmap, 8.0, 8.0, 90.0);
			}
			else
			{
				_hideChildren = true;
				arrow.dataSource = UIStyles.getBitmapDataForClassName("bullet_toggle_plus.png");
				//arrow.bitmap.transform.matrix = new Matrix();
				//DisplayObjectUtils.rotateAroundPoint(arrow.bitmap, 8.0, 8.0, 0.0);
				
				uiHeight = 16.0;
			}
			
			super.draw();
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
			onOpenClose.dispatch(value);
			draw();
			
			var p:UIContainerBase = uiParent;
			
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
			super.disposeForPool();
			_isOpen = true;
			label.dataSource = "";
			
			mainGroup.removeAllItems(false, vItemsToKeep);
		}
		
		override public function dispose():void 
		{
			super.dispose();
		}
	}

}