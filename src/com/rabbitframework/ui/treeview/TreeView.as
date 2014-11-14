package com.rabbitframework.ui.treeview 
{
	import com.rabbitframework.managers.pool.Pool;
	import com.rabbitframework.managers.pool.PoolManager;
	import com.rabbitframework.ui.dataprovider.DataProviderBase;
	import com.rabbitframework.ui.dataprovider.DataProviderManager;
	import com.rabbitframework.ui.scrollbar.VScrollBar;
	import com.rabbitframework.ui.states.DataSourceState;
	import com.rabbitframework.ui.states.DataSourceStateHolder;
	import com.rabbitframework.ui.UIBase;
	import com.rabbitframework.utils.DragAndDropUtils;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import org.osflash.signals.Signal;
	import wgmeditor.managers.draganddrop.DragAndDropObject;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class TreeView extends UIBase
	{
		public static const DRAG_TYPE_BEFORE:uint = 1;
		public static const DRAG_TYPE_IN:uint = 2;
		public static const DRAG_TYPE_AFTER:uint = 3;
		public static const DRAG_TYPE_IN_EMPTY:uint = 4;
		
		public var ITEM_SIZE:Number = 20.0;
		public var INDENT_SIZE:Number = 20.0;
		
		protected var itemPool:Pool = PoolManager.getInstance().getPoolForClass(TreeViewItem, true, 10);
		
		public var bg:Sprite;
		public var vScrollBar:VScrollBar;
		
		public var itemsContainer:Sprite;
		public var itemsContainerMask:Sprite;
		public var dragIn:Sprite;
		public var dragInBetween:Sprite;
		
		private var vItems:Vector.<TreeViewItem> = new Vector.<TreeViewItem>();
		
		private var drawStartX:Number = 0.0;
		private var drawStartY:Number = 0.0;
		private var currentDrawX:Number = 0.0;
		private var currentDrawY:Number = 0.0;
		private var currentItemsHeight:Number = 0.0;
		
		public var preSelectedDataSource:Object;
		public var preSelectedDataSourceIndex:int = -1;
		public var preSelectedDataSourceParent:Object;
		
		private var selectedDataSource:Object;
		public var selectedDataSourceIndex:int = -1;
		public var selectedDataSourceParent:Object;
		
		public var dataSourceStateHolder:DataSourceStateHolder = new DataSourceStateHolder();
		
		private var _isEditable:Boolean = false;
		private var _isItemDraggable:Boolean = true;
		private var _showTree:Boolean = true;
		private var _showTreeRoot:Boolean = false;
		
		private var _allowDeleteItem:Boolean = false;
		
		public var allowDropInItem:Boolean = true;
		public var allowDropBeforeItem:Boolean = true;
		public var allowDropAfterItem:Boolean = true;
		public var copyItemOnDropIfInitiatorIsDifferent:Boolean = true;
		
		private var dragAndDropObject:DragAndDropObject = null;
		
		public var pDragStartPos:Point = new Point();
		public var pDragEndPos:Point = new Point();
		public var dragMinDistance:Number = 2.0;
		public var dragScrollMaxDistance:Number = 20.0;
		public var dragType:uint = 0;
		public var dragOnDataSource:Object = null;
		
		public var onSelect:Signal = new Signal(Object);
		
		public function TreeView() 
		{
			
		}
		
		override public function init():void 
		{
			minUIWidth = 50.0;
			minUIHeight = 50.0;
			
			preSelectedDataSource = null;
			preSelectedDataSourceIndex = -1;
			preSelectedDataSourceParent = null;
			
			selectedDataSource = null;
			selectedDataSourceIndex = -1;
			selectedDataSourceParent = null;
			
			_isItemDraggable = true;
			_isEditable = true;
			_isDroppableOn = true;
			allowDropInItem = true;
			allowDropBeforeItem = true;
			allowDropAfterItem = true;
			copyItemOnDropIfInitiatorIsDifferent = true;
			
			dragIn.visible = false;
			dragIn.mouseEnabled = dragIn.mouseChildren = false;
			
			dragInBetween.visible = false;
			dragInBetween.mouseEnabled = dragInBetween.mouseChildren = false;
			
			vScrollBar.visible = vScrollBar.enabled = false;
			vScrollBar.onChange.add(vScrollBar_onChangeHandler);
			
			eManager.add(this, MouseEvent.MOUSE_WHEEL, mouseWheelHandler, eGroup);
		}
		
		private function mouseWheelHandler(e:MouseEvent):void 
		{
			vScrollBar.value += (e.delta / 3) * ITEM_SIZE;
		}
		
		private function vScrollBar_onChangeHandler(value:Number):void 
		{
			drawStartY = value;
			
			if ( drawStartY > 0.0 ) drawStartY = 0.0;
			
			drawItems(false);
		}
		
		override public function draw():void 
		{
			bg.width = uiWidth;
			bg.height = uiHeight;
			
			vScrollBar.onChange.remove(vScrollBar_onChangeHandler);
			vScrollBar.setSize(14.0, uiHeight - 4.0);
			vScrollBar.x = uiWidth - 14.0 - 2.0;
			vScrollBar.y = 2.0;
			vScrollBar.onChange.add(vScrollBar_onChangeHandler);
			
			itemsContainerMask.mouseEnabled = itemsContainerMask.mouseChildren = false;
			
			itemsContainerMask.x = itemsContainer.x = 4.0;
			itemsContainerMask.y = itemsContainer.y = 4.0;
			itemsContainerMask.width = uiWidth - 14.0 - 8.0;
			itemsContainerMask.height = uiHeight - 8.0;
			
			drawItems();
		}
		
		private function clearItemsForDrawing():void
		{
			var i:int = 0;
			var n:int = vItems.length;
			
			for (; i < n; i++) 
			{
				itemsContainer.removeChild(vItems[i]);
				itemPool.releaseObject(vItems[i]);
			}
			
			if ( vItems.length ) vItems.splice(0, vItems.length);
		}
		
		public function drawItems(updateScrollBar:Boolean = true):void
		{
			if ( vScrollBar.enabled )
			{
				itemsContainerMask.width = uiWidth - 14.0 - 8.0;
			}
			else
			{
				itemsContainerMask.width = uiWidth - 8.0;
			}
			
			currentDrawX = drawStartX;
			currentDrawY = drawStartY;
			
			clearItemsForDrawing();
			
			if ( !_dataSource )
			{
				vScrollBar.enabled = false;
				return;
			}
			
			var dataProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(_dataSource);
			
			if ( !dataProvider )
			{
				vScrollBar.enabled = false;
				return;
			}
			
			if ( _showTreeRoot )
			{
				drawDataProvider(_dataSource, 4.0, 0, _dataSource);
			}
			else
			{
				var i:int = 0;
				var n:int = dataProvider.getNumChildren(_dataSource);
				
				for (; i < n; i++) 
				{
					drawDataProvider(dataProvider.getItemAt(_dataSource, i), 4.0, i, _dataSource);
				}
			}
			
			currentItemsHeight = currentDrawY - drawStartY;
			
			if ( updateScrollBar )
			{
				//vScrollBar.onChange.remove(vScrollBar_onChangeHandler);
				vScrollBar.minimum = 0.0;
				vScrollBar.maximum = -(currentItemsHeight - itemsContainerMask.height);
				//vScrollBar.onChange.add(vScrollBar_onChangeHandler);
				
				if ( currentItemsHeight <= itemsContainerMask.height )
				{
					if ( vScrollBar.enabled == true || vScrollBar.visible == true )
					{
						vScrollBar.enabled = false;
						vScrollBar.visible = false;
						drawItems(false);
					}
				}
				else
				{
					if ( vScrollBar.enabled == false || vScrollBar.visible == false )
					{
						vScrollBar.enabled = true;
						vScrollBar.visible = true;
						drawItems(false);
					}
				}
			}
		}
		
		public function drawDataProvider(dataSource:Object, indentSize:Number = 0.0, dataSourceIndex:int = -1, dataSourceParent:Object = null):void
		{
			if ( !dataSource ) return;
			
			var dataProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(dataSource);
			
			if ( !dataProvider ) return;
			
			if ( currentDrawY + ITEM_SIZE >= 0.0 && currentDrawY < itemsContainerMask.height )
			{
				var item:TreeViewItem = itemPool.getObject() as TreeViewItem;
				item.treeView = this;
				item.x = currentDrawX;
				item.y = currentDrawY;
				item.paddingLeft = indentSize;
				item.dataSource = dataSource;
				item.dataSourceIndex = dataSourceIndex;
				item.dataSourceParent = dataSourceParent;
				item.setSize(bg.width - (vScrollBar.enabled ? 14.0 : 0.0) - 8.0, ITEM_SIZE);
				
				if ( selectedDataSource == dataSource && ( selectedDataSourceIndex < 0 || ( selectedDataSourceIndex == dataSourceIndex && selectedDataSourceParent == dataSourceParent ) ) )
				{
					item.selected = true;
				}
				else if ( preSelectedDataSource == dataSource && ( preSelectedDataSourceIndex < 0 || ( preSelectedDataSourceIndex == dataSourceIndex && preSelectedDataSourceParent == dataSourceParent ) ) )
				{
					item.preSelected = true;
				}
				else
				{
					item.selected = false;
				}
				
				vItems.push(item);
				itemsContainer.addChild(item);
			}
			
			currentDrawY += ITEM_SIZE;
			
			if ( _showTree )
			{
				var dataSourceState:DataSourceState = dataSourceStateHolder.getState(dataSource);
				
				if ( dataSourceState && dataSourceState.state == DataSourceState.STATE_OPEN )
				{
					var i:int = 0;
					var n:int = dataProvider.getNumChildren(dataSource);
					
					for (; i < n; i++) 
					{
						drawDataProvider(dataProvider.getItemAt(dataSource, i), indentSize + INDENT_SIZE, i, dataSource);
					}
				}
			}
		}
		
		override public function onDropOver(dragAndDropObject:DragAndDropObject):void 
		{
			if ( !_dataSource ) return;
			if ( !_isEditable ) return;
			
			if ( !DragAndDropUtils.isObjectOfAcceptedDroppableTypes(dragAndDropObject.object, _acceptedDroppableTypes) ) return;
			
			startDraggingDataSource(dragAndDropObject);
		}
		
		override public function onDropOut(dragAndDropObject:DragAndDropObject):void 
		{
			if ( !_dataSource ) return;
			if ( !_isEditable ) return;
			
			if ( !DragAndDropUtils.isObjectOfAcceptedDroppableTypes(dragAndDropObject.object, _acceptedDroppableTypes) ) return;
			
			if ( dragAndDropObject )
			{
				this.dragAndDropObject = null;
				stopDraggingDataSource();
			}
		}
		
		override public function onDrop(dragAndDropObject:DragAndDropObject):void 
		{
			//trace(this, "onDrop", dragAndDropObject);
			if ( !_dataSource ) return;
			if ( !_isEditable ) return;
			
			if ( !DragAndDropUtils.isObjectOfAcceptedDroppableTypes(dragAndDropObject.object, _acceptedDroppableTypes) ) return;
			
			if ( dragAndDropObject )
			{
				stopDraggingDataSource();
			}
		}
		
		public function startDraggingDataSource(dragAndDropObject:DragAndDropObject):void
		{
			//trace("startDraggingDataSource", dragAndDropObject);
			this.dragAndDropObject = dragAndDropObject;
			
			if ( dragAndDropObject )
			{
				eManager.add(stage, Event.ENTER_FRAME, drag_onEnterFrameHandler, [eGroup, eGroup + ".drag"]);
			}
		}
		
		private function drag_onEnterFrameHandler(e:Event):void 
		{
			dragOnDataSource = null;
			
			if ( !dataSource ) return;
			
			// check first if we are not near the top or the end of the visible list
			if ( vScrollBar.enabled )
			{
				if ( itemsContainer.mouseY <= dragScrollMaxDistance )
				{
					// scroll up
					//vScrollBar.value -= 0.05 * ((dragScrollMaxDistance - itemsContainer.mouseY) / dragScrollMaxDistance);
					vScrollBar.value += ITEM_SIZE * 0.25 * ((dragScrollMaxDistance - itemsContainer.mouseY) / dragScrollMaxDistance);
				}
				else if (itemsContainer.mouseY >= itemsContainerMask.height - dragScrollMaxDistance )
				{
					// scroll down
					//vScrollBar.value += 0.05 * ((itemsContainer.mouseY - (itemsContainerMask.height - dragScrollMaxDistance)) / dragScrollMaxDistance);
					vScrollBar.value -= ITEM_SIZE * 0.25 * ((itemsContainer.mouseY - (itemsContainerMask.height - dragScrollMaxDistance)) / dragScrollMaxDistance);
				}
			}
			
			// get item we are currently over
			var i:int = 0;
			var n:int = vItems.length;
			var item:TreeViewItem;
			var overItem:TreeViewItem;
			
			dragIn.visible = false;
			dragInBetween.visible = false;
			
			for (; i < n; i++) 
			{
				item = vItems[i];
				
				if ( itemsContainer.mouseX >= item.x && itemsContainer.mouseX <= item.x + item.uiWidth && itemsContainer.mouseY >= item.y && itemsContainer.mouseY <= item.y + item.uiHeight )
				{
					if( item.dataSource != dragAndDropObject.object ) overItem = item;
					break;
				}
			}
			
			if ( overItem )
			{
				//trace(overItem.x, overItem.y, overItem.uiWidth, overItem.uiHeight, itemsContainer.mouseX, itemsContainer.mouseY);
				dragOnDataSource = overItem.dataSource;
				
				// check if we are near the border of the item
				if ( allowDropBeforeItem && item.mouseY <= 3.0 )
				{
					dragType = DRAG_TYPE_BEFORE;
					
					dragInBetween.visible = true;
					dragInBetween.x = itemsContainer.x + overItem.x;
					dragInBetween.y = itemsContainer.y + overItem.y;
					dragInBetween.width = overItem.uiWidth;
				}
				else if ( allowDropAfterItem && item.mouseY > item.uiHeight - 3.0 )
				{
					dragType = DRAG_TYPE_AFTER;
					
					dragInBetween.visible = true;
					dragInBetween.x = itemsContainer.x + overItem.x;
					dragInBetween.y = itemsContainer.y + overItem.y + overItem.uiHeight;
					dragInBetween.width = overItem.uiWidth;
				}
				else if ( allowDropInItem )
				{
					dragType = DRAG_TYPE_IN;
					
					dragIn.visible = true;
					dragIn.x = itemsContainer.x + overItem.x;
					dragIn.y = itemsContainer.y + overItem.y;
					dragIn.width = overItem.uiWidth;
					dragIn.height = overItem.uiHeight;
				}
			}
			else if ( hitTestPoint(stage.mouseX, stage.mouseY, true) )
			{
				dragOnDataSource = dataSource;
				dragType = DRAG_TYPE_IN_EMPTY;
				
				dragInBetween.visible = true;
				dragInBetween.x = itemsContainer.x;
				dragInBetween.y = itemsContainer.y + currentDrawY;
				dragInBetween.width = bg.width - (vScrollBar.enabled ? 14.0 : 0.0) - 8.0;
			}
		}
		
		public function stopDraggingDataSource():void
		{
			//trace("stopDraggingDataSource", dragOnDataSource, dragAndDropObject);
			
			var needDrawingItems:Boolean = false;
			
			if ( dragOnDataSource && dragAndDropObject )
			{
				var dataSourceProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(dataSource);
				var dragOnDataSourceParent:Object = dataProviderManager.getParentForDataSourceInContainer(dataSource, dragOnDataSource);
				var dragOnDataSourceParentProvider:DataProviderBase;
				var dragOnDataSourceIndex:int;
				
				var dragOnDataSourceProvider:DataProviderBase
				
				if ( dragOnDataSourceParent )
				{
					dragOnDataSourceParentProvider = dataProviderManager.getDataProviderForDataSource(dragOnDataSourceParent);
					dragOnDataSourceIndex = dragOnDataSourceParentProvider.getItemIndex(dragOnDataSourceParent, dragOnDataSource);
				}
				
				//trace("stopDraggingDataSource", dragOnDataSource, dragAndDropObject, dragOnDataSourceParent, dragOnDataSourceIndex, dragType);
				
				if ( allowDropBeforeItem && dragType == DRAG_TYPE_BEFORE )
				{
					needDrawingItems = true;
					
					if ( copyItemOnDropIfInitiatorIsDifferent && dragAndDropObject.initiator && dragAndDropObject.initiator != this )
					{
						dataProviderManager.copyDataSourceTo(dragAndDropObject.object, dataSource, dragOnDataSourceIndex);
					}
					else
					{
						dataProviderManager.moveDataSourceAt(dragAndDropObject.object, dragAndDropObject.objectParent, dragAndDropObject.objectIndex, dragOnDataSourceParent, dragOnDataSourceIndex);
					}
				}
				else if ( allowDropInItem && dragType == DRAG_TYPE_IN )
				{
					needDrawingItems = true;
					
					if ( copyItemOnDropIfInitiatorIsDifferent && dragAndDropObject.initiator && dragAndDropObject.initiator != this )
					{
						dragOnDataSourceProvider = dataProviderManager.getDataProviderForDataSource(dragOnDataSource);
						dataProviderManager.copyDataSourceTo(dragAndDropObject.object, dragOnDataSource, dragOnDataSourceProvider.getNumChildren(dragOnDataSource));
					}
					else
					{
						dataProviderManager.moveDataSourceAt(dragAndDropObject.object, dragAndDropObject.objectParent, dragAndDropObject.objectIndex, dragOnDataSource, 0);
					}
				}
				else if ( dragType == DRAG_TYPE_AFTER )
				{
					needDrawingItems = true;
					
					// check first if dragOnDataSource is open and has children
					var dragOnDataSourceState:DataSourceState = dataSourceStateHolder.getState(dragOnDataSource);
					var dragOnDataProvider:DataProviderBase = dataProviderManager.getDataProviderForDataSource(dragOnDataSource);
					
					if ( allowDropInItem && dragOnDataSourceState && dragOnDataSourceState.state == DataSourceState.STATE_OPEN && dragOnDataProvider && dragOnDataProvider.getNumChildren(dragOnDataSource) > 0 )
					{
						if ( copyItemOnDropIfInitiatorIsDifferent && dragAndDropObject.initiator && dragAndDropObject.initiator != this )
						{
							dataProviderManager.copyDataSourceTo(dragAndDropObject.object, dragOnDataSource, -1);
						}
						else
						{
							dataProviderManager.moveDataSourceAt(dragAndDropObject.object, dragAndDropObject.objectParent, dragAndDropObject.objectIndex, dragOnDataSource, 0);
						}
					}
					else if ( allowDropAfterItem )
					{
						if ( copyItemOnDropIfInitiatorIsDifferent && dragAndDropObject.initiator && dragAndDropObject.initiator != this )
						{
							dataProviderManager.copyDataSourceTo(dragAndDropObject.object, dataSource, dragOnDataSourceIndex + 1);
						}
						else
						{
							dataProviderManager.moveDataSourceAt(dragAndDropObject.object, dragAndDropObject.objectParent, dragAndDropObject.objectIndex, dragOnDataSourceParent, dragOnDataSourceIndex + 1);
						}
					}
				}
				else if ( dragType == DRAG_TYPE_IN_EMPTY )
				{
					if ( copyItemOnDropIfInitiatorIsDifferent && dragAndDropObject.initiator && dragAndDropObject.initiator != this )
					{
						needDrawingItems = true;
						
						dragOnDataSourceProvider = dataProviderManager.getDataProviderForDataSource(dragOnDataSource);
						dataProviderManager.copyDataSourceTo(dragAndDropObject.object, dragOnDataSource, dragOnDataSourceProvider.getNumChildren(dragOnDataSource));
					}
				}
			}
			
			if ( preSelectedDataSource )
			{
				preSelectedDataSource = null;
				needDrawingItems = true;
			}
			
			eManager.removeAllFromGroup(eGroup + ".drag");
			dragAndDropObject = null;
			dragOnDataSource = null;
			dragType = 0;
			dragIn.visible = false;
			dragInBetween.visible = false;
			
			if( needDrawingItems ) drawItems();
		}
		
		override public function get dataSource():Object 
		{
			return super.dataSource;
		}
		
		override public function set dataSource(value:Object):void 
		{
			super.dataSource = value;
			drawItems();
		}
		
		public function getSelectedDataSource():Object
		{
			return selectedDataSource;
		}
		
		public function setSelectedDataSource(dataSource:Object, dataSourceIndex:int = -1, dataSourceParent:Object = null):void
		{
			if ( selectedDataSource == dataSource && selectedDataSourceIndex == dataSourceIndex && selectedDataSourceParent == dataSourceParent ) return;
			
			selectedDataSource = dataSource;
			selectedDataSourceIndex = dataSourceIndex;
			selectedDataSourceParent = dataSourceParent;
			
			drawItems();
		}
		
		public function getPreSelectedDataSource():Object
		{
			return preSelectedDataSource;
		}
		
		public function setPreSelectedDataSource(dataSource:Object, dataSourceIndex:int = -1, dataSourceParent:Object = null):void
		{
			preSelectedDataSource = dataSource;
			preSelectedDataSourceIndex = dataSourceIndex;
			preSelectedDataSourceParent = dataSourceParent;
			
			if ( preSelectedDataSource )
			{
				drawItems();
				
				eManager.add(stage, MouseEvent.MOUSE_UP, stage_mouseUpForDragHandler, [eGroup, eGroup + ".drag"]);
				
				if ( isEditable || isItemDraggable )
				{
					// check if we are trying to drag this item somewhere
					pDragStartPos.x = stage.mouseX;
					pDragStartPos.y = stage.mouseY;
					//eManager.add(stage, MouseEvent.MOUSE_UP, stage_mouseUpForDragHandler, [eGroup, eGroup + ".drag"]);
					eManager.add(stage, MouseEvent.MOUSE_MOVE, stage_mouseMoveForDragHandler, [eGroup, eGroup + ".drag", eGroup + ".dragMove"]);
				}
			}
		}
		
		private function stage_mouseMoveForDragHandler(e:MouseEvent):void 
		{
			pDragEndPos.x = stage.mouseX;
			pDragEndPos.y = stage.mouseY;
			
			if ( Point.distance(pDragStartPos, pDragEndPos) >= dragMinDistance )
			{
				eManager.removeAllFromGroup(eGroup + ".dragMove");
				
				//trace("start dragging");
				// start dragging
				var dado:DragAndDropObject = new DragAndDropObject();
				dado.object = preSelectedDataSource;
				dado.initiator = this;
				dado.objectIndex = preSelectedDataSourceIndex;
				dado.objectParent = preSelectedDataSourceParent;
				
				//trace(this, "stage_mouseMoveForDragHandler", dado.object, "///", dado.initiator, dado.objectIndex, dado.objectParent); 
				
				dragAndDropManager.startDrag(dado);
			}
		}
		
		private function stage_mouseUpForDragHandler(e:MouseEvent):void 
		{
			//trace("stage_mouseUpForDragHandler");
			stopDraggingDataSource();
		}
		
		public function get isItemDraggable():Boolean 
		{
			return _isItemDraggable;
		}
		
		public function set isItemDraggable(value:Boolean):void 
		{
			_isItemDraggable = value;
			//trace("isItemDraggable");
			if ( !_isItemDraggable ) stopDraggingDataSource();
		}
		
		public function get showTree():Boolean 
		{
			return _showTree;
		}
		
		public function set showTree(value:Boolean):void 
		{
			_showTree = value;
			drawItems();
		}
		
		public function get isEditable():Boolean 
		{
			return _isEditable;
		}
		
		public function set isEditable(value:Boolean):void 
		{
			_isEditable = value;
		}
		
		public function get allowDeleteItem():Boolean 
		{
			return _allowDeleteItem;
		}
		
		public function set allowDeleteItem(value:Boolean):void 
		{
			if ( _allowDeleteItem == value ) return;
			_allowDeleteItem = value;
			draw();
		}
		
		public function get showTreeRoot():Boolean 
		{
			return _showTreeRoot;
		}
		
		public function set showTreeRoot(value:Boolean):void 
		{
			if ( _showTreeRoot == value ) return;
			_showTreeRoot = value;
			draw();
		}
		
		override public function disposeForPool():void 
		{
			super.disposeForPool();
			vScrollBar.onChange.removeAll();
			onSelect.removeAll();
			clearItemsForDrawing();
			dataSource = null;
			selectedDataSource = null;
			preSelectedDataSource = null;
			_allowDeleteItem = false;
		}
		
		override public function dispose():void 
		{
			super.dispose();
			onSelect.removeAll();
			clearItemsForDrawing();
			dataSource = null;
			selectedDataSource = null;
			preSelectedDataSource = null;
			vItems = null;
			vScrollBar.dispose();
			vScrollBar = null;
		}
	}

}