package com.rabbitframework.utils 
{
	WGM::IS_EDITOR
	{
		import flash.filesystem.File;
	}
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @copyright Copyright Thomas John, all rights reserved 2011.
	 */
	public class FileUtils 
	{
		public static var aProtocols:Array = ["http:", "ftp:"];
		
		public static function isLocal(file:String):Boolean
		{
			var i:int = 0;
			var n:int = aProtocols.length;
			
			// check if one of the known protocols is being used
			for (i = 0; i < n; i++) 
			{
				if ( file.indexOf(aProtocols[i]) >= 0 ) return false;
			}
			
			// check if app is local or remote
			if ( !StageUtil.isLocal() ) return false;
			
			// if everything fails, then it must be local
			return true;
		}
		
		public static function getDirectoryOrFileFromPath(file:String, getDirectory:Boolean = true, keepSeparatorAtEndOfDirectory:Boolean = true):String
		{
			if ( file.indexOf("/") >= 0 )
			{
				if ( getDirectory )
				{
					return StringUtils.getBefore(file, "/", true) + (keepSeparatorAtEndOfDirectory ? "/" : "");
				}
				else
				{
					return StringUtils.getAfter(file, "/", true);
				}
			}
			else if ( file.indexOf("\\") >= 0 )
			{
				if ( getDirectory )
				{
					return StringUtils.getBefore(file, "\\", true) + (keepSeparatorAtEndOfDirectory ? "\\" : "");
				}
				else
				{
					return StringUtils.getAfter(file, "\\", true);
				}
			}
			
			return "";
		}
		
		public static function getRelativePath(rootPath:String, filePath:String):String
		{
			WGM::IS_EDITOR
			{
				var rootDir:File = new File(getDirectoryOrFileFromPath(rootPath));
				return rootDir.getRelativePath(new File(filePath));
			}
			
			return filePath;
		}
	}
	
}