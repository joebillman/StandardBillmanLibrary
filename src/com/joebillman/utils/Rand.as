////////////////////////////////////////////////////////////////////////////////
//  
//  JOE BILLMAN (joebillman.com)
//  Copyright 2012 Joe Billman
//  All Rights Reserved.
//
//  AUTHORS:
//  Joe Billman
//  
//  CREATION DATE: January 2009
// 
//	REVISION NOTES:
//  July 2009
//	- I added a random color function
//	November 2010
//	- I modified the random array function to be more useful for what I need it for (shuffling cards).
//	August 2012
//	- I added Grant Skinner's functions, changed some names and removed the old stuff.
//
//	NOTICE: I (Joe Billman) permit you to use, modify, and distribute this file no questions asked.
//          A great portion of this class is from Grant Skinner's Rnd class (gskinner.com). Thanks Grant!
////////////////////////////////////////////////////////////////////////////////
package com.joebillman.utils
{
	import flash.display.BitmapData;
	
	/**
	 * Rand: This is a useful class for generating random items.
	 *
	 *
	 * @example The following example illustrates basic usage.
	 * <listing version="3.0" >
	 * Rand.seed = Math.random()*0xFFFFFF;
	 * Rand.integer(-10, 10);</listing>
	 * 
	 * 
	 */
	public class Rand
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private-Static:
		//----------------------------------
		
		private static var _instance:Rand;
		private static var bmpData:BitmapData;
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private var _pointer:uint = 0;
		private var _seed:uint = 0;
		private var seedInvalid:Boolean = true;
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Public-Static:
		//----------------------------------
		
		public static function get instance():Rand
		{
			if(_instance == null)
			{
				_instance = new Rand();
			}
			return _instance;
		}
		
		public static function get pointer():uint
		{
			return instance.pointer;
		}
		
		public static function set pointer(value:uint):void
		{
			instance.pointer = value;
		}
		
		public static function get seed():uint
		{
			return instance.seed;
		}
		
		public static function set seed(value:uint):void
		{
			instance.seed = value;
		}
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		/**
		 * trace(Rndm.pointer); traces the current position in the number series
		 * Rndm.pointer = 50; moves the pointer to the 50th number in the series
		 * @return 
		 * 
		 */		
		public function get pointer():uint
		{
			return _pointer;
		}
		public function set pointer(value:uint):void {
			_pointer = value;
		}
		
		/**
		 * seed = Math.random()*0xFFFFFF; sets a random seed
		 * seed = 50; sets a static seed
		 * @return 
		 * 
		 */		
		public function get seed():uint
		{
			return _seed;
		}
		
		public function set seed(value:uint):void
		{
			if(value != _seed)
			{
				seedInvalid = true;
				_pointer=0;
			}
			_seed = value;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 *  Constructor.
		 *
		 */
		public function Rand(seed:uint=0)
		{
			_seed = seed;
			bmpData = new BitmapData(1000, 200);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Public-Static:
		//----------------------------------
		
		public static function array(src:Array):void
		{
			instance.array(src);
		}
		
		public static function bit(chance:Number=0.5):int
		{
			return instance.bit(chance);
		}
		
		public static function boolean(chance:Number=0.5):Boolean
		{
			return instance.boolean(chance);
		}
		
		public static function color():Object
		{
			return instance.color();
		}
		
		public static function destroy():void
		{
			instance.destroy();
		}
		
		public static function integer(min:Number, max:Number=NaN):int
		{
			return instance.integer(min, max);
		}
		
		public static function number(min:Number, max:Number=NaN):Number
		{
			return instance.number(min,max);
		}
		
		public static function random():Number
		{
			return instance.random();
		}
		
		public static function reset():void
		{
			instance.reset();
		}
		
		public static function sign(chance:Number=0.5):int
		{
			return instance.sign(chance);
		}
		
		public static function vector(src:*):void
		{
			instance.vector(src);
		}
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		/**
		 * This function ranodmizes an array.
		 * @param		src			array values from which to randomize.
		 * @return		void		The array is passed by value.
		 *   
		 */
		public function array(src:Array):void
		{
			var len:uint = src.length;
			for(var i:int=len-1; i>=0; i--)
			{
				var randIndex:uint = integer(0, len-1);
				var temp:* = src[randIndex];
				src[randIndex] = src[i];
				src[i] = temp;
			}
		}
		
		/**
		 * bit(); returns 1 or 0 (50% chance of 1)
		 * bit(0.8); returns 1 or 0 (80% chance of 1)
		 * @param chance
		 * @return 
		 * 
		 */		
		public function bit(chance:Number=0.5):int
		{
			return (random() < chance) ? 1 : 0;
		}
		
		/**
		 * boolean(); returns true or false (50% chance of true)
		 * boolean(0.8); returns true or false (80% chance of true)
		 * @param chance
		 * @return 
		 * 
		 */		
		public function boolean(chance:Number=0.5):Boolean
		{
			return (random() < chance);
		}
		
		/**
		 * This function returns a random color.
		 * 
		 */
		public function color():Object
		{
			return Object("0x"+("00000"+(Math.random()*16777216<<0).toString(16)).substr(-6));
		}
		
		/**
		 * Necessary for garbage collection to completely remove from memory. 
		 * 
		 */		
		public function destroy():void
		{
			bmpData = null;
			_instance = null;
		}
		
		/**
		 * integer(50); returns an integer between 0-50 inclusive. (Joe) I modified this by adding 1 to max so that it would include it.
		 * integer(20,50); returns an integer between 20-50 inclusive
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public function integer(min:Number,max:Number=NaN):int
		{
			if(isNaN(max))
			{
				max = min;
				min=0;
			}
			// Need to use floor instead of bit shift to work properly with negative values:
			return Math.floor(number(min, max+1));
		}
		
		/**
		 * number(50); returns a number between 0-50 exclusive
		 * number(20,50); returns a number between 20-50 exclusive
		 * @param min
		 * @param max
		 * @return 
		 * 
		 */		
		public function number(min:Number, max:Number=NaN):Number
		{
			if(isNaN(max))
			{
				max = min;
				min=0;
			}
			return random()*(max-min)+min;
		}
		
		/**
		 * random(); returns a number between 0-1 exclusive.
		 * @return 
		 * 
		 */		
		public function random():Number
		{
			if(seedInvalid)
			{
				if(_seed == 0)
				{
					_seed = Math.random()*100;
				}
				bmpData.noise(_seed, 0, 255, 1|2|4|8);
				seedInvalid = false;
			}
			_pointer = (_pointer+1)%200000;
			// Flash's numeric precision appears to run to 0.9999999999999999, but we'll drop one digit to be safe:
			return (bmpData.getPixel32(_pointer%1000, _pointer/1000>>0)*0.999999999999998+0.000000000000001)/0xFFFFFFFF;
		}
		
		/**
		 * reset(); resets the number series, retaining the same seed
		 * 
		 */		
		public function reset():void
		{
			_pointer = 0;
		}
		
		/**
		 * sign(); returns 1 or -1 (50% chance of 1)
		 * sign(0.8); returns 1 or -1 (80% chance of 1)
		 * @param chance
		 * @return 
		 * 
		 */		
		public function sign(chance:Number=0.5):int
		{
			return (random() < chance) ? 1 : -1;
		}
		
		/**
		 * This function ranodmizes a vector.
		 * @param		src			vector values from which to randomize.
		 * @return		void		The vector is passed by value.  
		 */
		public function vector(src:*):void
		{
			var len:uint = src.length;
			for(var i:int=len-1; i>=0; i--)
			{
				var randIndex:uint = integer(0, len-1);
				var temp:* = src[randIndex];
				src[randIndex] = src[i];
				src[i] = temp;
			}
		}
		
	}
}