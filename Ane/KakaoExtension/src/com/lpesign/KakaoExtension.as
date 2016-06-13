package com.lpesign
{
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;

	/**
	 * Air Native Extension 
	 */
	public class KakaoExtension extends EventDispatcher
	{
		private var _context:ExtensionContext;

		private static var _instance : KakaoExtension;
		private static var _constructed : Boolean;
		
		public function KakaoExtension()
		{
			if (!_constructed) throw new Error("Singleton, use Scene.instance");
			
			try
			{
				_context = ExtensionContext.createExtensionContext("com.lpesign.KakaoExtension", null);
				_context.addEventListener(StatusEvent.STATUS,statusHandle);
			} 
			catch(e:Error) 
			{
				trace(e.message);
			}
		}
		
		public static function get instance():KakaoExtension
		{
			if (_instance == null)
			{
				_constructed = true;
				_instance = new KakaoExtension();
				_constructed = false;
			}
			return _instance;
		}
		
		public function statusHandle(event:StatusEvent):void
		{
			if((event.level as String) == "LOGIN_OK")
			{
				dispatchEvent(new StatusEvent("LOGIN_OK"));
			}
			
			else if((event.level as String) == "LOGOUT_OK")
			{
				dispatchEvent(new StatusEvent("LOGOUT_OK"));
			}
			
			else if((event.level as String) == "GET_USERDATA")
			{
				dispatchEvent(new StatusEvent("GET_USERDATA",false, false, event.code, event.level));
			}
			
			else if((event.level as String) == "SAVE_OK")
			{
				dispatchEvent(new StatusEvent("SAVE_OK"));
			}
			
			else if((event.level as String) == "GET_IDLIST")
			{
				dispatchEvent(new StatusEvent("GET_IDLIST",false, false, event.code, event.level));
			}
			
			else if((event.level as String) == "GET_SERVER_USERDATA")
			{
				dispatchEvent(new StatusEvent("GET_SERVER_USERDATA",false, false, event.code, event.level));
			}
			
			else if((event.level as String) == "SAVE_DATA")
			{
				dispatchEvent(new StatusEvent("SAVE_DATA"));
			}
		}
		
		public function dispose() : void
		{
			_context.removeEventListener(StatusEvent.STATUS,statusHandle);
		}
		public function init():void
		{
			_context.call("init");
		}
		
		public function login():void
		{
			_context.call("login");
		}
		
		public function logout():void
		{
			_context.call("logout");
		}
		
		public function loginState() : String
		{
			return _context.call("loginstate") as String
		}
		
		public function curUserData() : String
		{
			return _context.call("curuserdata") as String
		}
		
		public function saveUserScore(maxScore : String) :void
		{
			_context.call("saveuserscroe", maxScore);
		}
		
		public function saveUserData(itemField : String, missonData : String, exitTime : String) :void
		{
			_context.call("saveuserdata", itemField, missonData, exitTime);
		}
		
		public function getIDList():void
		{
			_context.call("useridlist");
		}
		
		public function getServerUserData(userID : String) :void
		{
			_context.call("getserveruserdata", userID);
		}
	}
}