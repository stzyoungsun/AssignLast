package com.lpesign
{
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	/**
	 * Air Native Extension 
	 */
	public class Extension extends EventDispatcher
	{
		private var _context:ExtensionContext;
		private var _drawSprite : Function;

		public function Extension(drawSprite:Function = null)
		{
			_drawSprite = drawSprite;
			
			try
			{
				if(!_context) _context = ExtensionContext.createExtensionContext("com.lpesign.Extension", null);
				if(_context) _context.addEventListener(StatusEvent.STATUS,statusHandle);
			} 
			catch(e:Error) 
			{
				trace(e.message);
			}
		}
		
		public function statusHandle(event:StatusEvent):void
		{
			if((event.level as String) == "INPUT_ID")
			{
				dispatchEvent(new StatusEvent("INPUT_ID", false, false, event.code, event.level));
			}
			else if((event.level as String) == "eventCode")
			{
				_drawSprite(event.level as String);
			}
		}
		
		public function toast(message:String):void
		{
			_context.call("toast",message);
		}
		
		public function exitDialog(clickedFlag:Boolean):void
		{
			_context.call("exitdialog",clickedFlag);
		}
				
		public function listDialog(arrPngName:Array) : void
		{
			_context.call("listdialog",arrPngName);
		}
		
		public function spriteActivity(spriteSheet:BitmapData) : void
		{
			_context.call("spritesheet",spriteSheet);
		}
		
		public function push(icon : BitmapData, title:String, message : String, time:int, alarmFlag : Boolean):void
		{
			_context.call("push",icon, title,message,time,alarmFlag);
		}
		
		public function inputID():void
		{
			_context.call("input");
		}
		
		public function login():void
		{
			_context.call("login");
		}
	}
}