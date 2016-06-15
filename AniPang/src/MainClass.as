package
{
	import com.lpesign.Extension;
	import com.lpesign.KakaoExtension;
	
	import flash.desktop.NativeApplication;
	import flash.events.StatusEvent;
	import flash.ui.Keyboard;
	
	import UI.popup.PopupWindow;
	
	import gamescene.TitleScene;
	import gamescene.attend.AttendData;
	
	import loader.ResourceLoader;
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	import user.CurUserData;
	
	public class MainClass extends Sprite
	{
		public static const MAX_ATTENTBOX_COUNT : int = 7;
		
		private static var _attendDataVector : Vector.<AttendData> = new Vector.<AttendData>;
	
		private static var _sceneStage : Sprite = new Sprite();
		private static var _current : Sprite
		//Note @유영선 리소스를 로드하는 LoaderControl 생성
		private var _resourceLoader : ResourceLoader;
		
		private  var _exitPopupWindow : PopupWindow;

		public function MainClass()
		{
			_current = this;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
			_resourceLoader = new ResourceLoader(onLoaderComplete, onProgress);
			_resourceLoader.resourceLoad("PrevLoadResource");
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
			attendDataInit();
		}	
		
		/** 
		 * 1~7일 출석 데이터 미리 생성 후 저장
		 */		
		private function attendDataInit():void
		{
			_attendDataVector.push(new AttendData(1, AttendData.TYPE_HEART1, AniPang.stageWidth*0.4, AniPang.stageHeight*0.41, AniPang.stageWidth/6, AniPang.stageWidth/6));
			_attendDataVector.push(new AttendData(2, AttendData.TYPE_COIN300, AniPang.stageWidth*0.4 + AniPang.stageWidth/5, AniPang.stageHeight*0.41, AniPang.stageWidth/6, AniPang.stageWidth/6));
			_attendDataVector.push(new AttendData(3, AttendData.TYPE_COIN500, AniPang.stageWidth*0.4 + AniPang.stageWidth/5, AniPang.stageHeight*0.51, AniPang.stageWidth/6, AniPang.stageWidth/6));
			_attendDataVector.push(new AttendData(4, AttendData.TYPE_HEART5, AniPang.stageWidth*0.4, AniPang.stageHeight*0.51, AniPang.stageWidth/6, AniPang.stageWidth/6));
			_attendDataVector.push(new AttendData(5, AttendData.TYPE_COIN1000, AniPang.stageWidth*0.2, AniPang.stageHeight*0.51, AniPang.stageWidth/6, AniPang.stageWidth/6));
			_attendDataVector.push(new AttendData(6, AttendData.TYPE_COIN5000, AniPang.stageWidth*0.2, AniPang.stageHeight*0.61, AniPang.stageWidth/3.5, AniPang.stageWidth/5));
			_attendDataVector.push(new AttendData(7, AttendData.TYPE_COIN5000, AniPang.stageWidth*0.5, AniPang.stageHeight*0.61, AniPang.stageWidth/3.5, AniPang.stageWidth/5));
		}
		
		/**
		 * 백버튼 눌럿을 경우
		 */
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				//게임 종료 팝업 출력
				drawExitPopup();
			}
		}
		
		/**
		 *  게임 종료 팝업 출력
		 */		
		public function drawExitPopup():void
		{
			_exitPopupWindow = new PopupWindow("정말 종료 하실 껀가요 ㅠㅠ", 2, new Array("x","o"), null, onExit);
			addChild(_exitPopupWindow);
		}
		
		/**
		 * 게임 종료 팝업에서 "O" 버튼 눌럿을 경우
		 */
		public function onExit() : void
		{
			//현재 데이터 서버에 저장
			KakaoExtension.instance.addEventListener("SAVE_DATA", onSaveData);
				
			var exitTime : Date = new Date();
				
			CurUserData.instance.userData.exitTime = exitTime.toString();
				
			String(CurUserData.instance.userData.gold), String(CurUserData.instance.userData.totalStar), String(CurUserData.instance.userData.heart)
			
			var itemDataJson : String = "{" + "\"gold\":" + String(CurUserData.instance.userData.gold) + ",\"star\":" +  String(CurUserData.instance.userData.totalStar) +
				",\"heart\":" + String(CurUserData.instance.userData.heart) + ",\"hearttime\":" + String(AniPang.heartTimer) + 
				",\"backGoundSound\":" + "\"" + CurUserData.instance.userData.backGoundSound + "\"" +
				",\"effectSound\":" + "\"" + CurUserData.instance.userData.effectSound + "\"" + 
				",\"permitPush\":" + "\"" + CurUserData.instance.userData.permitPush + "\"" + 
				",\"attendCnt\":" + CurUserData.instance.userData.attendCnt + 
				",\"startTimeExpPotion\":" + "\"" + CurUserData.instance.userData.startTimeExpPotion + "\"" +  "}";
			
			trace(itemDataJson);
			
			var missonDataJson : String = "{" + "\"today_GameCount\":" + String(CurUserData.instance.userData.today_GameCount) + 
				",\"today_MaxScore\":" +  String(CurUserData.instance.userData.today_MaxScore) +",\"today_UseItemCount\":" + String(CurUserData.instance.userData.today_UseItemCount) + 
				",\"today_CompleteString\":" +  "\"" + CurUserData.instance.userData.today_CompleteString + "\"" + "}";
			
			trace(missonDataJson);
			
			if(TitleScene.sTitleViewLoadFlag == true)
				KakaoExtension.instance.saveUserData(itemDataJson, missonDataJson, CurUserData.instance.userData.exitTime);	
			else
				notSaveExit();
		}
		
		/**
		 * 유저데이터 성공적으로 저장
		 */		
		private function onSaveData(event:StatusEvent):void
		{
			//데이터 성공적으로 저장 후 게임 종료
			AniPang.exitFlag = true;
			dispose();
			Extension.instance.exitDialog();
			NativeApplication.nativeApplication.exit();
		}
		
		/**
		 * 유저데이터 저장 안하고 종료
		 */		
		private function notSaveExit():void
		{
			//유저데이터 저장 안하고 종료
			AniPang.exitFlag = true;
			dispose();
			Extension.instance.exitDialog();
			NativeApplication.nativeApplication.exit();
		}
		
		private function onProgress(progressCount : Number):void{}
		
		private function onLoaderComplete():void
		{
			TextureManager.getInstance().createAtlasTexture();
			
			var titleView : TitleScene = new TitleScene();
			SceneManager.instance.addScene(titleView);
			SceneManager.instance.sceneChange();
			
			_resourceLoader = null;
		}
		
		public override function dispose():void
		{
			super.dispose();
			removeChildren(0, -1, true);
			removeEventListeners();
		}
		
		public static function get sceneStage():Sprite{return _sceneStage;}
		public static function set sceneStage(value:Sprite):void{_sceneStage = value;}
		
		public static function get current():Sprite{return _current;}
		public static function set current(value:Sprite):void{_current = value;}
		
		public static function get attendDataVector():Vector.<AttendData>{return _attendDataVector;}
	}
}