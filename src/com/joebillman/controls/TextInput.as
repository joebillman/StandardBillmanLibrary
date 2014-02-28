package com.joebillman.controls
{
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.text.TextFormat;

	[Event(name="change", type="flash.events.Event")]
	
	public class TextInput extends Sprite
	{
		private var _bgColor:uint;
		private var _disabledAlpha:Number;
		private var _embedFonts:Boolean;
		private var _extraShadowColor:uint;
		private var _hasExtraShadow:Boolean;
		private var _hasInset:Boolean;
		private var _hasShadow:Boolean;
		private var _height:Number;
		private var _insetColor:uint;
		private var _insetColorAlpha:Number;
		private var _isPassword:Boolean;
		private var _maxChars:uint;
		private var _shadowColor:uint;
		private var _textFormat:TextFormat;
		private var _textField:TextField;
		private var _textFieldPaddingLeft:Number;
		private var _textFieldPaddingTop:Number;
		private var _width:Number;
		private var curGraphics:Graphics;
		private var defaultBuild:Boolean;
		private var insetBG:Shape;
		private var isBuilt:Boolean;
		private var isEditable:Boolean;
		private var isEnabled:Boolean;
		private var isRestricted:Boolean;
		private var isSelectable:Boolean;
		private var restrictedChars:String;
		private var shadowBG:Shape;
		private var extraShadowBG:Shape;
		private var txtBG:Shape;
		
		public function TextInput(buildDefault:Boolean=true)
		{
			defaultBuild = buildDefault;
			_init();
		}
		
		private function _init():void
		{
			_bgColor = 0xFFFFFF;
			_disabledAlpha = .45;
			isEditable = true;
			_embedFonts = false;
			_hasExtraShadow = true;
			_hasInset = true;
			_hasShadow = true;
			_height = 25;
			_insetColor = 0xDDDDDD;
			_insetColorAlpha = .65;
			_isPassword = false;
			_shadowColor = 0x999999;
			_extraShadowColor = _shadowColor;
			_textFieldPaddingLeft = 2;
			_textFieldPaddingTop = 2;
			_width = 150;
			isBuilt = false;
			isEnabled = true;
			isRestricted = false;
			isSelectable = true;
			if(defaultBuild)
			{
				build();
			}
		}
		
		private function buildTextField():void
		{
			if(_textField != null)
			{
				if(contains(_textField))
				{
					removeChild(_textField);
				}
				_textField = null;
			}
			_textField = new TextField();
			if(_embedFonts)
			{
				_textField.embedFonts = true;
			}
			if(isEditable)
			{
				_textField.type = TextFieldType.INPUT;
			}
			else
			{
				_textField.type = TextFieldType.DYNAMIC;
			}
			if(_isPassword)
			{
				_textField.displayAsPassword = true;
			}
			else
			{
				_textField.displayAsPassword = false;
			}
			if(_maxChars != 0)
			{
				_textField.maxChars = _maxChars;
			}
			if(isRestricted)
			{
				_textField.restrict = restrictedChars;
			}
			_textField.selectable = isSelectable;
			_textField.width = txtBG.width;
			_textField.height = txtBG.height+2;
			_textField.x = txtBG.x+_textFieldPaddingLeft;
			_textField.y = txtBG.y+_textFieldPaddingTop;
			if(_textFormat == null)
			{
				buildTextFormat();
			}
			_textField.defaultTextFormat = _textFormat;
			_textField.addEventListener(Event.CHANGE, handleChange, false, 0, true);
			addChild(_textField);
		}
		
		private function buildTextFormat():void
		{
			_textFormat = new TextFormat("_sans", 12, 0x000000);
		}

		private function drawBG():void
		{
			if(_hasInset)
			{
				insetBG = new Shape();
				curGraphics = insetBG.graphics;
				curGraphics.beginFill(_insetColor, _insetColorAlpha);
				curGraphics.drawRect(0, 0, _width, _height);
				curGraphics.endFill();
				addChild(insetBG);
			}
			if(_hasShadow)
			{
				shadowBG = new Shape();
				curGraphics = shadowBG.graphics;
				curGraphics.beginFill(_shadowColor);
				curGraphics.drawRect(1, 1, _width-2, _height-2);
				curGraphics.endFill();
				addChild(shadowBG);
			}
			if(_hasExtraShadow)
			{
				extraShadowBG = new Shape();
				curGraphics = extraShadowBG.graphics;
				curGraphics.beginFill(_extraShadowColor);
				curGraphics.drawRect(2, 2, _width-4, _height-4);
				curGraphics.endFill();
				addChild(extraShadowBG);
			}
			txtBG = new Shape();
			curGraphics = txtBG.graphics;
			curGraphics.beginFill(_bgColor);
			curGraphics.drawRect(3, 3, _width-5, _height-5);
			curGraphics.endFill();
			addChild(txtBG);
		}
		
		private function handleChange(evt:Event):void
		{
			evt.stopPropagation();
			dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		private function handleFocusIn(evt:FocusEvent):void
		{
			if(stage != null)
			{
				stage.focus = _textField;
			}
			else
			{
				throw new Error("The object is null, build() must me called first");
			}
		}
		
		public function appendText(newText:String):void
		{
			if(_textField != null)
			{
				_textField.appendText(newText);
			}
		}
		
		public function build():void
		{
			drawBG();
			buildTextField();
			addEventListener(FocusEvent.FOCUS_IN, handleFocusIn, false, 0, true);
			blendMode = BlendMode.LAYER;
			if(isEnabled)
			{
				alpha = 1;
			}
			else
			{
				alpha = _disabledAlpha;
			}
			isBuilt = true;
		}
		
		public function cleanup():void
		{
			if(insetBG != null)
			{
				if(contains(insetBG))
				{
					removeChild(insetBG);
				}
				insetBG = null;
			}
			if(shadowBG != null)
			{
				if(contains(shadowBG))
				{
					removeChild(shadowBG);
				}
				shadowBG = null;
			}
			if(extraShadowBG != null)
			{
				if(contains(extraShadowBG))
				{
					removeChild(extraShadowBG);
				}
				extraShadowBG = null;
			}
			if(txtBG != null)
			{
				if(contains(txtBG))
				{
					removeChild(txtBG);
				}
				txtBG = null;
			}
			if(_textField != null)
			{
				_textField.removeEventListener(Event.CHANGE, handleChange);
				if(contains(_textField))
				{
					removeChild(_textField);
				}
				_textField = null;
			}
			if(_textFormat != null)
			{
				_textFormat = null;
			}
			if(curGraphics != null)
			{
				curGraphics = null;
			}
		}
		
		public function getTextFormat():TextFormat
		{
			return _textFormat;
		}
		
		public function replaceSelectedText(value:String):void
		{
			if(_textField != null)
			{
				_textField.replaceSelectedText(value);
			}
		}
		
		public function replaceText(beginIndex:int, endIndex:int, newText:String):void
		{
			if(_textField != null)
			{
				_textField.replaceText(beginIndex, endIndex, newText);
			}
		}
		
		public function setSelection(beginIndex:int, endIndex:int):void
		{
			if(_textField != null)
			{
				_textField.setSelection(beginIndex, endIndex);
			}
			else
			{
				throw new Error("textField is null, build() must me called first");
			}
		}
		
		public function setTextFormat(format:TextFormat):void
		{
			_textFormat = format;
		}

		//
		public function get bgColor():uint
		{
			return _bgColor;
		}

		public function set bgColor(value:uint):void
		{
			_bgColor = value;
		}
		
		public function get caretIndex():int
		{
			if(_textField != null)
			{
				return _textField.caretIndex;
			}
			else
			{
				throw new Error("textField is null, build() must me called first");
			}
		}
		
		public function get disabledAlpha():Number
		{
			return _disabledAlpha;
		}
		
		public function set disabledAlpha(value:Number):void
		{
			_disabledAlpha = value;
		}
		
		public function get editable():Boolean
		{
			return _textField.type == TextFieldType.INPUT;
		}
		
		public function set editable(value:Boolean):void
		{
			isEditable = value;
			if(_textField != null)
			{
				if(isEditable)
				{
					_textField.type = TextFieldType.INPUT;
				}
				else
				{
					_textField.type = TextFieldType.DYNAMIC;
				}
			}
		}
		
		public function get embedFonts():Boolean
		{
			return _embedFonts;
		}
		
		public function set embedFonts(value:Boolean):void
		{
			_embedFonts = value;
		}
		
		public function get enabled():Boolean
		{
			return isEnabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			isEnabled = value;
			isSelectable = isEnabled;
			if(_textField != null && isEnabled)
			{
				alpha = 1;
				_textField.selectable = true;
			}
			else if(_textField != null && !isEnabled)
			{
				alpha = _disabledAlpha;
				_textField.selectable = false;
			}
		}
		
		public function get extraShadowColor():uint
		{
			return _extraShadowColor;
		}
		
		public function set extraShadowColor(value:uint):void
		{
			_extraShadowColor = value;
		}
		
		public function get hasExtraShadow():Boolean
		{
			return _hasExtraShadow;
		}
		
		public function set hasExtraShadow(value:Boolean):void
		{
			_hasExtraShadow = value;
		}
		
		public function get hasInset():Boolean
		{
			return _hasInset;
		}
		
		public function set hasInset(value:Boolean):void
		{
			_hasInset = value;
		}
		
		public function get hasShadow():Boolean
		{
			return _hasShadow;
		}
		
		public function set hasShadow(value:Boolean):void
		{
			_hasShadow = value;
		}

		public override function get height():Number
		{
			return _height;
		}

		public override function set height(value:Number):void
		{
			_height = value;
		}

		public function get insetColor():uint
		{
			return _insetColor;
		}

		public function set insetColor(value:uint):void
		{
			_insetColor = value;
		}

		public function get insetColorAlpha():Number
		{
			return _insetColorAlpha;
		}

		public function set insetColorAlpha(value:Number):void
		{
			_insetColorAlpha = value;
		}
		
		public function get isPassword():Boolean
		{
			return _isPassword;
		}
		
		public function set isPassword(value:Boolean):void
		{
			_isPassword = value;
		}
		
		public function get length():int
		{
			if(_textField != null)
			{
				return _textField.length;
			}
			return -1;
		}
		
		public function get maxChars():uint
		{
			return _maxChars;
		}
		
		public function set maxChars(value:uint):void
		{
			_maxChars = value;
			if(_textField != null)
			{
				_textField.maxChars = _maxChars;
			}
		}
		
		public function set restrict(value:String):void
		{
			if(value != "")
			{
				isRestricted = true;
			}
			else
			{
				isRestricted = false;
			}
			restrictedChars = value;
			if(_textField != null)
			{
				_textField.restrict = restrictedChars;
			}
		}
		
		public function get selectable():Boolean
		{
			return isSelectable;
		}
		
		public function set selectable(value:Boolean):void
		{
			isSelectable = value;
			if(isBuilt)
			{
				_textField.selectable = isSelectable;
			}
		}
		
		public function get selectedText():String
		{
			if(_textField != null)
			{
				return _textField.selectedText;
			}
			return "";
		}
		
		public function get selectionBeginIndex():int
		{
			if(_textField != null)
			{
				return _textField.selectionBeginIndex;
			}
			return -1;
		}
		
		public function get selectionEndIndex():int
		{
			if(_textField != null)
			{
				return _textField.selectionEndIndex;
			}
			return -1;
		}

		public function get shadowColor():uint
		{
			return _shadowColor;
		}

		public function set shadowColor(value:uint):void
		{
			_shadowColor = value;
		}
		
		public function get text():String
		{
			if(_textField != null)
			{
				return _textField.text;
			}
			return "";
		}
		
		public function set text(value:String):void
		{
			if(_textField != null)
			{
				if(_maxChars > 0)
				{
					if(value.length > _maxChars)
					{
						value = value.substr(0, _maxChars);
					}
				}
				_textField.text = value;
			}
		}
		
		public function get textBG():Shape
		{
			return txtBG;
		}
		
		public function set textBG(value:Shape):void
		{
			txtBG = value;
		}
		
		public function get textColor():uint
		{
			if(_textField != null)
			{
				return _textField.textColor;
			}
			return 0x000000;
		}
		
		public function set textColor(value:uint):void
		{
			if(_textField != null)
			{
				_textField.textColor = value;
			}
		}
		
		public function get textField():TextField
		{
			return _textField;
		}
		
		public function get textFieldPaddingLeft():Number
		{
			return _textFieldPaddingLeft;
		}
		
		public function set textFieldPaddingLeft(value:Number):void
		{
			_textFieldPaddingLeft = value;
		}
		
		public function get textFieldPaddingTop():Number
		{
			return _textFieldPaddingTop;
		}
		
		public function set textFieldPaddingTop(value:Number):void
		{
			_textFieldPaddingTop = value;
		}

		public function get textFormat():TextFormat
		{
			return _textFormat;
		}

		public function set textFormat(value:TextFormat):void
		{
			_textFormat = value;
		}
		
		public function get textHeight():Number
		{
			if(_textField != null)
			{
				return _textField.textHeight;
			}
			return 0;
		}
		
		public function get textWidth():Number
		{
			if(_textField != null)
			{
				return _textField.textWidth;
			}
			return 0;
		}

		public override function get width():Number
		{
			return _width;
		}

		public override function set width(value:Number):void
		{
			_width = value;
		}

	}
}