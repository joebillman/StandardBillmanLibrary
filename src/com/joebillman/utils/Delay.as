////////////////////////////////////////////////////////////////////////////////
//  
//  Joe Billman
//  Copyright 2015 Joe Billman
//  All Rights Reserved.
//  
////////////////////////////////////////////////////////////////////////////////

package com.joebillman.utils
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * Delay: This class is helpful for calling functions after a certain period of time.
	 *
	 *
	 */
	public class Delay
	{
		//--------------------------------------------------------------------------
		//
		//  Variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private static var delayCalls:Vector.<DelayData>;
		
		//--------------------------------------------------------------------------
		//
		//  Methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private static function checkForDuplicateIds(id:String):void
		{
			if(delayCalls)
			{
				var len:uint = delayCalls.length;
				for(var i:int=0; i<len; i++) 
				{
					if(delayCalls[i].id && delayCalls[i].id == id)
					{
						trace("!!! WARNING: Duplicate ID detected. Did you mean to set two delays with the same ID?");
						return;
					}
				}
			}
		}
		
		private static function handleComplete(event:TimerEvent):void
		{
			var curCall:DelayData;
			var len:uint = delayCalls.length;
			for(var i:int=0; i<len; i++) 
			{
				if(delayCalls[i].timer === event.target)
				{
					curCall = delayCalls[i];
					delayCalls.splice(i, 1);
					break;
				}
			}
			curCall.timer.reset();
			curCall.timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleComplete);
			curCall.timer = null;
			if(curCall.params)
			{
				curCall.callback.apply(null, curCall.params);
			}
			else
			{
				curCall.callback.call();
			}
			curCall.callback = null;
			curCall.id = null;
			curCall.params = null;
			if(delayCalls && delayCalls.length == 0)
			{
				delayCalls = null;
			}
		}
		
		private static function removeCall(id:String):void
		{
			if(delayCalls)
			{
				for(var i:int=0; i<delayCalls.length; i++) 
				{
					if(delayCalls[i].id == id)
					{
						delayCalls[i].callback = null;
						delayCalls[i].id = null;
						delayCalls[i].params = null;
						if(delayCalls[i].timer)
						{
							delayCalls[i].timer.reset();
							delayCalls[i].timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleComplete);
							delayCalls[i].timer = null;
						}
						delayCalls[i].params = null;
						delayCalls[i] = null;
						delayCalls.splice(i, 1);
					}
				}
			}
		}
		
		//----------------------------------
		//  Public-Static:
		//----------------------------------
		
		public static function anyDelaysAreRunning():Boolean
		{
			if(delayCalls)
			{
				var len:uint = delayCalls.length;
				for(var i:int=0; i<len; i++) 
				{
					if(delayCalls[i].timer && delayCalls[i].timer.running)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public static function callLater(functionToCall:Function, delayMS:Number, id:String=null, ...args):void
		{
			if(delayCalls == null)
			{
				delayCalls = new Vector.<DelayData>();
			}
			checkForDuplicateIds(id);
			var curCall:DelayData = new DelayData();
			curCall.timer = new Timer(1000, 1);
			curCall.timer.addEventListener(TimerEvent.TIMER_COMPLETE, handleComplete);
			curCall.callback = functionToCall;
			curCall.timer.delay = delayMS;
			if(id != null)
			{
				curCall.id = id;
			}
			curCall.params = args as Array;
			delayCalls.push(curCall);
			curCall.timer.start();
		}
		
		public static function cancelAllCalls():void
		{
			if(delayCalls)
			{
				var len:uint = delayCalls.length;
				for(var i:int=0; i<len; i++) 
				{
					if(delayCalls[i].timer)
					{
						delayCalls[i].timer.reset();
						delayCalls[i].timer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleComplete);
						delayCalls[i].timer = null;
					}
					delayCalls[i].callback = null;
					delayCalls[i].id = null;
					delayCalls[i].params = null;
					delayCalls[i] = null;
				}
				delayCalls = null;
			}
		}
		
		public static function cancelCall(id:String):void
		{
			removeCall(id);
		}
		
		public static function delayIsRunning(id:String):Boolean
		{
			if(delayCalls)
			{
				var len:uint = delayCalls.length;
				for(var i:int=0; i<len; i++) 
				{
					if(delayCalls[i].id && delayCalls[i].id == id)
					{
						return true;
					}
				}
			}
			return false;
		}
		
		public static function destroy():void
		{
			cancelAllCalls();
		}
		
		public static function getAllDelaysRunning():Vector.<DelayData>
		{
			var runningDelays:Vector.<DelayData> = new Vector.<DelayData>();
			if(delayCalls)
			{
				var len:uint = delayCalls.length;
				for(var i:int=0; i<len; i++) 
				{
					if(delayCalls[i].timer && delayCalls[i].timer.running)
					{
						runningDelays.push(delayCalls[i]);
					}
				}
			}
			return runningDelays;
		}
		
		public static function pauseCall(id:String):void
		{
			if(delayCalls)
			{
				var len:uint = delayCalls.length;
				for(var i:int=0; i<len; i++) 
				{
					if(delayCalls[i].id == id)
					{
						if(delayCalls[i].timer)
						{
							delayCalls[i].timer.stop();
						}
					}
				}
			}
		}
		
		public static function resumeCall(id:String):void
		{
			if(delayCalls)
			{
				var len:uint = delayCalls.length;
				for(var i:int=0; i<len; i++) 
				{
					if(delayCalls[i].id == id)
					{
						if(delayCalls[i].timer)
						{
							delayCalls[i].timer.start();
						}
					}
				}
			}
		}
		
	}
}