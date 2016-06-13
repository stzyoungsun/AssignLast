package gamescene
{
	import com.lpesign.Extension;
	import com.lpesign.KakaoExtension;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.StatusEvent;
	
	import UI.popup.PopupWindow;
	import UI.window.MainWindow;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import sound.SoundManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;

	public class ConfigScene extends Sprite
	{
		private var _backImage : Image;
		private var _mainWindow : MainWindow;
		
		private var _logoutButton : Button;
		
		private var _logoutPopup : PopupWindow;
		
		private var _buttonAtals : TextureAtlas;
		public function ConfigScene(nameWindowColor : String, nameWindowText : String)
		{
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["button.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["back.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			_mainWindow = new MainWindow("Green","환경 설정");
			_mainWindow.init(AniPang.stageWidth*0.1, AniPang.stageHeight*0.2, AniPang.stageWidth*0.8, AniPang.stageHeight*0.6);
			_mainWindow.addEventListener("EXIT", onExit);
			addChild(_mainWindow);
			
			_logoutButton = new Button(_buttonAtals.getTexture("logout"));
			_logoutButton.addEventListener(TouchEvent.TOUCH, onClicked);
			
			drawUpPanel();
			drawDownPanel();
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				SoundManager.getInstance().play("button.mp3", false);
				switch(event.currentTarget)
				{
					case _logoutButton:
						_logoutPopup = new PopupWindow("정말 로그 아웃 하실 껀가요 ㅠㅠ?", 2, new Array("x","o"), null, onOut);
						
						addChild(_logoutPopup);
						break;
				}
			}
		}
		
		/** 
		 * 팝업창 "O" 클릭
		 */		
		public function onOut() : void
		{
			//KakaoExtension.instance.addEventListener("SAVE_DATA", onSaveData);
			
			var exitTime : Date = new Date();
		
			CurUserData.instance.userData.exitTime = exitTime.toString();
			
			String(CurUserData.instance.userData.gold), String(CurUserData.instance.userData.totalStar), String(CurUserData.instance.userData.heart)
			
			var itemDataJson : String = "{" + "\"gold\":" + String(CurUserData.instance.userData.gold) + ",\"star\":" +  String(CurUserData.instance.userData.totalStar) +
				",\"heart\":" + String(CurUserData.instance.userData.heart) + ",\"hearttime\":" + String(AniPang.heartTimer) + "}";
			
			trace(itemDataJson);
			
			var missonDataJson : String = "{" + "\"today_GameCount\":" + String(CurUserData.instance.userData.today_GameCount) + 
				",\"today_MaxScore\":" +  String(CurUserData.instance.userData.today_MaxScore) +",\"today_UseItemCount\":" + String(CurUserData.instance.userData.today_UseItemCount) + 
				",\"today_CompleteString\":" +  "\"" + CurUserData.instance.userData.today_CompleteString + "\"" + "}";
			
			trace(missonDataJson);
			
			//KakaoExtension.instance.saveUserData(itemDataJson, missonDataJson, CurUserData.instance.userData.exitTime);
		}
		
		/**
		 * 유저데이터 성공적으로 저장
		 */		
		private function onSaveData(event:Event):void
		{
			//KakaoExtension.instance.removeEventListener("SAVE_DATA", onSaveData);
			
			//KakaoExtension.instance.logout();
			//KakaoExtension.instance.addEventListener("LOGOUT_OK", onLogout);
		}
		
		/**
		 * 로그아웃 성공적으로 완료
		 */		
		private function onLogout(event : StatusEvent):void
		{
			AniPang.logOutFlag = true;
			dispose();
			//Extension.instance.exitDialog();
			NativeApplication.nativeApplication.exit();
		}
		
		private function onExit():void
		{
			dispose();
			var mainView : MainScene = new MainScene();
			SceneManager.instance.addScene(mainView);
			SceneManager.instance.sceneChange();
		}
		
		private function drawDownPanel():void
		{
			var titleTextField : TextField = new TextField(_mainWindow.mainWindowRect.width, _mainWindow.mainWindowRect.height/10);
			
		}
		
		private function drawUpPanel():void
		{
			_logoutButton.width = _mainWindow.mainWindowRect.width;
			_logoutButton.height = _mainWindow.mainWindowRect.height/8;
			_logoutButton.x = _mainWindow.mainWindowRect.x;
			_logoutButton.y = _mainWindow.mainWindowRect.y + _mainWindow.mainWindowRect.height - _logoutButton.height;
			addChild(_logoutButton);
		}
		
		public function settingTextField(textField : TextField, x : int, y :int, color : uint, size : Number) : void
		{
			textField.x = x;
			textField.y = y;
			textField.format.color = color;
			textField.format.size = size;
			textField.format.bold = true;
		}
		
		public override function dispose() : void
		{
			super.dispose();
			
			removeChildren(0 , -1, true);
			removeEventListeners();
		}
	}
}