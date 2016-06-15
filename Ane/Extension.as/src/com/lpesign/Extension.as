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

		private static var _instance : Extension;
		private static var _constructed : Boolean;
		
		public function Extension()
		{
			if (!_constructed) throw new Error("Singleton, use Scene.instance");
			
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
		
		public static function get instance():Extension
		{
			if (_instance == null)
			{
				_constructed = true;
				_instance = new Extension();
				_constructed = false;
			}
			return _instance;
		}
		
		public function statusHandle(event:StatusEvent):void
		{
			if((event.level as String) == "INPUT_ID")
			{
				dispatchEvent(new StatusEvent("INPUT_ID", false, false, event.code, event.level));
			}
		}
		
		public function toast(message:String):void
		{
			_context.call("toast",message);
		}
		
		public function exitDialog():void
		{
			_context.call("exitdialog");
		}
				
		public function listDialog(arrPngName:Array) : void
		{
			_context.call("listdialog",arrPngName);
		}
		
		public function spriteActivity(spriteSheet:BitmapData) : void
		{
			_context.call("spritesheet",spriteSheet);
		}
		
		public function push(title:String, message : String, time:int, alarmFlag : Boolean):void
		{
			_context.call("push", title, message, time, alarmFlag);
		}
		
		public function inputID():void
		{
			_context.call("input");
		}
		
		public function login():void
		{
			_context.call("login");
		}
		
		public function noCheat() : void
		{
			_context.call("nocheat");
		}
	}
}