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
		
	}
}