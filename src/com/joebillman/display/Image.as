package com.joebillman.display
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;

	public class Image extends Sprite
	{
		
		private var file:File;
		private var fileName:String;
		private var loader:Loader;
		private var resolution:String;
		
		public function Image(fileName:String, resolution:String)
		{
			this.fileName = fileName;
			this.resolution = resolution;
			_init();
		}
		
		private function _init():void
		{
			load();
		}
		
		private function load():void
		{
			file = File.applicationDirectory.resolvePath("assets/graphics/"+resolution+"/"+fileName);
			if(file.exists)
			{
				var swfBytes:ByteArray = new ByteArray();
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				stream.readBytes(swfBytes);
				stream.close();
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, handleComplete);
				loader.loadBytes(swfBytes);
			}
		}
		
		private function handleComplete(event:Event):void
		{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, handleComplete);
			var bmpData:BitmapData = new BitmapData(loader.content.width, loader.content.height, true, 0xFF00FF);
			bmpData.draw(loader.content);
			var bitmap:Bitmap = new Bitmap(bmpData, "auto", true);
			addChild(bitmap);
		}
		
	}
}