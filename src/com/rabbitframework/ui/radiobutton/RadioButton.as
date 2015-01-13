package com.rabbitframework.ui.radiobutton 
{
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.button.Button;
	import com.rabbitframework.ui.styles.UIStyles;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public class RadioButton extends Button
	{
		public static var oGroups:Object = { };
		
		public var icon:Sprite;
		public var txt:TextField;
		
		private var _selected:Boolean = false;
		public var group:String = "";
		
		public var onSelect:Signal = new Signal();
		public static var onGroupSelect:Signal = new Signal();
		
		public function RadioButton(dataSource:Object = null, groupId:String = "") 
		{
			icon.visible = false;
			icon.mouseChildren = icon.mouseEnabled = false;
			
			if( groupId ) setRadioButtonGroupId(this, groupId);
			this.dataSource = dataSource;
		}
		
		public static function setRadioButtonGroupId(radioButton:RadioButton, group:String):void
		{
			var a:Array = oGroups[group] as Array;
			if ( !a ) a = oGroups[group] = new Array();
			if ( a.indexOf(radioButton) < 0 ) a.push(radioButton);
			radioButton.group = group;
		}
		
		override public function draw():void 
		{
			if( txt ) txt.width = uiWidth - txt.x;
			
			bg.y = Math.round((uiHeight - bg.height) * 0.5);
			icon.y = bg.y + 7.0;
			if( txt ) txt.y = bg.y - 1.0;
		}
		
		override protected function onMouseDownHandler(e:MouseEvent):void 
		{
			bg.getChildAt(0).transform.colorTransform = UIStyles.getSelectHighlightColorTransform();
		}
		
		override protected function onMouseUpHandler(e:MouseEvent):void 
		{
			bg.getChildAt(0).transform.colorTransform = UIStyles.getIdentityColorTransform();
		}
		
		override protected function onClickHandler(e:MouseEvent):void 
		{
			selected = true;
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
			if( txt ) txt.text = dataProviderManager.getDataSourceLabel(_dataSource);
		}
		
		public function get selected():Boolean 
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void 
		{
			if ( _selected == value ) return;
			
			_selected = value;
			
			onGroupSelect.dispatchData(group, this);
			
			if ( _selected )
			{
				icon.visible = true;
				
				var a:Array = oGroups[group] as Array;
				
				if ( a )
				{
					var i:int = 0;
					var n:int = a.length;
					
					for (; i < n; i++) 
					{
						var rb:RadioButton = a[i] as RadioButton;
						if( rb != this ) rb.selected = false;
					}
				}
			}
			else
			{
				icon.visible = false;
			}
			
			onSelect.dispatchData(this);
		}
		
		public function getSelectedRadioButtonInGroup():RadioButton
		{
			var a:Array = oGroups[group] as Array;
			
			if ( a )
			{
				var i:int = 0;
				var n:int = a.length;
				
				for (; i < n; i++) 
				{
					var rb:RadioButton = a[i] as RadioButton;
					if( rb.selected ) return rb;
				}
			}
			
			return null;
		}
	}

}