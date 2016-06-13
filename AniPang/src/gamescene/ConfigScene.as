package gamescene
{
	import com.lpesign.Extension;
	import com.lpesign.KakaoExtension;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	import flash.events.StatusEvent;
	
	import UI.Button.ConfigButton;
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
	import starling.utils.Align;
	
	import user.CurUserData;

	public class ConfigScene extends Sprite
	{
		private var _backImage : Image;
		
		private var _mainWindow : MainWindow;
		private var _logoutButton : Button;
		
		private var _logoutPopup : PopupWindow;
		
		private var _buttonAtals : TextureAtlas;
		private var _windowAtals : TextureAtlas;
		private var _iconAtals : TextureAtlas;
		
		public function ConfigScene(nameWindowColor : String, nameWindowText : String)
		{
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["button.png"];
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_iconAtals = TextureManager.getInstance().atlasTextureDictionary["Icon.png"];
			
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
			drewMidPanel();
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
		
		private function drawUpPanel():void
		{
			var titleTextField : TextField = new TextField(_mainWindow.mainWindowRect.width, _mainWindow.mainWindowRect.height/10);
			titleTextField.width = _mainWindow.mainWindowRect.width;
			titleTextField.height = _mainWindow.mainWindowRect.height/15;
			titleTextField.x = _mainWindow.mainWindowRect.x + _mainWindow.mainWindowRect.width/25;
			titleTextField.y = _mainWindow.mainWindowRect.y + _mainWindow.mainWindowRect.height/3.6;
			titleTextField.text = "게임설정";
			titleTextField.format.horizontalAlign = Align.LEFT;
			titleTextField.format.size = titleTextField.height/3;
			titleTextField.format.bold = true;
			addChild(titleTextField);
			
			var upPanelImage : Image = new Image(_windowAtals.getTexture("subWindow"));
			upPanelImage.width = _mainWindow.mainWindowRect.width*0.9;
			upPanelImage.height = _mainWindow.mainWindowRect.height/4;
			upPanelImage.x = titleTextField.x;
			upPanelImage.y = titleTextField.y + titleTextField.height;
			addChild(upPanelImage);
			
			var decoImage : Image = new Image(_iconAtals.getTexture("char"));
			decoImage.width = upPanelImage.height;
			decoImage.height = upPanelImage.height;
			decoImage.x = upPanelImage.x;
			decoImage.y = upPanelImage.y;
			addChild(decoImage);
			
			var backSoundButton : ConfigButton = new ConfigButton(upPanelImage.x + upPanelImage.width*0.45, upPanelImage.y + upPanelImage.height*0.1, upPanelImage.width*0.65, 
												upPanelImage.height/5, _buttonAtals.getTexture("music"), "배경음", CurUserData.instance.userData.backGoundSound);
			
			var effectSoundButton : ConfigButton = new ConfigButton(upPanelImage.x + upPanelImage.width*0.45, upPanelImage.y + upPanelImage.height*0.4, upPanelImage.width*0.65, 
				upPanelImage.height/5, _buttonAtals.getTexture("sound"), "효과음", CurUserData.instance.userData.effectSound);
			
			var permitPushButton : ConfigButton = new ConfigButton(upPanelImage.x + upPanelImage.width*0.45, upPanelImage.y + upPanelImage.height*0.7, upPanelImage.width*0.65, 
				upPanelImage.height/5, _buttonAtals.getTexture("muilt"), "푸쉬 알림", CurUserData.instance.userData.permitPush);
			
			addChild(backSoundButton);
			addChild(effectSoundButton);
			addChild(permitPushButton);
		}
		
		private function drewMidPanel():void
		{
			var titleTextField : TextField = new TextField(_mainWindow.mainWindowRect.width, _mainWindow.mainWindowRect.height/10);
			titleTextField.width = _mainWindow.mainWindowRect.width;
			titleTextField.height = _mainWindow.mainWindowRect.height/15;
			titleTextField.x = _mainWindow.mainWindowRect.x + _mainWindow.mainWindowRect.width/25;
			titleTextField.y = _mainWindow.mainWindowRect.y + _mainWindow.mainWindowRect.height/1.65;
			titleTextField.text = "애니팡 정보";
			titleTextField.format.horizontalAlign = Align.LEFT;
			titleTextField.format.size = titleTextField.height/3;
			titleTextField.format.bold = true;
			addChild(titleTextField);
			
			var downpanelImage : Image = new Image(_windowAtals.getTexture("subWindow"));
			downpanelImage.width = _mainWindow.mainWindowRect.width*0.9;
			downpanelImage.height = _mainWindow.mainWindowRect.height/6;
			downpanelImage.x = titleTextField.x;
			downpanelImage.y = titleTextField.y + titleTextField.height;
			addChild(downpanelImage);
			
			var userIDTextField : TextField = new TextField(_mainWindow.mainWindowRect.width, _mainWindow.mainWindowRect.height/10);
			userIDTextField.width = downpanelImage.width;
			userIDTextField.height = downpanelImage.height/5;
			userIDTextField.x = downpanelImage.x*1.05;
			userIDTextField.y = downpanelImage.y +downpanelImage.height/7.5;
			userIDTextField.text = "카카오 회원 번호 :    " + CurUserData.instance.userData.id;
			userIDTextField.format.horizontalAlign = Align.LEFT;
			userIDTextField.format.size = titleTextField.height/3;
			userIDTextField.format.bold = true;
			userIDTextField.format.color = 0x197276;
			addChild(userIDTextField);
			
			var userNameTextField : TextField = new TextField(_mainWindow.mainWindowRect.width, _mainWindow.mainWindowRect.height/10);
			userNameTextField.width = downpanelImage.width;
			userNameTextField.height = downpanelImage.height/5;
			userNameTextField.x = downpanelImage.x*1.05;
			userNameTextField.y = downpanelImage.y +downpanelImage.height/1.75;
			userNameTextField.text = "카카오 회원 이름 :    " + CurUserData.instance.userData.name;
			userNameTextField.format.horizontalAlign = Align.LEFT;
			userNameTextField.format.size = titleTextField.height/3;
			userNameTextField.format.bold = true;
			userNameTextField.format.color = 0x197276;
			addChild(userNameTextField);
		}
		
		private function drawDownPanel():void
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