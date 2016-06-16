package
{
	import com.lpesign.Extension;
	import com.lpesign.KakaoExtension;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import gamescene.TitleScene;
	
	import object.specialItem.ExpPotion;
	
	import scene.SceneManager;
	
	import sound.SoundManager;
	
	import starling.core.Starling;
	
	import user.CurUserData;
	
	import util.EventManager;
	
	[SWF(width="600", height="999", frameRate="60", backgroundColor="#ffffff")]
	public class AniPang extends Sprite
	{
		//하트가 한개 차는 시간
		public static const HEART_TIME : int = 300;
		//하트의 최대 값 (구매 시 MAX 값을 넘어가기도함)
		public static const MAX_HEART : int = 5;
		private var _mainStarling:Starling;

		public static var stageWidth : Number;
		public static var stageHeight : Number;
		//로그 아웃을 알리는 flag
		public static var logOutFlag : Boolean = false;
		//그냥 종료를 알리는 flag
		public static var exitFlag : Boolean = false;
		private static var _heartTimer : Number = HEART_TIME;
		
		private var _prevHeartTimer : int = 0;
		
		public static var prevExpTimer : int = 0;
		
		public static var evnetValue : int;
		public function AniPang()
		{
			super();
			//카카오톡 초기화
			KakaoExtension.instance.init();	
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			
			_mainStarling = new Starling(MainClass, stage);
			_mainStarling.showStats = true;
			
			_mainStarling.start();
			
			addEventListener(flash.events.Event.ACTIVATE, activateListener);
			addEventListener(flash.events.Event.DEACTIVATE, deactivateListener);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_prevHeartTimer = getTimer();
		}
		
		/**
		 * 게임 시작과 동시에 하트의 시간은 계속 차오름
		 */		
		private function onEnterFrame(event:Event):void
		{
			evnetValue = EventManager.timeEventcheck();
				
			if(ExpPotion.expPotionFlag == true)
			{
				var curExptTimer : int = getTimer();
				
				if(curExptTimer - prevExpTimer > 1000)
				{
					ExpPotion.remainSec--;
					prevExpTimer = getTimer();
				}
				
				if(ExpPotion.remainSec <= 0)
				{
					ExpPotion.expPotionStop();
				}
			}
			
			var curHeartTimer : int = getTimer();
			if(CurUserData.instance.userData.heart >= MAX_HEART) return;
				
			if(curHeartTimer - _prevHeartTimer > 1000)
			{
				_heartTimer--;
				_prevHeartTimer = getTimer();
				
				if(_heartTimer == 0)
				{
					CurUserData.instance.userData.heart++;
					_heartTimer = HEART_TIME;		
				}
			}
		}
		
		private function deactivateListener(event:flash.events.Event):void
		{
			if(TitleScene.sTitleViewLoadFlag == true)
			{
				SoundManager.getInstance().stopLoopedPlaying();
				if(logOutFlag == true)
				{
					Extension.instance.toast("로그 아웃이 성공적으로 되었습니다");
					logOutFlag = false;
				}
				//로그아웃이 아닐 경우  하트가 다차면 푸시메세지 전달
				else
				{
					//종료 할 때의 하트 수와 Max 값의 차이를 계산하여 하트가 꽉 차는 시간을 구함
					var pushTimer : int = ((MAX_HEART - CurUserData.instance.userData.heart)*HEART_TIME - (HEART_TIME - _heartTimer)) * 1000;
					//종료 시간을 구함
					var exitTime : Date = new Date();
					CurUserData.instance.userData.exitTime = exitTime.toString();
					//카톡의 필드의 개수가 5개가 Max인 것을 해결 하기 위해 한 필드에 Json을 저장 하여 여러개의 데이터를 저장 하도록 구현
					//유저의 일반 데이터 저장
					var itemDataJson : String = "{" + "\"gold\":" + String(CurUserData.instance.userData.gold) + ",\"star\":" +  String(CurUserData.instance.userData.totalStar) +
												",\"heart\":" + String(CurUserData.instance.userData.heart) + ",\"hearttime\":" + String(AniPang.heartTimer) + 
												",\"backGoundSound\":" + "\"" + CurUserData.instance.userData.backGoundSound + "\"" +
												",\"effectSound\":" + "\"" + CurUserData.instance.userData.effectSound + "\"" + 
												",\"permitPush\":" + "\"" + CurUserData.instance.userData.permitPush + "\"" + 
												",\"attendCnt\":" + CurUserData.instance.userData.attendCnt + 
												",\"startTimeExpPotion\":" + "\"" + CurUserData.instance.userData.startTimeExpPotion + "\"" +  "}";
					
					//유저의 일일 미션 데이터 저장
					var missonDataJson : String = "{" + "\"today_GameCount\":" + String(CurUserData.instance.userData.today_GameCount) + 
						",\"today_MaxScore\":" +  String(CurUserData.instance.userData.today_MaxScore) +",\"today_UseItemCount\":" + String(CurUserData.instance.userData.today_UseItemCount) + 
						",\"today_CompleteString\":" + "\"" + CurUserData.instance.userData.today_CompleteString + "\"" + "}";
					
					//카톡 서버의 데이터 저장
					KakaoExtension.instance.saveUserData(itemDataJson, missonDataJson, CurUserData.instance.userData.exitTime);
					//위에서 계산한 타이머가 0이 아니고 유저가 환경 설정에서 푸시를 허락 했으면 푸시 예약
					if(pushTimer > 0 && CurUserData.instance.userData.permitPush == "ON")
						Extension.instance.push("애니팡", "하트가 가득 찾어요~ 어서와서 하트를 써주세요~", pushTimer, true);
				}
				Starling.current.stop(true);
			}
		}
		
		/**
		 * 게임이 실행 됫을 경우
		 */		
		private function activateListener(event:flash.events.Event):void
		{
			//스탈링이 멈춰 있을 경우 스탈링 재시작
			if(Starling.current.isStarted == false)
				Starling.current.start();
			//타이틀 로딩을 완료 했을 경우  배경음 시작, 유저데이터 초기화
			if(TitleScene.sTitleViewLoadFlag == true)
			{
				SoundManager.getInstance().playLoopedPlaying();
				CurUserData.instance.initData(false, true);
				//메모리핵 프로그램이 있는지 검사 합니다
				//존재 한다면 프로그램을 강제 종료 합니다.
				Extension.instance.noCheat();
			}
			//로컬 푸시알람 중지
			if(CurUserData.instance.userData.permitPush == true)
				Extension.instance.push("애니팡", "하트가 가득 찾어요~ 어서와서 하트를 써주세요~", 0, false);
		
			//로그아웃, 게임종료 되었을 경우
			if((KakaoExtension.instance.loginState() == "LOGIN_OFF" || exitFlag == true) && TitleScene.sTitleViewLoadFlag == true)
			{
				//게임이 종료 되었거나 로그 아웃 됫을 경우 다시 키면 재실행
				var titleView : TitleScene = new TitleScene();
				SceneManager.instance.addScene(titleView);
				SceneManager.instance.sceneChange();
				exitFlag = false;
			}
		}
		
		/** 
		 * 하트 타임이 0 이 될 경우 하트의 개수를 증가
		 */		
		private function checkTimer():void
		{
			if(_heartTimer == 0)
			{
				CurUserData.instance.userData.heart++;
				_heartTimer = HEART_TIME;
			}
		}
		public static function get heartTimer():Number{return _heartTimer;}
		public static function set heartTimer(value:Number):void{_heartTimer = value;}
	}
}