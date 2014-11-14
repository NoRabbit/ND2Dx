/*
* Copyright (c) 2011 Atommica: http://atommica.com
* Created by Martín Conte Mac Donell (@Reflejo) <reflejo@gmail.com>
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in
* all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
* THE SOFTWARE.
*/

package com.atommica.plum
{
    import com.atommica.plum.geom.Parametric;
    
    import flash.display.DisplayObject;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.utils.Dictionary;

    [Event(name=TICK, type="Plum")]
    public class Plum extends EventDispatcher
    {
        public function Plum()
        {
            this.animations = new Dictionary(true);
            this.ticker = new Sprite();
        }
        
        /**
        * Remove animation related to a display object. (This will destroy the animation)
        */
        public function removeAnimationFrom(object:DisplayObject):void
        {
            if (object in this.animations)
            {
                this.animations[object].destroy();
                delete this.animations[object];
            }
        }

        /**
         * Add Animation to our dictionary and register ENTER_FRAME event as needed
         */
        public function addAnimation(object:DisplayObject, animation:Animation):void
        {
            this.animations[object] = animation;
            
            if (!this.ticker.hasEventListener(Event.ENTER_FRAME))
                this.ticker.addEventListener(Event.ENTER_FRAME, this.onTick);
        }
        
        /**
         * This is where you add animations. This class is static so you can do something 
         * like Plum.animate(ball, bezier);
         */
        public static function animate(object:DisplayObject, throughPath:Parametric, 
                                       options:Object):Animation
        {
            // Load default options
            for (var key:String in Plum.DEFAULTOPTIONS)
            {
                if (!(key in options))
                    options[key] = Plum.DEFAULTOPTIONS[key];
            }

            var animation:Animation = new Animation(object, throughPath, options);
            Plum.instance.addAnimation(object, animation);
            return animation;
        }
 
        /**
         * Listen enter_frame events and call step method for each animation. 
         */
        private function onTick(event:Event):void
        {
            for each(var animation:Animation in this.animations)
            {
                var t:Number = animation.nextT();
                if (t < 0) continue;

                animation.step(t);
                if (t >= 1) 
                {
                    Plum.instance.dispatchEvent(new Event(Event.COMPLETE));
                    this.removeAnimationFrom(animation.object);
                }
            }
            
            // Dispatch Tick event to avoid multiple enter-frame
            this.dispatchEvent(new Event(Plum.TICK));
        }
        
        /**
        * Singleton implementation
        */
        public static function get instance():Plum
        {
            if (Plum._instance == null)
                Plum._instance = new Plum();
            
            return Plum._instance;
        }
        
        public static const TICK:String = 'Tick';
        private static const DEFAULTOPTIONS:Object = {
            'speed': 100, // px per second
            'fps': 24,
            'start': 0,
            'paused': false,
            'reversed': false,
            'orientToPath': false
        };

        private static var _instance:Plum = null;
        
        private var animations:Dictionary;
        private var ticker:Sprite;
    }
}
