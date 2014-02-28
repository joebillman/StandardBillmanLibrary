/* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
*
* //AUTHOR:
*   Joe Billman - Software Engineer
*
*
* //DATE: 
*   July 2010
*
*
* //COPYRIGHT: 
*  
* 
* 
* //REVISION NOTES:
*   none currently
*
*
* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */
package com.joebillman.fx
{
	//IMPORTS:__________________________________________________________________________________________________
	//------------------------------------------------<IMPORTS>-----------------------------------------------//
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.PixelSnapping;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	
	/**
	* Reflection: This class dynamically creates a reflection for the display object that it is passed
	*
	* @example The following example creates
	* <listing version="3.0" >
	*
	* </listing>
	*
	*	@author Joe Billman
	*/
	public class ReflectionBitmap extends Sprite
	{
		
		//VARIABLES:________________________________________________________________________________________________
		//-----------------------------------------<VARIABLE MEMBERS>---------------------------------------------//
		//Private:
		//Simple
		private var _maskHeight:Number;		// Height of mask
		private var _maskPaddingX:Number;	// Side padding of the reflection
		private var _maskPaddingY:Number;	// Bottom padding between object and reflection
		//Complex
		private var _filters:Array;			// Array that contains filtes
		private var _spread:Array;			// Array that represents the spread of the gradient
		private var _transparency:Array;	// Array that represents the transparency of the gradient
		private var bitmap:Bitmap;			// Bitmap representation of the object
		private var matrix:Matrix;			// Matrix used in creating the linear gradient
		private var bitmapMask:Shape;		// Mask used on the bitmap
		private var container:Sprite;
		
		//CONSTRUCTOR:______________________________________________________________________________________________
		//----------------------------------------<CONSTRUCTOR Method>--------------------------------------------//
		/**
		 * 
		 * @param		target	Display object of which to make a reflection
		 * @default		
		 */
		public function ReflectionBitmap(target:BitmapData, targetW:Number, targetH:Number)
		{
			bitmap = new Bitmap(target, PixelSnapping.AUTO, true);
			bitmap.width = targetW;
			bitmap.height = targetH;
			bitmap.cacheAsBitmap = true;
			container = new Sprite();
			container.addChild(bitmap);
			_init();
		}
		
		//PRIVATE:______________________________________________________________________________________________
		//----------------------------------------<PRIVATE Methods>--------------------------------------------//
		/**
		 * Initializes variables and calls the two functions needed to build the reflection 
		 * 
		 */		
		private function _init():void
		{
			_maskHeight = bitmap.height/2;
			_maskPaddingX = 0;
			_maskPaddingY = 0;
			_filters = [new BlurFilter()];
			_spread = [0, 127, 255];
			_transparency = [.75, .55, 0];
			matrix = new Matrix();
		}
		
		/**
		 * Creates the bitmap and positions it 
		 * 
		 */
		private function buildBitmap():void
		{
			container.scaleY = -1;
			container.x += _maskPaddingX;
			container.y += container.height*2 + _maskPaddingY;
			container.filters = _filters;
			container.cacheAsBitmap = true;
			container.mask = bitmapMask;
			addChild(container);
		}
		
		/**
		 * Creates the mask and positions it 
		 * 
		 */
		private function buildMask():void
		{
			var gr:Graphics;
			matrix.createGradientBox(bitmap.width, _maskHeight, 90*(Math.PI/180));
			bitmapMask = new Shape();
			gr = bitmapMask.graphics;
			gr.clear();
			gr.beginGradientFill(GradientType.LINEAR, [0xFFFFFF, 0x666666, 0x000000], _transparency, _spread, matrix);
			gr.drawRect(0, 0, bitmap.width, _maskHeight);
			gr.endFill();
			bitmapMask.x = bitmap.x + _maskPaddingX;
			bitmapMask.y = bitmap.y + bitmap.height + _maskPaddingY;
			bitmapMask.cacheAsBitmap = true;
			addChild(bitmapMask);
		}
		
		//PUBLIC:______________________________________________________________________________________________
		//----------------------------------------<PUBLIC Methods>--------------------------------------------//
		/**
		 * Removes the mask and bitmap and marks them for deletion via the garbage collector 
		 * 
		 */
		public function cleanUp():void
		{
			removeChild(bitmapMask);
			bitmapMask = null;
		}
		/**
		 * Calls the two functions that build the reflection
		 * 
		 */
		public function drawReflection():void
		{
			buildMask();
			buildBitmap();
		}
		
		//GETTER / SETTER:__________________________________________________________________________________________
		//------------------------------------------<GETTER / SETTER Methods>---------------------------------------------//
		/**
		 * Sets the height of the mask
		 * @param		val		A Number value for the mask height.
		 * @default		target.height/2
		 * @return		void
		 */
		public function set maskHeight(val:Number):void
		{
			_maskHeight = val;
		}
		
		/**
		 * Sets the horizontal padding of the mask. Most useful for text
		 * @param		val		A Number value for the mask padding.
		 * @default		0
		 * @return		void
		 */
		public function set maskPaddingX(val:Number):void
		{
			_maskPaddingX = val;
		}
		
		/**
		 * Sets the vertical padding of the mask
		 * @param		val		A Number value for the mask padding.
		 * @default		0
		 * @return		void
		 */
		public function set maskPaddingY(val:Number):void
		{
			_maskPaddingY = val;
		}

		/**
		 * Sets the spread array for the mask gradient
		 * @param		val		An Array value for the spread of the mask gradient.
		 * @default		[0, 127, 255]
		 * @return		void
		 */
		public function set spread(val:Array):void
		{
			_spread = val;
		}
		
		/**
		 * Sets the filters array reflection
		 * @param		val		An Array value for the filters.
		 * @default		[]
		 * @return		void
		 */
		public override function set filters(val:Array):void
		{
			_filters = val;
		}

		/**
		 * Sets the transparency array for the mask gradient
		 * @param		val		An Array value for the transparency of the mask gradient.
		 * @default		[.75, .55, 0]
		 * @return		void
		 */
		public function set transparency(val:Array):void
		{
			_transparency = val;
		}
		
	}
}