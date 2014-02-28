/* * * * * * * * * * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* //AUTHORS:
*   Joe Billman
*	isFrontFacing function was written by Senocular. Big thanks!
*
* //DATES:
*	Nov 19, 2010
*
* //COPYRIGHT:
* 	2010
* 
* //REVISION NOTES:
*   none currently
*
*
* * * * * * * * * * * * * * * * * * * * *  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package com.joebillman.display
{
	//IMPORTS:__________________________________________________________________________________________________
	//------------------------------------------------<IMPORTS>-----------------------------------------------//
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	//--------------------------------------
	//  Class description
	//	This class contains a function that is very useful when flipping a display object in 3D and wanting to change what is displayed on the other side as it's flipped
	/**
	 * Status3D: 
	 *
	 *
	 * @example The following example.
	 * <p><strong>Note:</strong> Details</p>
	 * <listing version="3.0" >
	 * Status3D.isFrontFacing(myTarget);
	 * </listing>
	 *
	 *
	 * @author Joe Billman
	 */
	public class Status3D
	{
		//VARIABLES:________________________________________________________________________________________________
		//-----------------------------------------<VARIABLE MEMBERS>---------------------------------------------//
		
		//PUBLIC:__________________________________________________________________________________________________
		//---------------------------------------------<PUBLIC Methods>------------------------------------------//
		public static function isFrontFacing(target:DisplayObject):Boolean 
		{
			// define 3 arbitary points in the display object for a
			// global path to test winding
			var p1:Point = target.localToGlobal(new Point(0,0));
			var p2:Point = target.localToGlobal(new Point(100,0));
			var p3:Point = target.localToGlobal(new Point(0,100));
			// use the cross-product for winding which will determine if
			// the front face is facing the viewer
			return Boolean((p2.x-p1.x)*(p3.y-p1.y) - (p2.y-p1.y)*(p3.x-p1.x) > 0);
		}
	}
}