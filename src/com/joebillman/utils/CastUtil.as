////////////////////////////////////////////////////////////////////////////////
//  
//  Joe Billman
//  Copyright 2013 Joe Billman
//  All Rights Reserved.
//  
////////////////////////////////////////////////////////////////////////////////

package com.joebillman.utils
{
	
	/**
	 * CastUtil: Functions used to cast complex datatypes.
	 *
	 *
	 */
	public class CastUtil
	{
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		
		public static function stringToBoolean(value:String):Boolean
		{
			if(value == "true" || value == "1")
			{
				return true;
			}
			return false;
		}
		
	}
}