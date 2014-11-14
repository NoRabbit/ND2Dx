package de.nulldesign.nd2dx.components.ui 
{
	import de.nulldesign.nd2dx.components.ComponentBase;
	import de.nulldesign.nd2dx.components.ui.layout.UIHorizontalLayout;
	import de.nulldesign.nd2dx.components.ui.layout.UILayoutBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class UILayoutComponent extends ComponentBase implements IUIUpdatable
	{
		private var _layout:UILayoutBase = UIHorizontalLayout.reference;
		private var _roundPositionValues:Boolean = false;
		private var _itemSpace:Number = 0.0;
		
		public function UILayoutComponent() 
		{
			
		}
		
		override public function onAddedToNode():void 
		{
			updateUISize();
		}
		
		/* INTERFACE de.nulldesign.nd2dx.components.ui.IUIUpdatable */
		
		public function updateUISize():void 
		{
			if ( node && _layout ) _layout.positionChildren(node, _itemSpace, _roundPositionValues);
		}
		
		public function get layout():UILayoutBase 
		{
			return _layout;
		}
		
		public function set layout(value:UILayoutBase):void 
		{
			if ( _layout == value ) return;
			_layout = value;
			updateUISize();
		}
		
		public function get roundPositionValues():Boolean 
		{
			return _roundPositionValues;
		}
		
		public function set roundPositionValues(value:Boolean):void 
		{
			if ( _roundPositionValues == value ) return;
			_roundPositionValues = value;
			updateUISize();
		}
		
		public function get itemSpace():Number 
		{
			return _itemSpace;
		}
		
		public function set itemSpace(value:Number):void 
		{
			if ( _itemSpace == value ) return;
			_itemSpace = value;
			updateUISize();
		}
		
	}

}