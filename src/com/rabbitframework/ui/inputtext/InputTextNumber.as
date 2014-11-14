package com.rabbitframework.ui.inputtext 
{
	import com.rabbitframework.easing.Circ;
	import com.rabbitframework.easing.Expo;
	import com.rabbitframework.managers.keyboard.KeyboardManager;
	import com.rabbitframework.utils.MathUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class InputTextNumber extends InputText
	{
		protected var kbManager:KeyboardManager = KeyboardManager.getInstance();
		
		public var drag:Sprite;
		
		private var startPoint:Point = new Point();
		private var currentPoint:Point = new Point();
		private var currentValue:Number = 0.0;
		private var currentDecimalsCount:int = 0;
		
		public var precision:Number = 1.0;
		
		public function InputTextNumber(value:Number = 0.0, precision:Number = 1.0)
		{
			txt.restrict = "0123456789.\\-";
			dataSource = value.toString();
			this.precision = precision;
			drag.mouseEnabled = drag.mouseChildren = drag.useHandCursor = drag.buttonMode = true;
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			drag.x = 4.0;
			drag.y = (uiHeight - drag.height) * 0.5;
			
			txt.x = drag.x + drag.width + 4.0;
			txt.y = Math.round((uiHeight - txt.height) * 0.5) + 2;
			txt.width = uiWidth - txt.x;
		}
		
		override public function init():void 
		{
			super.init();
			
			eManager.add(drag, MouseEvent.MOUSE_DOWN, drag_mouseDownHandler, eGroup);
		}
		
		private function drag_mouseDownHandler(e:MouseEvent):void 
		{
			currentPoint.x = startPoint.x = stage.mouseX;
			currentPoint.y = startPoint.y = stage.mouseY;
			
			currentValue = Number(txt.text);
			currentDecimalsCount = MathUtils.getDecimalsCount(currentValue);
			currentDecimalsCount = Math.max(currentDecimalsCount, MathUtils.getDecimalsCount(precision));
			
			eManager.add(drag, Event.ENTER_FRAME, drag_enterFrameHandler, [eGroup, eGroup + ".efup"]);
			eManager.add(stage, MouseEvent.MOUSE_UP, stage_mouseUpHandler, [eGroup, eGroup + ".efup"]);
		}
		
		private function drag_enterFrameHandler(e:Event):void 
		{
			currentPoint.x = stage.mouseX;
			currentPoint.y = stage.mouseY;
			
			var res:Number = (currentPoint.x - startPoint.x) * precision;
			//trace(currentValue, res, MathUtils.roundTo(res, MathUtils.getDecimalsCount(precision)), currentValue + res);
			res = MathUtils.roundTo(res, MathUtils.getDecimalsCount(precision));
			
			
			
			if ( kbManager.isKeyDown(Keyboard.CONTROL) ) res *= 5.0;
			
			res += currentValue;
			currentValue = res;
			
			if ( kbManager.isKeyDown(Keyboard.SHIFT) )
			{
				if ( res < 0 )
				{
					res = Math.round(Math.abs(res));
					res = -res;
				}
				else
				{
					res = Math.round(res);
				}
			}
			
			if ( kbManager.isKeyDown(Keyboard.SPACE) )
			{
				if ( res < 0 )
				{
					res = Math.round(Math.abs(res) / 10) * 10;
					res = -res;
				}
				else
				{
					res = Math.round(res / 10) * 10;
				}
			}
			
			res = MathUtils.roundTo(res, currentDecimalsCount);
			
			dataSource = String(res);
			
			startPoint.x = currentPoint.x;
			startPoint.y = currentPoint.y;
		}
		
		private function stage_mouseUpHandler(e:MouseEvent):void 
		{
			eManager.removeAllFromGroup(eGroup + ".efup");
		}
	}

}