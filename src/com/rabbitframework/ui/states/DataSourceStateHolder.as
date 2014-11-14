package com.rabbitframework.ui.states 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DataSourceStateHolder 
	{
		public var dStateForDataSource:Dictionary = new Dictionary();
		
		public function DataSourceStateHolder() 
		{
			
		}
		
		public function setState(dataSource:Object, state:uint):DataSourceState
		{
			var dataSourceState:DataSourceState = dStateForDataSource[dataSource] as DataSourceState;
			if ( !dataSourceState ) dataSourceState = dStateForDataSource[dataSource] = new DataSourceState(dataSource, state);
			dataSourceState.state = state;
			return dataSourceState;
		}
		
		public function getState(dataSource:Object, createIfDoesNotExist:Boolean = false, defaultState:uint = 0):DataSourceState
		{
			var dataSourceState:DataSourceState = dStateForDataSource[dataSource] as DataSourceState;
			if ( !dataSourceState && createIfDoesNotExist ) dataSourceState = dStateForDataSource[dataSource] = new DataSourceState(dataSource, defaultState);
			return dataSourceState;
		}
		
		public function removeState(dataSource:Object):void
		{
			delete dStateForDataSource[dataSource];
		}
	}

}