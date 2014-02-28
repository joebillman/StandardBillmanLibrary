package com.joebillman.controls
{
	import flash.display.DisplayObject;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Matrix;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class RadioButton extends Sprite
	{
		private var _disabledAlpha:Number;
		private var _enabled:Boolean;
		private var _fillColor:uint;
		private var _group:RadioButtonGroup;
		private var _groupName:String;
		private var _height:Number;
		private var _insetAColor:uint;
		private var _insetBColor:uint;
		private var _label:String;
		private var _labelColor:uint;
		private var _labelPaddingLeft:Number;
		private var _labelPaddingTop:Number;
		private var _labelTxtFmt:TextFormat;
		private var _selected:Boolean;
		private var _selectedDotColor:uint;
		private var _strokeColor:Array;
		private var _strokeOverColor:Array;
		private var _value:Object;
		private var centerDrawPoint:Number;
		private var curGraphics:Graphics;
		private var curRadius:Number;
		private var defaultBuild:Boolean;
		private var fill:Shape;
		private var glass:Shape;
		private var glassAlpha:Array;
		private var gradientMatrix:Matrix;
		private var insetA:Shape;
		private var insetB:Shape;
		private var invisibleBtn:Sprite;
		private var isBuilt:Boolean;
		private var lableBtn:Sprite;
		private var labelTxtField:TextField;
		private var selectedDot:Shape;
		private var stroke:Shape;
		private var strokeOutColor:Array;
		
		
		public function RadioButton(label:String="Label", buildDefault:Boolean=true)
		{
			_label = label;
			defaultBuild = buildDefault;
			_init();
		}
		
		private function _init():void
		{
			_disabledAlpha = .45;
			_enabled = true;
			_fillColor = 0x444444;
			_height = 17;
			_insetAColor = 0x777777;
			_insetBColor = 0x111111;
			_labelColor = 0xEEEEEE;
			_labelPaddingLeft = 8;
			_labelPaddingTop = -1;
			_selected = false;
			_selectedDotColor = 0xF5CA30;
			_strokeColor = [0xDDDDDD, 0x333333];
			strokeOutColor = _strokeColor;
			_strokeOverColor = [0xFFE733, 0xE5BD2D];
			centerDrawPoint = _height/2;
			glassAlpha = [.75, .4, 0, .25];
			gradientMatrix = new Matrix();
			isBuilt = false;
			_labelTxtFmt = new TextFormat("_sans", 13, _labelColor, true);
			if(defaultBuild)
			{
				build();
			}
		}
		
		private function buildInvisibleBtn():void
		{
			invisibleBtn = new Sprite();
			curGraphics = invisibleBtn.graphics;
			curGraphics.beginFill(0x00FF00, 0);
			curGraphics.drawRect(0, 0, this.width, _height);
			curGraphics.endFill();
			invisibleBtn.buttonMode = true;
			invisibleBtn.mouseChildren = false;
			addChild(invisibleBtn);
		}
		
		private function buildLabel():void
		{
			labelTxtField = new TextField();
			labelTxtField.autoSize = TextFieldAutoSize.LEFT;
			labelTxtField.defaultTextFormat = _labelTxtFmt;
			labelTxtField.selectable = false;
			labelTxtField.text = _label;
			labelTxtField.x = _height+_labelPaddingLeft;
			labelTxtField.y += _labelPaddingTop;
			addChild(labelTxtField);
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
		
		private function configForMouse():void
		{
			invisibleBtn.mouseChildren = false;
			invisibleBtn.addEventListener(MouseEvent.CLICK, handleClick, false, 0, true);
			invisibleBtn.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown, false, 0, true);
			invisibleBtn.addEventListener(MouseEvent.MOUSE_OUT, handleMouseOut, false, 0, true);
			invisibleBtn.addEventListener(MouseEvent.MOUSE_OVER, handleMouseOver, false, 0, true);
		}
		
		private function draw():void
		{
			drawInset();
			drawStroke();
			drawFill();
			drawDot();
			drawGlass();
			if(!isBuilt)
			{
				buildLabel();
				buildInvisibleBtn();
			}
		}
		
		private function drawDot():void
		{
			erase(selectedDot);
			curRadius = centerDrawPoint-6;
			selectedDot = new Shape();
			curGraphics = selectedDot.graphics;
			curGraphics.beginFill(_selectedDotColor);
			curGraphics.drawCircle(centerDrawPoint, centerDrawPoint, curRadius);
			curGraphics.endFill();
			if(_selected)
			{
				selectedDot.visible = true;
			}
			else
			{
				selectedDot.visible = false;
			}
			addChild(selectedDot);
		}
		
		private function drawFill():void
		{
			erase(fill);
			curRadius = centerDrawPoint-3;
			fill = new Shape();
			curGraphics = fill.graphics;
			curGraphics.beginFill(_fillColor);
			curGraphics.drawCircle(centerDrawPoint, centerDrawPoint, curRadius);
			curGraphics.endFill();
			addChild(fill);
		}
		
		private function drawGlass():void
		{
			erase(glass);
			curRadius = centerDrawPoint-3;
			glass = new Shape();
			gradientMatrix.createGradientBox(_height, _height, 90*(Math.PI/180));
			curGraphics = glass.graphics;
			curGraphics.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0xFFFFFF, 0xFFFFFF, 0xFFFFFF], glassAlpha, [0, 127, 128, 255], gradientMatrix);
			curGraphics.drawCircle(centerDrawPoint, centerDrawPoint, curRadius);
			curGraphics.endFill();
			addChild(glass);
		}
		
		private function drawInset():void
		{
			erase(insetA);
			curRadius = centerDrawPoint;
			insetA = new Shape();
			curGraphics = insetA.graphics;
			curGraphics.beginFill(_insetAColor);
			curGraphics.drawCircle(centerDrawPoint, centerDrawPoint, curRadius);
			curGraphics.endFill();
			addChild(insetA);
			curRadius = centerDrawPoint-1;
			erase(insetB);
			insetB = new Shape();
			curGraphics = insetB.graphics;
			curGraphics.beginFill(_insetBColor);
			curGraphics.drawCircle(centerDrawPoint, centerDrawPoint, curRadius);
			curGraphics.endFill();
			addChild(insetB);
		}
		
		private function drawStroke():void
		{
			erase(stroke);
			curRadius = centerDrawPoint-2;
			stroke = new Shape();
			gradientMatrix.createGradientBox(_height, _height, 90*(Math.PI/180));
			curGraphics = stroke.graphics;
			curGraphics.beginGradientFill(GradientType.LINEAR, _strokeColor, [1, 1], [0, 255], gradientMatrix);
			curGraphics.drawCircle(centerDrawPoint, centerDrawPoint, curRadius);
			curGraphics.endFill();
			addChild(stroke);
		}
		
		private function handleClick(evt:MouseEvent):void
		{
			stage.focus = this;
			if(!_selected)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
		}
		
		private function handleMouseDown(evt:MouseEvent):void
		{
			glassAlpha = [.65, .3, 0, .5];
			draw();
		}
		
		private function handleMouseOut(evt:MouseEvent):void
		{
			glassAlpha = [.75, .4, 0, .25];
			_strokeColor = strokeOutColor;
			draw();
		}
		
		private function handleMouseOver(evt:MouseEvent):void
		{
			glassAlpha = [.85, .5, 0, .45];
			_strokeColor = _strokeOverColor;
			draw();
		}
		
		internal function setSelection(value:Boolean):void
		{
			_selected = value;
			if(selectedDot != null && _selected)
			{
				selectedDot.visible = true;
			}
			else if(selectedDot != null && !_selected)
			{
				selectedDot.visible = false;
			}
		}
		
		//
		public function build():void
		{
			draw();
			configForMouse();
			isBuilt = true;
		}
		
		public function cleanup():void
		{
			_strokeColor = null;
			_strokeOverColor = null;
			strokeOutColor = null;
			glassAlpha = null;
			if(insetA != null)
			{
				if(contains(insetA))
				{
					removeChild(insetA);
				}
				insetA = null;
			}
			if(insetB != null)
			{
				if(contains(insetB))
				{
					removeChild(insetB);
				}
				insetB = null;
			}
			if(stroke != null)
			{
				if(contains(stroke))
				{
					removeChild(stroke);
				}
				stroke = null;
			}
			if(fill != null)
			{
				if(contains(fill))
				{
					removeChild(fill);
				}
				fill = null;
			}
			if(selectedDot != null)
			{
				if(contains(selectedDot))
				{
					removeChild(selectedDot);
				}
				selectedDot = null;
			}
			if(glass != null)
			{
				if(contains(glass))
				{
					removeChild(glass);
				}
				glass = null;
			}
			if(labelTxtField != null)
			{
				if(contains(labelTxtField))
				{
					removeChild(labelTxtField);
				}
				labelTxtField = null;
			}
			if(_labelTxtFmt != null)
			{
				_labelTxtFmt = null;
			}
			if(invisibleBtn != null)
			{
				invisibleBtn.removeEventListener(MouseEvent.CLICK, handleClick);
				invisibleBtn.removeEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
				invisibleBtn.removeEventListener(MouseEvent.MOUSE_OUT, handleMouseOut);
				invisibleBtn.removeEventListener(MouseEvent.MOUSE_OVER, handleMouseOver);
				if(contains(invisibleBtn))
				{
					removeChild(invisibleBtn);
				}
				invisibleBtn = null;
			}
			if(curGraphics != null)
			{
				curGraphics = null;
			}
			if(gradientMatrix != null)
			{
				gradientMatrix = null;
			}
			if(_value != null)
			{
				_value = null;
			}
			if(_group != null)
			{
				_group = null;
			}
		}
		
		public function redraw():void
		{
			draw();
		}

		//
		public function get disabledAlpha():Number
		{
			return _disabledAlpha;
		}
		
		public function set disabledAlpha(value:Number):void
		{
			_disabledAlpha = value;
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
				invisibleBtn.mouseEnabled = true;
			}
			else
			{
				alpha = _disabledAlpha;
				invisibleBtn.mouseEnabled = false;
			}
		}
		
		public function get fillColor():uint
		{
			return _fillColor;
		}

		public function set fillColor(value:uint):void
		{
			_fillColor = value;
		}
		
		public function get group():RadioButtonGroup
		{
			return _group;
		}
		
		public function set group(value:RadioButtonGroup):void
		{
			_group = value;
		}
		
		public function get groupName():String
		{
			return _groupName;
		}
		
		public function set groupName(value:String):void
		{
			_groupName = value;
		}
		
		public override function get height():Number
		{
			return _height;
		}
		
		public override function set height(value:Number):void
		{
			_height = value;
		}

		public function get insetAColor():uint
		{
			return _insetAColor;
		}

		public function set insetAColor(value:uint):void
		{
			_insetAColor = value;
		}

		public function get insetBColor():uint
		{
			return _insetBColor;
		}

		public function set insetBColor(value:uint):void
		{
			_insetBColor = value;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
			if(isBuilt)
			{
				labelTxtField.text = _label;
			}
		}

		public function get labelColor():uint
		{
			return _labelColor;
		}

		public function set labelColor(value:uint):void
		{
			_labelColor = value;
			if(isBuilt)
			{
				labelTxtField.textColor = _labelColor;
			}
		}

		public function get labelPaddingLeft():Number
		{
			return _labelPaddingLeft;
		}

		public function set labelPaddingLeft(value:Number):void
		{
			_labelPaddingLeft = value;
		}
		
		public function get labelPaddingTop():Number
		{
			return _labelPaddingTop;
		}
		
		public function set labelPaddingTop(value:Number):void
		{
			_labelPaddingTop = value;
		}
		
		public function get labelTextFormat():TextFormat
		{
			return _labelTxtFmt;
		}
		
		public function set labelTextFormat(value:TextFormat):void
		{
			_labelTxtFmt = value;
		}
		
		public function get selected():Boolean
		{
			return _selected;
		}
		
		public function set selected(value:Boolean):void
		{
			if(_selected != value && _group != null)
			{
				dispatchEvent(new Event(Event.CHANGE));
			}
			else if(_selected != value && _group == null)
			{
				_selected = value;
			}
		}

		public function get selectedDotColor():uint
		{
			return _selectedDotColor;
		}

		public function set selectedDotColor(value:uint):void
		{
			_selectedDotColor = value;
		}

		public function get strokeColor():Array
		{
			return _strokeColor;
		}

		public function set strokeColor(value:Array):void
		{
			_strokeColor = value;
		}

		public function get strokeOverColor():Array
		{
			return _strokeOverColor;
		}

		public function set strokeOverColor(value:Array):void
		{
			_strokeOverColor = value;
		}

		public function get value():Object
		{
			return _value;
		}
		
		public function set value(value:Object):void
		{
			_value = value;
		}

	}
}