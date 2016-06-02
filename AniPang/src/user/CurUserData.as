package user
{
	import com.lpesign.KakaoExtension;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import starling.events.EventDispatcher;
	import starling.textures.Texture;

	public class CurUserData extends EventDispatcher
	{
		private static var _instance : CurUserData;
		private static var _constructed : Boolean;
		
		public function CurUserData()
		{
			if (!_constructed) throw new Error("Singleton, use Scene.instance");
		}

		public static function get instance():CurUserData
		{
			if (_instance == null)
			{
				_constructed = true;
				_instance = new CurUserData();
				_constructed = false;
			}
			return _instance;
		}
		
		private var _id : int = 0;
		private var _name : String = "";
		private var _profilePath : String = "";
		private var _curMaxScore : int = 0;
		private var _profileTexture : Texture;
		
		private var _scoreFlag : Boolean;
		public function initData(scoreFlag : Boolean = false) : void
		{
			_scoreFlag = scoreFlag;
			KakaoExtension.instance.addEventListener("GET_USERDATA", onGetUserData);
			KakaoExtension.instance.curUserData();
		}
		
		protected function onGetUserData(event:StatusEvent):void
		{
			// TODO Auto-generated method stub
			
			var extension:Array = event.code.split('$');
			
			_id = extension[0];
			_name = extension[1];
			_profilePath = extension[2];
			_curMaxScore = extension[3];
			
			if(_scoreFlag == true) return;
			
			if(_name == "null" || _name == null || _name == "")
				_name = "익명";
			
			if(_profilePath == "null" || _profilePath == null || _profilePath == "")
			{
				_profileTexture = null
				dispatchEvent((new starling.events.Event("PROFILE_LOAD_OK")));
			}
			else
			{
				var imageLoader:Loader = new Loader();
				imageLoader.load(new URLRequest(_profilePath));
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImageComplete);	
			}
		}
		
		protected function onLoadImageComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadImageComplete);
			
			var bitmap:Bitmap = event.target.content as Bitmap;
			_profileTexture = Texture.fromBitmapData(bitmap.bitmapData);
			
			bitmap = null;
			loaderInfo = null;
			
			dispatchEvent((new starling.events.Event("PROFILE_LOAD_OK")));
		}		
		
		public function get profileTexture():Texture{return _profileTexture;}
		
		public function get name():String{return _name;}
		
		public function get id():int{return _id;}
		
		public function get curMaxScore():int{return _curMaxScore;}
	}
}