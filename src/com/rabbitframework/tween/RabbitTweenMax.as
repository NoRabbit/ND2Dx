	/**
	 * RabbitTween
	 * Transition, Tween engine for flash ActionScript 3
	 * Provides easy and fast tools to control transitions for every DisplayObject objects
	 * and custom object.
	 * 
	 * RabbitTweenMax extends RabbitTween by adding the possibility to tween filters.
	 * 
	 * Documentation coming soon.
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
	import com.rabbitframework.tween.properties.filters.PropertyBevelFilter;
	import com.rabbitframework.tween.properties.filters.PropertyBlurFilter;
	import com.rabbitframework.tween.properties.filters.PropertyColorMatrixFilter;
	import com.rabbitframework.tween.properties.filters.PropertyDisplacementMapFilter;
	import com.rabbitframework.tween.properties.filters.PropertyDropShadowFilter;
	import com.rabbitframework.tween.properties.filters.PropertyGlowFilter;
	
	/**
	 * ...
	 * @author Thomas John (@) thomas.john@open-design.be
	 * @link http://blog.open-design.be
	 */
	public class RabbitTweenMax extends RabbitTween
	{
		// constants
		public static const FILTERS_OVERWRITE_NONE:int = 0;
		public static const FILTERS_OVERWRITE_ALL:int = 1;
		public static const FILTERS_OVERWRITE_SPECIFIED_INDEX_OF_SAME_TYPE:int = 2;
		public static const FILTERS_OVERWRITE_ALL_OF_SAME_TYPE:int = 3;
		
		public function RabbitTweenMax() 
		{
			super();
		}
		
		/**
		 * Set a target property start and end values. Check for overlapping properties if needed
		 * Overriden to add more properties (like filters, etc...)
		 * @param	target
		 * @param	property
		 * @param	startValue
		 * @param	endValue
		 */
		override public function setProperty(property:String, startValue:Object = null, endValue:Object = null):RabbitTween
		{
			if ( property == "dropShadowFilter" )
			{
				addPropertyToLinkedList(new PropertyDropShadowFilter(target, property, startValue, endValue));
			}
			else if ( property == "blurFilter" )
			{
				addPropertyToLinkedList(new PropertyBlurFilter(target, property, startValue, endValue));
			}
			else if ( property == "glowFilter" )
			{
				addPropertyToLinkedList(new PropertyGlowFilter(target, property, startValue, endValue));
			}
			else if ( property == "colorMatrixFilter" )
			{
				addPropertyToLinkedList(new PropertyColorMatrixFilter(target, property, startValue, endValue));
			}
			else if ( property == "bevelFilter" )
			{
				addPropertyToLinkedList(new PropertyBevelFilter(target, property, startValue, endValue));
			}
			else if ( property == "displacementMapFilter" )
			{
				addPropertyToLinkedList(new PropertyDisplacementMapFilter(target, property, startValue, endValue));
			}
			else
			{
				// call super function for other properties check
				return super.setProperty(property, startValue, endValue);
			}
			
			// need to check for overlapping properties ?
			if ( _overwrite == OVERWRITE_OVERLAPPING_PROPERTIES )
			{
				removeOverlappingProperties(property);
			}
			
			oProps[property] = lastTweenPropertyNode;
			
			return this;
		}
		
		/**
		 * Remove this tween permanently
		 */
		override public function removeTween():RabbitTween
		{
			//if ( !bIsActive ) return this;
			
			super.removeTween();
			
			// remove all properties if needed
			currentTweenPropertyNode = firstTweenPropertyNode;
			
			while ( currentTweenPropertyNode )
			{
				if( currentTweenPropertyNode.bRemoveOnComplete ) currentTweenPropertyNode.removeProperty();
				currentTweenPropertyNode = currentTweenPropertyNode.nextPropertyNode;
			}
			
			return this;
		}
		
		
		/**
		 * Start a tween from current properties to specified properties
		 * @param	target Target object
		 * @param	duration Tween duration
		 * @param	props Properties to tween
		 * @param	delay
		 * @return
		 */
		public static function to(target:Object, duration:Number, props:Object, delay:Number = 0.0):RabbitTweenMax
		{
			var tween:RabbitTweenMax = new RabbitTweenMax();
			tween.initTween(target, duration, delay)
			.setProperties(props)
			.start();
			
			return tween;
		}
		
		/**
		 * Start a new tween from specified properties to current properties
		 * @param	target
		 * @param	duration
		 * @param	props
		 * @param	delay
		 * @return
		 */
		public static function from(target:Object, duration:Number, props:Object, delay:Number = 0.0):RabbitTweenMax
		{
			var tween:RabbitTweenMax = new RabbitTweenMax();
			tween.initTween(target, duration, delay)
			.setProperties(null, props)
			.start();
			
			return tween;
		}
		
		/**
		 * Start a new tween from specified properties to specified properties
		 * @param	target
		 * @param	duration
		 * @param	propsFrom
		 * @param	propsTo
		 * @param	delay
		 * @return
		 */
		public static function fromTo(target:Object, duration:Number, propsFrom:Object, propsTo:Object, delay:Number = 0.0):RabbitTweenMax
		{
			var tween:RabbitTweenMax = new RabbitTweenMax();
			tween.initTween(target, duration, delay)
			.setProperties(propsTo, propsFrom)
			.start();
			
			return tween;
		}
	}
	
}