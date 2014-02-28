package com.joebillman.controls
{
	import flash.text.TextFormat;

	public class AlertAttributes
	{
		public var alertFormat:TextFormat;				// Format used for alert body text
		public var autoMask:Boolean;					// Signals whether to mask content by default
		public var blurAmount:Number;					// Amount of blur applied to parent
		public var btmCurve:Number;						// This is the amount of curve of the bottom corners of the window in pixels
		public var btnColor:uint;						// Close button fill color
		public var btnOverColor:uint;					// Close button over color
		public var btnSymbolColor:uint;					// Button X symbol color
		public var closeOnX:Boolean;					// Signals whether the window closes when the X button is pressed
		public var color:uint;							// Window Color
		public var colorAlpha:Number;					// Window Color Alpha
		public var contentBGAlpha:Number;				// The amount of transparency of the main content area
		public var contentBGColor:uint;					// The color of the main inset content area
		public var customAlignH:Number					// Custom height used for centering window
		public var customAlignW:Number					// Custom width used for centering window
		public var destroyOnFade:Boolean				// Signals whether to destroy the window when the fadeOut function is called
		public var fadeInDelay:Number;					// Delay time before window fades in
		public var fadeInOnBuild:Boolean;				// Signals whether to fade the window in on open
		public var fadeInTime:Number;					// Time in seconds for the window fade in
		public var fadeOutOnDestroy:Boolean;			// Signals whether to fade the window out on exit
		public var fadeOutTime:Number;					// Time in seconds for the window fade out
		public var hasBlur:Boolean;						// Signals whether it is blurred
		public var hasCloseX:Boolean;					// Signals whether to build the close X button
		public var hasContentFill:Boolean;				// Signals whether it has a content fill area
		public var hasContentFillInset:Boolean;			// Signals whether it has a content fill inset
		public var hasDropShadow:Boolean;				// Signals whether it has a drop shadow
		public var hasTitleBG:Boolean;					// Signals whether the title has a round colored background
		public var hasTitleInset:Boolean;				// Signals whether the title has an inset
		public var isCentered:Boolean;					// Signals whether the window is aligned to the center
		public var isDraggable:Boolean;					// Signals whether the window is draggable
		public var isModal:Boolean;						// Signals whether it is modal
		public var isPaddedToTitle:Boolean;				// Signals whether the title is padded to the title or if it is titled to the window
		public var isVisible:Boolean;					// Whether window is visible when buildWindow is called
		public var leftAlignTitle:Boolean				// Signals whether to left align title text
		public var modalAlpha:Number;					// Alpha amount of the modal Sprite
		public var modalColor:uint;						// Color of the modal Sprite
		public var sizeToContent:Boolean;				// Signals whether to size to content
		public var titleBGColor:uint;					// The color of the title's background
		public var titleBGPadding:Number;				// The padding used for the title background
		public var titleColor:uint;						// The color of the title text
		public var titleFormat:TextFormat;				// Format used for title text
		public var titleInsetColor:uint;				// Title inset text field
		public var topCurve:Number;						// This is the amount of curve of the top corners of the window in pixels
		public var updateBlur:Boolean;					// Signals whether to update the blur
		
		public function AlertAttributes(customW:Number=0, customH:Number=0, delayTime:Number=0)
		{
			customAlignW = customW;
			customAlignH = customH;
			fadeInDelay = delayTime;
			_init();
		}
		
		private function _init():void
		{
			autoMask = true;
			blurAmount = 5;
			btmCurve = 0;
			btnColor = 0x555555;
			btnOverColor = 0xFFFFFF;
			btnSymbolColor = 0xFFFFFF;
			closeOnX = true;
			color = 0x666666;
			colorAlpha = .75;
			contentBGAlpha = 1;
			contentBGColor = 0xF4F4F4;
			destroyOnFade = true;
			fadeInOnBuild = true;
			fadeInTime = .5;
			fadeOutOnDestroy = true;
			fadeOutTime = .5;
			hasBlur = true;
			hasCloseX = false;
			hasContentFill = true;
			hasContentFillInset = true;
			hasDropShadow = true;
			hasTitleBG = true;
			hasTitleInset = false;
			isCentered = true;
			isDraggable = true;
			isModal = true;
			isPaddedToTitle = true;
			isVisible = true;
			leftAlignTitle = false;
			modalAlpha = .25;
			modalColor = 0xCCCCCC;
			sizeToContent = true;
			titleBGColor = 0xB2B2B2;
			titleBGPadding = 7;
			titleColor = 0x000000;
			titleInsetColor = 0x000000;
			topCurve = 10;
			updateBlur = false;
		}
	}
}