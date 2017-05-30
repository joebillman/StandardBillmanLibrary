package com.joebillman.formatters
{
	
	public class TimeFormatter
	{
		private static const MS_IN_HR:Number = 3600000;
		private static const MS_IN_MIN:Number = 60000;
		private static const MS_IN_SEC:Number = 1000;
		
		public static function milliToHrAndMin(val:Number):String
		{
			var formattedTime:String = "";
			var hr:Number = Math.floor(val / MS_IN_HR);
			var min:Number = Math.floor((val % MS_IN_HR) / MS_IN_MIN);
			
			if(hr < 10)
			{
				formattedTime += "0"+hr.toString();
			}
			else
			{
				formattedTime += hr.toString();
			}
			formattedTime += ":";
			if(min < 10)
			{
				formattedTime += "0"+min.toString();
			}
			else
			{
				formattedTime += min.toString();
			}
			
			return formattedTime;
		}
		
		public static function milliToHrAndMinAndSec(val:Number):String
		{
			var formattedTime:String = "";
			var hr:Number = Math.floor(val / MS_IN_HR);
			var min:Number = Math.floor((val % MS_IN_HR) / MS_IN_MIN);
			var sec:Number = Math.floor(((val % MS_IN_HR) % MS_IN_MIN) / MS_IN_SEC);
			
			if(hr < 10)
			{
				formattedTime += "0"+hr.toString();
			}
			else
			{
				formattedTime += hr.toString();
			}
			formattedTime += ":";
			if(min < 10)
			{
				formattedTime += "0"+min.toString();
			}
			else
			{
				formattedTime += min.toString();
			}
			formattedTime += ":";
			if(sec < 10)
			{
				formattedTime += "0"+sec.toString();
			}
			else
			{
				formattedTime += sec.toString();
			}
			
			return formattedTime;
		}
		
		public static function milliToMinAndSec(val:Number):String
		{
			var formattedTime:String = "";
			var min:Number = Math.floor(val / MS_IN_MIN);
			var sec:Number = Math.floor((val % MS_IN_MIN) / MS_IN_SEC);
			
			if(min < 10)
			{
				formattedTime += "0"+min.toString();
			}
			else
			{
				formattedTime += min.toString();
			}
			formattedTime += ":";
			if(sec < 10)
			{
				formattedTime += "0"+sec.toString();
			}
			else
			{
				formattedTime += sec.toString();
			}
			
			return formattedTime;
		}
		
		public static function secToMinAndSec(val:Number):String
		{
			var formattedTime:String = "";
			var min:Number;
			var sec:Number;
			
			min = val/60;
			sec = val%60;
			
			if(min < 10)
			{
				formattedTime += "0"+min.toString();
			}
			else
			{
				formattedTime += min.toString();
			}
			formattedTime += ":";
			if(sec < 10)
			{
				formattedTime += "0"+sec.toString();
			}
			else
			{
				formattedTime += sec.toString();
			}
			
			return formattedTime;
		}
		
		public static function minAndSecToSec(val:String):Number
		{
			var min:Number;
			var minTime:String;
			var sec:Number;
			var secTime:String;
			
			minTime = val.substring(0, val.indexOf(":"));
			secTime = val.substr(val.indexOf(":")+1);
			min = Number(minTime)*60;
			sec = Number(secTime);
			
			return min+sec;
		}
		
	}
	
}