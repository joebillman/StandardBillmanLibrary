
package com.joebillman.sound
{
	import com.joebillman.events.SoundManagerEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import caurina.transitions.Tweener;
	
	/**
	 * SoundManager: Manages sounds used for things like loops and sound fx.
	 *
	 *
	 * @example The following demonstrates basic usage.
	 * <listing version="3.0" >
	 * soundManager = new SoundManager();
	 * soundManager.addSound(new SoundData("doh.mp3", "doh", SoundType.FX));
	 * soundManager.play("doh");</listing>
	 *
	 *
	 */
	public class SoundManager extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private var _sounds:Vector.<SoundObject>;
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function get length():uint
		{
			return _sounds.length;
		}
		
		public function get sounds():Vector.<SoundObject>
		{
			return _sounds;
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
		public function SoundManager()
		{
			_init();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private function _init():void
		{
			_sounds = new Vector.<SoundObject>();
		}
		
		private function destroySounds():void
		{
			var len:uint = _sounds.length;
			for(var i:uint=0; i<len; i++) 
			{
				_sounds[i].cleanup();
			}
			_sounds = null;
		}
		
		private function findSound(name:String):SoundObject
		{
			if(_sounds == null)
			{
				return null;
			}
			var targetSound:SoundObject = null;
			var len:uint = _sounds.length;
			for(var i:uint=0; i<len; i++) 
			{
				if(_sounds[i].name == name)
				{
					targetSound = _sounds[i];
					break;
				}
			}
			
			return targetSound;
		}
		
		private function handleFadeOutComplete(event:SoundManagerEvent):void
		{
			event.target.removeEventListener(SoundManagerEvent.FADE_OUT_COMPLETE, handleFadeOutComplete);
			dispatchEvent(event);
		}
		
		private function handleSoundComplete(event:Event):void
		{
			event.target.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			dispatchEvent(new SoundManagerEvent(SoundManagerEvent.SOUND_COMPLETE, event.target.name));
		}
		
		private function stopAllLoops():void
		{
			if(_sounds == null)
			{
				return;
			}
			var len:uint = _sounds.length;
			for(var i:uint=0; i<len; i++) 
			{
				if(_sounds[i].type == SoundType.LOOP)
				{
					_sounds[i].stop();
				}
			}
		}
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		public function addSound(sound:SoundData):void
		{
			var sndObject:SoundObject = new SoundObject(sound.url, sound.name, sound.type, sound.volume);
			_sounds.push(sndObject);
		}
		
		public function cleanup():void
		{
			Tweener.removeAllTweens();
			destroySounds();
		}
		
		public function fadeIn(name:String, fadeTime:uint=5, endVolume:Number=1):void
		{
			var targetSound:SoundObject = findSound(name);
			if(targetSound.hasCustomVolume)
			{
				endVolume = targetSound.defaultVolume;
			}
			if(endVolume > 1)
			{
				endVolume / 100;
			}
			if(targetSound)
			{
				targetSound.fadeIn(fadeTime, endVolume);
			}
		}
		
		public function fadeOut(name:String, fadeTime:uint=3, endVolume:Number=0):void
		{
			if(endVolume > 1)
			{
				endVolume / 100;
			}
			
			var targetSound:SoundObject = findSound(name);
			if(targetSound)
			{
				targetSound.addEventListener(SoundManagerEvent.FADE_OUT_COMPLETE, handleFadeOutComplete, false, 0, true);
				targetSound.fadeOut(fadeTime, endVolume);
			}
		}
		
		public function fadeOutAllSounds(fadeTime:uint=3, endVolume:Number=0):void
		{
			var len:uint = sounds.length;
			for(var i:int=0; i<len; i++) 
			{
				fadeOut(sounds[i].name, fadeTime, endVolume);
			}
		}
		
		public function loop(name:String, fade:Boolean=false, stopAllOthers:Boolean=true):void
		{
			if(stopAllOthers)
			{
				stopAllLoops();
			}
			var targetSound:SoundObject = findSound(name);
			if(targetSound)
			{
				if(fade)
				{
					targetSound.volume = 0;
				}
				targetSound.play(0, false, int.MAX_VALUE);
				if(fade)
				{
					fadeIn(name);
				}
			}
			else
			{
				throw new Error("Unable to loop audio because a reference to it was not found.", "Error");
			}
		}
		
		public function play(name:String, fade:Boolean=false, allowOverlap:Boolean=false, stopAllOthers:Boolean=true, stopSpecific:Array=null, startTime:Number=0, loops:int=0):void
		{
			var targetSound:SoundObject = findSound(name);
			if(targetSound.type == SoundType.LOOP)
			{
				loop(name, fade, stopAllOthers);
			}
			else
			{
				if(targetSound)
				{
					targetSound.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete, false, 0, true);
					targetSound.play(startTime, allowOverlap, loops);
				}
			}
		}
		
		public function resume(name:String):void
		{
			var targetSound:SoundObject = findSound(name);
			if(targetSound)
			{
				targetSound.resume();
			}
		}
		
		public function stop(name:String):void
		{
			var targetSound:SoundObject = findSound(name);
			if(targetSound)
			{
				targetSound.stop();
			}
		}
		
		public function stopAllSounds():void
		{
			var len:uint = _sounds.length;
			for(var i:int=0; i<len; i++) 
			{
				_sounds[i].stop();
			}
		}
		
	}
}