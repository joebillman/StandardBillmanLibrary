package com.joebillman.controls
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class RadioButtonGroup extends EventDispatcher
	{
		private var _name:String;
		private var _numRadioButtons:uint;
		private var _selectedData:Object;
		private var _selection:RadioButton;
		private var radioBtns:Vector.<RadioButton>;
		
		
		public function RadioButtonGroup()
		{
			_init();
		}
		
		private function _init():void
		{
			_name = "RadioButtonGroup";
			radioBtns = new Vector.<RadioButton>();	
		}
		
		private function handleChange(evt:Event):void
		{
			var len:uint = radioBtns.length;
			for(var i:uint=0; i<len; i++) 
			{
				if(evt.target == radioBtns[i])
				{
					radioBtns[i].setSelection(true);
					_selectedData = radioBtns[i].value;
					_selection = radioBtns[i];
				}
				else
				{
					radioBtns[i].setSelection(false);
				}
			}
			dispatchEvent(new Event(Event.CHANGE));
		}
		
		//
		public function addRadioButton(radioBtn:RadioButton):void
		{
			radioBtn.group = this;
			radioBtn.groupName = _name;
			radioBtns.push(radioBtn);
			radioBtn.addEventListener(Event.CHANGE, handleChange, false, 0, true);
			if(radioBtn.selected)
			{
				_selection = radioBtn;
			}
		}
		
		public function cleanup():void
		{
			if(_selectedData != null)
			{
				_selectedData = null;
			}
			if(_selection != null)
			{
				_selection = null;
			}
			if(radioBtns != null)
			{
				var len:uint = radioBtns.length;
				for(var i:uint=0; i<len; i++) 
				{
					radioBtns[i].removeEventListener(Event.CHANGE, handleChange);
				}
				radioBtns = null;
			}
		}
		
		public function getRadioButtonAt(index:uint):RadioButton
		{
			return radioBtns[index];
		}

		public function getRadioButtonIndex(radioBtn:RadioButton):int
		{
			var len:uint = radioBtns.length;
			for(var i:uint=0; i<len; i++) 
			{
				if(radioBtn == radioBtns[i])
				{
					return i;
				}
			}
			return -1;
		}
		
		//
		public function get name():String
		{
			return _name;
		}

		public function get numRadioButtons():uint
		{
			_numRadioButtons = radioBtns.length;
			return _numRadioButtons;
		}

		public function get selectedData():Object
		{
			return _selectedData;
		}

		public function set selectedData(value:Object):void
		{
			_selectedData = value;
		}

		public function get selection():RadioButton
		{
			return _selection;
		}

		public function set selection(value:RadioButton):void
		{
			_selection = value;
		}
	}
}