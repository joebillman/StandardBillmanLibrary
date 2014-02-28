package com.joebillman.controls
{
	import com.joebillman.containers.Window;
	import com.joebillman.controls.Button;
	
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	//--------------------------------------
	//  Class description
	//
	/**
	 * Alert: Creates an alert window.
	 *
	 *
	 * @example The following example creates a simple alert window.
	 * <listing version="3.0" >
	 * package
	 * {
	 *     import bf.controls.Alert;
	 * 
	 *     import flash.display.MovieClip; 
	 * 
	 *     public class AlertExample extends MovieClip
	 *     {
	 * 
	 *         public function AlertExample()
	 *         {
	 *             _init();
	 *         }
	 * 
	 *         private function _init():void
	 *         {
	 *			  Alert.show(this, "This is a sample alert.", "Error", [Alert.OK], handleAlert);
	 *         }
	 * 
	 *         private function handleAlert(type:int):void
	 *         {
	 *            switch(type)
	 *            {
	 *               case Alert.OK:
	 *               trace("OK");
	 *               break;
	 *            }
	 *         }
	 *     }
	 * }
	 * </listing>
	 *
	 *
	 * @author Joe Billman
	 */
	public class Alert extends Sprite
	{
		private const BTN_HEIGHT:uint = 22;
		private const BTN_PADDING:uint = 10;
		private const BTN_WIDTH:uint = 60;
		private const MAX_WIDTH:uint = 458;
		private const MIN_WIDTH:uint = 150;
		private const TXT_PADDING:uint = 20;
		
		private var bg:Shape;
		private var btns:Array;
		private var closeFunction:Function;
		private var content:Sprite;
		private var iconPath:String;
		private var isHTMLText:Boolean;
		private var myParent:DisplayObjectContainer;
		private var txtField:TextField;
		private var txtFmt:TextFormat;
		private var win:Window;
		
		public static const CANCEL:int = 0;
		public static const NO:int = 1;
		public static const OK:int = 2;
		public static const YES:int = 3;
		
		
		/**
		 * Builds the content that will appear in the window 
		 * @param text		Text to display in the window
		 * @param flags		These flags determine which buttons will display as well as the order in which they display. Alert.OK,  Alert.CANCEL,  Alert.YES,  Alert.NO
		 * 
		 */		
		private function buildContent(text:String, flags:Array, attributes:AlertAttributes):void
		{
			var btnXs:Array;
			var contentHeight:Number;
			var len:uint;
			var gr:Graphics;
			var i:uint;
			var minBtnLen:Number;
			if(flags != null)
			{
				var uniqueFlags:Array = [];
				len = flags.length;
				for(i=0; i<len; i++) 
				{
					if(isUnique(flags[i], uniqueFlags))
					{
						uniqueFlags.push(flags[i]);
					}
				}
				flags = uniqueFlags.slice();
				len = flags.length;
				uniqueFlags = null;
			}
			else
			{
				len = 0;
			}
			minBtnLen = (BTN_WIDTH*len)+(BTN_PADDING*(len+1));
			bg = new Shape();
			content = new Sprite();
			if(txtFmt == null)
			{
				txtFmt = new TextFormat("_sans", 15, 0x000000, null, null, null, null, null, "center");
			}
			txtField = new TextField();
			txtField.autoSize = TextFieldAutoSize.LEFT;
			txtField.defaultTextFormat = txtFmt;
			if(!isHTMLText)
			{
				txtField.text = text;
			}
			else
			{
				txtField.htmlText = text;
			}
			txtField.y = 6;
			contentHeight = txtField.y+txtField.height+BTN_HEIGHT+(BTN_PADDING*2);
			gr = bg.graphics;
			if(attributes != null)
			{
				gr.beginFill(attributes.contentBGColor, attributes.contentBGAlpha);
			}
			else
			{
				gr.beginFill(0xF4F4F4);
			}
			if(txtField.width <= MIN_WIDTH)
			{
				if(MIN_WIDTH+TXT_PADDING > minBtnLen)
				{
					gr.drawRect(0, 0, MIN_WIDTH+TXT_PADDING, contentHeight);
				}
				else
				{
					gr.drawRect(0, 0, minBtnLen, contentHeight);
				}
			}
			else if(txtField.width > MIN_WIDTH && txtField.width < (MAX_WIDTH-TXT_PADDING))
			{
				if(txtField.width+TXT_PADDING > minBtnLen)
				{
					gr.drawRect(0, 0, txtField.width+TXT_PADDING, contentHeight);
				}
				else
				{
					gr.drawRect(0, 0, minBtnLen, contentHeight);
				}
			}
			else
			{
				txtField.multiline = true;
				txtField.wordWrap = true;
				txtField.width = MAX_WIDTH-TXT_PADDING;
				contentHeight = txtField.y+txtField.height+BTN_HEIGHT+(BTN_PADDING*2);
				if(MIN_WIDTH > minBtnLen)
				{
					gr.drawRect(0, 0, MAX_WIDTH, contentHeight);
				}
				else
				{
					gr.drawRect(0, 0, minBtnLen, contentHeight);
				}
			}
			gr.endFill();
			content.addChild(bg);
			txtField.x = ((content.width-txtField.width)/2);
			content.addChild(txtField);
			win.content = content;
			if(len > 0)
			{
				btns = new Array(len);
				btnXs = new Array(len);
				calcXs(btnXs);
			}
			for(i=0; i<len; i++) 
			{
				switch(flags[i])
				{
					case OK:
						btns[i] = new Button("OK", false);
						break;
					case CANCEL:
						btns[i] = new Button("Cancel", false);
						break;
					case YES:
						btns[i] = new Button("Yes", false);
						break;
					case NO:
						btns[i] = new Button("No", false);
						break;
				}
				btns[i].width = BTN_WIDTH;
				btns[i].x = btnXs[i];
				btns[i].y = txtField.y+txtField.height+BTN_PADDING;
				btns[i].addEventListener(MouseEvent.CLICK, handleClick);
				content.addChild(btns[i]);
				btns[i].build();
			}
			btnXs = null;
		}
		
		/**
		 * Calculates the x positions for the buttons
		 * @param btnXs		The array that holds the x values
		 * 
		 */		
		private function calcXs(btnXs:Array):void
		{
			var len:uint = btnXs.length;
			var spacing:Number = (content.width-BTN_WIDTH*len)/(len+1);
			for(var i:uint=0; i<len; i++) 
			{
				if(i>0)
				{
					btnXs[i] = (spacing*(i+1)) + (BTN_WIDTH*i);
				}
				else
				{
					btnXs[i] = spacing;
				}
			}
		}
		
		/**
		 *Performs necessary gc cleanup 
		 * 
		 */		
		private function cleanup():void
		{
			if(content != null)
			{
				var len:uint = btns.length;
				content.removeChild(bg);
				bg = null;
				content.removeChild(txtField);
				txtField = null;
				txtFmt = null;
				for(var i:uint=0; i<len; i++) 
				{
					btns[i].removeEventListener(MouseEvent.CLICK, handleClick);
					content.removeChild(btns[i]);
				}
				btns = null;
			}
			if(win != null)
			{
				if(myParent.contains(win))
				{
					win.destroyWindow();
					myParent.removeChild(win);
				}
				content = null;
				win = null;
				myParent = null;
			}
			if(closeFunction != null)
			{
				closeFunction = null;
			}
			if(iconPath != null)
			{
				iconPath = null;
			}
		}
		
		/**
		 * Configures the window that will be used as the alert
		 * @param title
		 * @param attributes
		 * 
		 */		
		private function configWin(title:String, attributes:AlertAttributes):void
		{
			win = new Window();
			if(attributes != null)
			{
				if(attributes.alertFormat != null)
				{
					txtFmt = attributes.alertFormat;
				}
				win.autoMask = attributes.autoMask;
				win.blurAmount = attributes.blurAmount;
				win.btmCurve = attributes.btmCurve;
				win.btnColor = attributes.btnColor;
				win.btnOverColor = attributes.btnOverColor;
				win.btnSymbolColor = attributes.btnSymbolColor;
				win.closeOnX = attributes.closeOnX;
				win.color = attributes.color;
				win.colorAlpha = attributes.colorAlpha;
				win.destroyOnFade = attributes.destroyOnFade;
				win.fadeInOnBuild = attributes.fadeInOnBuild;
				win.fadeInTime = attributes.fadeInTime;
				win.fadeOutOnDestroy = attributes.fadeOutOnDestroy;
				win.fadeOutTime = attributes.fadeOutTime;
				win.hasBlur = attributes.hasBlur;
				win.hasCloseX = attributes.hasCloseX;
				win.hasContentFill = attributes.hasContentFill;
				win.hasContentFillInset = attributes.hasContentFillInset;
				win.hasDropShadow = attributes.hasDropShadow;
				win.hasTitleBG = attributes.hasTitleBG;
				win.hasTitleInset = attributes.hasTitleInset;
				win.isCentered = attributes.isCentered;
				win.isDraggable = attributes.isDraggable;
				win.isModal = attributes.isModal;
				win.isPaddedToTitle = attributes.isPaddedToTitle;
				win.isVisible = attributes.isVisible;
				win.leftAlignTitle = attributes.leftAlignTitle;
				win.modalAlpha = attributes.modalAlpha;
				win.modalColor = attributes.modalColor;
				win.sizeToContent = attributes.sizeToContent;
				win.titleBGColor = attributes.titleBGColor;
				win.titleBGPadding = attributes.titleBGPadding;
				win.titleColor = attributes.titleColor;
				win.titleFormat = attributes.titleFormat;
				if(attributes.hasTitleInset)
				{
					win.titleInsetColor = attributes.titleInsetColor;
				}
				win.topCurve = attributes.topCurve;
				win.updateBlur = attributes.updateBlur;
			}
			else
			{
				win.color = 0x666666;
				win.colorAlpha = .75;
				win.hasCloseX = false;
			}
			win.contentBGAlpha = 0;
			win.contentBGColor = 0xFFFFFF;
			win.icon = iconPath;
			win.title = title;
		}
		
		/**
		 * Handles the button clicks 
		 * @param evt
		 * 
		 */		
		private function handleClick(evt:MouseEvent):void
		{
			switch(evt.target.text)
			{
				case "OK":
					if(closeFunction != null)
					{
						closeFunction(OK);
					}
					break;
				case "Yes":
					if(closeFunction != null)
					{
						closeFunction(YES);
					}
					break;
				case "No":
					if(closeFunction != null)
					{
						closeFunction(NO);
					}
					break;
				case "Cancel":
					if(closeFunction != null)
					{
						closeFunction(CANCEL);
					}
					break;
			}
			cleanup();
		}
		
		/**
		 * Checks for duplicate values in the flags array
		 * @param val	value that is being checked
		 * @param arr	array that is being checked
		 * @return 		true if unique, false if not
		 * 
		 */		
		private function isUnique(val:uint, arr:Array):Boolean
		{
			var len:uint = arr.length;
			for(var i:uint=0; i<len; i++) 
			{
				if(val == arr[i])
				{
					return false;
				}
			}
			return true;
		}
		
		/**
		 * Displays the the alert window
		 * @param parent	Parent object that the alert window will be added to.
		 * @param text		Message text that will display in the window.
		 * @param title		Title to be displayed in the top of the window.
		 * @param flags		Array that signals which buttons to include in the window and in which order. Alert.OK,  Alert.CANCEL,  Alert.YES,  Alert.NO
		 * @param icon		Path to the image to be used as the icon.
		 */
		public static function show(parent:DisplayObjectContainer, text:String, title:String="Alert", flags:Array=null, closeHandler:Function=null, icon:String=null, attributes:AlertAttributes=null, isHTMLText:Boolean=false):Alert
		{
			var alert:Alert = new Alert();
			alert.myParent = parent;
			if(flags == null)
			{
				flags = [OK];
			}
			alert.closeFunction = closeHandler;
			alert.iconPath = icon;
			alert.isHTMLText = isHTMLText;
			alert.configWin(title, attributes);
			alert.buildContent(text, flags, attributes);
			alert.myParent.addChild(alert.win);
			if(attributes != null)
			{
				alert.win.build(attributes.customAlignW, attributes.customAlignH, attributes.fadeInDelay);
			}
			else
			{
				alert.win.build();
			}
			return alert;
		}
	}
}