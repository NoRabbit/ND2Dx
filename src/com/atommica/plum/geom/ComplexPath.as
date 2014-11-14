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

    public class ComplexPath extends Parametric
    {
        public function ComplexPath(paths:Array)
        {
            this.paths = paths;
        }
        
        /**
        * Calculate a porportional t, based on total arcLength, and returns x, y.
        */
        public override function getPoint(t:Number, ignoreParam:Boolean=false):Point
        {
            t = (t < 0) ? 0: t;
            t = (t > 1) ? 1: t;

            var sum:Number = this.paths[0].arcLength;
            var lastSum:Number = 0.0;

            var n:uint = this.paths.length;
            var d:Number = t * this.arcLength;
            var i:uint = 1;
            
            while ((sum < d) && (i < n))
            {
                lastSum = sum;
                sum += this.paths[i++].arcLength;
            }
            
            t = (d - lastSum) / this.paths[i - 1].arcLength;
            return this.paths[i - 1].getPoint(t, ignoreParam);
        }

        /**
         * Return the set of y-coordinates corresponding to the input x-coordinate
         */
        public override function yAtX(x:Number):Array
        {
            var res:Array = []
            for each(var path:Parametric in this.paths)
            {
                var ys:Array = path.yAtX(x);
                if (ys.length > 0)
                    res.push.apply(null, ys);
            }
            
            return res;
        }
        
        /**
         * Return arc-length of curve segment on [0, t].
         */
        public override function arcLengthAt(t:Number, precision:uint=8):Number
        {
            t = (t < 0) ? 0: t;
            t = (t > 1) ? 1: t;
            
            var sum:Number = 0.0;
            for each (var path:Parametric in this.paths)
            {
                sum += path.arcLength;
            }
            
            return sum;
        }

        private var paths:Array;        
    }
}
