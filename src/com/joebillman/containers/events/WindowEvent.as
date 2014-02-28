/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* //AUTHOR:
*   Joe Billman - Software Engineer
*
*
* //DATE: 
*   January 2011
*
*
* //COPYRIGHT: 
*   U.S. Institute of Languages®. All rights reserved.
*
*
* //SAMPLE USAGE:
* 
* 
* 
* //BRIEF EXPLINATION:
*   This class defines the events used by the WindowFlex class
* 
* 
* //REVISION NOTES:
*   none currently
*
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package com.joebillman.containers.events
{
	//IMPORTS:__________________________________________________________________________________________________
	//----------------------------------------------<IMPORTS>-------------------------------------------------//
	import flash.events.Event;

	public class WindowEvent extends flash.events.Event
	{
		//VARIABLES:________________________________________________________________________________________________
		//-----------------------------------------<VARIABLE MEMBERS>---------------------------------------------//
		//Private:
		
		//Public:
		public static const CLOSE:String = "winClose";
		public static const CLOSE_BTN:String = "winCloseBtn";
		public static const FADE_IN:String = "winFadeIn";
		public static const FADE_IN_COMPLETE:String = "winFadeInComplete";
		public static const FADE_OUT:String = "winFadeOut";
		public static const FADE_OUT_COMPLETE:String = "winFadeOutComplete";
		
		//CONSTRUCTOR:______________________________________________________________________________________________
		//----------------------------------------<CONSTRUCTOR Methods>-------------------------------------------//
		//Constructor. 
		public function WindowEvent(evt:String)
		{
			super(evt);
		}
		
		//PUBLIC:__________________________________________________________________________________________________
		//------------------------------------------<Public Methods>---------------------------------------------//
		//When creating custom events, you have to ovveride the clone function for correct bubbling and operation
		public override function clone():Event
		{
			return new WindowEvent(this.type);
		}
		//When creating custom events, you have to ovveride the toString function for correct bubbling and operation
		public override function toString():String
		{
			return this.type;
		}
		
	}
	
}