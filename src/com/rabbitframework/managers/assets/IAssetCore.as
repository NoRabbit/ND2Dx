package com.rabbitframework.managers.assets 
{
	import com.rabbitframework.utils.IDisposable;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public interface IAssetCore extends IDisposable
	{
		function load():void;
		function close():void;
		
		function addGroup(group:IAssetGroup):void;
		function removeGroup(group:IAssetGroup):void;
		
		function isInGroupId(groupId:String):Boolean;
		
		function set id(value:String):void;
		function get id():String;
		
		function set status(value:int):void;
		function get status():int;
		
		function get bytesLoaded():int;
		
		function set bytesTotal(value:int):void;
		function get bytesTotal():int;
		
		function get percentLoaded():Number;
		
		function set preventCache(value:Boolean):void;
		function get preventCache():Boolean;
		
		function set preventCacheId(value:String):void;
		function get preventCacheId():String;
	}
	
}