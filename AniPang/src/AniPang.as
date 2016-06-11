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
	
	import scene.SceneManager;
	
	import starling.core.Starling;
	
	import user.CurUserData;
	
	[SWF(width="600", height="999", frameRate="60", backgroundColor="#ffffff")]
	public class AniPang extends Sprite
	{
		public static const HEART_TIME : int = 300;
		public static const MAX_HEART : int = 5;
		private var _mainStarling:Starling;

		public static var stageWidth : Number;
		public static var stageHeight : Number;
		public static var logOutFlag : Boolean = false;
		public static var exitFlag : Boolean = false;
		private static var _heartTimer : Number = HEART_TIME;
		
		private var _prevTimer : int = 0;
		public function AniPang()
		{
			super();
			
			//KakaoExtension.instance.init();	
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			
			_mainStarling = new Starling(MainClass, stage);
			_mainStarling.showStats = true;
			
			_mainStarling.start();
			
			//addEventListener(flash.events.Event.ACTIVATE, activateListener);
			//addEventListener(flash.events.Event.DEACTIVATE, deactivateListener);
			//addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			_prevTimer = getTimer();
		}
		
		private function onEnterFrame(event:Event):void
		{
			var curTimer : int = getTimer();
			if(CurUserData.instance.userData.heart >= MAX_HEART) return;
				
			if(curTimer - _prevTimer > 1000)
			{
				_heartTimer--;
				_prevTimer = getTimer();
				
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
				if(logOutFlag == true)
				{
					//Extension.instance.toast("로그 아웃이 성공적으로 되었습니다");
					logOutFlag = false;
				}
				//로그아웃이 아닐 경우  하트가 다차면 푸시메세지 전달
				else
				{
					var pushTimer : int = ((MAX_HEART - CurUserData.instance.userData.heart)*HEART_TIME - (HEART_TIME - _heartTimer)) * 1000;
					var exitTime : Date = new Date();
					CurUserData.instance.userData.exitTime = exitTime.toString();
					trace(CurUserData.instance.userData.exitTime);
					trace(pushTimer);
				
					var itemDataJson : String = "{" + "\"gold\":" + String(CurUserData.instance.userData.gold) + ",\"star\":" +  String(CurUserData.instance.userData.totalStar) +
												",\"heart\":" + String(CurUserData.instance.userData.heart) + ",\"hearttime\":" + String(AniPang.heartTimer) + "}";
					
					trace(itemDataJson);
					
					//KakaoExtension.instance.saveUserData(itemDataJson, CurUserData.instance.userData.exitTime);
//					if(pushTimer > 0)
//						Extension.instance.push("애니팡", "하트가 가득 찾어요~ 어서와서 하트를 써주세요~", pushTimer, true);
				}
					
				Starling.current.stop(true);
			}
		}
		
		private function activateListener(event:flash.events.Event):void
		{
			if(Starling.current.isStarted == false)
				Starling.current.start();
			
			//Extension.instance.push("애니팡", "하트가 가득 찾어요~ 어서와서 하트를 써주세요~", 0, false);
			
			//유저 데이터 만 갱신
			CurUserData.instance.initData(false, true);
			trace(TitleScene.sTitleViewLoadFlag);
			
			//로그아웃, 게임종료 되었을 경우
//			if((KakaoExtension.instance.loginState() == "LOGIN_OFF" || exitFlag == true) && TitleScene.sTitleViewLoadFlag == true)
//			{
//				//게임이 종료 되었거나 로그 아웃 됫을 경우 다시 키면 재실행
//				var titleView : TitleScene = new TitleScene();
//				SceneManager.instance.addScene(titleView);
//				SceneManager.instance.sceneChange();
//				exitFlag = false;
//			}
			
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