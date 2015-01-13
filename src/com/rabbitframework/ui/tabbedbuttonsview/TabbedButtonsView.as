package com.rabbitframework.ui.tabbedbuttonsview 
{
	import com.rabbitframework.managers.pool.PoolManager;
	import com.rabbitframework.signals.Signal;
	import com.rabbitframework.ui.button.Button;
	import com.rabbitframework.ui.dataprovider.DataProviderBase;
	import com.rabbitframework.ui.UIBase;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TabbedButtonsView extends UIBase
	{
		private var vItems:Vector.<UIBase> = new Vector.<UIBase>();
		
		public var onSelect:Signal = new Signal();
		
		private var _selectedDataSource:Object;
		
		public function TabbedButtonsView() 
		{
			minUIWidth = 40.0;
			minUIHeight = 20.0;
			
			//setSize(500, 34);
			
			/*dataSource =
			[
				{ label:"Home" },
				{ label:"About", children:
					[
						{ label:"02 a" },
						{ label:"02 b", children:
							[
							{label:"02 a 01" },
							{ label:"02 b 02" }
							] }
					] },
				{ label:"Softwares" },
				{ label:"Showcase", children:
					[
						{label:"04 a" },
						{label:"04 b" }
					] },
				{ label:"About" },
				{ label:"Contact" },
				{ label:"History", children:
					[
						{ label:"07 a" },
						{label:"07 b" }
					] }
			];*/
		}
		
		override public function draw():void 
		{
			drawItems();
		}
		
		public function drawItems():void
		{
			clearItemsForDrawing();
			
			if ( !_dataSource ) return;
			
			var dataProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(_dataSource);
			
			if ( !dataProvider ) return;
			
			var i:int = 0;
			var n:int = dataProvider.getNumChildren(_dataSource);
			var item:TabbedButton;
			
			var itemWidth:Number = Math.floor(uiWidth / n);
			var lastItemWidth:Number = itemWidth + (uiWidth - (itemWidth * n));
			var currentX:Number = 0.0;
			
			for (; i < n; i++) 
			{
				if ( i == 0 )
				{
					item = poolManager.getObject(TabbedButtonLeft) as TabbedButton;
				}
				else if ( i == n - 1)
				{
					item = poolManager.getObject(TabbedButtonRight) as TabbedButton;
					itemWidth = lastItemWidth;
				}
				else
				{
					item = poolManager.getObject(TabbedButtonMiddle) as TabbedButton;
				}
				
				item.x = currentX;
				item.y = 0.0;
				item.setSize(itemWidth, uiHeight, true);
				item.dataSource = dataProvider.getItemAt(_dataSource, i);
				item.selected = item.dataSource == _selectedDataSource;
				item.onMouseClick.add(item_onMouseClickHandler);
				
				currentX += itemWidth;
				
				addChild(item);
				
				vItems.push(item);
			}
			
			uiWidth = currentX;
		}
		
		private function item_onMouseClickHandler(item:UIBase):void 
		{
			selectedDataSource = item.dataSource;
		}
		
		private function clearItemsForDrawing():void 
		{
			var i:int = 0;
			var n:int = vItems.length;
			
			for (; i < n; i++) 
			{
				removeChild(vItems[i]);
				poolManager.releaseObject(vItems[i]);
			}
			
			if ( vItems.length ) vItems.splice(0, vItems.length);
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
			draw();
		}
		
		public function get selectedDataSource():Object 
		{
			return _selectedDataSource;
		}
		
		public function set selectedDataSource(value:Object):void 
		{
			_selectedDataSource = value;
			draw();
			onSelect.dispatchData(_selectedDataSource);
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			clearItemsForDrawing();
			onSelect.removeAll();
		}
		
		override public function dispose():void 
		{
			super.dispose();
			clearItemsForDrawing();
			onSelect.removeAll();
			onSelect = null;
		}
	}

}