package com.rabbitframework.ui.scrollbar 
{
	import com.rabbitframework.ui.button.Button;
	import com.rabbitframework.ui.button.ButtonDrag;
	import com.rabbitframework.ui.UIBase;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class VScrollBar extends UIBase
	{
		public static const MIN_BAR_SIZE:Number = 10.0;
		
		public var bg:Sprite;
		
		public var buttonBar:ButtonDrag;
		
		private var _minimum:Number = 0.0;
		private var _maximum:Number = 0.0;
		private var _value:Number = 0.0;
		private var _valuePrct:Number = 0.0;
		
		public var onChange:Signal = new Signal(Number);
		
		public function VScrollBar() 
		{
			minUIWidth = 14.0;
			//setSize(14.0, 200.0);
		}
		
		override public function init():void 
		{
			super.init();
			
			buttonBar.onStartDrag.add(buttonBar_onStartDrag);
			buttonBar.onStopDrag.add(buttonBar_onStopDrag);
		}
		
		private function buttonBar_onStartDrag(buttonDrag:ButtonDrag):void 
		{
			eManager.add(this, Event.ENTER_FRAME, onButtonBarDrag, [eGroup, eGroup + ".enterframe"]);
		}
		
		private function onButtonBarDrag(e:Event):void 
		{
			updateValue();
		}
		
		private function buttonBar_onStopDrag(buttonDrag:ButtonDrag):void 
		{
			eManager.removeAllFromGroup(eGroup + ".enterframe");
		}
		
		override public function draw():void 
		{
			super.draw();
			
			bg.x = 0.0;
			bg.y = 0.0;
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			var totalSpaceLeftForBar:Number = uiHeight - 4.0 - MIN_BAR_SIZE;
			var minMaxDistance:Number = Math.abs(getMinMaxDistance());
			var h:Number = minMaxDistance / uiHeight;
			if ( h > 1.0 ) h = 1.0;
			if ( h < 0.0 ) h = 0.0;
			h = 1.0 - h;
			
			buttonBar.setSize(uiWidth - 4.0, MIN_BAR_SIZE + (totalSpaceLeftForBar * h));
			buttonBar.rectDrag.x = 2.0;
			buttonBar.rectDrag.y = 2.0;
			buttonBar.rectDrag.width = 0.0;
			buttonBar.rectDrag.height = uiHeight - 4.0 - buttonBar.uiHeight;
			
			buttonBar.x = 2.0;
			buttonBar.y = 2.0 + (valuePrct * buttonBar.rectDrag.height);
		}
		
		public function updateValue():void
		{
			var prct:Number = (buttonBar.y - buttonBar.rectDrag.y) / buttonBar.rectDrag.height;
			
			if ( prct > 1.0 ) prct = 1.0;
			if ( prct < 0.0 ) prct = 0.0;
			
			_value = _minimum + ((_maximum - _minimum) * prct);
			
			onChange.dispatch(_value);
		}
		
		public function getMinMaxDistance():Number
		{
			return _maximum - _minimum;
		}
		
		public function get minimum():Number 
		{
			return _minimum;
		}
		
		public function set minimum(value:Number):void 
		{
			_minimum = value;
			this.value = this.value;
			draw();
		}
		
		public function get maximum():Number 
		{
			return _maximum;
		}
		
		public function set maximum(value:Number):void 
		{
			_maximum = value;
			this.value = this.value;
			draw();
		}
		
		public function get value():Number 
		{
			return _value;
		}
		
		public function set value(value:Number):void 
		{
			_value = value;
			
			if ( isNaN(_value) ) _value = _minimum;
			
			if ( getMinMaxDistance() > 0 )
			{
				if ( _value < _minimum ) _value = _minimum;
				if ( _value > _maximum ) _value = _maximum;
			}
			else
			{
				if ( _value > _minimum ) _value = _minimum;
				if ( _value < _maximum ) _value = _maximum;
			}
			
			draw();
			
			onChange.dispatch(_value);
		}
		
		public function get valuePrct():Number 
		{
			return Math.abs((_value - _minimum) / getMinMaxDistance());
		}
		
		public function set valuePrct(value:Number):void 
		{
			_valuePrct = value;
			
			if ( _valuePrct > 1.0 ) _valuePrct = 1.0;
			if ( _valuePrct < 0.0 ) _valuePrct = 0.0;
			
			value = _minimum + ((_maximum - _minimum) * _valuePrct);
		}
		
		override public function get enabled():Boolean 
		{
			return super.enabled;
		}
		
		override public function set enabled(value:Boolean):void 
		{
			super.enabled = value;
			
			if ( _enabled )
			{
				buttonBar.visible = true;
				alpha = 1.0;
			}
			else
			{
				buttonBar.visible = false;
				alpha = 0.4;
			}
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			onChange.removeAll();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			onChange.removeAll();
			onChange = null;
			bg = null;
			buttonBar = null;
		}
	}

}