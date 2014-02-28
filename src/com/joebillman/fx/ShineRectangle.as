package com.joebillman.fx
{	
	import flash.display.MovieClip;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.SpreadMethod;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filters.BitmapFilterType;
	import flash.filters.GradientGlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	
	public class ShineRectangle extends Sprite
	{
		//simple
		private var autoStart:Boolean;
		private var hasGlow:Boolean;
		private var hasShimmer:Boolean;
		private var loop:Boolean;
		private var shimmerTransparency:Number;
		private var curPosition:int;
		private var startPosition:int;
		private var blur:uint; 
		private var degree:uint;
		private var endPosition:uint;
		private var maskHeight:uint;
		private var maskPadding:uint;
		private var maskWidth:uint;
		private var intensity:uint;
		private var shineWidth:uint;
		private var speed:uint;
		//complex
		private var glowColor:Array;
		private var matrix:Matrix;
		private var target:MovieClip;
		private var container:Sprite;
		private var glow:Sprite;
		private var shineMask:Sprite;
		
		
		public function ShineRectangle(target:MovieClip, color:Array=null, speed:uint=10, intensity:uint=20, blur:uint=10, shineWidth:uint=50, degree:uint=45, hasGlow:Boolean=true, hasShimmer:Boolean=true, shimmerTransparency:Number=.1, loop:Boolean=false, autoStart:Boolean=false)
		{
			this.target = target;
			if(color == null)
			{
				glowColor = ShineColor.BLUE;
			}
			else
			{
				glowColor = color;
			}
			this.speed = speed;
			this.intensity = intensity;
			this.blur = blur;
			this.shineWidth = shineWidth;
			this.degree = degree;
			this.hasGlow = hasGlow;
			this.hasShimmer = hasShimmer;
			this.shimmerTransparency = shimmerTransparency;
			this.loop = loop;
			this.autoStart = autoStart;
			_init();
		}
		
		//private
		private function _init():void
		{
			buildContainer();
			buildMask();
			container.mask = shineMask;
			if(hasGlow)
			{
				buildGlow();
			}
			if(autoStart)
			{
				startShine();
			}
		}
		
		private function animateMask(evt:Event=null):void
		{
			matrix.createGradientBox(shineWidth, maskHeight, (Math.PI/180*degree), curPosition);
			shineMask.graphics.clear();
			shineMask.graphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0x000000, 0x000000], [0, 1, 0], [0, 127, 255], matrix, SpreadMethod.PAD);
			shineMask.graphics.drawRect(0, 0, maskWidth, maskHeight);
			shineMask.graphics.endFill();
			
			if(curPosition < endPosition)
			{
				curPosition += speed;
			}
			else
			{
				if(loop)
				{
					curPosition = startPosition;
				}
				else
				{
					target.removeEventListener(Event.ENTER_FRAME, animateMask);
				}
			}
		}
		
		private function buildContainer():void
		{
			var gr:Graphics;
			container = new Sprite();
			if(hasShimmer)
			{
				gr = container.graphics;
				gr.beginFill(0xFFFFFF, shimmerTransparency);
				gr.drawRect(0, 0, target.width, target.height);
				gr.endFill();
			}
			target.addChild(container);
			container.cacheAsBitmap = true;
		}
		
		private function buildGlow():void
		{
			var gr:Graphics;
			glow = new Sprite();
			gr = glow.graphics;
			gr.beginFill(0x000000);
			gr.drawRect(0, 0, target.width, target.height);
			gr.endFill();
			container.addChild(glow);
			glow.cacheAsBitmap = true;
			glow.filters = [new GradientGlowFilter(0, 45, glowColor, [0, .75, 1, 1], [0, 63, 126, 255], blur, blur, 1.2, 1, BitmapFilterType.OUTER, true)];
		}
		
		private function buildMask():void
		{
			shineMask = new Sprite();
			target.addChild(shineMask);
			shineMask.cacheAsBitmap = true;
			maskPadding = blur+2;
			maskWidth = target.width+maskPadding;
			maskHeight = target.height+maskPadding;
			shineMask.x = -(maskPadding/2);
			shineMask.y = -(maskPadding/2);
			matrix = new Matrix();
			startPosition = -(shineWidth+maskPadding);
			curPosition = startPosition;
			endPosition = target.width+shineWidth+maskPadding;
		}
		
		//public
		public function startShine():void
		{
			curPosition = startPosition;
			target.addEventListener(Event.ENTER_FRAME, animateMask, false, 0, true);
		}
		
		public function stopShine():void
		{
			target.removeEventListener(Event.ENTER_FRAME, animateMask);
			curPosition = endPosition;
			animateMask();
		}
		
	}
	
}