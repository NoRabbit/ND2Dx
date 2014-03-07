	
	/**
	 * RabbitTween
	 * Transition, Tween engine for flash ActionScript 3
	 * Provides easy and fast tools to control transitions for every DisplayObject objects
	 * and custom object.
	 * 
	 * RabbitTween extends RabbitTweenCore
	 * 
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @version 0.2
	 * @link http://blog.open-design.be
	 *
	 * Copyright 2009, Thomas John. All rights reserved.
	 * 
	 **/
	
	/**
	 * Open source under the BSD License.
	 * All rights reserved.
	 * Redistribution and use in source and binary forms, with or without modification,
	 * are permitted for free provided that the following conditions are met:
	 * 		* No fee(s) is(are) collected from end user(s) for the use of any product containing
	 * 		  part(s) or all of this work. If you do so, you will need to get the correct License.
	 * 		  Send me an email for such a request: thomas.john@open-design.be
	 *		* Redistributions of source code must retain the above copyright notice, this list of
	 * 		  conditions and the following disclaimer.
	 * 		* Redistributions in binary form must reproduce the above copyright notice, this list
	 * 		  of conditions and the following disclaimer in the documentation and/or other materials
	 * 		  provided with the distribution.
	 * 		* Neither the name of the author nor the names of contributors may be used to endorse or
	 * 		  promote products derived from this software without specific prior written permission.
	 * 
	 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
	 * ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
	 * WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
	 * IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
	 * INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
	 * NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
	 * PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
	 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
	 * ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE 
	 * POSSIBILITY OF SUCH DAMAGE.
	 */
	
package com.rabbitframework.tween 
{
	import com.rabbitframework.tween.properties.displayobject.movieclip.PropertyMcFrame;
	import com.rabbitframework.tween.properties.PropertyBoolean;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;;
	import com.rabbitframework.tween.core.RabbitTweenCore;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoAlpha;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoAutoAlpha;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoHeight;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoRotation;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoRotationX;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoRotationY;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoRotationZ;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoScaleX;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoScaleY;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoScaleZ;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoWidth;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoX;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoY;
	import com.rabbitframework.tween.properties.displayobject.PropertyDoZ;
	import com.rabbitframework.tween.properties.PropertyBase;
	import com.rabbitframework.tween.properties.PropertyNumber;
	import com.rabbitframework.tween.properties.sound.PropertySoundVolume;
	import com.rabbitframework.tween.properties.specials.PropertyAutoAlpha;
	import com.rabbitframework.tween.properties.specials.PropertyRemoveTint;
	import com.rabbitframework.tween.properties.specials.PropertyTint;
	import com.rabbitframework.tween.RabbitTween;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @link http://blog.open-design.be
	 */
	public class RabbitTween extends RabbitTweenCore
	{
		/**
		 * STATIC VARS AND CONSTANTS FOR CORE ENGINE
		 */
		
		// static vars
		protected static var enterFrameSprite:Sprite = new Sprite();
		protected static var bIsEngineStarted:Boolean = false;
		
		// linked list for our tweens
		protected static var llFirstTween:RabbitTween = null;
		protected static var llLastTween:RabbitTween = null;
		protected static var llCurrentTween:RabbitTween = null;
		protected static var llNextTween:RabbitTween = null;
		
		// dictionary that stores all the tweens for a target
		protected static var dTargets:Dictionary = new Dictionary(true);
		
		// default ease function
		public static var defaultEase:Function = LinearEaseOut;
		
		// current time for use in every tween
		public static var currentTime:Number = 0.0;
		
		/**
		 * TWEEN VARS
		 */
		
		// linked list: previous and next nodes
		public var prevTweenNode:RabbitTween = null;
		public var nextTweenNode:RabbitTween = null;
		
		// linked list: nodes of the same target
		public var prevTweenTargetNode:RabbitTween = null;
		public var nextTweenTargetNode:RabbitTween = null;
		public var lastTweenTargetNode:RabbitTween = null;
		public var currentTweenTargetNode:RabbitTween = null;
		public var currentPreviousTweenTargetNode:RabbitTween = null;
		
		// linked list: this tween properties
		protected var firstTweenPropertyNode:PropertyBase = null;
		protected var lastTweenPropertyNode:PropertyBase = null;
		protected var currentTweenPropertyNode:PropertyBase = null;
		
		// object containing all properties
		protected var oProps:Object = { };
		
		// booleans specifying tween states
		public var bIsInited:Boolean = false;
		public var bIsStarted:Boolean = false;
		public var bIsTweenStarted:Boolean = false;
		public var bIsPaused:Boolean = false;
		public var bPropertiesInited:Boolean = false;
		public var bPropertiesReversed:Boolean = false;
		
		// times
		public var startTime:Number = 0.0;
		
		// ease function
		public var ease:Function = defaultEase;
		public var easeProxyF:Function = null;
		public var easeParams:Array = null;
		
		// constants
		public static const OVERWRITE_NONE:int = 0;
		public static const OVERWRITE_ALL:int = 1;
		public static const OVERWRITE_OVERLAPPING_PROPERTIES:int = 2;
		public static const OVERWRITE_CONCURRENT:int = 3;
		
		// default overwrite
		public static var defaultOverwrite:int = OVERWRITE_NONE;
		protected var _overwrite:int = OVERWRITE_NONE;
		protected var overwriteToSet:int = OVERWRITE_NONE;
		
		// callbacks
		public var onStart:Array = null;
		public var onStartParams:Array = null;
		public var onUpdate:Array = null;
		public var onUpdateParams:Array = null;
		public var onComplete:Array = null;
		public var onCompleteParams:Array = null;
		public var onYoyo:Array = null;
		public var onYoyoParams:Array = null;
		public var onLoop:Array = null;
		public var onLoopParams:Array = null;
		
		public var loop:int = -1;
		private var _loopCount:int = 0;
		public var yoyo:int = -1;
		private var _yoyoCount:int = 0;
		
		
		/**
		 * Create a new instance of RabbitTween
		 */
		public function RabbitTween() 
		{
			
		}
		
		/**
		 * ########################################
		 * #
		 * # PROPERTIES
		 * #
		 * ########################################
		 */
		
		public function setProperties(to:Object, from:Object = null):RabbitTween 
		{
			var prop:String;
			
			if ( to == null && from )
			{
				for (prop in from) 
				{
					setProperty(prop, from[prop], target[prop]);
				}
			}
			else if ( from )
			{
				// merge properties in order to have the properties contained in "to" as well.
				createPropertiesInObject(from, to, null);
				
				for (prop in from) 
				{
					setProperty(prop, from[prop], to[prop]);
				}
			}
			else if ( to )
			{
				for (prop in to) 
				{
					setProperty(prop, null, to[prop]);
				}
			}
			
			if ( overwriteToSet != OVERWRITE_NONE ) overwrite(overwriteToSet);
			
			return this;
		}
		
		public function setProperty(property:String, startValue:Object = null, endValue:Object = null):RabbitTween 
		{
			if ( property == "ease" )
			{
				ease = endValue as Function;
			}
			else if ( property == "easeParams" )
			{
				easeParams = endValue as Array;
				
				if ( easeParams != null )
				{
					easeProxyF = ease;
					ease = easeProxy;
				}
				else if( ease == easeProxy )
				{
					ease = easeProxyF;
				}
			}
			else if ( property == "overwrite" )
			{
				//overwrite(int(endValue));
				overwriteToSet = int(endValue);
			}
			else if ( property == "onStart" )
			{
				addOnStart((endValue as Array)[0], (endValue as Array)[1]);
				return this;
			}
			else if ( property == "onUpdate" )
			{
				addOnUpdate((endValue as Array)[0], (endValue as Array)[1]);
				return this;
			}
			else if ( property == "onComplete" )
			{
				addOnComplete((endValue as Array)[0], (endValue as Array)[1]);
				return this;
			}
			else if ( property == "loop" )
			{
				loop = endValue as int;
				calculateTotalDuration();
			}
			else if ( property == "yoyo" )
			{
				yoyo = endValue as int;
				calculateTotalDuration();
			}
			else if ( property == "tint" )
			{
				addPropertyToLinkedList(new PropertyTint(target, property, startValue, endValue));
			}
			else if ( property == "removeTint" && endValue == true )
			{
				addPropertyToLinkedList(new PropertyRemoveTint(target, property, startValue, endValue));
				
				// remove tint property from tweens of the same target
				removeOverlappingProperties("tint");
			}
			else if ( property == "boolean" )
			{
				addPropertyToLinkedList(new PropertyBoolean(target, property, startValue, endValue));
			}
			else if ( property == "volume" )
			{
				addPropertyToLinkedList(new PropertySoundVolume(target, property, startValue, endValue));
			}
			else if ( target is DisplayObject )
			{
				if ( property == "x" )
				{
					addPropertyToLinkedList(new PropertyDoX(target, property, startValue, endValue));
				}
				else if ( property == "y" )
				{
					addPropertyToLinkedList(new PropertyDoY(target, property, startValue, endValue));
				}
				else if ( property == "z" )
				{
					addPropertyToLinkedList(new PropertyDoZ(target, property, startValue, endValue));
				}
				else if ( property == "alpha" )
				{
					addPropertyToLinkedList(new PropertyDoAlpha(target, property, startValue, endValue));
				}
				else if ( property == "autoAlpha" )
				{
					property = "alpha";
					addPropertyToLinkedList(new PropertyDoAutoAlpha(target, property, startValue, endValue));
				}
				else if ( property == "height" )
				{
					addPropertyToLinkedList(new PropertyDoHeight(target, property, startValue, endValue));
				}
				else if ( property == "width" )
				{
					addPropertyToLinkedList(new PropertyDoWidth(target, property, startValue, endValue));
				}
				else if ( property == "rotation" )
				{
					addPropertyToLinkedList(new PropertyDoRotation(target, property, startValue, endValue));
				}
				else if ( property == "rotationX" )
				{
					addPropertyToLinkedList(new PropertyDoRotationX(target, property, startValue, endValue));
				}
				else if ( property == "rotationY" )
				{
					addPropertyToLinkedList(new PropertyDoRotationY(target, property, startValue, endValue));
				}
				else if ( property == "rotationZ" )
				{
					addPropertyToLinkedList(new PropertyDoRotationZ(target, property, startValue, endValue));
				}
				else if ( property == "scaleX" )
				{
					addPropertyToLinkedList(new PropertyDoScaleX(target, property, startValue, endValue));
				}
				else if ( property == "scaleY" )
				{
					addPropertyToLinkedList(new PropertyDoScaleY(target, property, startValue, endValue));
				}
				else if ( property == "scaleZ" )
				{
					addPropertyToLinkedList(new PropertyDoScaleZ(target, property, startValue, endValue));
				}
				else if ( target is MovieClip )
				{
					if ( property == "frame" )
					{
						addPropertyToLinkedList(new PropertyMcFrame(target, property, startValue, endValue));
					}
					else if ( startValue is Number || endValue is Number )
					{
						addPropertyToLinkedList(new PropertyNumber(target, property, startValue, endValue));
					}
				}
				else if ( startValue is Number || endValue is Number )
				{
					addPropertyToLinkedList(new PropertyNumber(target, property, startValue, endValue));
				}
			}
			else if ( property == "autoAlpha" )
			{
				property = "alpha";
				addPropertyToLinkedList(new PropertyAutoAlpha(target, property, startValue, endValue));
			}
			else if ( startValue is Number || endValue is Number )
			{
				addPropertyToLinkedList(new PropertyNumber(target, property, startValue, endValue));
			}
			
			oProps[property] = lastTweenPropertyNode;
			
			return this;
		}
		
		/**
		 * Add a property to the linked list
		 * @param	property
		 */
		protected function addPropertyToLinkedList(property:PropertyBase):void
		{
			if ( lastTweenPropertyNode )
			{
				lastTweenPropertyNode.nextPropertyNode = property;
				property.previousPropertyNode = lastTweenPropertyNode;
				lastTweenPropertyNode = property;
			}
			else
			{
				firstTweenPropertyNode = lastTweenPropertyNode = property;
			}
		}
		
		/**
		 * Initialize tweened properties of this tween
		 * @return
		 */
		public function initProperties():RabbitTween
		{
			if ( bPropertiesInited ) return this;
			bPropertiesInited = true;
			
			currentTweenPropertyNode = firstTweenPropertyNode;
			
			while ( currentTweenPropertyNode )
			{
				currentTweenPropertyNode.init();
				currentTweenPropertyNode = currentTweenPropertyNode.nextPropertyNode;
			}
			
			return this;
		}
		
		/**
		 * Remove overlapping properties of tweens of the same target
		 * @param	property
		 */
		protected function removeOverlappingProperties(property:String):void
		{
			currentTweenTargetNode = lastTweenTargetNode;
			
			while ( currentTweenTargetNode )
			{
				RabbitTween(currentTweenTargetNode).removeProperty(property);
				currentTweenTargetNode = currentTweenTargetNode.prevTweenTargetNode;
			}
		}
		
		/**
		 * Remove a property
		 * @param	prop property name to remove
		 * @return	this tween object
		 */
		public function removeProperty(prop:String):RabbitTween
		{
			var property:PropertyBase = oProps[prop] as PropertyBase;
			
			if ( property )
			{
				property.removeProperty();
				if ( property.previousPropertyNode ) property.previousPropertyNode.nextPropertyNode = property.nextPropertyNode;
				if ( property.nextPropertyNode ) property.nextPropertyNode.previousPropertyNode = property.previousPropertyNode;
				
				delete oProps[prop];
			}
			
			return this;
		}
		
		/**
		 * Reverse and initialize tweened properties of this tween
		 * @return
		 */
		public function reverseAndInitProperties():RabbitTween
		{
			bPropertiesReversed = !bPropertiesReversed;
			
			var endValue:Object;
			
			currentTweenPropertyNode = firstTweenPropertyNode;
			
			while ( currentTweenPropertyNode )
			{
				//trace("reverseAndInitProperties", currentTweenPropertyNode.endValue, currentTweenPropertyNode.startValue);
				
				endValue = currentTweenPropertyNode.endValue;
				currentTweenPropertyNode.endValue = currentTweenPropertyNode.startValue;
				currentTweenPropertyNode.startValue = endValue;
				currentTweenPropertyNode.init();
				
				currentTweenPropertyNode = currentTweenPropertyNode.nextPropertyNode;
			}
			
			return this;
		}
		
		/**
		 * Update property start and end values
		 * @param	prop property name
		 * @param	startValue start value
		 * @param	endValue end value
		 * @return	this tween object
		 */
		public function updatePropertyValues(prop:String, startValue:Object, endValue:Object = null):RabbitTween
		{
			var property:PropertyBase = oProps[prop] as PropertyBase;
			
			if ( startValue != null ) property.startValue = startValue;
			if ( endValue != null ) property.endValue = endValue;
			
			property.init();
			
			return this;
		}
		
		/**
		 * ########################################
		 * #
		 * # OVERWRITE
		 * #
		 * ########################################
		 */
		
		/**
		 * Overwrite parameter
		 * @param	value
		 * @return
		 */
		public function overwrite(value:int):RabbitTween
		{
			_overwrite = value;
			
			if ( _overwrite == OVERWRITE_OVERLAPPING_PROPERTIES )
			{
				currentTweenPropertyNode = firstTweenPropertyNode;
				
				while ( currentTweenPropertyNode )
				{
					removeOverlappingProperties(currentTweenPropertyNode.property);
					currentTweenPropertyNode = currentTweenPropertyNode.nextPropertyNode;
				}
			}
			// remove all tweens of same target
			else if ( _overwrite == OVERWRITE_ALL )
			{
				currentTweenTargetNode = prevTweenTargetNode;
				
				// basically, we just remove the other tweens
				while ( currentTweenTargetNode )
				{
					currentPreviousTweenTargetNode = currentTweenTargetNode.prevTweenTargetNode;
					currentTweenTargetNode.removeTween();
					currentTweenTargetNode = currentPreviousTweenTargetNode;
				}
			}
			// check if we need to overwrite all concurrent tweens of the same target
			else if ( _overwrite == OVERWRITE_CONCURRENT )
			{
				currentTweenTargetNode = prevTweenTargetNode;
				
				// basically, we just remove the other tweens if they already have started
				while ( currentTweenTargetNode )
				{
					currentPreviousTweenTargetNode = currentTweenTargetNode.prevTweenTargetNode;
					if( currentTweenTargetNode.bIsStarted ) currentTweenTargetNode.removeTween();
					currentTweenTargetNode = currentPreviousTweenTargetNode;
				}
			}
			
			return this;
		}
		
		/**
		 * ########################################
		 * #
		 * # TWEEN
		 * #
		 * ########################################
		 */
		
		/**
		 * Initialize tween and add it to linked list of tweens of same target
		 * @param	target target to tween
		 * @param	duration duration of tween
		 * @param	delay delay before tween start
		 * @return
		 */
		public function initTween(target:Object, duration:Number, delay:Number = 0.0):RabbitTween
		{
			this.target = target;
			this.duration = duration;
			this.delay = delay;
			
			if ( bIsInited ) return this;
			bIsInited = true;
			
			// get last tween from the linked list for this target
			currentTweenTargetNode = lastTweenTargetNode = dTargets[target];
			
			// add this tween to the linked list for this target
			if ( lastTweenTargetNode )
			{
				lastTweenTargetNode.nextTweenTargetNode = this;
				prevTweenTargetNode = lastTweenTargetNode;
			}
			
			currentTweenTargetNode = lastTweenTargetNode = dTargets[target] = this;
			
			return this;
		}
		
		/**
		 * Start tween and add it to linked list of tweens processed by the engine
		 * @return
		 */
		public function start():RabbitTween
		{
			if ( bIsStarted ) return this;
			bIsStarted = true;
			
			// start engine if needed
			startEngine();
			
			// set starting and ending time
			startTime = currentTime + _delay;
			
			_progress = 0.0;
			currentDuration = 0.0;
			
			loopCount = 0;
			yoyoCount = 0;
			
			// init properties
			//initProperties();
			
			// add tween to linked list
			if ( llLastTween )
			{
				llLastTween.nextTweenNode = this;
				prevTweenNode = llLastTween;
				llLastTween = this;
			}
			else
			{
				llFirstTween = llLastTween = this;
			}
			
			return this;
		}
		
		/**
		 * Stop this tween and remove it
		 * @return
		 */
		public function stop():RabbitTween
		{
			if ( !bIsStarted ) return this;
			bIsStarted = false;
			
			// remove tween
			removeTween();
			
			return this;
		}
		
		/**
		 * Pause this tween
		 * @return
		 */
		public function pause():RabbitTween
		{
			if ( bIsPaused ) return this;
			bIsPaused = true;
			
			return this;
		}
		
		/**
		 * Resume this tween
		 * @return
		 */
		public function resume():RabbitTween
		{
			if ( !bIsPaused ) return this;
			bIsPaused = false;
			
			startTime = getTimer() - (currentTotalDuration * 1.000);
			
			return this;
		}
		
		/**
		 * Remove this tween permanently
		 * @return
		 */
		public function removeTween():RabbitTween
		{
			bIsStarted = false;
			bIsTweenStarted = false;
			
			// remove it from the target linked list
			if ( dTargets[target] == this ) dTargets[target] = prevTweenTargetNode;
			
			if ( prevTweenTargetNode ) prevTweenTargetNode.nextTweenTargetNode = nextTweenTargetNode;
			if ( nextTweenTargetNode ) nextTweenTargetNode.prevTweenTargetNode = prevTweenTargetNode;
			
			// remove it from main linked list
			if ( prevTweenNode ) prevTweenNode.nextTweenNode = nextTweenNode;
			if ( nextTweenNode ) nextTweenNode.prevTweenNode = prevTweenNode;
			
			if ( llFirstTween == this ) llFirstTween = nextTweenNode;
			if ( llLastTween == this ) llLastTween = prevTweenNode;
			
			prevTweenTargetNode = null;
			nextTweenTargetNode = null;
			prevTweenNode = null;
			nextTweenNode = null;
			
			return this;
		}
		
		/**
		 * Restart this tween as it would start for the first time.
		 * @return Tween instance
		 */
		public function restart():RabbitTween
		{
			if ( !bIsStarted )
			{
				start();
				return this;
			}
			
			loopCount = 0;
			yoyoCount = 0;
			
			return repeat();
		}
		
		/**
		 * Repeat this tween
		 * @return
		 */
		public function repeat():RabbitTween
		{
			_progress = 0.0;
			currentDuration = 0.0;
			
			// set starting time
			startTime = currentTime;
			
			return this;
		}
		
		/**
		 * reverse this tween
		 * @return
		 */
		public function reverse():RabbitTween
		{
			_progress = 0.0;
			currentDuration = 0.0;
			
			// init reversed properties
			reverseAndInitProperties();
			
			// set starting time
			startTime = currentTime;
			
			return this;
		}
		
		/**
		 * Update this tween properties according to it's delay and duration
		 * @return
		 */
		public function update():RabbitTween
		{
			if ( bIsStarted && !bIsPaused )
			{
				if ( !bIsTweenStarted )
				{
					if ( currentTime >= startTime )
					{
						bIsTweenStarted = true;
						
						initProperties();
						
						// callback function
						if ( onStart != null ) callFunctions(onStart, onStartParams);
					}
					else
					{
						return this;
					}
				}
				
				// calculate current total duration (loops and yoyo included)
				currentDuration = currentTotalDuration = currentTime - startTime;
				
				// any loops/yoyo ?
				if ( loop > 0 || yoyo > 0 ) currentDuration = currentTotalDuration % _duration;
				
				if ( currentTotalDuration >= _totalDuration )
				{
					currentTotalDuration = _totalDuration;
					currentDuration = _duration;
				}
				
				// get progress
				_progress = currentDuration / _duration;
				
				// check to see where we are in the yoyo loop (first round, second, etc...) se we know if we need to invert properties or not
				if ( yoyo > 0 && _progress < 1 )
				{
					var index:int = Math.floor(currentTotalDuration / _duration);
					
					yoyoCount = index;
					
					// check if odd or even number
					if ( index % 2 > 0 )
					{
						// odd, reverse properties if needed
						if ( !bPropertiesReversed ) reverseAndInitProperties();
					}
					else
					{
						// even, reverse properties to normal state if needed
						if ( bPropertiesReversed ) reverseAndInitProperties();
					}
				}
			}
			else
			{
				if ( !bIsTweenStarted )
				{
					bIsTweenStarted = true;
					
					initProperties();
					
					// callback function
					if ( onStart != null ) callFunctions(onStart, onStartParams);
				}
			}
			
			factor = ease(currentDuration, 0, 1, _duration);
			
			if ( currentDuration >= _duration )
			{
				factor = 1;
				_progress = 1.0;
			}
			
			currentTweenPropertyNode = firstTweenPropertyNode;
			
			while ( currentTweenPropertyNode )
			{
				currentTweenPropertyNode.update(factor);
				currentTweenPropertyNode = currentTweenPropertyNode.nextPropertyNode;
			}
			
			// call update callback
			if ( onUpdate != null ) callFunctions(onUpdate, onUpdateParams);
			
			//if( yoyo >
			
			// check if end of tween (loops and yoyo included)
			if ( currentTotalDuration >= _totalDuration && (bIsStarted && !bIsPaused) )
			{
				if ( yoyo == 0 )
				{
					yoyoCount = yoyoCount + 1;
					reverse();
				}
				else if ( loop == 0 )
				{
					repeat();
				}
				else
				{
					// call complete callback
					if ( onComplete != null ) callFunctions(onComplete, onCompleteParams);
					
					// stop tween
					stop();
				}
			}
			
			return this;
		}
		
		/**
		 * ########################################
		 * #
		 * # CALLBACKS
		 * #
		 * ########################################
		 */
		
		/**
		 * Call functions with their respective params
		 * @param	functions
		 * @param	params
		 */
		protected function callFunctions(functions:Array, params:Array):void
		{
			var i:int = 0;
			var n:int = functions.length;
			var currentFunction:Function;
			var currentParams:Array;
			
			for (i = 0; i < n; i++) 
			{
				currentFunction = functions[i] as Function;
				currentParams = params[i] as Array;
				(currentFunction as Function).apply(null, currentParams);
			}
		}
		
		/**
		 * Add a start callback. It gets called when tween starts. After specified delay.
		 * @param	callback function to call back
		 * @param	params list of parameters to pass to the callback function
		 * @return
		 */
		public function addOnStart(callback:Function, params:Array = null):RabbitTween
		{
			if ( callback == null ) return this;
			if ( !onStart ) onStart = [];
			if ( !onStartParams ) onStartParams = [];
			onStart.push(callback);
			onStartParams.push(params);
			return this;
		}
		
		/**
		 * Add an update callback. It gets called when tween updates.
		 * @param	callback function to call back
		 * @param	params list of parameters to pass to the callback function
		 * @return
		 */
		public function addOnUpdate(callback:Function, params:Array = null):RabbitTween
		{
			if ( callback == null ) return this;
			if ( !onUpdate ) onUpdate = [];
			if ( !onUpdateParams ) onUpdateParams = [];
			onUpdate.push(callback);
			onUpdateParams.push(params);
			return this;
		}
		
		/**
		 * Add a complete callback. It gets called when tween reaches its end.
		 * @param	callback function to call back
		 * @param	params list of parameters to pass to the callback function
		 * @return
		 */
		public function addOnComplete(callback:Function, params:Array = null):RabbitTween
		{
			if ( callback == null ) return this;
			if ( !onComplete ) onComplete = [];
			if ( !onCompleteParams ) onCompleteParams = [];
			onComplete.push(callback);
			onCompleteParams.push(params);
			return this;
		}
		
		public function addOnYoyo(callback:Function, params:Array = null):RabbitTween
		{
			if ( callback == null ) return this;
			if ( !onYoyo ) onYoyo = [];
			if ( !onYoyoParams ) onYoyoParams = [];
			onYoyo.push(callback);
			onYoyoParams.push(params);
			return this;
		}
		
		public function addOnLoop(callback:Function, params:Array = null):RabbitTween
		{
			if ( callback == null ) return this;
			if ( !onLoop ) onLoop = [];
			if ( !onLoopParams ) onLoopParams = [];
			onLoop.push(callback);
			onLoopParams.push(params);
			return this;
		}
		
		/**
		 * ########################################
		 * #
		 * # CORE ENGINE STATIC FUNCTIONS
		 * #
		 * ########################################
		 */
		
		/**
		 * Start core engine. Should normally not be used.
		 */
		public static function startEngine():void
		{
			if ( bIsEngineStarted ) return;
			bIsEngineStarted = true;
			
			// get current time
			currentTime = getTimer();
			
			// register event listener
			enterFrameSprite.addEventListener(Event.ENTER_FRAME, enterFrameHandler, false, 0, true);
		}
		
		/**
		 * Stop core engine. Should normally not be used.
		 */
		public static function stopEngine():void
		{
			if ( !bIsEngineStarted ) return;
			bIsEngineStarted = false;
			
			// remove event listener
			enterFrameSprite.removeEventListener(Event.ENTER_FRAME, enterFrameHandler, false);
		}
		
		/**
		 * function called for ENTER_FRAME event of core engine (where all tweens are updated)
		 * @param	e
		 */
		public static function enterFrameHandler(e:Event):void 
		{
			llCurrentTween = llFirstTween;
			currentTime = getTimer();
			
			while ( llCurrentTween )
			{
				// use of next if current tween gets removed
				llNextTween = llCurrentTween.nextTweenNode;
				if ( !llCurrentTween.bIsPaused ) llCurrentTween.update();
				llCurrentTween = llNextTween;
			}
		}
		
		/**
		 * Remove all tweens present in the linked list
		 */
		public static function removeAllTweens(target:Object = null):void
		{
			llCurrentTween = llFirstTween;
			
			while ( llCurrentTween )
			{
				llNextTween = llCurrentTween.nextTweenNode;
				
				//if ( llCurrentTween == llLastTween ) llLastTween = llCurrentTween.prevTweenNode;
				//if ( llCurrentTween == llFirstTween ) llFirstTween = llCurrentTween.nextTweenNode;
				
				if ( target == null )
				{
					llCurrentTween.removeTween();
				}
				else
				{
					if( llCurrentTween.target == target ) llCurrentTween.removeTween();
				}
				
				llCurrentTween = llNextTween;
			}
			
			if ( target == null ) llCurrentTween = llFirstTween = llLastTween = llNextTween = null;
		}
		
		/**
		 * Copy properties from $from object tot $to object. Overwrite an already existing property if specified.
		 * @param	$from
		 * @param	$to
		 * @param	$overwrite
		 */
		public static function copyProperties($from:Object, $to:Object, $overwrite:Boolean = true):void
		{
			var s:String;
			
			for (s in $from) 
			{
				try
				{
					if ( $overwrite )
					{
						$to[s] = $from[s];
					}
					else if ( !(s in $to) )
					{
						$to[s] = $from[s];
					}
				}
				catch(e:Error)
				{
					
				}
			}
		}
		
		/**
		 * Copy specified properties in $specifiedProps from $from object tot $to object. Overwrite an already existing property if specified.
		 * @param	$from
		 * @param	$to
		 * @param	$specifiedProps
		 * @param	$overwrite
		 */
		public static function copySpecifiedProperties($from:Object, $to:Object, $specifiedProps:Array, $overwrite:Boolean = true):void
		{
			var s:String;
			
			for each (s in $specifiedProps) 
			{
				try
				{
					if ( $overwrite )
					{
						$to[s] = $from[s];
					}
					else if ( !(s in $to) )
					{
						$to[s] = $from[s];
					}
				}
				catch(e:Error)
				{
					
				}
			}
		}
		
		/**
		 * Start a tween from current properties values to specified properties values
		 * @param	target Target object
		 * @param	duration Tween duration
		 * @param	props Properties to tween
		 * @return
		 */
		public static function to(target:Object, duration:Number, props:Object, delay:Number = 0.0):RabbitTween
		{
			var tween:RabbitTween = new RabbitTween();
			tween.initTween(target, duration, delay)
			.setProperties(props)
			.start();
			
			return tween;
		}
		
		/**
		 * Start a new tween from specified properties values to current properties values
		 * @param	$target
		 * @param	$duration
		 * @param	$props
		 * @param	$delay
		 * @return
		 */
		public static function from(target:Object, duration:Number, props:Object, delay:Number = 0.0):RabbitTween
		{
			var tween:RabbitTween = new RabbitTween();
			tween.initTween(target, duration, delay)
			.setProperties(null, props)
			.start();
			
			return tween;
		}
		
		/**
		 * Start a new tween from specified properties values to specified properties values
		 * @param	$target
		 * @param	$duration
		 * @param	$propsFrom
		 * @param	$propsTo
		 * @param	$delay
		 * @return
		 */
		public static function fromTo(target:Object, duration:Number, propsFrom:Object, propsTo:Object, delay:Number = 0.0):RabbitTween
		{
			var tween:RabbitTween = new RabbitTween();
			tween.initTween(target, duration, delay)
			.setProperties(propsTo, propsFrom)
			.start();
			
			return tween;
		}
		
		/**
		 * Create properties in $object from $properties if they do not exist already and set them to $value.
		 * @param	$object
		 * @param	$properties
		 * @param	$value
		 */
		public static function createPropertiesInObject(object:Object, properties:Object, value:Object = null):void
		{
			var s:String;
			
			for ( s in properties) 
			{
				if ( !(s in object) )
				{
					try
					{
						object[s] = value;
					}
					catch(e:Error)
					{
						
					}
				}
			}
		}
		
		/**
		 * Default ease function
		 * @param	t
		 * @param	b
		 * @param	c
		 * @param	d
		 * @return
		 */
		public static function LinearEaseOut(t:Number, b:Number, c:Number, d:Number):Number
		{
			return c*t/d + b;
		}
		
		/**
		 * Proxied easing function for using with easeParams
		 * @param	$t
		 * @param	$b
		 * @param	$c
		 * @param	$d
		 * @return
		 */
		protected function easeProxy(t:Number, b:Number, c:Number, d:Number):Number
		{
			return easeProxyF.apply(null, arguments.concat(easeParams));
		}
		
		override public function set progress(value:Number):void 
		{
			if ( _progress == value ) return;
			
			_progress = value;
			
			currentDuration = currentTotalDuration = _totalDuration * value;
			
			// any loops/yoyo ?
			if ( loop > 0 || yoyo > 0 ) currentDuration = currentTotalDuration % _duration;
			
			if ( _progress >= 1 )
			{
				currentDuration = _duration;
			}
			
			// check to see where we are in the yoyo loop (first round, second, etc...) se we know if we need to invert properties or not
			if ( yoyo > 0 && _progress < 1 )
			{
				var index:int = Math.floor(currentTotalDuration / _duration);
				
				// check if odd or even number
				if ( index % 2 > 0 )
				{
					// odd, reverse properties if needed
					if ( !bPropertiesReversed ) reverseAndInitProperties();
				}
				else
				{
					// even, reverse properties to normal state if needed
					if ( bPropertiesReversed ) reverseAndInitProperties();
				}
			}
			
			update();
		}
		
		override public function set delay(value:Number):void 
		{
			value *= 1000;
			
			if ( !bIsStarted && _delay != value )
			{
				startTime -= _delay;
				startTime += value;
				super.delay = value * 0.001;
			}
		}
		
		public function get loopCount():int { return _loopCount; }
		
		public function set loopCount(value:int):void 
		{
			if ( value == _loopCount ) return;
			_loopCount = value;
			if ( onLoop != null ) callFunctions(onLoop, onLoopParams);
		}
		
		public function get yoyoCount():int { return _yoyoCount; }
		
		public function set yoyoCount(value:int):void 
		{
			if ( value == _yoyoCount ) return;
			_yoyoCount = value;
			
			if ( onYoyo != null ) callFunctions(onYoyo, onYoyoParams);
		}
		
		override public function calculateTotalDuration():void 
		{
			var d:Number = _duration;
			if ( yoyo > 0 ) d += d * yoyo;
			if ( loop > 0 ) d += d * loop;
			
			_totalDuration = d;
		}
	}
	
}