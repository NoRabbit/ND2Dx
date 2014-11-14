package com.rabbitframework.ui.dataprovider 
{
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	
	/**
	 * Singleton class
	 * @author Thomas John
	 * @copyright (c) Thomas John
	 */
	public class DataProviderManager 
	{
		private static var instance:DataProviderManager = new DataProviderManager();
		
		public function DataProviderManager() 
		{
			if ( instance ) throw new Error( "DataProviderManager can only be accessed through DataProviderManager.getInstance()" );
			
			registerDataProviderForDataSourceClass(Object, new ObjectDataProvider());
			registerDataProviderForDataSourceClass(String, new StringDataProvider());
			registerDataProviderForDataSourceClass(Array, new ArrayDataProvider());
			registerDataProviderForDataSourceClass(BitmapData, new BitmapDataProvider());
			registerDataProviderForDataSourceClass(DisplayObjectContainer, new DisplayObjectContainerDataProvider());
			registerDataProviderForDataSourceClass(DisplayObject, new DisplayObjectDataProvider());
		}
		
		public static function getInstance():DataProviderManager 
		{
			return instance;
		}
		
		private var dDataProviderForDataSource:Dictionary = new Dictionary();
		
		public function registerDataProviderForDataSourceClass(dataSourceClass:Class, dataProvider:DataProviderBase):void
		{
			dDataProviderForDataSource[dataSourceClass] = dataProvider;
		}
		
		public function getDataProviderForDataSourceClass(dataSourceClass:Class):DataProviderBase
		{
			return dDataProviderForDataSource[dataSourceClass];
		}
		
		public function getDataProviderForDataSource(dataSource:Object):DataProviderBase
		{
			var dataSourceClassName:String = getQualifiedClassName(dataSource);
			var dataSourceClass:Class = getDefinitionByName(dataSourceClassName) as Class;
			
			var dataProvider:DataProviderBase = dDataProviderForDataSource[dataSourceClass];
			
			if ( !dataProvider )
			{
				var i:int = 20;
				
				while (i >= 0) 
				{
					i--;
					
					dataSourceClassName = getQualifiedSuperclassName(dataSourceClass);
					
					//trace(dataSourceClassName);
					
					if ( !dataSourceClassName ) return null;
					
					dataSourceClass = getDefinitionByName(dataSourceClassName) as Class;
					
					//trace(dataSourceClass);
					
					dataProvider = dDataProviderForDataSource[dataSourceClass];
					
					if ( dataProvider ) return dataProvider;
				}
			}
			
			return dataProvider;
		}
		
		public function getDataSourceLabel(dataSource:Object):String
		{
			if ( dataSource === null ) return "";
			var dataProvider:DataProviderBase = getDataProviderForDataSource(dataSource);
			if ( dataProvider ) return dataProvider.getLabel(dataSource);
			return "";
		}
		
		public function getDataSourceIcon(dataSource:Object):BitmapData
		{
			if ( dataSource === null ) return null;
			var dataProvider:DataProviderBase = getDataProviderForDataSource(dataSource);
			if ( dataProvider ) return dataProvider.getIcon(dataSource);
			return null;
		}
		
		public function getDataSourceParent(dataSource:Object, dataSourceInitial:Object):Object
		{
			if ( !dataSource ) return null;
			if ( !dataSourceInitial ) return null;
			
			var dataSourceParent:Object = null;
			var dataProvider:DataProviderBase = getDataProviderForDataSource(dataSource);
			
			if ( dataProvider ) dataSourceParent = dataProvider.getParent(dataSource);
			
			if( !dataSourceParent ) dataSourceParent = lookForDataSourceInParent(dataSourceInitial, dataSource);
			
			return dataSourceParent;
		}
		
		public function lookForDataSourceInParent(dataSourceParent:Object, dataSource:Object):Object
		{
			if ( !dataSourceParent ) return null;
			
			var dataProvider:DataProviderBase = getDataProviderForDataSource(dataSourceParent);
			
			if ( !dataProvider ) return null;
			
			var i:int = 0;
			var n:int = dataProvider.getNumChildren(dataSourceParent);
			var currentDataSource:Object = null;
			
			for (; i < n; i++) 
			{
				currentDataSource = dataProvider.getItemAt(dataSourceParent, i);
				
				if ( currentDataSource == dataSource ) return dataSourceParent;
				
				currentDataSource = lookForDataSourceInParent(currentDataSource, dataSource);
				
				if ( currentDataSource ) return currentDataSource;
			}
			
			return null;
		}
		
		public function removeDataSourceFromParent(dataSourceToRemove:Object, dataSourceInitial:Object):Object
		{
			var dataSourceToRemoveParent:Object = getDataSourceParent(dataSourceToRemove, dataSourceInitial);
			
			if ( dataSourceToRemoveParent )
			{
				var dataProvider:DataProviderBase = getDataProviderForDataSource(dataSourceToRemoveParent);
				if ( dataProvider ) dataProvider.removeItem(dataSourceToRemoveParent, dataSourceToRemove);
			}
			
			return dataSourceToRemoveParent;
		}
		
		public function moveDataSourceBefore(dataSourceToMove:Object, dataSourceTarget:Object, dataSourceInitial:Object):void
		{
			// get parent of target
			var dataSourceTargetParent:Object = getDataSourceParent(dataSourceTarget, dataSourceInitial);
			
			if ( dataSourceTargetParent && (dataSourceTargetParent != dataSourceToMove) )
			{
				var dataProvider:DataProviderBase = getDataProviderForDataSource(dataSourceTargetParent);
				
				if ( dataProvider && dataProvider.canContainChildren(dataSourceTargetParent) )
				{
					// remove dataSourceToMove from its parent
					removeDataSourceFromParent(dataSourceToMove, dataSourceInitial);
					
					// get index of target in parent
					var index:int = dataProvider.getItemIndex(dataSourceTargetParent, dataSourceTarget);
					
					// and add our moving dataSource before our target
					dataProvider.addItemAt(dataSourceTargetParent, dataSourceToMove, index);
				}
			}
		}
		
		public function moveDataSourceIn(dataSourceToMove:Object, dataSourceTarget:Object, dataSourceInitial:Object, index:int = -1):void
		{
			if ( dataSourceToMove == dataSourceTarget ) return;
			
			// then add it to target
			var dataProvider:DataProviderBase = getDataProviderForDataSource(dataSourceTarget);
				
			if ( dataProvider && dataProvider.canContainChildren(dataSourceTarget) )
			{
				// remove dataSourceToMove from its parent
				removeDataSourceFromParent(dataSourceToMove, dataSourceInitial);
				
				if ( index >= 0 )
				{
					dataProvider.addItemAt(dataSourceTarget, dataSourceToMove, index);
				}
				else
				{
					dataProvider.addItem(dataSourceTarget, dataSourceToMove);
				}
			}
		}
		
		public function moveDataSourceAfter(dataSourceToMove:Object, dataSourceTarget:Object, dataSourceInitial:Object):void
		{
			//trace("moveDataSourceAfter", dataSourceToMove, dataSourceTarget, dataSourceInitial);
			
			// get parent of target
			var dataSourceTargetParent:Object = getDataSourceParent(dataSourceTarget, dataSourceInitial);
			
			if ( dataSourceTargetParent && (dataSourceTargetParent != dataSourceToMove) )
			{
				var dataProvider:DataProviderBase = getDataProviderForDataSource(dataSourceTargetParent);
				
				if ( dataProvider && dataProvider.canContainChildren(dataSourceTargetParent) )
				{
					// remove dataSourceToMove from its parent
					removeDataSourceFromParent(dataSourceToMove, dataSourceInitial);
					
					// get index of target in parent
					var index:int = dataProvider.getItemIndex(dataSourceTargetParent, dataSourceTarget);
					
					// and add our moving dataSource after our target
					dataProvider.addItemAt(dataSourceTargetParent, dataSourceToMove, index + 1);
				}
			}
		}
		
		public function moveDataSourceAt(dataSourceToMove:Object, dataSourceToMoveParent:Object, dataSourceToMoveIndex:int, dataSourceTarget:Object, index:int):void
		{
			//trace("moveDataSourceAt dataSourceToMove", dataSourceToMove);
			//trace("moveDataSourceAt dataSourceToMoveContainer", dataSourceToMoveParent);
			//trace("moveDataSourceAt dataSourceToMoveIndex", dataSourceToMoveIndex);
			//trace("moveDataSourceAt dataSourceTarget", dataSourceTarget);
			//trace("moveDataSourceAt index", index);
			
			// get direct parent of dataSourceToMove in dataSourceToMoveContainer
			//var dataSourceToMoveParent:Object = getParentForDataSourceInContainer(dataSourceToMoveContainer, dataSourceToMove);
			
			//trace("dataSourceToMoveParent", dataSourceToMoveParent);
			
			if ( !dataSourceToMoveParent ) return;
			
			var dataSourceToMoveParentProvider:DataProviderBase = getDataProviderForDataSource(dataSourceToMoveParent);
			var dataSourceTargetProvider:DataProviderBase = getDataProviderForDataSource(dataSourceTarget);
			
			if ( !dataSourceToMoveParentProvider ) return;
			if ( !dataSourceTargetProvider ) return;
			
			if ( !dataSourceTargetProvider.canContainChildren(dataSourceTarget) ) return;
			
			//if ( dataSourceToMoveParent == dataSourceTarget && dataSourceToMoveParentProvider.getItemIndex(dataSourceToMoveParent, dataSourceToMove) < index ) index --;
			if ( dataSourceToMoveParent == dataSourceTarget && dataSourceToMoveIndex < index ) index --;
			
			//dataSourceToMoveParentProvider.removeItem(dataSourceToMoveParent, dataSourceToMove);
			dataSourceToMoveParentProvider.removeItemAt(dataSourceToMoveParent, dataSourceToMoveIndex);
			dataSourceTargetProvider.addItemAt(dataSourceTarget, dataSourceToMove, index);
		}
		
		public function copyDataSourceTo(dataSourceToCopy:Object, dataSourceTarget:Object, index:int):void
		{
			var dataSourceTargetProvider:DataProviderBase = getDataProviderForDataSource(dataSourceTarget);
			if ( !dataSourceTargetProvider.canContainChildren(dataSourceTarget) ) return;
			dataSourceTargetProvider.addItemAt(dataSourceTarget, dataSourceToCopy, index);
		}
		
		public function getParentForDataSourceInContainer(container:Object, dataSource:Object):Object
		{
			//trace("getParentForDataSourceInContainer", container, dataSource);
			
			if ( !container ) return null;
			
			var containerProvider:DataProviderBase = getDataProviderForDataSource(container);
			
			if ( !containerProvider ) return null;
			
			var i:int = 0;
			var n:int = containerProvider.getNumChildren(container);
			var currentDataSource:Object = null;
			
			for (; i < n; i++) 
			{
				currentDataSource = containerProvider.getItemAt(container, i);
				
				if ( currentDataSource == dataSource ) return container;
				
				currentDataSource = getParentForDataSourceInContainer(currentDataSource, dataSource);
				
				if ( currentDataSource ) return currentDataSource;
			}
			
			return null;
		}
	}
	
}