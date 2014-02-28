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
*   none currently
*
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package com.joebillman.utils
{
	/**
	* 	Precisely: This is a static class that allows you to do precision based functions.
	*
	*	@author Joe Billman
	*/
	public class Precisely
	{
		/**
		 * This function allows you to set the decimal precision for a number. The values range from 0 (remove decimal places) up. Note: you get strange results for values higher than 8.
		 * @param		val			The number that you will be applying the precision to.
		 * @param		precision	The precision value.
		 * @return		Number		The number that was passed in with the newly generated precision.  
		 */
		public static function setPrecision(val:Number, precision:uint):Number
		{
			var placeValue:uint = Math.pow(10, precision);	//This generates the necessary power of ten needed to perform the math. Ex: 10 to the 2nd power is 100 which then represents the hundredths place in the equation.
			return int(val*placeValue)/placeValue;
		}
	}
}