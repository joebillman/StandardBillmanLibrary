////////////////////////////////////////////////////////////////////////////////
//  
//  Copyright 2012 Joseph Billman (joebillman.com). All Rights Reserved.
//  
//  This ActionScript source code is free.
//  You can redistribute and/or modify it in accordance with the
//  terms of the accompanying Simplified BSD License Agreement.
//
////////////////////////////////////////////////////////////////////////////////
package com.joebillman.utils
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.system.System;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	/**
	 * FpsProfiler: Profiles frames per second (FPS) and memory.
	 *
	 *
	 * @example The following example illustrates basic usage.
	 * <p><strong>Note: If you need more control over the profiler you will need to store it in a variable and access it's public methods from that instance.</strong> Details</p>
	 * <listing version="3.0" >
	 * FpsProfiler.profile(this.stage);</listing>
	 * 
	 * 
	 */
	public class FpsProfiler extends Sprite
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private const AVG_BG_COLOR:uint = 0xCCCCCC;
		private const AVG_BG_HEIGHT:Number = 20;
		private const AVG_FONT_COLOR:uint = 0x333333;
		private const AVG_FONT_SIZE:uint = 12;
		private const AVG_RAM_HEIGHT:Number = 19;
		private const AVG_TITLE:String = "AVG FPS: ";
		private const FONT:String = "_sans";
		private const FPS_BG_COLOR:uint = 0xFFFFFF;
		private const FPS_BG_HEIGHT:Number = 30;
		private const FPS_BUFFER:uint = 5;
		private const FPS_FONT_COLOR:uint = 0x777777;
		private const FPS_FONT_COLOR_GOOD:uint = 0x00FF00;
		private const FPS_FONT_COLOR_BAD:uint = 0xFF0000;
		private const FPS_FONT_SIZE:uint = 18;
		private const FPS_TITLE:String = "FPS:  ";
		private const FPS_TITLE_HEIGHT:Number = 25;
		private const PADDING:Number = 10;
		private const RADIUS:Number = 8;
		private const RAM_BG_COLOR:uint = 0x666666;
		private const RAM_BG_HEIGHT:Number = 20;
		private const RAM_FONT_COLOR:uint = 0xFFFFFF;
		private const RAM_FONT_SIZE:uint = 12;
		private const RAM_TITLE:String = "RAM MB:  ";
		private const SAMPLE_SIZE:uint = 20;
		private const WIDTH:Number = 92;

		private static var profiler:FpsProfiler;
		
		private var averages:Array;
		private var bgAVG:Shape;
		private var bgFPS:Shape;
		private var bgRAM:Shape;
		private var container:Sprite;
		private var curTime:int;
		private var frameCount:uint;
		private var labelAVG:TextField;
		private var labelAVG2:TextField;
		private var labelFPS:TextField;
		private var labelFPS2:TextField;
		private var labelRAM:TextField;
		private var labelRAM2:TextField;
		private var lastTime:int;
		private var targetObject:DisplayObjectContainer;
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private function addDropShadow():void
		{
			container.filters = [new GlowFilter(0x000000, .55, 10, 10, 2)];
		}
		
		private function build():void
		{
			averages = [];
			container = new Sprite();
			frameCount = 0;
			createBgFPS();
			createBgAVG();
			createLabelFPS();
			createLabelAVG();
			createBgRAM();
			createLabelRAM();
			addDropShadow();
			startProfiling();
		}
		
		private function calcAVG():uint
		{
			var sum:uint = 0;
			var len:uint = averages.length;
			for(var i:uint=0; i<len; i++)
			{
				sum += averages[i];
			}
			return sum/len;
		}
		
		private function calcRAM():String
		{
			return ((System.totalMemory/1024)/1024).toFixed(0);
		}
		
		private function createBgAVG():void
		{
			bgAVG = new Shape();
			var gr:Graphics = bgAVG.graphics;
			gr.beginFill(AVG_BG_COLOR);
			gr.drawRect(0, 0, WIDTH, AVG_BG_HEIGHT)
			gr.endFill();
			bgAVG.y = bgFPS.y+bgFPS.height;
			container.addChild(bgAVG);
		}
		
		private function createBgFPS():void
		{
			bgFPS = new Shape();
			var gr:Graphics = bgFPS.graphics;
			gr.beginFill(FPS_BG_COLOR);
			gr.moveTo(0, RADIUS);
			gr.curveTo(0, 0, RADIUS, 0);
			gr.lineTo(WIDTH-RADIUS, 0);
			gr.curveTo(WIDTH, 0, WIDTH, RADIUS);
			gr.lineTo(WIDTH, FPS_BG_HEIGHT);
			gr.lineTo(0, FPS_BG_HEIGHT);
			gr.lineTo(0, 2);
			gr.endFill();
			container.addChild(bgFPS);
		}
		
		private function createBgRAM():void
		{
			bgRAM = new Shape();
			var gr:Graphics = bgRAM.graphics;
			gr.beginFill(RAM_BG_COLOR);
			gr.lineTo(WIDTH, 0);
			gr.lineTo(WIDTH, RAM_BG_HEIGHT-RADIUS);
			gr.curveTo(WIDTH, RAM_BG_HEIGHT, WIDTH-RADIUS, RAM_BG_HEIGHT);
			gr.lineTo(0+RADIUS, RAM_BG_HEIGHT);
			gr.curveTo(0, RAM_BG_HEIGHT, 0, RAM_BG_HEIGHT-RADIUS);
			gr.lineTo(0, 0);
			gr.endFill();
			bgRAM.y = bgAVG.y+bgAVG.height;
			container.addChild(bgRAM);
		}
		
		private function createLabelAVG():void
		{
			labelAVG = new TextField();
			labelAVG.defaultTextFormat = new TextFormat(FONT, AVG_FONT_SIZE, AVG_FONT_COLOR, null, null, null, null, null, "left");
			labelAVG.width = (WIDTH-PADDING)*.78;
			labelAVG.height = AVG_RAM_HEIGHT;
			labelAVG.selectable = false;
			labelAVG.text = AVG_TITLE;
			labelAVG.x = labelFPS.x;
			labelAVG.y = bgAVG.y + ((bgAVG.height-labelAVG.height)/2);
			container.addChild(labelAVG);
			
			labelAVG2 = new TextField();
			labelAVG2.defaultTextFormat = new TextFormat(FONT, AVG_FONT_SIZE, AVG_FONT_COLOR, null, null, null, null, null, "right");
			labelAVG2.width = (WIDTH-PADDING)*.22;
			labelAVG2.height = labelAVG.height;
			labelAVG2.selectable = false;
			labelAVG2.text = "0";
			labelAVG2.x = labelAVG.x+labelAVG.width;
			labelAVG2.y = labelAVG.y;
			container.addChild(labelAVG2);
		}
		
		private function createLabelFPS():void
		{
			labelFPS = new TextField();
			labelFPS.defaultTextFormat = new TextFormat(FONT, FPS_FONT_SIZE, FPS_FONT_COLOR, null, null, null, null, null, "left");
			labelFPS.selectable = false;
			labelFPS.width = (WIDTH-PADDING)*.6;
			labelFPS.height = FPS_TITLE_HEIGHT;
			labelFPS.text = FPS_TITLE;
			labelFPS.x = PADDING/2;
			labelFPS.y = bgFPS.y + ((bgFPS.height-labelFPS.height)/2);
			container.addChild(labelFPS);
			
			labelFPS2 = new TextField();
			labelFPS2.defaultTextFormat = new TextFormat(FONT, FPS_FONT_SIZE, FPS_FONT_COLOR, null, null, null, null, null, "right");
			labelFPS2.selectable = false;
			labelFPS2.width = (WIDTH-PADDING)*.4;
			labelFPS2.height = labelFPS.height;
			labelFPS2.text = targetObject.stage.frameRate.toString();
			labelFPS2.x = labelFPS.x+labelFPS.width;
			labelFPS2.y = labelFPS.y;
			container.addChild(labelFPS2);
		}
		
		private function createLabelRAM():void
		{
			labelRAM = new TextField();
			labelRAM.defaultTextFormat = new TextFormat(FONT, RAM_FONT_SIZE, RAM_FONT_COLOR, null, null, null, null, null, "left");
			labelRAM.width = (WIDTH-PADDING)*.70;
			labelRAM.height = AVG_RAM_HEIGHT;
			labelRAM.selectable = false;
			labelRAM.text = RAM_TITLE;
			labelRAM.x = labelFPS.x;
			labelRAM.y = bgRAM.y + ((bgRAM.height-labelRAM.height)/2);
			container.addChild(labelRAM);
			
			labelRAM2 = new TextField();
			labelRAM2.defaultTextFormat = new TextFormat(FONT, RAM_FONT_SIZE, RAM_FONT_COLOR, null, null, null, null, null, "right");
			labelRAM2.width = (WIDTH-PADDING)*.3;
			labelRAM2.height = labelRAM.height;
			labelRAM2.selectable = false;
			labelRAM2.text = "0";
			labelRAM2.x = labelRAM.x+labelRAM.width;
			labelRAM2.y =labelRAM.y;
			container.addChild(labelRAM2);
		}
		
		private function destroyBgAVG():void
		{
			if(bgAVG)
			{
				if(container.contains(bgAVG))
				{
					container.removeChild(bgAVG);
				}
				bgAVG = null;
			}
		}
		
		private function destroyBgFPS():void
		{
			if(bgFPS)
			{
				if(container.contains(bgFPS))
				{
					container.removeChild(bgFPS);
				}
				bgFPS = null;
			}
		}
		
		private function destroyBgRAM():void
		{
			if(bgRAM)
			{
				if(container.contains(bgRAM))
				{
					container.removeChild(bgRAM);
				}
				bgRAM = null;
			}
		}
		
		private function destroyLabelAVG():void
		{
			if(labelAVG)
			{
				if(container.contains(labelAVG))
				{
					container.removeChild(labelAVG);
				}
				labelAVG = null;
			}
			
			if(labelAVG2)
			{
				if(container.contains(labelAVG2))
				{
					container.removeChild(labelAVG2);
				}
				labelAVG2 = null;
			}
		}
		
		private function destroyLabelFPS():void
		{
			if(labelFPS)
			{
				if(container.contains(labelFPS))
				{
					container.removeChild(labelFPS);
				}
				labelFPS = null;
			}
			
			if(labelFPS2)
			{
				if(container.contains(labelFPS2))
				{
					container.removeChild(labelFPS2);
				}
				labelFPS2 = null;
			}
		}
		
		private function destroyLabelRAM():void
		{
			if(labelRAM)
			{
				if(container.contains(labelRAM))
				{
					container.removeChild(labelRAM);
				}
				labelRAM = null;
			}
			
			if(labelRAM2)
			{
				if(container.contains(labelRAM2))
				{
					container.removeChild(labelRAM2);
				}
				labelRAM2 = null;
			}
		}
		
		private function handleEnterFrame(event:Event):void
		{
			curTime = getTimer();
			frameCount++;
 
			if(curTime >= lastTime+1000)
			{
				lastTime = curTime;
				labelFPS2.text = frameCount.toString();
				if(frameCount < targetObject.stage.frameRate-FPS_BUFFER)
				{
					labelFPS2.textColor = FPS_FONT_COLOR_BAD;
				}
				else if(frameCount > targetObject.stage.frameRate)
				{
					labelFPS2.textColor = FPS_FONT_COLOR_GOOD;
				}
				else
				{
					labelFPS2.textColor = FPS_FONT_COLOR;
				}
				averages.unshift(frameCount);
				labelAVG.text = AVG_TITLE;
				labelAVG2.text = calcAVG().toString();
				if(averages.length > SAMPLE_SIZE-1)
				{
					averages.pop();
				}
				labelRAM.text = RAM_TITLE;
				labelRAM2.text = calcRAM();
				frameCount = 0;
			}			
		}
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		public function moveTo(x:Number, y:Number):void
		{
			this.container.x = x;
			this.container.y = y;
		}
		
		public static function profile(target:DisplayObjectContainer, profilerX:Number=3, profilerY:Number=3):FpsProfiler
		{
			profiler = new FpsProfiler();
			profiler.targetObject = target;
			profiler.build();
			profiler.container.x = profilerX;
			profiler.container.y = profilerY;
			profiler.targetObject.addChild(profiler.container);
			
			return profiler;
		}
		
		public function setScale(scale:Number):void
		{
			this.container.scaleX = this.container.scaleY = scale;
		}
		
		public static function destroy():void
		{
			if(profiler)
			{
				if(profiler.targetObject)
				{
					profiler.stopProfiling();
					if(profiler.container)
					{
						if(profiler.targetObject.contains(profiler.container))
						{
							profiler.targetObject.removeChild(profiler.container);
						}
					}
					profiler.targetObject = null;
				}
				if(profiler.container)
				{
					profiler.destroyLabelRAM();
					profiler.destroyBgRAM();
					profiler.destroyLabelAVG();
					profiler.destroyLabelFPS();
					profiler.destroyBgAVG();
					profiler.destroyBgFPS();
					profiler.container = null;
				}
			}
		}

		public function startProfiling():void
		{
			targetObject.addEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
		public function stopProfiling():void
		{
			targetObject.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
		}
		
	}
	
}
