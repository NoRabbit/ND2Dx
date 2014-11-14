package com.rabbitframework.managers.languages 
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	/**
	 * Singleton class
	 * @author Thomas John (thomas.john@open-design.be)
	 */
	public class LanguagesManager extends EventDispatcher
	{
		// our unique instance of this class
		private static var instance:LanguagesManager = new LanguagesManager();
		
		// list of supported languages
		public var aListLanguages:Array;
		
		// object containing frame number for each language
		public var oLanguagesFrame:Object;
		
		// default language
		public var sDefaultLanguage:String;
		
		// current language
		public var currentLg:String = "";
		
		/**
		 * Check if an instance already exists and if it does throw an error
		 */
		public function LanguagesManager() 
		{
			if ( instance ) throw new Error( "LanguagesManager can only be accessed through LanguagesManager.getInstance()" );
			//...
			
		}
		
		/**
		 * Get unique instance of this singleton class
		 * @return					<LanguagesManager> Instance of this class
		 */
		public static function getInstance():LanguagesManager
		{
			return instance;
		}
		
		/**
		 * Sets a list of supported language
		 * @param	s_list List of supported languages separated by a ","
		 */
		public function setListSupportedLanguages(s_list:String):void
		{
			// get the list of all supported languages
			aListLanguages = s_list.split(",");
			
			// if no language, stop here
			if ( aListLanguages.length < 1 ) return;
			
			// create a new object containing frame number for each language
			oLanguagesFrame = new Object();
			
			// loop through list
			var i:int = 0;
			var n:int = aListLanguages.length;
			
			for (i = 0 ; i < n ; i++)
			{
				// frame number for this language
				oLanguagesFrame[aListLanguages[i]] = i + 1;
			}
		}
		
		/**
		 * Set current language
		 */
		public function set lg(value:String):void
		{
			setLanguage(value);
		}
		
		/**
		 * Get current language
		 */
		public function get lg():String
		{
			return currentLg;
		}
		
		// set the language
		private function setLanguage(lg:String):void
		{
			if ( lg == "" ) return;
			
			if ( lg != currentLg )
			{
				// ok, set it as current one
				currentLg = lg;
				
				dispatchEvent( new Event(Event.CHANGE) );
			}
		}
		
		// get a frame number for the current language
		public function getFrame():uint
		{
			// is there a current language ? default frame is 1
			if ( currentLg == "" ) return 1;
			
			//trace("getFrame", currentLg, oLanguagesFrame, oLanguagesFrame[currentLg]);
			
			// is the object ok ?
			if ( oLanguagesFrame )
			{
				// is the current language in the object ?
				if ( oLanguagesFrame[currentLg] )
				{
					// yep, return its value
					return oLanguagesFrame[currentLg];
				}
			}
			
			// nothing ?, 1 by default
			return 1;
		}
	}
	
}