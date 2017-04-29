
package com.joebillman.sound
{
	
	/**
	 * SoundData: Initial object that contains data needed to construct sound object
	 *
	 *
	 */
	public class SoundData
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private var _name:String;
		private var _type:String;
		private var _url:*;
		private var _volume:Number;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 *  Constructor.
		 *
		 */
		public function SoundData(url:*, name:String, type:String=null, volume:Number=1)
		{
			_url = url;
			_name = name;
			_type = type;
			_volume = volume;
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function get name():String
		{
			return _name;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get url():*
		{
			return _url;
		}
		
		public function get volume():Number
		{
			return _volume;
		}
		
	}
}