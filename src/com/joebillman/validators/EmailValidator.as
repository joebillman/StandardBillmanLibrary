package com.joebillman.validators
{
	public class EmailValidator
	{
		public static function validateEmail(emailAddress:String):Boolean
		{
			var testsPassed:uint = 0;
			if(emailAddress.indexOf('@') > 0)
				testsPassed++;
			if(emailAddress.lastIndexOf('.') > emailAddress.indexOf('@'))
				testsPassed++;
			if(testsPassed == 2)
				return true;
			else
				return false;
		}
	}
}
