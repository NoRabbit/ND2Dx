package com.rabbitframework.managers.assets 
{
	import flash.net.URLVariables;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public interface IAsset extends IAssetCore
	{
		function init(id:String, url:String, autoStartLoad:Boolean = false, maxRetries:int = 3, timeOutDelay:int = 3000):void;
		
		function set url(value:String):void;
		function get url():String;
		
		function set maxRetries(value:int):void;
		function get maxRetries():int;
		
		function set retriesCount(value:int):void;
		function get retriesCount():int;
		
		function set timeOutDelay(value:Number):void;
		function get timeOutDelay():Number;
		
		function get httpStatus():int;
		
		function set method(value:String):void;
		function get method():String;
		
		function set dataFormat(value:String):void;
		function get dataFormat():String;
		
		function set variables(value:URLVariables):void;
		function get variables():URLVariables;
		
		function addLoaderEvents():void;
		function removeLoaderEvents():void;
		
		function getContent():*;
		
		
	}
	
}