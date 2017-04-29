////////////////////////////////////////////////////////////////////////////////
//  
//  Joe Billman
//  Copyright 2016 Joe Billman
//  All Rights Reserved.
//  
////////////////////////////////////////////////////////////////////////////////

package com.joebillman.utils
{
	import flash.external.ExternalInterface;
	
	/**
	 * ConsoleUtil: Function used to output to the JavaScript console.
	 *
	 *
	 */
	public class ConsoleUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		
		public static function log(value:String):void
		{
			if(ExternalInterface.available)
			{
				ExternalInterface.call("console.log", value);
			}
		}
		
	}
}