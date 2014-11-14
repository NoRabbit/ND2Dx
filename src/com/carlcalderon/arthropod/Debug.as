/**
* Debug
* Designed for version 0.96.7 to 1.0 of the Arthropod Debugger.
* 
* USE AT YOUR OWN RISK!
* Any trace that is made with arthropod may be viewed by others.
* The main purpose of arthropod and this debug class is to debug
* unpublished AIR applications or sites in their real 
* environment (such as a web-browser). Future versions of
* Arthropod may change the trace-engine pattern and may cause
* traces for older versions not work properly.
* 
* A big thanks goes out to:
* Stockholm Postproduction - www.stopp.se
* Lee Brimelow - www.theflashblog.com 
* 
* @author Carl Calderon 2008
* @version 0.74
* @link http.//www.carlcalderon.com/
* @since 0.72
*/

package com.carlcalderon.arthropod {
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Stage;
	import flash.events.StatusEvent;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.net.LocalConnection;
	import flash.system.System;
	import flash.utils.ByteArray;

	public class Debug {
		
		/**
		 * Version control
		 */
		public static const NAME		:String = 'Debug';
		public static const VERSION		:String = '0.74';
		
		/**
		 * Privacy
		 * By setting this password, you need to enter the
		 * same in "Arthropod -> Settings -> Connection Password"
		 * to be able to see the traces.
		 * 
		 * default: 'CDC309AF';
		 */
		public static var password		:String = 'CDC309AF';
		
		/**
		 * Predefined colors
		 */
		public static var RED			:uint = 0xCC0000;
		public static var GREEN			:uint = 0x00CC00;
		public static var BLUE			:uint = 0x6666CC;
		public static var PINK			:uint = 0xCC00CC;
		public static var YELLOW		:uint = 0xCCCC00;
		public static var LIGHT_BLUE	:uint = 0x00CCCC;
		
		/**
		 * Status event
		 * If false, arthropod will trace error messages.
		 */
		public static var ignoreStatus		:Boolean = true;
		
		/**
		 * Security (not tested)
		 * If secure is true, only the <code>secureDomain</code> will be accepted.
		 */
		public static var secure			:Boolean = false;
		
		/**
		 * A single domain to be used as the secure domain. (not tested)
		 */
		public static var secureDomain		:String	 = '*';
		
		/**
		 * Switches tracing on/off.
		 * TIP: Set this switch to false before release of AIR applications.
		 */
		public static var allowLog			:Boolean = true;
		
		/**
		 * DO NOT CHANGE THESE VALUES! IF CHANGED, ARTHROPOD MIGHT NOT WORK PROPERLY!
		 */
		private static const DOMAIN			:String = 'com.carlcalderon.Arthropod';
		private static const CHECK			:String = '.161E714B6C1A76DE7B9865F88B32FCCE8FABA7B5.1';
		private static const TYPE			:String = 'app';
		private static const CONNECTION		:String = 'arthropod';
		
		private static const LOG_OPERATION		:String = 'debug';
		private static const ERROR_OPERATION	:String = 'debugError';
		private static const WARNING_OPERATION	:String = 'debugWarning';
		private static const ARRAY_OPERATION	:String = 'debugArray';
		private static const BITMAP_OPERATION	:String = 'debugBitmapData';
		private static const OBJECT_OPERATION	:String = 'debugObject';
		private static const MEMORY_OPERATION	:String = 'debugMemory';
		private static const CLEAR_OPERATION	:String = 'debugClear';
		
		private static var lc					:LocalConnection 	= new LocalConnection();
		private static var hasEventListeners	:Boolean 			= false;
		
		/**
		 * Traces a message to Arthropod
		 * 
		 * @param	message		Message to be traced
		 * @param	color		opt. Color of the message
		 * @return				True if successful
		 */
		public static function log ( message:*, color:uint = 0xFEFEFE ) :Boolean {
			return send ( LOG_OPERATION, String ( message ) , color ) ;
		}
		
		/**
		 * Traces a warning to Arthropod.
		 * The message will be displayed in yellow.
		 * 
		 * @param	message		Message to be traced
		 * @return				True if successful
		 */
		public static function error ( message:* ) :Boolean {
			return send ( ERROR_OPERATION, String ( message ) , 0xCC0000 ) ;
		}
		
		/**
		 * Traces an error to Arthropod.
		 * The message will be displayed in red.
		 * 
		 * @param	message		Message to be traced
		 * @return				True if successful
		 */
		public static function warning ( message:* ) :Boolean {
			return send ( WARNING_OPERATION, String ( message ) , 0xCCCC00 ) ;
		}
		
		/**
		 * Clears all the traces, including arrays and bitmaps
		 * from the Arthropod application window.
		 * 
		 * @return				True if successful
		 */
		public static function clear ( ) :Boolean {
			return send ( CLEAR_OPERATION, 0, 0x000000 ) ;
		}
		
		/**
		 * Traces an array to Arthropod.
		 * 
		 * If no earlier arrays have been traced,
		 * Arthropod will open up the array-window
		 * automatically. For each array that is traced,
		 * the array-window will clear and display the
		 * new one. This is useful for buffer-arrays, etc.
		 * 
		 * @param	arr			Array to be traced
		 * @return				True if successful
		 */
		public static function array ( arr:Array ) :Boolean {
			return send ( ARRAY_OPERATION, arr,null ) ;
		}
		
		/**
		 * Traces a thumbnail of the specified BitmapData
		 * to Arthropod.
		 * 
		 * The internal connection between Arthropod and
		 * the Debug class only accept calls less than
		 * 40Kb. The bitmap method converts the specified
		 * BitmapData to an acceptable size for the call.
		 * 
		 * @param	bmd			Any IBitmapDrawable
		 * @param	label		Label
		 * @return				True if successful
		 */
		public static function bitmap ( bmd:*, label:String = null ) :Boolean {
			var bm:BitmapData = new BitmapData ( 100, 100, true, 0x00FFFFFF ) ;
			var mtx:Matrix = new Matrix ( ) ;
			var s:Number = 100 / (( bmd.width >= bmd.height ) ? bmd.width : bmd.height ) ;
			mtx.scale ( s, s ) ;
			bm.draw ( bmd, mtx,null,null,null,true ) ;
			var bounds:Rectangle = new Rectangle ( 0, 0, Math.floor ( bmd.width * s ) , Math.floor ( bmd.height * s ) ) ;
			return send ( BITMAP_OPERATION, bm.getPixels ( bounds ), { bounds:bounds, lbl:label } ) ;
		}
		
		/**
		 * Traces a snapshot of the current stage state.
		 * 
		 * @param	stage		Stage
		 * @param	label		Label
		 * @return				True if successful
		 */
		public static function snapshot ( stage:Stage, label:String=null ) :Boolean {
			if ( stage )
				return bitmap ( stage, label ) ;
			return false;
		}
		
		/**
		 * Traces an <code>object</code> to Arthropod.
		 * The first level of arguments are traced as follows:
		 * 
		 * trace:
		 * Debug.object( { name: Carl, surname: Calderon } );
		 * 
		 * output:
		 * object
		 * name: Carl
		 * surname: Calderon
		 * 
		 * @param	obj			Object to be traced
		 * @return				True if successful
		 */
		public static function object ( obj:* ) :Boolean {
			return send ( OBJECT_OPERATION, obj, null ) ;
		}
		
		/**
		 * Traces the current memory size used by Adobe Flash Player.
		 * Observe that this also includes AIR applications (such as
		 * Arthropod). Use with care.
		 * 
		 * @return				True if successful
		 */
		public static function memory ( ) :Boolean {
			return send ( MEMORY_OPERATION, System.totalMemory, null ) ;
		}
		
		/**
		 * [internal-use]
		 * Sends the message
		 * 
		 * @param	operation	Operation name
		 * @param	value		Value to send
		 * @param	color		opt. Color of the message
		 */
		private static function send( operation:String, value:*, prop:* ):Boolean {
			if (!secure) 	lc.allowInsecureDomain('*');
			else 			lc.allowDomain(secureDomain);
			if (!hasEventListeners) {
				if ( ignoreStatus ) lc.addEventListener(StatusEvent.STATUS, ignore);
				else 				lc.addEventListener(StatusEvent.STATUS, status);
				hasEventListeners = true;
			}
			if(allowLog){
				try {
					lc.send ( TYPE + '#' + DOMAIN + CHECK + ':' + CONNECTION , operation, password, value, prop ) ;
					return true;
				} catch (e:*) {
					return false;
				}
			}
			return false;
		}
		
		/**
		 * [internal-use]
		 * Traces the status of the Debugger.
		 * 
		 * @see		ignoreStatus
		 * @param	e			StatusEvent
		 */
		private static function status(e:StatusEvent):void {
			//trace( 'Arthropod status:\n' + e.toString() );
		}
		
		/**
		 * [internal-use]
		 * Method used to ignore StatusEvent's if an error occurs.
		 * 
		 * @see		ignoreStatus
		 * @param	e			StatusEvent
		 */
		private static function ignore(e:StatusEvent):void { }
		
	}
	
}
