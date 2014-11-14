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
    
    import flash.geom.Point;

    public class Cubic implements IPoly
    {
        public function Cubic()
        {
            this.reset();
        }

        public function get degree():uint { return 3; }

        public function reset():void
        {
            this.points = new Vector.<Point>();
        }

        public function addCoef(x:Number, y:Number):void
        {
            this.points.push(new Point(x, y));
        }

        public function getCoef(idx:uint):Point
        { 
            if(idx > -1 && idx < 4)
                return this.points[idx];
            
            return null;
        }

        public function getX(t:Number):Number
        {
            return this.points[0].x + t * (this.points[1].x + t * (this.points[2].x + t * this.points[3].x));
        }

        public function getY(t:Number):Number
        {
            return this.points[0].y + t * (this.points[1].y + t * (this.points[2].y + t * this.points[3].y));
        }

        public function getXPrime(t:Number):Number
        {
            return this.points[1].x + t * (2.0 * this.points[2].x + t * (3.0 * this.points[3].x));
        }

        public function getYPrime(t:Number):Number
        {
            return this.points[1].y + t * (2.0 * this.points[2].y + t * (3.0 * this.points[3].y));
        }

        public function getDeriv(t:Number):Number
        {
            // use chain rule
            var dy:Number = this.getYPrime(t);
            var dx:Number = this.getXPrime(t);
            return dy / dx;
        }

        private var points:Vector.<Point>;
    }
}