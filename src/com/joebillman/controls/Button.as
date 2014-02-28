package com.joebillman.controls
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.errors.IOError;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.filters.DropShadowFilter;
	import flash.geom.Matrix;
	import flash.net.URLRequest;
	import flash.sampler.getInvocationCount;
	import flash.system.LoaderContext;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	//--------------------------------------
	//  Class description
	//
	/**
	 * Button: Creates a Button with only code.
	 *
	 *
	 * @example The following example creates a button and modifies some of its properties so that it looks like a default flash button.
	 * <p><strong>Note: </strong>This button this makes is ugly. If you want a better looking button just go with the default settings.</p>
	 * <listing version="3.0" >
	 * package
	 * {
	 *     import bf.controls.Button;
	 * 
	 *     import flash.display.MovieClip; 
	 * 
	 *     public class ButtonExample extends MovieClip
	 *     {
	 * 
	 *         private var btn:Button;
	 * 
	 *         public function ButtonExample()
	 *         {
	 *             _init();
	 *         }
	 * 
	 *         private function _init():void
	 *         {
	 *			  btn = new Button("Label", false);
	 *			  btn.color = 0xF1F1F1;
	 *			  btn.downColor = btn.color;
	 * 			  btn.overColor = btn.color;
	 *			  btn.hasInset = false;
	 *  		  btn.hastextAccent = false;
	 *            btn.strokeGradient = [0xB7BABC, 0x585F63];
	 *            btn.strokeOverGradient = [0x009DFF, 0x0075BF];
	 * 			  btn.textSize = 11;
	 *            addChild(btn);
	 * 			  btn.build();
	 *         }
	 *     }
	 * }
	 * </listing>
	 *
	 *
	 * @author Joe Billman
	 */
	public class Button extends Sprite
	{
		private const DEFAULT_PADDING:Number = 2.111223;
		
		private var _color:uint;
		private var _enabled:Boolean;
		private var _downColor:uint;
		private var _hasDownShadow:Boolean;
		private var _hasInset:Boolean;
		private var _hasTextAccent:Boolean;
		private var _height:Number;
		private var _icon:String;
		private var _iconPercentageOfHeight:Number;
		private var _iconX:Number;
		private var _label:String;
		private var _overColor:uint;
		private var _roundness:Number;
		private var _sizeToIcon:Boolean;
		private var _sizeToText:Boolean;
		private var _strokeGradient:Array;
		private var _strokeOverGradient:Array;
		private var _textAccentColor:uint;
		private var _textField:TextField;
		private var _textFormat:TextFormat;
		private var _textOverColor:uint;
		private var _textPadding:Number;
		private var _textSize:Number;
		private var _width:Number;
		private var customWidth:Boolean;
		private var iconBmp:Bitmap;
		private var iconLoader:Loader;
		private var innerShadow:Sprite;
		private var isBuilt:Boolean;
		private var fill:Shape;
		private var glass:Shape;
		private var inset:Shape;
		private var stroke:Shape;
		
		public function Button(label:String="Label", buildDefault:Boolean=true)
		{
			super();
			_label = label;
			_init(buildDefault);
		}
		
		private function _init(buildDefault:Boolean):void
		{
			_color = 0x999999;
			_downColor = 0xAAAAAA;
			_enabled = true;
			_hasDownShadow = true;
			_hasInset = true;
			_hasTextAccent = true;
			_iconPercentageOfHeight = .95;
			_iconX = 6;
			_overColor = 0xBBBBBB;
			_height = 22;
			_roundness = 5.5;
			_sizeToIcon = false;
			_sizeToText = false;
			_strokeGradient = [0xB7BABC, 0x585F63];
			_strokeOverGradient = _strokeGradient;
			_textAccentColor = 0xFFFFFF;
			_textPadding = DEFAULT_PADDING;
			_textSize = 13;
			_textFormat = new TextFormat("_sans", _textSize, 0x000000);
			_textOverColor = uint(_textFormat.color);
			_width = 100;
			customWidth = false;
			isBuilt = false;
			if(buildDefault)
			{
				build();
			}
		}
		
		private function adjustWidth():void
		{
			var tField:TextField = new TextField();
			tField.autoSize = TextFieldAutoSize.LEFT;
			tField.defaultTextFormat = _textFormat;
			tField.text = _label;
			if(_icon == null && !customWidth)
			{
				_width = tField.width+Math.abs(_textPadding)*2;
			}
			else
			{
				if(!customWidth)
				{
					_width = (tField.width+Math.abs(_textPadding)*2) + (iconBmp.width+_iconX);
				}
			}	
			tField = null;
		}
		
		private function buildInnerShadow():void
		{
			var gr:Graphics;
			var gradientMatrix:Matrix = new Matrix();
			erase(innerShadow);
			innerShadow = new Sprite();
			gradientMatrix.createGradientBox(_width, _height, 90*(Math.PI/180));
			gr = innerShadow.graphics;
			gr.beginFill(0x000000);
			gr.drawRoundRect(0, 0, _width, _height, _roundness);
			gr.endFill();
			innerShadow.filters = [new DropShadowFilter(4, 65, 0, .7, 4, 4, 1, 1, true, true)];
			innerShadow.visible = false;
			addChild(innerShadow);
		}
		
		private function buildTextField():void
		{
			erase(_textField);
			_textField = new TextField();
			_textField.antiAliasType = AntiAliasType.ADVANCED;
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.defaultTextFormat = _textFormat;
			_textField.width = _width - (Math.abs(_textPadding)*2);
			_textField.selectable = false;
			_textField.text = _label;
			if(_icon == null)
			{
				if(_textPadding == DEFAULT_PADDING)
				{
					_textField.x = (_width-_textField.width)/2;
				}
				else
				{
					_textField.x = _textPadding;
				}
			}
			else
			{
				var openSpace:Number = _width-(_iconX+iconBmp.width);
				if(_textPadding == DEFAULT_PADDING)
				{
					_textField.x = ((_iconX+iconBmp.width) + ((openSpace-(_textField.width+DEFAULT_PADDING*2))/2));
				}
				else
				{
					_textField.x = (_iconX+iconBmp.width) + _textPadding;
				}
			}
			_textField.y = (_height - (_textField.height))/2;
			if(_hasTextAccent)
			{
				_textField.filters = [new DropShadowFilter(1, 45, _textAccentColor, 1, 1, 1)];
			}
			addChild(_textField);
		}
		
		private function configForMouse():void
		{
			mouseChildren = false;
			buttonMode = true;
			addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true);
			addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true);
			addEventListener(MouseEvent.MOUSE_UP, handleMouseUp, false, 0, true);
		}
		
		/**
		 * Creates the icon for the button
		 */
		private function createIcon():void
		{
			iconLoader = new Loader();
			iconLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onIconLoaded, false, 0, true);
			iconLoader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, handleIOError, false, 0, true);
			var context:LoaderContext = new LoaderContext();
			context.checkPolicyFile = true;
			iconLoader.load(new URLRequest(_icon), context);
		}
		
		private function draw():void
		{
			if(_sizeToText)
			{
				adjustWidth();
			}
			if(_hasInset)
			{
				drawInset();
			}
			drawFill(_color);
			drawGlass();
			if(_label != "")
			{
				buildTextField();
			}
			buildInnerShadow();
			drawStroke(_strokeGradient);
			isBuilt = true;
		}
		
		private function drawInset():void
		{
			var gr:Graphics;
			var gradientMatrix:Matrix = new Matrix();
			erase(inset);
			inset = new Shape();
			gradientMatrix.createGradientBox(_width+4, _height+4, 90*(Math.PI/180));
			gr = inset.graphics;
			gr.beginGradientFill(GradientType.LINEAR, [0x000000, 0xFFFFFF], [.70, .85], [75, 255], gradientMatrix);
			gr.drawRoundRect(0, 0, _width+4, _height+4, _roundness);
			gr.endFill();
			inset.x = -2;
			inset.y = -2;
			addChild(inset);
		}
		
		private function drawFill(color:uint):void
		{
			var gr:Graphics;
			var gradientMatrix:Matrix = new Matrix();
			erase(fill);
			fill = new Shape();
			gradientMatrix.createGradientBox(_width, _height, 90*(Math.PI/180));
			gr = fill.graphics;
			gr.beginFill(color);
			gr.drawRoundRect(0, 0, _width, _height, _roundness);
			gr.endFill();
			if(inset != null)
			{
				addChildAt(fill, getChildIndex(inset)+1);
			}
			else
			{
				addChildAt(fill, 0);
			}
		}
		
		private function drawGlass():void
		{
			var gr:Graphics;
			var gradientMatrix:Matrix = new Matrix();
			erase(glass);
			glass = new Shape();
			gradientMatrix.createGradientBox(_width, _height, 90*(Math.PI/180));
			gr = glass.graphics;
			gr.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF], [.85, .45, 0, .25], [0, 128, 129, 255], gradientMatrix);
			gr.drawRoundRect(0, 0, _width, _height, _roundness);
			gr.endFill();
			addChild(glass);
		}
		
		private function drawStroke(color:Array):void
		{
			var gr:Graphics;
			var gradientMatrix:Matrix = new Matrix();
			erase(stroke);
			stroke = new Shape();
			gradientMatrix.createGradientBox(_width, _height, 90*(Math.PI/180));
			gr = stroke.graphics;
			gr.lineStyle(1, 0, 1.0, true);
			gr.lineGradientStyle(GradientType.LINEAR, color, [1, 1], [0, 255], gradientMatrix);
			gr.drawRoundRect(0, 0, _width, _height, _roundness);
			gr.endFill();
			addChild(stroke);
		}
		
		private function erase(obj:DisplayObject):void
		{
			if(obj != null)
			{
				if(contains(obj))
				{
					removeChild(obj);
				}
				obj = null;
			}
		}
		
		private function handleIOError(evt:IOErrorEvent):void
		{
			throw new Error("The url supplied for the icon appears to be incorrect.");
		}
		
		private function handleMouseDown(evt:MouseEvent):void
		{
			stage.focus = this;
			if(_hasDownShadow)
			{
				innerShadow.visible = true;
			}
			stroke.visible = false;
			if(_downColor != _color)
			{
				drawFill(_downColor);
			}
		}
		
		private function handleMouseOut(evt:MouseEvent):void
		{
			innerShadow.visible = false;
			drawStroke(_strokeGradient);
			drawFill(_color);
			if(_textField != null)
			{
				_textField.textColor = uint(_textFormat.color);
			}
		}
		
		private function handleMouseOver(evt:MouseEvent):void
		{
			if(_strokeOverGradient != _strokeGradient)
			{
				drawStroke(_strokeOverGradient);
			}
			if(_overColor != _color)
			{
				drawFill(_overColor);
			}
			if(_textOverColor != _textFormat.color)
			{
				_textField.textColor = _textOverColor;
			}
		}
		
		private function handleMouseUp(evt:MouseEvent):void
		{
			innerShadow.visible = false;
			stroke.visible = true;
			if(_overColor != _color)
			{
				drawFill(_overColor);
			}
		}
		
		/**
		 * Handles when the icon is loaded and fires a COMPLETE event
		 */
		private function onIconLoaded(evt:Event):void
		{
			iconLoader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onIconLoaded);
			iconLoader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, handleIOError);
			erase(iconBmp);
			var widthToHeight:Number;
			var iconBmpData:BitmapData = new BitmapData(iconLoader.width, iconLoader.height, true, 0xFF00FF);
			iconBmpData.draw(iconLoader);
			iconBmp = new Bitmap(iconBmpData, PixelSnapping.AUTO, true);
			widthToHeight = iconBmp.width/iconBmp.height;
			iconBmp.height = _height*_iconPercentageOfHeight;
			iconBmp.width = iconBmp.height*widthToHeight;
			iconBmp.x = _iconX;
			iconBmp.y = (_height-iconBmp.height)/2;
			if(_sizeToIcon && _label == "" && !customWidth)
			{
				_width = iconBmp.width+12;
				iconBmp.x = (_width-iconBmp.width)/2;
			}
			else
			{
				if(!customWidth)
				{
					_width  += (iconBmp.width+_iconX);
				}
			}
			draw();
			addChild(iconBmp);
			configForMouse();
		}
		
		//Public
		public function build():void
		{
			if(!isBuilt)
			{
				if(_icon != null)
				{
					createIcon();
				}
				else
				{
					draw();
					configForMouse();
				}
			}
			else
			{
				throw new Error("Button is already built. Use redraw(). Check the buildDefault value of the constructor, if not set to false build is called automatically.");
			}
		}
		
		public function cleanup():void
		{
			if(inset != null)
			{
				if(contains(inset))
				{
					removeChild(inset);
				}
				inset = null;
			}
			if(fill != null)
			{
				if(contains(fill))
				{
					removeChild(fill);
				}
				fill = null;
			}
			if(glass != null)
			{
				if(contains(glass))
				{
					removeChild(glass);
				}
				glass = null;
			}
			if(iconLoader != null)
			{
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
			if(_textField != null)
			{
				if(contains(_textField))
				{
					removeChild(_textField);
				}
				_textField = null;
			}
			if(innerShadow != null)
			{
				if(contains(innerShadow))
				{
					removeChild(innerShadow);
				}
				innerShadow = null;
			}
			if(stroke != null)
			{
				if(contains(stroke))
				{
					removeChild(stroke);
				}
				stroke = null;
			}
		}
		
		public function redraw():void
		{
			draw();
		}

		public function get color():uint
		{
			return _color;
		}

		public function set color(value:uint):void
		{
			_color = value;
		}

		public function get downColor():uint
		{
			return _downColor;
		}

		public function set downColor(value:uint):void
		{
			_downColor = value;
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
			if(_enabled)
			{
				alpha = 1;
				mouseEnabled = true;
			}
			else
			{
				alpha = .5;
				mouseEnabled = false;
			}
		}

		public function get hasDownShadow():Boolean
		{
			return _hasDownShadow;
		}

		public function set hasDownShadow(value:Boolean):void
		{
			_hasDownShadow = value;
		}

		public function get hasInset():Boolean
		{
			return _hasInset;
		}

		public function set hasInset(value:Boolean):void
		{
			_hasInset = value;
		}
		
		public function get hasTextAccent():Boolean
		{
			return _hasTextAccent;
		}
		
		public function set hasTextAccent(value:Boolean):void
		{
			_hasTextAccent = value;
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height = value;
		}
		
		public function get icon():String
		{
			return _icon;
		}
		
		public function set icon(value:String):void
		{
			_icon = value;
		}
		
		public function get iconPercentageOfHeight():Number
		{
			return _iconPercentageOfHeight;
		}
		
		public function set iconPercentageOfHeight(value:Number):void
		{
			_iconPercentageOfHeight = value;
		}
		
		public function get iconX():Number
		{
			return _iconX;
		}
		
		public function set iconX(value:Number):void
		{
			_iconX = value;
		}

		public function get label():String
		{
			return _label;
		}

		public function set label(value:String):void
		{
			_label = value;
		}

		public function get overColor():uint
		{
			return _overColor;
		}

		public function set overColor(value:uint):void
		{
			_overColor = value;
		}

		public function get roundness():Number
		{
			return _roundness;
		}

		public function set roundness(value:Number):void
		{
			_roundness = value;
		}
		
		public function get sizeToIcon():Boolean
		{
			return _sizeToIcon;
		}
		
		public function set sizeToIcon(value:Boolean):void
		{
			_sizeToIcon = value;
		}
		
		public function get sizeToText():Boolean
		{
			return _sizeToText;
		}
		
		public function set sizeToText(value:Boolean):void
		{
			_sizeToText = value;
		}

		public function get strokeGradient():Array
		{
			return _strokeGradient;
		}

		public function set strokeGradient(value:Array):void
		{
			_strokeGradient = value;
		}

		public function get strokeOverGradient():Array
		{
			return _strokeOverGradient;
		}

		public function set strokeOverGradient(value:Array):void
		{
			_strokeOverGradient = value;
		}
		
		public function get text():String
		{
			return _textField.text;
		}
		
		public function set text(value:String):void
		{
			_textField.text = value;
		}
		
		public function get textAccentColor():uint
		{
			return _textAccentColor;
		}
		
		public function set textAccentColor(value:uint):void
		{
			_textAccentColor = value;
		}

		public function get textColor():uint
		{
			return uint(_textFormat.color);
		}

		public function set textColor(value:uint):void
		{
			_textFormat.color = value;
		}

		public function get textField():TextField
		{
			return _textField;
		}

		public function get textFormat():TextFormat
		{
			return _textFormat;
		}

		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
		}

		public function get textOverColor():uint
		{
			return _textOverColor;
		}

		public function set textOverColor(value:uint):void
		{
			_textOverColor = value;
		}

		public function get textPadding():Number
		{
			return _textPadding;
		}

		public function set textPadding(value:Number):void
		{
			_textPadding = value;
		}
		
		public function get textSize():Number
		{
			return _textSize;
		}

		public function set textSize(value:Number):void
		{
			_textSize = value;
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width = value;
			customWidth = true;
		}

	}
}