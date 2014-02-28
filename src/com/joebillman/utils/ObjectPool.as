////////////////////////////////////////////////////////////////////////////////
//  
//  JOE BILLMAN (joebillman.com)
//  Copyright 2012 Joe Billman
//  All Rights Reserved.
//  
//  AUTHORS:
//  Joe Billman
//  
//  CREATION DATE:
//  Aug 4, 2012
//  
//  REVISION NOTES:
//  
////////////////////////////////////////////////////////////////////////////////

package com.joebillman.utils
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	
	/**
	 * ObjectPool: This a useful class for creating objects that will be used over and over. Instantiation only occurs once per object.
	 *
	 *
	 * @example The following example.
	 * <p><strong>Note:</strong> Details</p>
	 * <listing version="3.0" >
	 * var enemyPool:ObjectPool = new ObjectPool(Enemy, 25);</listing>
	 *
	 *
	 */
	public class ObjectPool
	{
		//--------------------------------------------------------------------------
		//
		//  Class variables
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private var count:int;
		private var ObjClass:Class;
		private var stopMCsOnCreation:Boolean;
		private var stopMCsOnDestruction:Boolean;
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		private var objects:Array;
		
		//--------------------------------------------------------------------------
		//
		//  Constructor
		//
		//--------------------------------------------------------------------------
		/**
		 *  Constructor.
		 *
		 */
		public function ObjectPool(type:Class, amount:int, stopMCsOnCreation:Boolean=false, stopMCsOnDestruction:Boolean=false)
		{
			ObjClass = type;
			count = amount;
			this.stopMCsOnCreation = stopMCsOnCreation;
			this.stopMCsOnDestruction = stopMCsOnDestruction;
			_init();
		}
		
		//--------------------------------------------------------------------------
		//
		//  Class methods
		//
		//--------------------------------------------------------------------------
		
		//----------------------------------
		//  Private:
		//----------------------------------
		
		private function _init():void
		{
			objects = new Array(count);
			createPool();
		}
		
		private function createPool():void
		{
			for(var i:int=0; i<count; i++) 
			{
				objects[i] = new ObjClass();
				if(objects[i] is MovieClip && stopMCsOnCreation)
				{
					MovieClip(objects[i]).gotoAndStop(1);
				}
			}
		}
		
		//----------------------------------
		//  Public:
		//----------------------------------
		
		/**
		 * Destroys the objects array by setting it to null. 
		 * 
		 */		
		public function destroy():void
		{
			objects = null;
		}
		
		/**
		 * Gets a reference to the objects array. This is useful for performing individual item cleanup. 
		 * @return 
		 * 
		 */		
		public function getAllObjects():Array
		{
			return objects;
		}
		
		/**
		 * Gets an available item from the pool. 
		 * @return 
		 * 
		 */		
		public function getObject():DisplayObject
		{
			if(count > 0)
			{
				return objects[--count];
			}
			else
			{
				throw new Error("There are currently no objects available.");
			}
		}
		
		/**
		 * Returns an item to the pool. 
		 * @param obj
		 * 
		 */		
		public function returnObject(obj:DisplayObject):void
		{
			if(obj is MovieClip && stopMCsOnDestruction)
			{
				MovieClip(obj).gotoAndStop(1);
			}
			objects[count++] = obj;
		}
		
	}
}