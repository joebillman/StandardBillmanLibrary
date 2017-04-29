////////////////////////////////////////////////////////////////////////////////
//  
//  Joe Billman
//  Copyright 2015 Joe Billman
//  All Rights Reserved.
//  
////////////////////////////////////////////////////////////////////////////////

package com.joebillman.utils
{
	import flash.utils.Timer;
	
	/**
	 * DelayData: Datatype used by the Delay class
	 *
	 *
	 */
	public class DelayData
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		public var callback:Function;
		public var id:String;
		public var params:Array;
		public var timer:Timer;
		
	}
}