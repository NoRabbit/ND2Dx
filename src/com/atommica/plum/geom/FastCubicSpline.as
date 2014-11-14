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
  
    public class FastCubicSpline
    {
        public function FastCubicSpline()
        {
            t = [];
            y = [];
            u = [];
            v = [];
            h = [];
            b = [];
            z = [];
            hInv = [];
        }

        /**
        * Add/Insert a knot in a manner that maintains non-overlapping intervals.  
        * This method rearranges knot order, if necessary, to maintain 
        * non-overlapping intervals.
        */
        public function addControlPoint(x:Number, y:Number):void
        {
            this.invalidate = true;

            if (this.t.length == 0)
            {
                this.t.push(x);
                this.y.push(y);
                this.knotCount++;
            }
            else
            {
                if (x > this.t[this.knotCount - 1])
                {
                    this.t.push(x);
                    this.y.push(y);
                    this.knotCount++;
                }
                else if (x < this.t[0])
                {
                    this.insert(x, y, 0);
                }
                else if (this.knotCount > 1)
                {
                    for( var i:int=0; i < this.knotCount - 1; ++i)
                    {
                        if( x > this.t[i] && x < this.t[i + 1])
                            this.insert(x, y, i + 1);
                    }
                }
            }
        }

        /** 
        * Insert knot at index
        */
        private function insert(x:Number, y:Number, idx:int):void
        {
            this.t.splice(idx, 0, x );
            this.y.splice(idx, 0, y );

            this.knotCount++;
        }
    
        /**
        * Delete all knots
        */
        public function deleteAllKnots():void
        {
            this.t.splice(0);
            this.y.splice(0);

            this.knotCount = 0;
            this.invalidate = true;
        }


        /**
        * Evaluate spline at a given x-coordinate
        *
        * Return - NaN if there are no knots
        *        - y[0] if there is only one knot
        *        - Spline value at the input x-coordinate, if there are two or more knots
        */
        public function eval(x:Number):Number
        {
            if (this.knotCount == 0)
                return NaN;
            
            else if (this.knotCount == 1)
                return this.y[0];
            
            else
            {
                if (this.invalidate)
                    this.computeZ();

                 // determine interval
                var i:uint = 0;
                this.delta    = x - this.t[0];
                for( var j:uint=this.knotCount - 2; j >= 0; j-- )
                {
                    if (x >= this.t[j])
                    {
                        this.delta = x - this.t[j];
                        i = j;
                        break;
                    }
                }

                var b:Number = (this.y[i + 1] - this.y[i]) * this.hInv[i] - this.h[i] * 
                               (this.z[i + 1] + 2.0 * this.z[i]) * 0.1666666666666667;
                var q:Number = 0.5 * this.z[i] + this.delta * (this.z[i + 1] - this.z[i]) 
                    * 0.1666666666666667 * this.hInv[i];
                var r:Number = b + this.delta * q;
                var s:Number = this.y[i] + this.delta * r;
        
                return s;
            }
        }

        /**
        * Compute z[i] based on current knots
        */
        private function computeZ():void
        {
            // Pre-generate h^-1 since the same quantity could be repeatedly 
            // calculated in eval()
            for (var i:uint=0; i < this.knotCount - 1; ++i)
            {
                this.h[i] = this.t[i + 1] - this.t[i];
                this.hInv[i] = 1.0 / this.h[i];
                this.b[i] = (this.y[i + 1] - this.y[i]) * this.hInv[i];
            }

            // recurrence relations for u(i) and v(i) -- tridiagonal solver
            this.u[1] = 2.0 * (this.h[0] + this.h[1]);
            this.v[1] = 6.0 * (this.b[1] - this.b[0]);
   
            for (i = 2; i < this.knotCount - 1; ++i)
            {
                this.u[i] = 2.0 * (this.h[i] + this.h[i - 1]) - (this.h[i - 1] * 
                    this.h[i - 1]) / this.u[i - 1];
                this.v[i] = 6.0 * (this.b[i] - this.b[i - 1]) - (this.h[i - 1] * 
                    this.v[i - 1]) / this.u[i - 1];
            }

            // compute z(i)
            this.z[this.knotCount - 1] = 0.0;
            for (i = this.knotCount - 2; i >= 1; i--)
            {
                this.z[i] = (this.v[i] - this.h[i] * this.z[i + 1]) / this.u[i];
            }

            this.z[0] = 0.0;

            this.invalidate = false;
        }
        
        private var t:Array;
        private var y:Array;
        private var u:Array;
        private var v:Array;
        private var h:Array;
        private var b:Array;
        private var z:Array;
        
        // Precomputed h^-1 values
        private var hInv:Array;
        
        // Current x-t(i)
        private var delta:Number = 0.0;
        
        private var invalidate:Boolean = true;
        
        public var knotCount:uint = 0;
    }
}