/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* //AUTHORS:
*   Joe Billman - Software Engineer
*
*
* //DATES: 
*   January 2011
*
*
* //COPYRIGHT: 
*   Binary Fusion Inc. All rights reserved.
* 
* 
* //REVISION NOTES:
*   This is a major rework to a previous class called WindowX
*
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package com.joebillman.containers
{
	//IMPORTS:__________________________________________________________________________________________________
	//------------------------------------------------<IMPORTS>-----------------------------------------------//
	import com.joebillman.containers.events.WindowEvent;
	
	import caurina.transitions.Equations;
	import caurina.transitions.Tweener;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.filters.BitmapFilterQuality;
	import flash.filters.BlurFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	//--------------------------------------
	//  Events
	//
	/**
	 *  Dispatched when the window begins to fade in.
	 *
	 *  @eventType bf.containers.events.WindowEvent
	 */
	[Event(name="FADE_IN", type="bf.containers.events.WindowEvent")]
	/**
	 *  Dispatched when the window has faded in.
	 *
	 *  @eventType bf.containers.events.WindowEvent
	 */
	[Event(name="FADE_IN_COMPLETE", type="bf.containers.events.WindowEvent")]
	/**
	 *  Dispatched when the window begins to fade out.
	 *
	 *  @eventType bf.containers.events.WindowEvent
	 */
	[Event(name="FADE_OUT", type="bf.containers.events.WindowEvent")]	
	/**
	 *  Dispatched when the window has faded out.
	 *
	 *  @eventType bf.containers.events.WindowEvent
	 */
	[Event(name="FADE_OUT_COMPLETE", type="bf.containers.events.WindowEvent")]	
	/**
	 *  Dispatched when the window is destroyed by pushing the corner x button.
	 *
	 *  @eventType bf.containers.events.WindowEvent
	 */
	[Event(name="CLOSE", type="bf.containers.events.WindowEvent")]
	/**
	 *  Dispatched when the window is destroyed by pushing the corner x button and closeOnX is set to true.
	 *
	 *  @eventType bf.containers.events.WindowEvent
	 */
	[Event(name="CLOSE_BTN", type="bf.containers.events.WindowEvent")]
	
	//--------------------------------------
	//  Class description
	//
	/**
	 * Window: Creates a window that can be used as a pop-in or a content window.
	 *
	 *
	 * @example The following example creates a window, modifies some of its properties and then creates a square and adds that as content.
	 * <p><strong>Note:</strong> The order of the statements is important. All changes must be made prior to calling build() and build() must be called after addChild().</p>
	 * <p><strong>Important GC Info:</strong> Make sure to listen for the close event. In that handler function make sure to remove the close listener, null the content variable if you used one, call removeChild() for the window and null out the window variable in that order.</p>
	 * <listing version="3.0" >
	 * package
	 * {
	 *     import bf.containers.Window;
	 *	   import bf.containers.events.WindowEvent;
	 * 
	 *     import flash.display.MovieClip; 
	 *     import flash.display.Sprite;
	 * 
	 *     public class WindowExample extends MovieClip
	 *     {
	 * 
	 *         private var myWindow:Window;
	 * 
	 *         public function WindowExample()
	 *         {
	 *             _init();
	 *         }
	 * 
	 *         private function _init():void
	 *         {
	 *			   var winContent:Sprite = new Sprite();
	 *			   winContent.graphics.beginFill(0x0066CC);
	 *			   winContent.graphics.drawRect(0,0,300,225);
	 *			   winContent.graphics.endFill();
	 *  
	 *             myWindow = new Window(winContent);
	 *             myWindow.title = "This window rocks!";
	 *             myWindow.hasTitleBG = true;
	 *             myWindow.addEventListener(WindowEvent.CLOSE, handleClose);
	 *             addChild(myWindow);
	 *             myWindow.build();
	 *         }
	 * 
	 *         private function handleClose(evt:WindowEvent):void
	 *         {
	 *             myWindow.removeEventListener(WindowEvent.CLOSE, handleClose);
	 *             removeChild(myWindow);
	 *             myWindow = null;
	 *         }
	 *     }
	 * }
	 * </listing>
	 *
	 *
	 * @author Joe Billman
	 */
	public class Window extends Sprite
	{
		//VARIABLES:________________________________________________________________________________________________
		//-----------------------------------------<VARIABLE MEMBERS>---------------------------------------------//
		
		//Private:
		private const DEFAULT_HEIGHT:Number = 99.99;	// Default height of window
		private const DEFAULT_WIDTH:Number = 149.99;	// Default width of window
		private const EXTRA_VERTICAL:Number = 38;   	// This is the extra vertical pixels used to draw the window that are not part of the content
		private const EXTRA_HORIZONTAL:Number = 14; 	// This is the extra horizontal pixels used to draw the window that are not part of the content
		private const IN:uint = 1;						// Signals to fade in after a delay to fade has been set
		private const OUT:uint = 2;						// Signals to fade out after a delay to fade has been set
		
		private var _autoMask:Boolean;					// Signals whether to mask content by default
		private var _blurAmount:Number;					// Amount of blur applied to parent
		private var _btmCurve:Number;					// This is the amount of curve of the bottom corners of the window in pixels
		private var _btnColor:uint;						// Close button fill color
		private var _btnOverColor:uint;					// Close button over color
		private var _btnSymbolColor:uint;				// Button X symbol color
		private var _closeOnX:Boolean;					// Signals whether the window closes when the X button is pressed
		private var _color:uint;						// Window Color
		private var _colorAlpha:Number;					// Window Color Alpha
		private var _content:DisplayObject;				// Reference to the content passed in as the content for the window
		private var _contentBGAlpha:Number;				// The amount of transparency of the main content area
		private var _contentBGColor:uint;				// The color of the main inset content area
		private var _contentHeight:Number;				// Reference to the content Height
		private var _contentWidth:Number;				// Reference to the content Width
		private var _contentX:Number;					// Reference to the content Width
		private var _contentY:Number;					// Reference to the content Height
		private var _curParent:DisplayObjectContainer;	// Parent of the pop-in window
		private var _destroyOnFade:Boolean				// Signals whether to destroy the window when the fadeOut function is called
		private var _fadeInOnBuild:Boolean;				// Signals whether to fade the window in on open
		private var _fadeInTime:Number;					// Time in seconds for the window fade in
		private var _fadeOutOnDestroy:Boolean;			// Signals whether to fade the window out on exit
		private var _fadeOutTime:Number;				// Time in seconds for the window fade out
		private var _hasBlur:Boolean;					// Signals whether it is blurred
		private var _hasCloseX:Boolean;					// Signals whether to build the close X button
		private var _hasContentFill:Boolean;			// Signals whether it has a content fill area
		private var _hasContentFillInset:Boolean;		// Signals whether it has a content fill inset
		private var _hasDropShadow:Boolean;				// Signals whether it has a drop shadow
		private var _hasTitleBG:Boolean;				// Signals whether the title has a round colored background
		private var _hasTitleInset:Boolean;				// Signals whether the title has an inset
		private var _height:Number;						// Window Height
		private var _icon:String;						// Window Icon
		private var _isDraggable:Boolean;				// Signals whether the window is draggable
		private var _isFading:Boolean					// Signals whether it is currently fading
		private var _isModal:Boolean;					// Signals whether it is modal
		private var _isPaddedToTitle:Boolean;			// Signals whether the title is padded to the title or if it is titled to the window
		private var _isVisible:Boolean;					// Whether window is visible when buildWindow is called
		private var _leftAlignTitle:Boolean				// Signals whether to left align title text
		private var _modalAlpha:Number;					// Alpha amount of the modal Sprite
		private var _modalColor:uint;					// Color of the modal Sprite
		private var _ratio:Number;						// Ratio used in scaling
		private var _sizeToContent:Boolean;				// Signals whether to size to content
		private var _title:String;						// Window title
		private var _title_txt:TextField;				// Title text field
		private var _titleBGColor:uint;					// The color of the title's background
		private var _titleBGPadding:Number;				// The padding used for the title background
		private var _titleColor:uint;					// The color of the title text
		private var _titleFormat:TextFormat;			// Format used for title text
		private var _titleInsetColor:uint;				// Title inset text field
		private var _topCurve:Number;					// This is the amount of curve of the top corners of the window in pixels
		private var _updateBlur:Boolean;				// Signals whether to update the blur
		private var _width:Number;						// Window width
		private var _x:Number;							// Window x value
		private var _y:Number;							// Window y value
		private var blur:Bitmap;						// Bitmap used for blurring
		private var centerX:Number;						// Original stage center x point. This is to compensate for scaling
		private var centerY:Number;						// Original stage center y point. This is to compensate for scaling
		private var closeBtn:Sprite;					// This is the Sprite that acts as the close button
		private var contentMask:Shape;					// Shape used to mask content
		private var curGraphics:Graphics;				// This holds a pointer to the current graphics being drawn at a given time
		private var dragBtn:Sprite;						// This is the Sprite created for a mouse area at the top of the window to enable draggability
		private var fadeTimer:Timer;					// Timer used for the dealy of the fade
		private var fadeToCall:uint;					// Which fade to call after the delay
		private var iconAdded:Boolean;					// Reference to whether the first icon has been built or not
		private var iconBmp:Bitmap;						// Bitmap used for icon
		private var iconLoader:Loader;					// Path to the icon image for the window
		private var isDragging:Boolean;					// Signals when the window is actually being dragged
		private var isHidden:Boolean;					// Reference to whether the window has been destroyed or not
		private var modal:Sprite;						// Sprite used for modal creation
		private var titleBG:Shape;						// Shape used in the title background
		private var titleBGGlass:Shape;					// Shape used for the title background glass look
		private var titleBGInset:Shape;					// Shape used for the title background inset
		private var windowBuilt:Boolean;				// Reference to whether the window has been built or not
		private var windowDS:Shape;						// Shape used to create drop shadow
		private var windowFill:Shape;					// Shape used for window fill
		private var windowContentFill:Shape;			// Shape used for window content area fill
		private var windowGlass:Shape;					// Shape used for the top glass of the window
		private var windowInset:Shape;					// Shape used for the inset portion of the content
		
		//Public:
		public var isCentered:Boolean;
		
		//CONSTRUCTOR:______________________________________________________________________________________________
		//----------------------------------------<CONSTRUCTOR Method>--------------------------------------------//
		/**
		 * The default constructor has an optional content parameter. It also initializes variables
		 * @param content	Optional. Content used in the window. It saves one step in that you don't need to then call .content
		 */
		public function Window(content:DisplayObject=null)
		{
			_init(content);
		}
		
		
		// PRIVATE:_____________________________________________________________
		//------------------------------------------<PRIVATE Methods>------------------------------------//
		
		/**
		 * This function sets the initial values for the variables
		 */
		private function _init(content:DisplayObject):void
		{
			_autoMask = true;
			_blurAmount = 5;
			_btmCurve = 0;
			_btnColor = 0x555555;
			_btnOverColor = 0xFFFFFF;
			_btnSymbolColor = 0xFFFFFF;
			_closeOnX = true;
			_color = 0x222222;
			_colorAlpha = .55;
			_contentBGAlpha = 1;
			_contentBGColor = 0xFFFFFF;
			_contentX = 7;
			_contentY = 29;
			_destroyOnFade = true;
			_fadeInOnBuild = true;
			_fadeInTime = .5;
			_fadeOutOnDestroy = true;
			_fadeOutTime = .5;
			_hasBlur = true;
			_hasCloseX = true;
			_hasContentFill = true;
			_hasContentFillInset = true;
			_hasDropShadow = true;
			_hasTitleBG = true;
			_hasTitleInset = false;
			_height = DEFAULT_HEIGHT;
			_contentHeight = _height-EXTRA_VERTICAL;
			_icon = null;
			_isDraggable = true;
			_isFading = false;
			_isModal = true;
			_isPaddedToTitle = true;
			_isVisible = true;
			_leftAlignTitle = false;
			_modalAlpha = .25;
			_modalColor = 0xCCCCCC;
			_ratio = 1;
			_sizeToContent = true;
			_title = "Window";
			_titleBGColor = 0xB2B2B2;
			_titleBGPadding = 7;
			_titleColor = 0x000000;
			_titleInsetColor = 0x000000;
			_topCurve = 10;
			_width = DEFAULT_WIDTH;
			_contentWidth = _width-EXTRA_HORIZONTAL;
			_x = 0;
			_y = 0;
			fadeToCall = IN;
			iconAdded = false;
			isCentered = true;
			isHidden = false;
			windowBuilt = false;
			buildTxtFormats();
			setContent(content);
		}
		
		/**
		 * Builds the default text formats for the title and title inset
		 */
		private function buildTxtFormats():void
		{
			_titleFormat = new TextFormat();
			_titleFormat.align = TextFormatAlign.CENTER;
			_titleFormat.color = _titleColor;
			_titleFormat.font = "_sans";
			_titleFormat.size = 15;
		}
		
		/**
		 * Moves the window back to the center point
		 */
		private function centerWindow(tweenTo:Boolean=true, tweenTime:Number=.5):void
		{
			var derrivedCenterX:Number = centerX-_width/2;
			var derrivedCenterY:Number = centerY-_height/2;
			
			this.scaleX = this.scaleY = _ratio;
			
			if(!tweenTo)
			{
				this.x = derrivedCenterX;
				this.y = derrivedCenterY;
			}
			else
			{
				Tweener.addTween(this, {x:derrivedCenterX, y:derrivedCenterY, time:tweenTime, transition:Equations.easeOutCirc});
			}
		}
		
		/**
		 * Creates the blurred out functionality
		 */
		private function createBlur():void
		{
			try
			{
				if(_isVisible)
				{
					var bmpData:BitmapData = new BitmapData(_curParent.width, _curParent.height);
					bmpData.draw(_curParent);
					blur = new Bitmap(bmpData);
					blur.filters = [new BlurFilter(_blurAmount, _blurAmount)];
					blur.cacheAsBitmap = true;
					_curParent.addChildAt(blur, _curParent.getChildIndex(this));
				}
			}
			catch(e:Error)
			{
				throw new Error("Blur failed: Missing parent data. Make sure parent has some type of background.\nNote: This could also be caused by calling build() before addChild(). You must first add the window to the display list before calling the build function.");
			}
		}
		
		/**
		 * Creates the button and all its parts for the window
		 */
		private function createButton():void
		{
			var btnBgMatrix:Matrix = new Matrix();
			var btnGlassMatrix:Matrix = new Matrix();
			var windowBtnBG:Shape = new Shape();
			var windowBtnFill:Shape = new Shape();
			var windowBtnX:Shape = new Shape();
			var windowBtnGlass:Shape = new Shape();
			closeBtn = new Sprite();
			
			// Background
			btnBgMatrix.createGradientBox(20, 20, 90*(Math.PI/180));
			curGraphics = windowBtnBG.graphics;
			curGraphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [.75, .85], [75, 255], btnBgMatrix);
			curGraphics.drawRoundRect(_width-26.5, 4, 20, 20, 5);
			curGraphics.endFill();
			closeBtn.addChild(windowBtnBG);
			// Fill
			curGraphics = windowBtnFill.graphics;
			curGraphics.beginFill(_btnColor, 1);
			curGraphics.drawRoundRect(_width-25.5, 5, 18, 18, 4.5);
			curGraphics.endFill();
			closeBtn.addChild(windowBtnFill);
			// Glass
			btnGlassMatrix.createGradientBox(18, 18, 90*(Math.PI/180));
			curGraphics = windowBtnGlass.graphics;
			curGraphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [.95, .55, 0, 0, .25], [50, 198, 199, 205, 255], btnGlassMatrix);
			curGraphics.drawRoundRect(_width-25.5, 5, 18, 18, 4.5);
			curGraphics.endFill();
			closeBtn.addChild(windowBtnGlass);
			// X Symbol
			curGraphics = windowBtnX.graphics;
			curGraphics.lineStyle(.1, 0x333333, .5);
			curGraphics.beginFill(_btnSymbolColor, .85);
			curGraphics.lineTo(2.5, 0);
			curGraphics.lineTo(6.5, 3.7);
			curGraphics.lineTo(10.5, 0);
			curGraphics.lineTo(13, 0);
			curGraphics.lineTo(13, 2);
			curGraphics.lineTo(8.8, 6);
			curGraphics.lineTo(13, 10);
			curGraphics.lineTo(13, 12);
			curGraphics.lineTo(10.5, 12);
			curGraphics.lineTo(6.5, 8.3);
			curGraphics.lineTo(2.5, 12);
			curGraphics.lineTo(0, 12);
			curGraphics.lineTo(0, 10);
			curGraphics.lineTo(4.2, 6);
			curGraphics.lineTo(0, 2);
			curGraphics.lineTo(0, 0);
			curGraphics.endFill();
			windowBtnX.x = _width-23;
			windowBtnX.y = 7.8;
			closeBtn.addChild(windowBtnX);
			
			// Button functionality
			closeBtn.buttonMode = true;
			closeBtn.mouseChildren = false;
			closeBtn.addEventListener(MouseEvent.ROLL_OVER, handleRollOver, false, 0, true);
			closeBtn.addEventListener(MouseEvent.ROLL_OUT, handleRollOut, false, 0, true);
			closeBtn.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
			addChild(closeBtn);
		}
		
		/**
		 * Draws a shape a little shorter than the window and applies a drop shadow filter
		 */
		private function createDropShadow():void
		{
			var left:Number = .55;
			var top:Number = 3.5;
			var right:Number = .5;
			var btm:Number = 0;
			windowDS = new Shape();
			curGraphics = windowDS.graphics;
			
			curGraphics.beginFill(_color, .95);
			curGraphics.moveTo(left, top+_topCurve);
			curGraphics.curveTo(left, top, left+_topCurve, top);
			curGraphics.lineTo(_width-right-_topCurve, top);
			curGraphics.curveTo(_width-right, top, _width-right, top+_topCurve);
			curGraphics.lineTo(_width-right, _height-btm-_btmCurve);
			curGraphics.curveTo(_width-right, _height-btm, _width-right-_btmCurve, _height-btm);
			curGraphics.lineTo(left+_btmCurve, _height-btm);
			curGraphics.curveTo(left, _height-btm, left, _height-btm-_btmCurve);
			curGraphics.lineTo(left, top+_topCurve);
			curGraphics.endFill();
			windowDS.filters = [new GlowFilter(0x000000, .75, 12, 12, 2, BitmapFilterQuality.MEDIUM, false, true)];
			addChild(windowDS);
		}
		
		/**
		 * Creates the icon for the window
		 */
		private function createIcon():void
		{
			if(!iconAdded)
			{
				iconLoader = new Loader();
			}
			iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoaded, false, 0, true);
			iconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			iconLoader.load(new URLRequest(_icon), context);
		}
		
		/**
		 * Creates the mask for the window
		 */
		private function createMask():void
		{
			var glassHeight:Number = 14;
			var left:Number = 6;
			var top:Number = 0;
			var right:Number = 6;
			var btm:Number = 8;
			contentMask = new Shape();
			
			// The 1 and -1 in these is to compensate for the stroke on the inset fill
			curGraphics = contentMask.graphics;
			curGraphics.beginFill(0x00FF00, 1);
			curGraphics.moveTo(left+1, glassHeight*2+top+1);
			curGraphics.lineTo(_width-right-1, glassHeight*2+top+1);
			curGraphics.lineTo(_width-right-1, _height-btm-1);
			curGraphics.lineTo(left+1, _height-btm-1);
			curGraphics.lineTo(left+1, glassHeight*2+top+1);
			curGraphics.endFill();
			addChild(contentMask);
			_content.mask = contentMask;
		}
		
		/**
		 * Creates the modal functionality
		 */
		private function createModal():void
		{
			if(_isVisible)
			{
				modal = new Sprite();
				var gr:Graphics = modal.graphics;
				gr.beginFill(_modalColor, _modalAlpha);
				gr.drawRect(0, 0, _curParent.width, _curParent.height);
				gr.endFill();
				modal.cacheAsBitmap = true;
				_curParent.addChildAt(modal, _curParent.getChildIndex(this));
			}
		}
		
		/**
		 * Creates the title text for the window
		 */
		private function createText():void
		{
			var left:Number;
			var top:Number = 3.5;
			_title_txt = new TextField();
			// White by default
			_title_txt.defaultTextFormat = _titleFormat;
			_title_txt.selectable = false;
			
			if(_icon != null)
			{
				left = 28;
			}
			else
			{
				left = 6;
			}
			
			_title_txt.width = _width-left*2;
			_title_txt.text = _title;
			_title_txt.x = left;
			_title_txt.y = top+.5;
			_title_txt.mouseEnabled = false;
			addChild(_title_txt);
			
			// Black by default
			if(_hasTitleInset)
			{
				_title_txt.filters = [new DropShadowFilter(1, 225, _titleInsetColor, 1, 0, 0)];
			}
		}
		
		/**
		 * Destroys the blur bitmap
		 */
		private function destroyBlur(complete:Boolean=false):void
		{
			if(blur != null)
			{
				if(_curParent.contains(blur))
				{
					_curParent.removeChild(blur);
				}
				blur = null;
			}
			if(complete)
			{
				if(_curParent)
				{
					if(_curParent.stage != null)
					{
						_curParent.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
					}
				}
			}
		}
		
		/**
		 * Destroys the blur bitmap
		 */
		private function destroyDraggable():void
		{
			if(dragBtn != null)
			{
				dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				dragBtn.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
				if(contains(dragBtn))
				{
					removeChild(dragBtn);
				}
				dragBtn = null;
			}
		}
		
		/**
		 * Destroys the modal Sprite
		 */
		private function destroyModal():void
		{
			trace("modal destroyed");
			if(modal != null)
			{
				if(_curParent.contains(modal))
				{
					_curParent.removeChild(modal);
				}
				modal = null;
			}
		}
		
		/**
		 * Destroys the title text for the window
		 */
		private function destroyText():void
		{
			if(_title_txt != null)
			{
				if(contains(_title_txt))
				{
					removeChild(_title_txt);
				}
				_title_txt = null;
			}
		}
		
		/**
		 * Destroys the modal Sprite
		 */
		private function destroyTitleBG():void
		{
			if(titleBG != null)
			{
				if(contains(titleBG))
				{
					removeChild(titleBG);
				}
				titleBG = null;
			}
			if(titleBGGlass != null)
			{
				if(contains(titleBGGlass))
				{
					removeChild(titleBGGlass);
				}
				titleBGGlass = null;
			}
			if(titleBGInset != null)
			{
				if(contains(titleBGInset))
				{
					removeChild(titleBGInset);
				}
				titleBGInset = null;
			}
		}
		
		/**
		 * Displays content
		 */
		private function displayContent():void
		{
			_content.x = _contentX;
			_content.y = _contentY;
			addChild(_content);
			if(_autoMask)
			{
				applyMask();
			}
		}
		
		/**
		 * The brain of drawing the window calls the functions to create modal, blur, inset, icon, glass, title background, close button, title text, draggable hit area button
		 */
		private function drawWindow():void
		{
			// Fill
			drawFill();
			// Inset
			if(_hasContentFill)
			{
				drawContentFill();
			}
			// Icon
			if(_icon != null)
			{
				createIcon();
			}
			// Glass
			drawGlass();
			//Title Background
			if(_hasTitleBG)
			{
				drawTitleBG();
			}
			// Button
			if(_hasCloseX)
			{
				createButton();
			}
			// Text
			createText();
			// Drag
			if(_isDraggable)
			{
				makeDraggable();
			}
			windowBuilt = true;
		}
		
		/**
		 * Creates the fill for the window
		 */
		private function drawFill():void
		{
			var left:Number = 0;
			var top:Number = 0;
			var right:Number = 0;
			var btm:Number = 0;
			windowFill = new Shape();
			curGraphics = windowFill.graphics;
			curGraphics.beginFill(_color, _colorAlpha);
			curGraphics.moveTo(left, top+_topCurve);
			curGraphics.curveTo(left, top, left+_topCurve, top);
			curGraphics.lineTo(_width-right-_topCurve, top);
			curGraphics.curveTo(_width-right, top, _width-right, top+_topCurve);
			curGraphics.lineTo(_width-right, _height-btm-_btmCurve);
			curGraphics.curveTo(_width-right, _height-btm, _width-right-_btmCurve, _height-btm);
			curGraphics.lineTo(left+_btmCurve, _height-btm);
			curGraphics.curveTo(left, _height-btm, left, _height-btm-_btmCurve);
			curGraphics.lineTo(left, top+_topCurve);
			curGraphics.endFill();
			addChild(windowFill);
		}
		
		/**
		 * Creates the inset content area for the window
		 */
		private function drawContentFill():void
		{
			var gradientMatrix:Matrix = new Matrix();
			windowContentFill = new Shape();
			windowInset = new Shape();
			
			if(_hasContentFillInset)
			{
				gradientMatrix.createGradientBox(_contentWidth+2, _contentHeight+2, 70*(Math.PI/180));
				curGraphics = windowInset.graphics;
				curGraphics.beginGradientFill(GradientType.LINEAR, [0x333333, 0xBBBBBB], [1, 1], [0, 255], gradientMatrix);
				curGraphics.drawRect(_contentX-1, _contentY-1, _contentWidth+2, _contentHeight+1.5);
				curGraphics.endFill();
				addChild(windowInset);
			}
			curGraphics = windowContentFill.graphics;
			curGraphics.beginFill(_contentBGColor, _contentBGAlpha);
			curGraphics.drawRect(_contentX, _contentY, _contentWidth, _contentHeight);
			curGraphics.endFill();
			addChild(windowContentFill);
		}
		
		/**
		 * Creates the title background for the window
		 */
		private function drawTitleBG():void
		{
			var titleBgMatrix:Matrix = new Matrix();
			titleBG = new Shape();
			titleBGGlass = new Shape();
			titleBGInset = new Shape();
			
			if(_isPaddedToTitle)
			{
				var txtWidth:Number;
				var tempTxtSize:TextField = new TextField();
				// Temp Text
				tempTxtSize.text = _title;
				tempTxtSize.setTextFormat(_titleFormat);
				tempTxtSize.autoSize = TextFieldAutoSize.LEFT;
				txtWidth = tempTxtSize.textWidth;
				// Inset
				// The random integer values in these like 4 are just for positioning, I determined a lot of the by visually looking at it
				titleBgMatrix.createGradientBox((txtWidth+_titleBGPadding*2)+4, 22, 90*(Math.PI/180));
				curGraphics = titleBGInset.graphics;
				curGraphics.clear();
				curGraphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [.75, .85], [75, 255], titleBgMatrix);
				curGraphics.drawRoundRect(((_width/2-(txtWidth/2))-(_titleBGPadding+2)), 3.2, (txtWidth+_titleBGPadding*2)+4, 22, 20);
				curGraphics.endFill();
				addChild(titleBGInset);
				// Fill
				curGraphics = titleBG.graphics;
				curGraphics.clear();
				curGraphics.beginFill(_titleBGColor, 1);
				curGraphics.drawRoundRect(((_width/2-(txtWidth/2))-_titleBGPadding), 5.2, txtWidth+_titleBGPadding*2, 18.2, 18);
				curGraphics.endFill();
				tempTxtSize = null;
				addChild(titleBG);
				// Glass
				titleBgMatrix.createGradientBox((txtWidth+_titleBGPadding*2), 18, 90*(Math.PI/180));
				curGraphics = titleBGGlass.graphics;
				curGraphics.clear();
				curGraphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [.75, .55, 0], [75, 204, 205], titleBgMatrix);
				curGraphics.drawRoundRect(((_width/2-(txtWidth/2))-(_titleBGPadding)), 5.2, (txtWidth+_titleBGPadding*2), 18.2, 18);
				curGraphics.endFill();
				addChild(titleBGGlass);
			}
			else
			{
				// Inset
				titleBgMatrix.createGradientBox(_width-(26.5*2+_titleBGPadding*2), 22, 90*(Math.PI/180));
				curGraphics = titleBGInset.graphics;
				curGraphics.clear();
				curGraphics.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [.75, .85], [75, 255], titleBgMatrix);
				curGraphics.drawRoundRect(26.5+_titleBGPadding, 3.2, _width-(26.5*2+_titleBGPadding*2), 22, 20);
				curGraphics.endFill();
				addChild(titleBGInset);
				// Fill
				curGraphics = titleBG.graphics;
				curGraphics.clear();
				curGraphics.beginFill(_titleBGColor, 1);
				curGraphics.drawRoundRect(26.5+_titleBGPadding+2, 5.2, _width-((26.5*2+_titleBGPadding*2)+4), 18.2, 18);
				curGraphics.endFill();
				addChild(titleBG);
				// Glass
				titleBgMatrix.createGradientBox(26.5+_titleBGPadding+2, 18, 90*(Math.PI/180));
				curGraphics = titleBGGlass.graphics;
				curGraphics.clear();
				curGraphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [.75, .55, 0], [75, 204, 205], titleBgMatrix);
				curGraphics.drawRoundRect(26.5+_titleBGPadding+2, 5.2, _width-((26.5*2+_titleBGPadding*2)+4), 18.2, 18);
				curGraphics.endFill();
				addChild(titleBGGlass);
			}
		}
		
		/**
		 * Creates the glass for the window top
		 */
		private function drawGlass():void
		{
			var glassMatrix:Matrix = new Matrix();
			var glassHeight:Number = 14;
			var left:Number = 1;
			var top:Number = 1;
			var right:Number = 1;
			windowGlass = new Shape();
			
			glassMatrix.createGradientBox(_width, glassHeight, 90*(Math.PI/180));
			curGraphics = windowGlass.graphics;
			curGraphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [.95, .55, .35], [0, 175, 255], glassMatrix);
			curGraphics.moveTo(left, top-_topCurve);
			curGraphics.lineTo(left, top+_topCurve);
			curGraphics.curveTo(left-0.5, top-0.5, left+_topCurve, top);
			curGraphics.lineTo(_width-right-_topCurve, top);
			curGraphics.curveTo(_width-right+0.5, top-0.5, _width-right, top+_topCurve);
			curGraphics.lineTo(_width-right, glassHeight);
			curGraphics.lineTo(left, glassHeight);
			curGraphics.endFill();
			addChild(windowGlass);			
		}
		
		/**
		 * The body of the fadeIn function
		 */
		private function fadeInWin():void
		{
			if(windowFill == null)
			{
				throw new Error("Window has been destroyed. Window must be rebuilt.\nNote: If you don't want to destroy window on fade out change the destroyOnFade property to false.");
			}
			this.cacheAsBitmap = false;
			if(closeBtn != null)
			{
				closeBtn.mouseEnabled = true;
			}
			
			if(this.alpha != 0)
			{
				this.alpha = 0;
			}
			if(_hasBlur && isHidden)
			{
				_isVisible = true;
				if(blur == null)
				{
					createBlur();
				}
			}
			if(_isModal  && isHidden)
			{
				_isVisible = true;
				if(modal == null)
				{
					createModal();
				}
			}
			if(this.blendMode != BlendMode.LAYER)
			{
				this.blendMode = BlendMode.LAYER;	// The layer blend mode helps the fade look better by fading the window as one object versus multiple objects
			}
			
			visible = true;
			dispatchEvent(new WindowEvent(WindowEvent.FADE_IN));
			Tweener.addTween(this, {alpha:1, time:_fadeInTime, transition:Equations.easeOutCirc, onComplete:onFadeIn});
			_isFading = true;
		}
		
		/**
		 * The body of the fadeOut function
		 */
		private function fadeOutWin():void
		{
			this.cacheAsBitmap = false;
			if(this.blendMode != BlendMode.LAYER)
			{
				this.blendMode = BlendMode.LAYER;	// The layer blend mode helps the fade look better by fading the window as one object versus multiple objects
			}
			dispatchEvent(new WindowEvent(WindowEvent.FADE_OUT));
			Tweener.addTween(this, {alpha:0, time:_fadeInTime, transition:Equations.easeOutCirc, onComplete:onFadeOut});
			_isFading = true;
		}
		
		/**
		 * Handles the click of the close button and fades and or closes the window depending on the settings
		 */
		private function handleClick(evt:MouseEvent):void
		{
			if(_fadeOutOnDestroy)
			{
				closeBtn.mouseEnabled = false;
				fadeOut();
			}
			else
			{
				closeBtn.mouseEnabled = false;
				destroyWindow();
			}
		}
		
		/**
		 * Handles the updating of the blur
		 */
		private function handleEnterFrame(evt:Event):void
		{
			destroyBlur();
			createBlur();
		}
		
		/**
		 * Handles error throw if the icon url is incorrect 
		 * @param evt
		 * 
		 */		
		private function handleIOError(evt:IOErrorEvent):void
		{
			throw new Error("The url supplied for the icon appears to be incorrect.");
		}
		
		/**
		 * Handles the mouse down of the draggable button and starts the dragging
		 */
		private function handleMouseDown(evt:MouseEvent):void
		{
			this.startDrag();
			isDragging = true;
		}
		
		/**
		 * Handles when the mouse leaves the canvas area when dragging and repositions the window in the center to prevent loss of control of the window
		 */
		private function handleMouseLeave(evt:Event):void
		{
			if(isDragging)
			{
				isDragging = false;
				this.stopDrag();
				centerWindow();
			}
		}
		
		/**
		 * Handles the mouse up of the draggable button and stops the dragging
		 */
		private function handleMouseUp(evt:MouseEvent):void
		{
			this.stopDrag();
			isDragging = false;
		}
		
		/**
		 * Handles the mouse roll over and fires a ROLL_OUT event
		 */
		private function handleRollOut(evt:MouseEvent):void
		{
			closeBtn.filters = [];
			dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT));
		}
		
		/**
		 * Handles the mouse roll over and fires a ROLL_OVER event
		 */
		private function handleRollOver(evt:MouseEvent):void
		{
			closeBtn.filters = [new GlowFilter(_btnOverColor, .65, 5, 5, 2)];
			dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER));
		}
		
		/**
		 * Handles the completion of the fade timer
		 */
		private function handleTimerComplete(evt:TimerEvent):void
		{
			if(fadeToCall == IN)
			{
				fadeInWin();
			}
			if(fadeToCall == OUT)
			{
				fadeOutWin();
			}
		}
		
		/**
		 * Makes the window draggable
		 */
		private function makeDraggable():void
		{
			dragBtn = new Sprite();
			dragBtn.name = "drag_btn";
			curGraphics = dragBtn.graphics;
			curGraphics.beginFill(0xFFFFFF, 0);
			if(_hasCloseX)
			{
				curGraphics.drawRect(0, 0, _width-30, 28);
			}
			else
			{
				curGraphics.drawRect(0, 0, _width, 28);
			}
			curGraphics.endFill();
			dragBtn.hitArea = dragBtn;
			dragBtn.mouseEnabled = true;
			dragBtn.mouseChildren = false;
			dragBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			dragBtn.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
			addChild(dragBtn);
		}
		
		/**
		 * Handles when the fade in is finished and fires a FADE_IN event
		 */
		private function onFadeIn():void
		{
			this.cacheAsBitmap = true;
			_isFading = false;
			if(updateBlur)
			{
				_curParent.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
			}
			dispatchEvent(new WindowEvent(WindowEvent.FADE_IN_COMPLETE));
		}
		
		/**
		 * Handles when the fade out is finished
		 */
		protected function onFadeOut():void
		{
			this.cacheAsBitmap = true;
			this.visible = false;
			_isFading = false;
			if(_destroyOnFade)
			{
				destroyWindow();
			}
			else
			{
				if(_hasBlur)
				{
					destroyBlur();
				}
				if(_isModal)
				{
					destroyModal();
				}
			}
			if(updateBlur)
			{
				_curParent.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
			dispatchEvent(new WindowEvent(WindowEvent.FADE_OUT_COMPLETE));
		}
		
		/**
		 * Handles when the icon is loaded and fires a COMPLETE event
		 */
		private function onIconLoaded(evt:Event):void
		{
			iconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onIconLoaded);
			iconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			var widthToHeight:Number;
			var iconBmpData:BitmapData = new BitmapData(iconLoader.width, iconLoader.height, true, 0xFF00FF);
			iconBmpData.draw(iconLoader);
			iconBmp = new Bitmap(iconBmpData, PixelSnapping.AUTO, true);
			widthToHeight = iconBmp.width/iconBmp.height;
			iconBmp.height = 20;
			iconBmp.width = iconBmp.height*widthToHeight;
			iconBmp.x = 6;
			iconBmp.y = 5;
			if(!iconAdded)
			{
				addChild(iconBmp);
				iconAdded = true;
			}
		}
		
		/**
		 * Verifies and sets the content for the window
		 */
		private function setContent(val:DisplayObject):void
		{
			if(val != null)
			{
				_content = val;
				_contentWidth = _content.width;
				_contentHeight = _content.height;
				if(_sizeToContent)
				{
					_width = _contentWidth+EXTRA_HORIZONTAL;
					_height = _contentHeight+EXTRA_VERTICAL;
				}
			}
		}
		
		/**
		 * Updates title text field
		 */
		private function updateText():void
		{
			_title_txt.text = _title;
			_title_txt.setTextFormat(_titleFormat);
			if(_hasTitleInset)
			{
				_title_txt.filters = [new DropShadowFilter(1, 245, _titleInsetColor, 1, 0, 0)];
			}
		}
		
		// PUBLIC:______________________________________________________________
		//------------------------------------------<PUBLIC Methods>------------------------------------//
		
		//
		/**
		 * Creates and applies a mask to the content
		 */
		public function applyMask():void
		{
			createMask();
		}
		
		/**
		 * This function calls all the functions neccessary to build the pop-in window. It calls functions to build the default text formats, creates a drop shadow if needed and draw the window
		 * @param customAlignW	A custom number used as the width of the parent. This is important when it comes to centering the window.
		 * @param customAlignH	A custom number used as the height of the parent. This is important when it comes to centering the window.
		 * */
		public function build(customAlignW:Number=0, customAlignH:Number=0, delayTime:Number=0):void
		{
			if(this.parent == null)
			{
				throw new Error("Parent value is null.\nNote: Make sure that you have called addChild on the window before calling build.");
			}
			_curParent = this.parent;
			if(_width < DEFAULT_WIDTH || _height < DEFAULT_HEIGHT)
			{
				throw new Error("Invalid width or height.\nNote: Please check the width and height that you are trying to set and verify that is is greater than the default values.\nDefaults:\n width: "+Math.ceil(DEFAULT_WIDTH)+"\n height: "+Math.ceil(DEFAULT_HEIGHT));
			}
			if(isNaN(centerX))
			{
				if(customAlignW != 0 || customAlignH != 0)
				{
					centerX = customAlignW/2;
					centerY = customAlignH/2;
				}
				else
				{
					centerX = _curParent.width/2;
					centerY = _curParent.height/2;
				}
			}
			
			if(_hasBlur && delayTime == 0)
			{
				createBlur();
				if(_updateBlur && _isVisible)
				{
					_curParent.stage.addEventListener(Event.ENTER_FRAME, handleEnterFrame, false, 0, true);
				}
			}
			
			if(_isModal && delayTime == 0)
			{
				createModal();
			}
			
			if(_hasDropShadow)
			{
				createDropShadow();
			}
			
			drawWindow();
			if(_content != null)
			{
				displayContent();
			}
			
			this.cacheAsBitmap = true;
			
			if(closeBtn != null && !closeBtn.mouseEnabled)
			{
				closeBtn.mouseEnabled = true;
			}
			
			if(_curParent.stage != null)
			{
				_curParent.stage.addEventListener(Event.MOUSE_LEAVE, handleMouseLeave, false, 0, true);
			}
			
			if(_isVisible)
			{
				visible = true;
			}
			else
			{
				visible = false;
			}
			
			if(isCentered)
			{
				centerWindow(false);
			}
			
			if(_fadeInOnBuild && _isVisible)
			{
				fadeIn(delayTime);
			}
		}
		
		/**
		 * This function removes any and all references created by the window
		 */
		public function cleanup(complete:Boolean=true):void
		{
			if(fadeTimer != null)
			{
				fadeTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete);
				fadeTimer.reset();
				fadeTimer = null;
			}
					
			destroyBlur(true);
			destroyModal();
			if(windowDS != null)
			{
				if(contains(windowDS))
				{
					removeChild(windowDS);
				}
				windowDS = null;
			}
			if(windowFill != null)
			{
				if(contains(windowFill))
				{
					removeChild(windowFill);
				}
				windowFill = null;
			}
			if(windowContentFill != null)
			{
				if(contains(windowContentFill))
				{
					removeChild(windowContentFill);
				}
				windowContentFill = null;
			}
			if(windowInset != null)
			{
				if(contains(windowInset))
				{
					removeChild(windowInset);
				}
				windowInset = null;
			}
			if(iconLoader != null)
			{
				iconAdded = false;
				iconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onIconLoaded);
				iconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
				iconLoader.unload();
				if(contains(iconLoader))
				{
					removeChild(iconLoader);
				}
				iconLoader = null;
			}
			if(iconBmp != null)
			{
				if(contains(iconBmp))
				{
					removeChild(iconBmp);
				}
				iconBmp = null;
			}
			if(windowGlass != null)
			{
				if(contains(windowGlass))
				{
					removeChild(windowGlass);
				}
				windowGlass = null;
			}
			if(titleBG != null)
			{
				if(contains(titleBG))
				{
					removeChild(titleBG);
				}
				titleBG = null;
			}
			if(titleBGGlass != null)
			{
				if(contains(titleBGGlass))
				{
					removeChild(titleBGGlass);
				}
				titleBGGlass = null;
			}
			if(titleBGInset != null)
			{
				if(contains(titleBGInset))
				{
					removeChild(titleBGInset);
				}
				titleBGInset = null;
			}
			if(closeBtn != null)
			{
				closeBtn.removeEventListener(MouseEvent.ROLL_OVER, handleRollOver);
				closeBtn.removeEventListener(MouseEvent.ROLL_OUT, handleRollOut);
				closeBtn.removeEventListener(MouseEvent.CLICK, handleClick);
				if(contains(closeBtn))
				{
					removeChild(closeBtn);
				}
				closeBtn = null;
			}
			if(_title_txt != null)
			{
				if(contains(_title_txt))
				{
					removeChild(_title_txt);
				}
				_title_txt = null;
			}
			if(_titleFormat != null && complete)
			{
				_titleFormat = null;
			}
			if(curGraphics != null)
			{
				curGraphics = null;
			}
			if(dragBtn != null)
			{
				dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				dragBtn.removeEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
				if(contains(dragBtn))
				{
					removeChild(dragBtn);
				}
				dragBtn = null;
			}
			if(_content != null && complete)
			{
				if(contains(_content))
				{
					removeChild(_content);
				}
				_content = null;
			}
			if(contentMask != null)
			{
				if(contains(contentMask))
				{
					contentMask = null;
				}
				contentMask = null;
			}
			if(_curParent != null && complete)
			{
				if(_curParent.stage != null)
				{
					_curParent.stage.removeEventListener(Event.MOUSE_LEAVE, handleMouseLeave);
				}
				_curParent = null;
			}
		}
		
		/**
		 * This function dispatches an event to destroy the pop in window
		 */
		public function destroyWindow():void
		{
			cleanup();
			if(closeOnX)
			{
				dispatchEvent(new WindowEvent(WindowEvent.CLOSE));
			}
			else
			{
				dispatchEvent(new WindowEvent(WindowEvent.CLOSE_BTN));
			}
		}
		
		/**
		 * Fades window in
		 */
		public function fadeIn(delayTime:Number=0, duration:Number=NaN):void
		{
			if(!isNaN(duration))
			{
				_fadeInTime = duration;
			}
			if(delayTime != 0)
			{
				fadeToCall = IN;
				isVisible = false;
				alpha = 0;
				if(fadeTimer == null)
				{
					fadeTimer = new Timer(1000, 1);
					fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete, false, 0, true);
				}
				fadeTimer.reset();
				fadeTimer.delay = delayTime*1000;
				fadeTimer.start();
			}
			else
			{
				fadeInWin();
			}
		}
		
		/**
		 * Fades window out
		 */
		public function fadeOut(delayTime:Number=0, duration:Number=NaN):void
		{
			if(!isNaN(duration))
			{
				_fadeInTime = duration;
			}
			if(delayTime != 0)
			{
				fadeToCall = OUT;
				isVisible = false;
				alpha = 0;
				if(fadeTimer == null)
				{
					fadeTimer = new Timer(1000, 1);
					fadeTimer.addEventListener(TimerEvent.TIMER_COMPLETE, handleTimerComplete, false, 0, true);
				}
				fadeTimer.reset();
				fadeTimer.delay = delayTime*1000;
				fadeTimer.start();
			}
			else
			{
				fadeOutWin();
			}
		}
		
		/**
		 * Rebuilds window
		 * @param customAlignW	A custom number used as the width of the parent. This is important when it comes to centering the window.
		 * @param customAlignH	A custom number used as the height of the parent. This is important when it comes to centering the window.
		 * */
		public function rebuild(customAlignW:Number=0, customAlignH:Number=0):void
		{
			if(_curParent == null)
			{
				throw new Error("Parent value is null.\nNote: Make sure that you have called addChild on the window before calling rebuild.");
			}
			if(windowBuilt)
			{
				cleanup(false);
				windowBuilt = false;
				build(customAlignW, customAlignH);
			}
		}
		
		// GETTERS & SETTERS:______________________________________________________________
		/**
		 * Gets or sets the autoMask value
		 * @default true
		 */
		public function get autoMask():Boolean
		{
			return _autoMask;
		}
		/**
		 * @private (setter)
		 */
		public function set autoMask(val:Boolean):void
		{
			_autoMask = val;
		}
		
		/**
		 * Gets or sets the blur amount
		 * @default 5
		 */
		public function get blurAmount():Number
		{
			return _blurAmount;
		}
		/**
		 * @private (setter)
		 */
		public function set blurAmount(val:Number):void
		{
			_blurAmount = val;
		}
		
		/**
		 * Gets or sets the color of the close button
		 * @default 0xCC0000
		 */
		public function get btnColor():uint
		{
			return _btnColor;
		}
		/**
		 * @private (setter)
		 */
		public function set btnColor(val:uint):void
		{
			_btnColor = val;
		}
		
		/**
		 * Gets or sets the color of the close button over glow
		 * @default 0xFF0000
		 */
		public function get btnOverColor():uint
		{
			return _btnOverColor;
		}
		/**
		 * @private (setter)
		 */
		public function set btnOverColor(val:uint):void
		{
			_btnOverColor = val;
		}
		
		/**
		 * Gets or sets the amount of curve on the bottom corners
		 * @default 0
		 */
		public function get btmCurve():Number
		{
			return _btmCurve;
		}
		/**
		 * @private (setter)
		 */
		public function set btmCurve(val:Number):void
		{
			_btmCurve = val;
		}
		
		/**
		 * Gets or sets the color of the 'X' symbol in the close button
		 * @default 0xFFFFFF
		 */
		public function get btnSymbolColor():uint
		{
			return _btnSymbolColor;
		}
		/**
		 * @private (setter)
		 */
		public function set btnSymbolColor(val:uint):void
		{
			_btnSymbolColor = val;
		}
		
		/**
		 * Gets or sets whether the window closes automatically when the X button is pressed
		 * @default true
		 */
		public function get closeOnX():Boolean
		{
			return _closeOnX;
		}
		/**
		 * @private (setter)
		 */
		public function set closeOnX(val:Boolean):void
		{
			_closeOnX = val;
		}
		
		/**
		 * Gets or sets the color value of the window
		 * @default 0x000000
		 */
		public function get color():uint
		{
			return _color;
		}
		/**
		 * @private (setter)
		 */
		public function set color(val:uint):void
		{
			_color = val;
		}
		
		/**
		 * Gets or sets the alpha value of the window
		 * @default 1
		 */
		public function get colorAlpha():Number
		{
			return _colorAlpha;
		}
		/**
		 * @private (setter)
		 */
		public function set colorAlpha(val:Number):void
		{
			_colorAlpha = val;
		}
		
		/**
		 * Gets or sets a reference to the content for the window
		 * @default null
		 */
		public function get content():DisplayObject
		{
			return _content;
		}
		/**
		 * @private (setter)
		 */
		public function set content(val:DisplayObject):void
		{
			if(_content != null)
			{
				if(contains(_content))
				{
					removeChild(_content);
					_content = null;
				}
			}
			setContent(val);
			if(windowBuilt)
			{
				cleanup(false);
				windowBuilt = false;
				build();
				centerWindow(false);
			}
		}
		
		/**
		 * Gets or sets the alpha of the inset content area for the window
		 * @default .95
		 */
		public function get contentBGAlpha():Number
		{
			return _contentBGAlpha;
		}
		/**
		 * @private (setter)
		 */
		public function set contentBGAlpha(val:Number):void
		{
			_contentBGAlpha = val;
		}
		
		/**
		 * Gets or sets the color of the content area for the window
		 * @default 0xFFFFFF
		 */
		public function get contentBGColor():uint
		{
			return _contentBGColor;
		}
		/**
		 * @private (setter)
		 */
		public function set contentBGColor(val:uint):void
		{
			_contentBGColor = val;
		}
		
		/**
		 * Gets or sets the value of the content height of the window 
		 * @default 62
		 */
		public function get contentHeight():Number
		{
			return _contentHeight;
		}
		/**
		 * @private (setter)
		 */
		public function set contentHeight(val:Number):void
		{
			_contentHeight = val;
		}
		
		/**
		 * Gets or sets the value of the content width of the window 
		 * @default 86
		 */
		public function get contentWidth():Number
		{
			return _contentWidth;
		}
		/**
		 * @private (setter)
		 */
		public function set contentWidth(val:Number):void
		{
			_contentWidth = val;
		}
		
		/**
		 * Gets or sets the value of the content starting x position
		 * @default 7
		 */
		public function get contentX():Number
		{
			return _contentX;
		}
		/**
		 * @private (setter)
		 */
		public function set contentX(val:Number):void
		{
			_contentX = val;
			if(_content != null)
			{
				_content.x = _contentX;
			}
		}
		
		/**
		 * Gets or sets the value of the content starting y position 
		 * @default 29
		 */
		public function get contentY():Number
		{
			return _contentY;
		}
		/**
		 * @private (setter)
		 */
		public function set contentY(val:Number):void
		{
			_contentY = val;
			if(_content != null)
			{
				_content.y = _contentY;
			}
		}
		
		/**
		 * Gets or sets a reference to the parent value of the window
		 * @default null
		 */
		public function get curParent():DisplayObjectContainer
		{
			return _curParent;
		}
		/**
		 * @private (setter)
		 */
		public function set curParent(val:DisplayObjectContainer):void
		{
			_curParent = val;
		}
		
		/**
		 * Gets or sets a reference to the destroyOnFade value
		 * @default null
		 */
		public function get destroyOnFade():Boolean
		{
			return _destroyOnFade;
		}
		/**
		 * @private (setter)
		 */
		public function set destroyOnFade(val:Boolean):void
		{
			_destroyOnFade = val;
		}
		
		/**
		 * Gets or sets whether to fade in or not when buildWindow is called
		 * @default true
		 */
		public function get fadeInOnBuild():Boolean
		{
			return _fadeInOnBuild;
		}
		/**
		 * @private (setter)
		 */
		public function set fadeInOnBuild(val:Boolean):void
		{
			_fadeInOnBuild = val;
		}
		
		/**
		 * Gets or sets the time in seconds for the fade in
		 * @default 2
		 */
		public function get fadeInTime():Number
		{
			return _fadeInTime;
		}
		/**
		 * @private (setter)
		 */
		public function set fadeInTime(val:Number):void
		{
			_fadeInTime = val;
		}
		
		/**
		 * Gets or sets whether to fade out or not when destroyWindow is called
		 * @default true
		 */
		public function get fadeOutOnDestroy():Boolean
		{
			return _fadeOutOnDestroy;
		}
		/**
		 * @private (setter)
		 */
		public function set fadeOutOnDestroy(val:Boolean):void
		{
			_fadeOutOnDestroy = val;
		}
		
		/**
		 * Gets or sets the time in seconds for the fade out
		 * @default 1
		 */
		public function get fadeOutTime():Number
		{
			return _fadeOutTime;
		}
		/**
		 * @private (setter)
		 */
		public function set fadeOutTime(val:Number):void
		{
			_fadeOutTime = val;
		}
		
		/**
		 * Gets or sets the blur mode for the window
		 * @default true
		 */
		public function get hasBlur():Boolean
		{
			return _hasBlur;
		}
		/**
		 * @private (setter)
		 */
		public function set hasBlur(val:Boolean):void
		{
			_hasBlur = val;
		}
		
		/**
		 * Gets the close X button mode for the window
		 * @default true
		 */
		public function get hasCloseX():Boolean
		{
			return _hasCloseX;
		}
		/**
		 * @private (setter)
		 */
		public function set hasCloseX(val:Boolean):void
		{
			_hasCloseX = val;
		}
		
		/**
		 * Gets or sets the main content fill for the window. When this is true a box is drawn to represent the content area. Leaving this off will leave the window at the window color with no differentiation for the content area
		 * @default true
		 */
		public function get hasContentFill():Boolean
		{
			return _hasContentFill;
		}
		/**
		 * @private (setter)
		 */
		public function set hasContentFill(val:Boolean):void
		{
			_hasContentFill = val;
		}
		
		/**
		 * Gets or sets the main content inset for the window. When this is true a inset effect is drawn around the box that represents the content area.
		 * @default true
		 */
		public function get hasContentFillInset():Boolean
		{
			return _hasContentFillInset;
		}
		/**
		 * @private (setter)
		 */
		public function set hasContentFillInset(val:Boolean):void
		{
			_hasContentFillInset = val;
		}
		
		/**
		 * Gets the drop shadow mode for the window
		 * @default true
		 */
		public function get hasDropShadow():Boolean
		{
			return _hasDropShadow;
		}
		/**
		 * @private (setter)
		 */
		public function set hasDropShadow(val:Boolean):void
		{
			_hasDropShadow = val;
		}
		
		/**
		 * Gets or sets the value to signal whether to use a background inset fill behind the title in the top of the window
		 * @default false
		 */
		public function get hasTitleBG():Boolean
		{
			return _hasTitleBG;
		}
		/**
		 * @private (setter)
		 */
		public function set hasTitleBG(val:Boolean):void
		{
			_hasTitleBG = val;
		}
		
		/**
		 * Gets or sets the inset on the text used as the title in the top of the window
		 * @default false
		 */
		public function get hasTitleInset():Boolean
		{
			return _hasTitleInset;
		}
		/**
		 * @private (setter)
		 */
		public function set hasTitleInset(val:Boolean):void
		{
			_hasTitleInset = val;
		}
		
		/**
		 * Gets or sets the value of the current height of the window
		 * @default 100
		 */
		public override function get height():Number
		{
			return _height;
		}
		/**
		 * @private (setter)
		 */
		public override function set height(val:Number):void
		{
			_height = val+EXTRA_VERTICAL;
			_sizeToContent = false;
			_contentHeight = val;
		}
		
		/**
		 * Gets or sets the icon for the window. Note: 24 X 24 is the optimized size
		 * @default null
		 */
		public function get icon():String
		{
			return _icon;
		}
		/**
		 * @private (setter)
		 */
		public function set icon(val:String):void
		{
			_icon = val;
			if(windowBuilt)
			{
				iconAdded = false;
				if(iconBmp != null)
				{
					if(contains(iconBmp))
					{
						removeChild(iconBmp);
					}
				}
				createIcon();
			}
		}
		
		/**
		 * Gets or sets whether the window is draggable or not
		 * @default true
		 */
		public function get isDraggable():Boolean
		{
			return _isDraggable;
		}
		/**
		 * @private (setter)
		 */
		public function set isDraggable(val:Boolean):void
		{
			_isDraggable = val;
		}
		
		/**
		 * Gets the window is currently fading.
		 * @default true
		 */
		public function get isFading():Boolean
		{
			return _isFading;
		}
		
		/**
		 * Gets or sets the modal mode for the window
		 * @default false
		 */
		public function get isModal():Boolean
		{
			return _isModal;
		}
		/**
		 * @private (setter)
		 */
		public function set isModal(val:Boolean):void
		{
			_isModal = val;
		}
		
		/**
		 * Gets or sets whether to size the title background to the title or to the window. When set to true the title background fill will size itself to the title text plus the padding. When set to false it will size to the window minus the padding
		 * @default true
		 */
		public function get isPaddedToTitle():Boolean
		{
			return _isPaddedToTitle;
		}
		/**
		 * @private (setter)
		 */
		public function set isPaddedToTitle(val:Boolean):void
		{
			_isPaddedToTitle = val;			
		}
		
		/**
		 * Gets or sets visibility of the window.
		 * @default true
		 */
		public function get isVisible():Boolean
		{
			return _isVisible;
		}
		/**
		 * @private (setter)
		 */
		public function set isVisible(val:Boolean):void
		{
			_isVisible = val;
			isHidden = !_isVisible;
		}
		
		/**
		 * Gets or sets the left align of the title.
		 * @default false
		 */
		public function get leftAlignTitle():Boolean
		{
			return _leftAlignTitle;
		}
		/**
		 * @private (setter)
		 */
		public function set leftAlignTitle(val:Boolean):void
		{
			_leftAlignTitle = val;
			if(_leftAlignTitle)
			{
				_titleFormat.align = TextFormatAlign.LEFT;
				_hasTitleBG = false;
			}
		}
		
		/**
		 * Gets or sets the alpha of the modal.
		 * @default .25
		 */
		public function get modalAlpha():Number
		{
			return _modalAlpha;
		}
		/**
		 * @private (setter)
		 */
		public function set modalAlpha(val:Number):void
		{
			_modalAlpha = val;
		}
		
		/**
		 * Gets or sets the color of the modal.
		 * @default .25
		 */
		public function get modalColor():uint
		{
			return _modalColor;
		}
		/**
		 * @private (setter)
		 */
		public function set modalColor(val:uint):void
		{
			_modalColor = val;
		}
		
		/**
		 * Gets or sets the ratio used in scaling the window.
		 * @default 1
		 */
		public function get ratio():Number
		{
			return _ratio;
		}
		/**
		 * @private (setter)
		 */
		public function set ratio(value:Number):void
		{
			_ratio = value;
		}
		
		/**
		 * Gets or sets whether the window is sized to the content.
		 * @default true
		 */
		public function get sizeToContent():Boolean
		{
			return _sizeToContent;
		}
		/**
		 * @private (setter)
		 */
		public function set sizeToContent(val:Boolean):void
		{
			_sizeToContent = val;
		}
		
		/**
		 * Gets or sets the title for the window
		 * @default ""
		 */
		public function get title():String
		{
			return _title;
		}
		/**
		 * @private (setter)
		 */
		public function set title(val:String):void
		{
			_title = val;
			if(windowBuilt)
			{
				updateText();
				destroyTitleBG();
				drawTitleBG();
				destroyText();
				createText();
				if(_isDraggable)
				{
					destroyDraggable();
					makeDraggable();
				}
			}
		}
		
		/**
		 * Gets a reference to the content for the window
		 */
		public function get title_txt():TextField
		{
			return _title_txt;
		}
		
		/**
		 * Gets or sets the color of the background of the title fill
		 * @default 0xCC0000
		 */
		public function get titleBGColor():uint
		{
			return _titleBGColor;
		}
		/**
		 * @private (setter)
		 */
		public function set titleBGColor(val:uint):void
		{
			_titleBGColor = val;
		}
		
		/**
		 * Gets or sets the padding to be used for the background title fill
		 * @default 6
		 */
		public function get titleBGPadding():Number
		{
			return _titleBGPadding;
		}
		/**
		 * @private (setter)
		 */
		public function set titleBGPadding(val:Number):void
		{
			_titleBGPadding = val;
		}
		
		/**
		 * Gets or sets the color value of the title text
		 * @default 0xFFFFFF
		 */
		public function get titleColor():uint
		{
			return _titleColor;
		}
		/**
		 * @private (setter)
		 */
		public function set titleColor(val:uint):void
		{
			_titleColor = val;
			if(_titleFormat != null && _title_txt != null)
			{
				_titleFormat.color = _titleColor
				_title_txt.setTextFormat(_titleFormat);
			}
		}
		
		/**
		 * Gets or sets the title format for the window
		 * @default 15 Arial 0xFFFFFF
		 */
		public function get titleFormat():TextFormat
		{
			return _titleFormat;
		}
		/**
		 * @private (setter)
		 */
		public function set titleFormat(val:TextFormat):void
		{
			if(val != null)
			{
				_titleFormat = val;
			}
			if(_title_txt != null)
			{
				_title_txt.setTextFormat(_titleFormat);
			}
		}
		
		/**
		 * Gets or sets the title inset color
		 * @default 0x000000
		 */
		public function get titleInsetColor():uint
		{
			return _titleInsetColor;
		}
		/**
		 * @private (setter)
		 */
		public function set titleInsetColor(val:uint):void
		{
			if(_hasTitleInset)
			{
				_titleInsetColor = val;
			}
			else
			{
				trace("Warning: The title inset is not set to true therefore this will not be seen.");
			}
		}
		
		/**
		 * Gets or sets the amount of curve on the top corners
		 * @default 10
		 */
		public function get topCurve():Number
		{
			return _topCurve;
		}
		/**
		 * @private (setter)
		 */
		public function set topCurve(val:Number):void
		{
			_topCurve = val;
		}
		
		/**
		 * Gets or sets whether or not to update the blur. This would be useful if the parent has children with movement
		 * @default false
		 */
		public function get updateBlur():Boolean
		{
			return _updateBlur;
		}
		/**
		 * @private (setter)
		 */
		public function set updateBlur(val:Boolean):void
		{
			if(_updateBlur)
			{
				_curParent.stage.removeEventListener(Event.ENTER_FRAME, handleEnterFrame);
			}
			_updateBlur = val;
		}
		
		/**
		 * Gets or sets a value for the current width of the window.
		 * @default 100
		 */
		public override function get width():Number
		{
			return _width;
		}
		/**
		 * @private (setter)
		 */
		public override function set width(val:Number):void
		{
			_width = val+EXTRA_HORIZONTAL;
			_sizeToContent = false;
			_contentWidth = val;
		}
		
		/**
		 * Gets or sets the x value of the window.
		 * @default 0
		 */
		public override function get x():Number
		{
			return _x;
		}
		/**
		 * @private (setter)
		 */
		public override function set x(val:Number):void
		{
			_x = val;
			super.x = _x;
			isCentered = false;
		}
		
		/**
		 * Gets or sets the y value of the window.
		 * @default 0
		 */
		public override function get y():Number
		{
			return _y;
		}
		/**
		 * @private (setter)
		 */
		public override function set y(val:Number):void
		{
			_y = val;
			super.y = _y;
			isCentered = false;
		}

		
	}
	
}