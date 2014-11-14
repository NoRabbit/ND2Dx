package com.rabbitframework.ui.dataprovider 
{
	/**
	 * ...
	 * @author Thomas John
	 */
	public class StringDataProvider extends DataProviderBase
	{
		
		public function StringDataProvider() 
		{
			
		}
		
		override public function getLabel(dataSource:Object):String 
		{
			return String(dataSource);
		}
	}

}