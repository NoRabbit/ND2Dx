package com.rabbitframework.ui.states 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class DataSourceState 
	{
		public static const STATE_NONE:uint = 0;
		public static const STATE_CLOSED:uint = 1;
		public static const STATE_OPEN:uint = 2;
		
		public var dataSource:Object;
		public var state:uint = STATE_NONE;
		
		public function DataSourceState(dataSource:Object, state:uint) 
		{
			this.dataSource = dataSource;
			this.state = state;
		}
		
	}

}