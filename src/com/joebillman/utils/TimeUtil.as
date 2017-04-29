////////////////////////////////////////////////////////////////////////////////
//  
//  Joe Billman
//  Copyright 2017 Joe Billman
//  All Rights Reserved.
//  
////////////////////////////////////////////////////////////////////////////////

package com.joebillman.utils
{
	
	/**
	 * TimeUtil: Utility for converting time values.
	 *
	 *
	 */
	public class TimeUtil
	{
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		public static function minToMiliSec(minutes:Number):Number
		{
			return secToMiliSec(minToSec(minutes));
		}
		
		public static function minToSec(minutes:Number):Number
		{
			return minutes*60;
		}
		
		public static function secToMiliSec(seconds:Number):Number
		{
			return seconds*1000;
		}
		
	}
}