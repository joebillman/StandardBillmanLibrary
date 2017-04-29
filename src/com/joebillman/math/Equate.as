/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* //AUTHOR:
*   Joe Billman
*
*
* //DATE: 
*   January 2009
*
*
* //COPYRIGHT: 
*   Joe Billman. All rights reserved.
* 
* 
* //REVISION NOTES:
*
*	6/11/2014 - Added calcPPI function
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package com.joebillman.math
{
	/**
	* 	Equate: This class is a class with different useful equations.
	*
	*	@author Joe Billman
	*/
	public class Equate
	{
				
		/**
		 * This function calculates a payment.
		 * @param		P		Principle amount.
		 * @param		r		Rate.
		 * @param		n		Number of payments.
		 * @return		String	This is the money representaion.  
		 */
		public static function amortization(P:int, r:int, n:int):String
		{
			var A:Number = P*((r*(Math.pow((1+r), n))) / ((Math.pow((1+r), n)-1)));
			return("$ "+A.toFixed(2));
		}
		
		/**
		 * 
		 * @param 	hPixels		Horizontal pixels (resolutionX width)
		 * @param 	vPixels		Vertical pixels (resolutionY height)
		 * @param 	diagSize	Diagonal size (screen size)
		 * @param 	round		Whether to round the result
		 * @return 	Number		Resulting PPI
		 * 
		 */		
		public static function calcPPI(hPixels:Number, vPixels:Number, diagSize:Number, round:Boolean=true):Number
		{
			if(round)
			{
				return Math.round(Math.sqrt(Math.pow(hPixels, 2)+Math.pow(vPixels, 2))/diagSize);
			}
			else
			{
				return Math.sqrt(Math.pow(hPixels, 2)+Math.pow(vPixels, 2))/diagSize;
			}
		}
		
	}
}