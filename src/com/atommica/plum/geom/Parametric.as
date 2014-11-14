/*
 * Copyright (c) 2011 Atommica: http://atommica.com
 * Created by Martín Conte Mac Donell (@Reflejo) <reflejo@gmail.com>
 *
 * Lot of maths ideas taken from Singularity (www.algorithmist.net)
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

package com.atommica.plum.geom
{
    import com.atommica.plum.math.Gauss;
    
    import flash.display.Graphics;
    import flash.geom.Point;
  
    public class Parametric
    {
        public function Parametric(parameterization:String=ARC_LENGTH)
        {
            this.parameterization = parameterization;

            this.integrand = function(t:Number):Number
            {
                var x:Number = coef.getXPrime(t);
                var y:Number = coef.getYPrime(t);
        
                return Math.sqrt( x * x + y * y );
            };
        
            this.gauss = new Gauss();      
            this.spline = new FastCubicSpline();
        }

        /**
         * Return arc-length of the *entire* curve by numerical integration
         */
        public function get arcLength():Number
        {
            if ((this._arcLength != -1) && !invalidate)
                return this._arcLength;

            var len:Number =  arcLengthAt(1, 5);
            this._arcLength = len;
            
            return len;
        }
   
        /**
         * Return arc-length of curve segment on [0, t].
         */
        public function arcLengthAt(t:Number, precision:uint=8):Number
        {
            t = (t < 0) ? 0: t;
            t = (t > 1) ? 1: t;

            if (invalidate)
                this.computeCoef();

            return gauss.eval(this.integrand, 0, t, precision);
        }
 
        /**
         * Parameterize the entire curve.
         */
        protected function parameterize():void
        {
            if (this.parameterization == ARC_LENGTH)
            {
                if( this.spline.knotCount > 0 )
                    this.spline.deleteAllKnots();
                
                var arcLen:Array = [];
                var len:Number = 0;
                var values:Vector.<Number> = new <Number>[0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 
                                                          0.6, 0.7, 0.8, 0.9, 1.0];
                for (var i:uint = 0; i < 10; i++)
                {
                    var a:Number = 0.1 * i;
                    var b:Number = 0.1 * (i + 1);
                    
                    len += this.gauss.eval(this.integrand, values[i], values[i+1], 8);
                    arcLen[i] = len;
                }
    
                var normalize:Number = 1.0 / len;
                // x of spline knot is normalized arc-length, 
                // y is t-value for uniform parameterization
                this.spline.addControlPoint(0.0, 0.0);
                
                for (var j:uint = 1; j < 10; j++)
                {
                    var l:Number = arcLen[j - 1] * normalize;
                    this.spline.addControlPoint(l, values[j]);
                }
                
                // last control point, t=1, normalized arc-length = 1
                this.spline.addControlPoint(1.0, 1.0);
            }
        }

        /**
         * Get parameterized s for given t.
         */
        protected function getParam(t:Number):Number
        {
            t = (t < 0) ? 0 : t;
            t = (t > 1) ? 1 : t;

            // if arc-length parameterization, approximate L^-1(s)
            if ((t == 0) || (t == 1)) return t;

            if (this.parameterization == ARC_LENGTH)
                return this.spline.eval(t);
            else
                return t;
        }
        
        /**
        * Naive draw method
        */
        public function draw(graphics:Graphics, thickness:uint=1, color:uint=0xff0000,
                             precision:Number=0.01, dotted:Boolean=false):void
        {
            var t:Number = precision;
            var first:Point = this.getPoint(0.0);
            
            graphics.lineStyle(thickness, color);            
            graphics.moveTo(first.x, first.y);

            while (t <= 1)
            {
                var p:Point = this.getPoint(t);
                if (dotted)
                {
                    graphics.beginFill(color);            
                    graphics.drawCircle(p.x, p.y, 2);
                }
                else
                {
                    graphics.lineTo(p.x, p.y);
                }
                t += precision;
            }
            
        }

        /*
        * You SHOULD implement theses methods, but this isn't a must.
        */
        public function getPoint(t:Number, ignoreParam:Boolean=false):Point { return null; } 
        public function getXPrime(n:Number):Number { return 0.0; } 
        public function getYPrime(n:Number):Number { return 0.0; }         
        public function computeCoef():void {}
        public function yAtX(x:Number):Array { return null; }         

        public static const ARC_LENGTH:String = 'A';
        public static const UNIFORM:String = 'U';
    

        protected var parameterization:String;
        public var points:Vector.<Point>;
        protected var invalidate:Boolean = true;
        protected var integrand:Function;
        
        // Gauss-Legendre integration class
        protected var gauss:Gauss;
        
        // Polynomial curve that implements IPoly interface
        protected var coef:IPoly;
        
        // interpolate arc-length vs. t
        protected var spline:FastCubicSpline;
        
        // Arc-length computation and parameterization (cache)
        protected var _arcLength:Number = -1;
    }
}
