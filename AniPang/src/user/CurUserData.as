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
	
	import starling.events.EventDispatcher;
	import starling.textures.Texture;

	/**
	 * 현재 접속 한 유저의 서버 데이터 입니다
	 */
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
		
		private var _userData : UserDataFormat = new UserDataFormat();
		
		//최고 점수만  재 갱신
		private var _scoreFlag : Boolean;
		//유저 데이터만 갱신
		private var _userDataFlag : Boolean;
		public function initData(scoreFlag : Boolean = false, userDataFlag : Boolean = false) : void
		{
			
			_scoreFlag = scoreFlag;
			_userDataFlag = userDataFlag;
			//카톡 서버에서 데이터를 무사히 불러왔을 경우 GET_USERDATA 이벤트 발생
			KakaoExtension.instance.addEventListener("GET_USERDATA", onGetUserData);
			KakaoExtension.instance.curUserData();
		}
		
		/**
		 * GET_USERDATA 이벤트 발생 하면 서버에서 받은 데이터 저장
		 */		
		protected function onGetUserData(event:StatusEvent):void
		{
			var extension:Array = event.code.split('$');
		
			_userData.id = extension[0];
			_userData.name = extension[1];
			_userData.profilePath = extension[2];
			_userData.curMaxScore = extension[3];
			
			//최고 점수만  재 갱신
			if(_scoreFlag == true) return;
			
			//커스텀 필드의 개수의 제한으로 사용자  관련 데이터는 묶어서 JSON으로 전송
			if(extension[4] == "null")
			{
				_userData.gold = 2000;
				_userData.totalStar = 0;
				_userData.heart = AniPang.MAX_HEART;
				AniPang.heartTimer = AniPang.HEART_TIME;
				_userData.backGoundSound = "ON";
				_userData.effectSound = "ON";
				_userData.permitPush = "ON";
				_userData.attendCnt = 0;
				_userData.startTimeExpPotion = "null";
			}
			
			else
			{
				var userItemData : Object = json.JSON.decode(extension[4]);
				
				_userData.gold = userItemData.gold;
				_userData.totalStar = userItemData.star;
				_userData.heart = userItemData.heart;
				AniPang.heartTimer = userItemData.hearttime
				_userData.backGoundSound = userItemData.backGoundSound;
				_userData.effectSound = userItemData.effectSound;
				_userData.permitPush = userItemData.permitPush;
				_userData.attendCnt = userItemData.attendCnt;
				userData.startTimeExpPotion = userItemData.startTimeExpPotion;
			}
			//유저 종료 시간
			_userData.exitTime = extension[6];
			
			//종료 시간과 현재 접속 시간의 차이를 이용하여 하루가 지났을 경우 일일 미션 데이터 초기화
			if(initMisson() == true) extension[5] = "null"
			//서버에 있는 일일 미션 데이터를 현재 유저 데이터에 저장
			if(extension[5] == "null")
			{
				_userData.today_GameCount = 0;
				_userData.today_MaxScore = 0;
				_userData.today_UseItemCount = 0;
				_userData.today_CompleteString = "XXXXXXXXXX";
				_userData.today_CompleteCount = 0;
			}
				
			else
			{
				var todayMisson : Object = json.JSON.decode(extension[5]);
				
				_userData.today_GameCount = todayMisson.today_GameCount;
				_userData.today_MaxScore = todayMisson.today_MaxScore;
				_userData.today_UseItemCount = todayMisson.today_UseItemCount;
				_userData.today_CompleteString = todayMisson.today_CompleteString;
				_userData.today_CompleteCount = 0;
				
				if(CurUserData.instance.userData.today_CompleteString == "Complete") 
				{
					_userData.today_CompleteCount = 10;
				}
				
				else
				{
					for(var i : int =0; i < _userData.today_CompleteString.length; i++)
					{
						if(_userData.today_CompleteString.charAt(i) == "O")
							_userData.today_CompleteCount++;
					}
				}
				
			}
			
			calcHeart();
			
			if(_userDataFlag == true) return;
			
			//이름이 없을 경우 익명처리
			if(_userData.name == "null" || _userData.name == null || _userData.name == "")
				_userData.name = "익명";
			
			//프로필 사진이 없을 경우 대체 사진으로 대체
			if(_userData.profilePath == "null" || _userData.profilePath == null || _userData.profilePath == "")
			{
				_userData.profileTexture = TextureManager.getInstance().textureDictionary["notProfile.png"];
				dispatchEvent((new starling.events.Event("PROFILE_LOAD_OK")));
			}
			
			else
			{
				var imageLoader:Loader = new Loader();
				imageLoader.load(new URLRequest(_userData.profilePath));
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImageComplete);	
			}
			
		}
		
		/**
		 * 현재 시간과 유저의 최종 종료 시간의 날짜가 다르면 return true
		 */		
		private function initMisson():Boolean
		{
			var curDate : Date = new Date();
			var prevDate : Date = new Date(_userData.exitTime);
			
			if(curDate.date != prevDate.date) 
			{
				curDate = null;
				prevDate = null;
				return true;
			}
			
			else
			{
				curDate = null;
				prevDate = null;
				return false;
			}
		}
		
		/**
		 *  데일리 미션을 초기화 합니다
		 */		
		public function initMission() : void
		{
			_userData.today_CompleteCount = 0;
			_userData.today_GameCount = 0;
			_userData.today_MaxScore = 0;
			_userData.today_UseItemCount = 0;
			_userData.today_CompleteString = "XXXXXXXXXX";
		}
		
		/**
		 *  종료 후 접속 시 시간 계산을 통해 하트 개수 설정
		 */		
		private function calcHeart():void
		{
			if(_userData.heart > AniPang.MAX_HEART) return;
			
			var curDate : Date = new Date();
			var prevDate : Date = new Date(_userData.exitTime);
			
			//종료 후 재접 속까지 시간 계산
			var inActiveTerm : int = (curDate.getTime() - prevDate.getTime())/1000;
			
			_userData.heart += inActiveTerm/AniPang.HEART_TIME;
			AniPang.heartTimer -= inActiveTerm%AniPang.HEART_TIME;
			
			if(AniPang.heartTimer < 0)
			{
				_userData.heart++;
				AniPang.heartTimer = AniPang.HEART_TIME + AniPang.heartTimer;
			}
			
			if(_userData.heart > AniPang.MAX_HEART)
			{
				_userData.heart = AniPang.MAX_HEART;
				AniPang.heartTimer = AniPang.HEART_TIME;
			}
			
			curDate = null;
			prevDate = null;
		}
		
		protected function onLoadImageComplete(event:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(event.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadImageComplete);
			
			var bitmap:Bitmap = event.target.content as Bitmap;
			_userData.profileTexture = Texture.fromBitmapData(bitmap.bitmapData);
			
			bitmap = null;
			loaderInfo = null;
			
			dispatchEvent((new starling.events.Event("PROFILE_LOAD_OK")));
		}		
		
		public function get userData():UserDataFormat{return _userData;}
	}
}