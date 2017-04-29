
package com.joebillman.sound
{
	import com.joebillman.events.SoundManagerEvent;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	/**
	 * SoundObject: This is used as a data type for the SoundManager class
	 *
	 *
	 */
	public class SoundObject extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private var _defaultVolume:Number;
		private var _name:String;
		private var _transform:SoundTransform;
		private var _type:String;
		private var channel:SoundChannel;
		private var channels:Vector.<SoundChannel>;
		private var curAudioTime:Number;
		private var loopCount:int;
		private var playParams:Array;
		private var sound:Sound;
		private var sounds:Vector.<Sound>;
		private var url:*;
		private var waitTimer:Timer;
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		public var hasCustomVolume:Boolean;
		public var isFading:Boolean;
		public var isPlaying:Boolean;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 *  Constructor.
		 *
		 */
		public function SoundObject(url:*, name:String, type:String=null, vol:Number=1)
		{
			hasCustomVolume = false;
			this.url = url;
			_name = name;
			this._type = type;
			if(vol != 1)
			{
				hasCustomVolume = true;
			}
			_defaultVolume = vol; 
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
			curAudioTime = -1;
			isFading = false;
			isPlaying = false;
			
			createSoundTransform();
			loadSound();
		}
		
		private function createSoundTransform():void
		{
			_transform = new SoundTransform();
			if(_defaultVolume > 1)
			{
				_defaultVolume /= 100;
			}
			_transform.volume = _defaultVolume;
		}
		
		private function createWaitTimer():void
		{
			waitTimer = new Timer(1000, 1);
			waitTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete, false, 0, true);
		}
		
		private function destroySound():void
		{
			if(channel)
			{
				channel.stop();
				channel.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
				channel = null;
			}
			if(sound)
			{
				sound.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				sound = null;
			}
		}
		
		private function destroyVectors():void
		{
			if(channels)
			{
				var len:uint = channels.length;
				for(var i:uint=0; i<len; i++) 
				{
					channels[i].stop();
					channels[i].removeEventListener(Event.COMPLETE, handleSoundComplete);
					channels[i] = null;
				}
				channels = null;
			}
			if(sounds)
			{
				len = sounds.length;
				for(i=0; i<len; i++) 
				{
					sounds[i] = null;
				}
				sounds = null;
			}
		}
		
		private function destroyWaitTimer():void
		{
			if(waitTimer)
			{
				waitTimer.reset();
				waitTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
				waitTimer = null;
			}
		}
		
		private function getTargetIndex(item:Object, targets:*):int
		{
			var targetIndex:int = -1;
			
			var len:uint = targets.length;
			for(var i:uint=0; i<len; i++) 
			{
				if(item === targets[i])
				{
					targetIndex = i;
					break;
				}
			}
			
			return targetIndex;
		}
		
		private function handleFadeInComplete():void
		{
			isFading = false;
		}
		
		private function handleFadeOutComplete():void
		{
			isFading = false;
			stop();
			dispatchEvent(new SoundManagerEvent(SoundManagerEvent.FADE_OUT_COMPLETE, _name));
		}
		
		private function handleIOError(evt:IOErrorEvent):void
		{
			//handle error if needed
		}
		
		private function handleSoundComplete(event:Event):void
		{
			event.target.removeEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
			if(sounds)
			{
				var targetIndex:int = getTargetIndex(event.target, sounds);
				channels.splice(targetIndex, 1);
				sounds.splice(targetIndex, 1);
			}
			dispatchEvent(event);
		}
		
		private function handleTimerComplete(event:TimerEvent):void
		{
			play(playParams[0], playParams[1], playParams[2]);
		}
		
		private function loadSound():void
		{
			if(url is Class)
			{
				sound = new url();
			}
			else if(url is String)
			{
				sound = new Sound();
				sound.addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
				sound.load(new URLRequest(url));
			}
			else
			{
				throw new Error("Unrecognized sound format");
				return;
			}
			sound.play(0, 0, new SoundTransform(0));
		}
		
		private function waitAndTryAgain(waitTime:Number):void
		{
			waitTimer.reset();
			waitTimer.delay = waitTime;
			waitTimer.start();
		}
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		public function cleanup():void
		{
			playParams = null;
			destroyWaitTimer();
			destroySound();
			destroyVectors();
		}
		
		public function fadeIn(fadeTime:uint=5, endVolume:Number=1):void
		{
			if(isFading)
			{
				Tweener.removeTweens(this);
			}
			if(_transform.volume == endVolume || _transform.volume == 1 || _transform.volume == _defaultVolume)
			{
				_transform.volume = 0.01;
			}
			if(!isPlaying)
			{
				play();
			}
			Tweener.addTween(this, {volume:endVolume, time:fadeTime, transition:Equations.easeInQuad, onComplete:handleFadeInComplete});
			isFading = true;
		}
		
		public function fadeOut(fadeTime:uint, endVolume:Number):void
		{
			if(isFading)
			{
				Tweener.removeTweens(this);
			}
			if(_transform.volume == endVolume || _transform.volume == 0)
			{
				_transform.volume = _defaultVolume;
			}
			Tweener.addTween(this, {volume:endVolume, time:fadeTime, transition:Equations.easeOutQuad, onComplete:handleFadeOutComplete});
			isFading = true;
		}
		
		public function play(startTime:Number=0, allowOverlap:Boolean=false, loops:int=0):void
		{
			isPlaying = true;
			loopCount = loops;
			if(_transform.volume == 0)
			{
				_transform.volume = _defaultVolume;
			}
			if(!allowOverlap)
			{
				curAudioTime = startTime;
				channel = sound.play(curAudioTime, loopCount, _transform);
				if(channel)
				{
					channel.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete, false, 0, true);
				}
				else
				{
					if(waitTimer == null)
					{
						createWaitTimer();
					}
					playParams = [startTime, allowOverlap, loops];
					waitAndTryAgain(500);
				}
			}
			else
			{
				if(sounds == null)
				{
					sounds = new Vector.<Sound>();
				}
				if(channels == null)
				{
					channels = new Vector.<SoundChannel>();
				}
				var chnl:SoundChannel = new SoundChannel;
				var snd:Sound = new Sound(new URLRequest(url));
				chnl = snd.play(startTime, loopCount, _transform);
				chnl.addEventListener(Event.SOUND_COMPLETE, handleSoundComplete);
				channels.push(chnl);
				sounds.push(snd);
			}
		}
		
		public function resume():void
		{
			if(curAudioTime > -1)
			{
				if(_transform.volume == 0)
				{
					_transform.volume = 0.01;
					fadeIn();
				}
				else
				{
					play(curAudioTime, false, loopCount);
				}
			}
		}
		
		public function stop():void
		{
			isPlaying = false;
			if(channel)
			{
				if(isFading)
				{
					isFading = false;
				}
				Tweener.removeTweens(this);
				curAudioTime = channel.position;
				channel.stop();
			}
		}
		
		//--------------------------------------------------------------------------
		//
		//  Properties
		//
		//--------------------------------------------------------------------------
		
		public function get defaultVolume():Number
		{
			return _defaultVolume;
		}
		
		public function get name():String
		{
			return _name;
		}
		
		public function get transform():SoundTransform
		{
			return _transform;
		}
		
		public function get type():String
		{
			return _type;
		}
		
		public function get volume():Number
		{
			return _transform.volume;
		}
		
		public function set volume(value:Number):void
		{
			_transform.volume = value;
			if(channel)
			{
				channel.soundTransform = _transform;
			}
		}
		
	}
}