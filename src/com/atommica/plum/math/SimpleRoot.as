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

package com.atommica.plum.math
{

    public class SimpleRoot
    {    
        /**
        * Finds a single root given an interval 
        *
        * x0:Number root isolated in interval [x0, x2]
        * x2:Number root isolated in interval [x0, x2]
        * f:Function reference to function whose root in the interval is desired.
        *   Function accepts a single Number argument.
        * imax:uint maximum number of iterations (default MAX_ITER)
        * eps:Number tolerance value for root (default TOL)
        
        * Returns approximation of desired root within specified tolerance and iteration limit. 
        * In addition to too small an iteration limit or too tight a tolerance, some 
        * patholotical numerical conditions exist under which the method may incorrectly report a root.
        */
        public function findRoot(x0:Number, x2:Number, f:Function, imax:uint=MAX_ITER, eps:Number=TOL):Number
        {
            var x1:Number
            var y0:Number = f(x0);
            var y1:Number;
            var y2:Number = f(x2);
            var b:Number;
            var c:Number;
            var y10:Number;
            var y20:Number;
            var y21:Number;
            var xm:Number;
            var ym:Number;
            var temp:Number;
            
            var xmlast:Number = x0;
            
            if (y0 == 0.0) return x0;
            if (y2 == 0.0) return x2;
            
            this.iterations = 0;
            for (var i:uint = 0; i < imax; ++i)
            {
                this.iterations++;
                
                x1 = 0.5 * (x2 + x0);
                y1 = f(x1);
                if (y1 == 0.0) return x1;
                if (Math.abs(x1 - x0) < eps) return x1;
                
                if (y1 * y0 > 0.0 )
                {
                    temp = x0;
                    x0   = x2;
                    x2   = temp;
                    temp = y0;
                    y0   = y2;
                    y2   = temp;
                }
                
                y10 = y1 - y0;
                y21 = y2 - y1;
                y20 = y2 - y0;
                if (y2 * y20 < 2.0 * y1 * y10 )
                {
                    x2 = x1;
                    y2 = y1;
                }
                else
                {
                    b  = (x1  - x0 ) / y10;   
                    c  = (y10 - y21) / (y21 * y20); 
                    xm = x0 - b * y0 * (1.0 - c * y1);
                    ym = f(xm);
                    
                    if (ym == 0.0) return xm;
                    if (Math.abs(xm - xmlast) < eps) return xm;

                    xmlast = xm;
                    if (ym * y0 < 0.0)
                    {
                        x2 = xm;
                        y2 = ym;
                    }
                    else
                    {
                        x0 = xm;
                        y0 = ym;
                        x2 = x1;
                        y2 = y1;
                    }
                }
            }
            
            return x1;            
        }  
        
        private var iterations:uint = 0;
 
        private static const TOL:Number = 0.000001;
        private static const MAX_ITER:uint = 100;
    }
}
