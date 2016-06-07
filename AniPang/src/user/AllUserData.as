package user
{
	import com.lpesign.KakaoExtension;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.StatusEvent;
	import flash.net.URLRequest;
	
	import json.JSON;
	
	import loader.TextureManager;
	
	import starling.events.Event;
	import starling.events.EventDispatcher;
	import starling.textures.Texture;
	
	/**
	 * 게임에 가입 한 모든 유저의 데이터 입니다.
	 */	
	public class AllUserData extends EventDispatcher
	{
		private static var _instance : AllUserData;
		private static var _constructed : Boolean;
		
		public function AllUserData()
		{
			if(!_constructed) throw new Error("Singleton, use ScoreManager.instance");
		}
		
		public static function get instance(): AllUserData
		{
			if(_instance == null)
			{
				_constructed = true;
				_instance = new AllUserData();
				_constructed = false;
			}
			return _instance;
		}
		
		private var _userIDList : Object;
		private var _userData : Vector.<UserDataFormat>;
		private var _userNum : int = 0;
		
		public function initRankData() : void
		{
			_userData  = new Vector.<UserDataFormat>;
			//KakaoExtension.instance.addEventListener("GET_IDLIST", onGetIDList);
			//KakaoExtension.instance.getIDList();
		}
		
		/**
		 * 서버로 부터 유저리스트를 성공적으로 받으면 불려지는 콜백 함수
		 */		
		private function onGetIDList(event:StatusEvent):void
		{
			//KakaoExtension.instance.removeEventListener("GET_IDLIST", onGetIDList);
			_userIDList = json.JSON.decode(event.code);
		
			//KakaoExtension.instance.addEventListener("GET_SERVER_USERDATA", onSeverUserData);
			//KakaoExtension.instance.getServerUserData(_userIDList.elements[_userNum]);
		}
		
		private function onSeverUserData(event:StatusEvent):void
		{
			var tempObject : Object;
			tempObject = json.JSON.decode(event.code);
			_userData.push(new UserDataFormat());
			
			_userData[_userNum].id = tempObject.id;
			
			if(tempObject.properties != null)
			{
				if(tempObject.properties.nickname == null)
					_userData[_userNum].name = "익명";
				else 
					_userData[_userNum].name = tempObject.properties.nickname;
				
				if(tempObject.properties.score == null)
					_userData[_userNum].curMaxScore = 0;
				else
					_userData[_userNum].curMaxScore = tempObject.properties.score;
				
				if(tempObject.properties.profile_image == null)
					_userData[_userNum].profilePath = "";
				else
					_userData[_userNum].profilePath = tempObject.properties.profile_image;
			}
			
			else
			{
				_userData[_userNum].name = "익명";
				_userData[_userNum].curMaxScore = 0;
				_userData[_userNum].profilePath = "";
			}
			addEventListener("PROFILE_LOAD_OK", onProfileLoad);
			//프로필 사진이 없을 경우 대체 사진으로 대체
			if(_userData[_userNum].profilePath == "null" || _userData[_userNum].profilePath == null || _userData[_userNum].profilePath == "")
			{
				_userData[_userNum].profileTexture = TextureManager.getInstance().textureDictionary["notProfile.png"];
				dispatchEvent((new starling.events.Event("PROFILE_LOAD_OK")));
			}
			else
			{
				var imageLoader:Loader = new Loader();
				imageLoader.load(new URLRequest(_userData[_userNum].profilePath));
				imageLoader.contentLoaderInfo.addEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);	
			}
		}
		
		private function onLoadImageComplete(event:flash.events.Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(flash.events.Event.COMPLETE, onLoadImageComplete);
			
			var bitmap:Bitmap = event.target.content as Bitmap;
			_userData[_userNum].profileTexture = Texture.fromBitmapData(bitmap.bitmapData);
			
			bitmap = null;
			loaderInfo = null;
			
			dispatchEvent((new starling.events.Event("PROFILE_LOAD_OK")));
		}	
		
		private function onProfileLoad():void
		{
			if(_userNum == _userIDList.total_count - 1)
			{
				removeEventListener("PROFILE_LOAD_OK", onProfileLoad);
				//KakaoExtension.instance.removeEventListener("GET_SERVER_USERDATA", onSeverUserData);
				
				dispatchEvent((new starling.events.Event("ALL_DATA_LOAD")));
				
				trace("모든 데이터 로드 완료");
				return;
			}
			//KakaoExtension.instance.getServerUserData(_userIDList.elements[++_userNum]);
		}
		
		public function upSort() : void
		{
			_userData.sort(orderAbs);
			
			function orderAbs(userData1 : UserDataFormat, userData2 : UserDataFormat):int		
			{
				if(userData1.curMaxScore > userData2.curMaxScore)
					return -1;
				else if(userData1.curMaxScore < userData2.curMaxScore)
					return 1;
				else
					return 0;	
			}
		}
		
		public function dispose() : void 
		{
			_userIDList = null;
			_userData = null;
			_userNum = 0;
		}
		
		public function get userData():Vector.<UserDataFormat>{return _userData;}
		public function get userCount() : int {return _userIDList.total_count;}
	}
}