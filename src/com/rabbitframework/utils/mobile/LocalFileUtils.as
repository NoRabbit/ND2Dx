package com.rabbitframework.utils.mobile 
{
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	/**
	 * ...
	 * @author Thomas John
	 */
	public class LocalFileUtils 
	{
		
		public static function writeObjectToLocalFile(fileName:String, data:Object):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeObject(data);
			fileStream.close()
		}
		
		public static function writeStringToLocalFile(fileName:String, data:String):void
		{
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.WRITE);
			fileStream.writeUTF(data);
			fileStream.close()
		}
		
		public static function readObjectFromLocalFile(fileName:String):Object
		{
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
			
			if ( !file.exists ) return null;
			
			var fileStream:FileStream = new FileStream();
			
			fileStream.open(file, FileMode.READ);
			var data:Object = fileStream.readObject();
			fileStream.close();
			
			return data;
		}
		
		public static function readStringFromLocalFile(fileName:String):String
		{
			var file:File = File.applicationStorageDirectory.resolvePath(fileName);
			
			if ( !file.exists ) return null;
			
			var fileStream:FileStream = new FileStream();
			
			fileStream.open(file, FileMode.READ);
			var data:String = fileStream.readUTF();
			fileStream.close();
			
			return data;
		}
		
	}

}