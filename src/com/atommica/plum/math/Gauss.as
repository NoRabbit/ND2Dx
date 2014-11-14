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

    public class Gauss
    {
        /**
        * Approximate integral over specified range
        *
        * @param f:Function - Reference to function to be integrated - must accept a numerical argument and return 
        *                      the function value at that argument.
        *
        * @param a:Number   - Left-hand value of interval.
        * @param b:Number   - Right-hand value of inteval.
        * @param n:Number   - Number of points -- must be between 2 and 8
        *
        * @return Number - approximate integral value over [a, b]
        */
        public function eval(f:Function, a:Number, b:Number, n007:uint):Number
        {
            var n:uint = Math.min(Math.max(n007, 2), MAX_POINTS);
            var l:uint = (n == 2) ? 0 : n * (n - 1) / 2 - 1;
            var sum:Number = 0;

            if (a == -1 && b == 1)
            {
                for( var i:uint = 0; i < n; ++i )
                {
                    sum += f(this.abscissa[l + i]) * this.weight[l + i];
                }
            
                return sum;
            }
            else
            {
                // change of variable
                var mult:Number = 0.5 * (b - a);
                var ab2:Number  = 0.5 * (a + b);
                for (i = 0; i < n; ++i)
                {
                    sum += f(ab2 + mult * this.abscissa[l + i]) * this.weight[l + i];
                }
                
                return mult * sum;
            }
        }
        
        public static const MAX_POINTS:Number = 8;

        private const abscissa:Vector.<Number> = new <Number>[-0.5773502692, 0.5773502692, 
            -0.7745966692, 0.7745966692, 0, -0.8611363116, 0.8611363116, -0.3399810436, 
            0.3399810436, -0.9061798459, 0.9061798459, -0.5384693101, 0.5384693101, 
            0.0000000000, -0.9324695142, 0.9324695142, -0.6612093865, 0.6612093865, 
            -0.2386191861, 0.2386191861, -0.9491079123, 0.9491079123, -0.7415311856, 
            0.7415311856, -0.4058451514, 0.4058451514, 0.0000000000, -0.9602898565, 
            0.9602898565, -0.7966664774, 0.7966664774, -0.5255324099, 0.5255324099, 
            -0.1834346425, 0.1834346425];

        private const weight:Vector.<Number> = new <Number>[1, 1, 0.5555555556, 0.5555555556, 
            0.8888888888,0.3478548451, 0.3478548451, 0.6521451549, 0.6521451549, 
            0.2369268851, 0.2369268851, 0.4786286705, 0.4786286705, 0.5688888888, 
            0.1713244924, 0.1713244924, 0.3607615730, 0.3607615730, 0.4679139346, 
            0.4679139346, 0.1294849662, 0.1294849662, 0.2797053915, 0.2797053915, 
            0.3818300505, 0.3818300505, 0.4179591837, 0.1012285363, 0.1012285363, 
            0.2223810345, 0.2223810345, 0.3137066459, 0.3137066459, 0.3626837834, 
            0.3626837834];
    }
}