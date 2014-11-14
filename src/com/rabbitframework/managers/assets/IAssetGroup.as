package com.rabbitframework.managers.assets 
{
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public interface IAssetGroup extends IAssetCore
	{
		function loadNextAssets():void;
		function loadNextAsset():Boolean;
		function loadAsset(asset:IAssetCore, suspendCurrentLoadingAsset:Boolean = false):void;
		
		function addChild(child:IAssetCore):void;
		function removeChild(child:IAssetCore):void;
		
		function addChildEvents(child:IAssetCore):void;
		function removeChildEvents(child:IAssetCore):void;
		
		function get currentLoadingAsset():IAssetCore;
		function get totalAssets():int;
		function get totalLoadingAssets():int;
		function get totalCompletedAssets():int;
		function get totalIdleAssets():int;
		
		function set maxSimultaneousLoadingAssets(value:int):void;
		function get maxSimultaneousLoadingAssets():int;
	}
	
}