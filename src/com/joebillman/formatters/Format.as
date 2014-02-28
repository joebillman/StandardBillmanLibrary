/* * * * * * * * * * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* //AUTHORS:
*   Joe Billman
*
* //DATES:
*	Dec 3, 2010
*
* //COPYRIGHT:
* 	2010
* 
* //REVISION NOTES:
*   none currently
*
*
* * * * * * * * * * * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package com.joebillman.formatters
{
	//IMPORTS:__________________________________________________________________________________________________
	//------------------------------------------------<IMPORTS>-----------------------------------------------//
	
	//--------------------------------------
	//  Class description
	//
	/**
	 * Format: 
	 *
	 *
	 * @example The following example.
	 * <p><strong>Note:</strong> Details</p>
	 * <listing version="3.0" >
	 * package
	 * {
	 *     public class
	 *     {
	 *     	
	 *     }
	 * }
	 * </listing>
	 *
	 *
	 * @author Joe Billman
	 */
	public class Format
	{
		//VARIABLES:________________________________________________________________________________________________
		//-----------------------------------------<VARIABLE MEMBERS>---------------------------------------------//
		
		//PRIVATE:
		
		//PUBLIC:
		
		//PRIVATE:__________________________________________________________________________________________________
		//---------------------------------------------<PRIVATE Methods>------------------------------------------//
		
		//PUBLIC:__________________________________________________________________________________________________
		//---------------------------------------------<PUBLIC Methods>------------------------------------------//
		public static function asMoney(val:int):String
		{
			var isNegative:Boolean = false;
			var moneyVal:String = val.toString();
			var len:uint;
			if(val < 0)
			{
				isNegative = true;
				moneyVal = moneyVal.replace(/-/, "");
			}
			len = moneyVal.length;
			for(var i:int=len; i>0; i-=3)
			{
				if(i == len)
				{
					continue;
				}
				var firstHalf:String = moneyVal.substring(0, i);
				var lastHalf:String = moneyVal.substring(i);
				moneyVal = firstHalf+","+lastHalf;
			}
			if(isNegative)
			{
				return"$-"+moneyVal;
			}
			return "$"+moneyVal;
		}
	}
}