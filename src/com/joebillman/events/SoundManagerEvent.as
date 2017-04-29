
package com.joebillman.events
{
	import flash.events.Event;
	
	/**
	 * SoundManagerEvent: Events dispatched from the SoundManager class.
	 *
	 *
	 */
	public class SoundManagerEvent extends Event
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		public static const FADE_OUT_COMPLETE:String = "SoundManagerEvent:fadeOutComplete"; 
		public static const SOUND_COMPLETE:String = "SoundManagerEvent:soundComplete"; 
		
		public var data:Object;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 *  Constructor.
		 *  
		 * @param type	Type of event.
		 * 
		 */		
		public function SoundManagerEvent(type:String, data:Object=null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			this.data = data;
			super(type, bubbles, cancelable);
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		public override function clone():Event
		{
			return new SoundManagerEvent(type, data, bubbles, cancelable);
		}
		
		public override function toString():String
		{
			return type;
		}
		
	}
}