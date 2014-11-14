package com.rabbitframework.utils 
{
	
	/**
	 * ...
	 * @author Thomas John
	 */
	public interface IPoolable extends IDisposable
	{
		function initFromPool():void
		function disposeForPool():void
	}
	
}