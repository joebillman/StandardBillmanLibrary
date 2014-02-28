package com.joebillman.formatters
{
	
	public class TimeFormatter
	{
		public static function milliToMinAndSec(val:uint):String
		{
			var time_str:String = "";
			var min:int = Math.floor(val / 1000 / 60);
			var sec:int = (Math.floor(val / 1000) % 60);
			time_str += (min < 10)? 0+min.toString():min.toString();
			time_str += ":";
			time_str += (sec < 10)?0+sec.toString():sec.toString();
			
			return time_str;
		}
		
		public static function secToMinAndSec(val:uint):String
		{
			var min:uint;
			var minTime:String;
			var sec:uint;
			var secTime:String;
			
			min = val/60;
			sec = val%60;
			
			if(min < 10)
			{
				minTime = "0"+min.toString();
			}
			else
			{
				minTime = min.toString();
			}
			
			if(sec < 10)
			{
				secTime = "0"+sec.toString();
			}
			else
			{
				secTime = sec.toString();
			}
			
			return minTime+":"+secTime;
		}
		
		public static function minAndSecToSec(val:String):uint
		{
			var min:uint;
			var minTime:String;
			var sec:uint;
			var secTime:String;
			
			minTime = val.substring(0, val.indexOf(":"));
			secTime = val.substr(val.indexOf(":")+1);
			min = uint(minTime)*60;
			sec = uint(secTime);
			
			return min+sec;
		}
		
	}
	
}