package gameview
{
	
	
	import com.lpesign.KakaoExtension;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import ui.MainWindow;

	public class MainView extends Sprite
	{
		private var _mainImage : Image;
		private var _windowSprite : MainWindow;
		private var _logoutButton : Button;
		private var _startButton : Button;
		private var _exitButton : Button;
		private var _windowAtals : TextureAtlas;
		private var _undateTextField : TextField;
		
		public function MainView()
		{
			_mainImage = new Image(TextureManager.getInstance().textureDictionary["mainView.png"]);
			_mainImage.width = AniPang.stageWidth;
			_mainImage.height = AniPang.stageHeight;
			addChild(_mainImage);
			
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			
			drawWindow();
		}
		
		private function drawWindow():void
		{
			_windowSprite = new MainWindow();
			_windowSprite.init(0, _mainImage.height*0.2, _mainImage.width, _mainImage.height/1.5);
			addChild(_windowSprite);
			
			_logoutButton = new Button(TextureManager.getInstance().textureDictionary["kakaoButton.png"],"로그 아웃");
			_logoutButton.width = _mainImage.width/7;
			_logoutButton.height = _mainImage.width/7;
			_logoutButton.x = _mainImage.width -_logoutButton.width; 
			_logoutButton.y = _mainImage.y + _mainImage.height/4;
			_logoutButton.textFormat.color = 0xffffff;
			_logoutButton.textFormat.size = _logoutButton.height/5;
			_logoutButton.textFormat.bold = true;
			_logoutButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_logoutButton);
			
			_startButton = new Button(_windowAtals.getTexture("redButton"),"게임 시작");
			_startButton.width = _mainImage.width/3;
			_startButton.height = _mainImage.height/5;
			_startButton.x = AniPang.stageWidth * 0.06; 
			_startButton.y = AniPang.stageHeight * 0.64; 
			_startButton.textFormat.color = 0xffffff;
			_startButton.textFormat.size = _logoutButton.height/4;
			_startButton.textFormat.bold = true;	
			_startButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_startButton);
			
			_exitButton = new Button(_windowAtals.getTexture("blueButton.png"),"종료");
			_exitButton.width = _mainImage.width/3;
			_exitButton.height =  _mainImage.height/5; 
			_exitButton.x = AniPang.stageWidth * 0.06 + _startButton.width*1.64;
			_exitButton.y = AniPang.stageHeight * 0.64; 
			_exitButton.textFormat.color = 0xffffff;
			_exitButton.textFormat.size = _logoutButton.height/4;
			_exitButton.textFormat.bold = true;	
			_exitButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_exitButton);
			
			_undateTextField = new TextField(_mainImage.width, _mainImage.height/4);
			_undateTextField.x = _mainImage.width*0.03;
			_undateTextField.y = _mainImage.height*0.4;
			_undateTextField.format.size = _mainImage.height*0.05;
			_undateTextField.text = "추후 상점 만들 공간";
			
			addChild(_undateTextField);
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				switch(event.currentTarget)
				{
					case _logoutButton:
						KakaoExtension.instance.logout();
						KakaoExtension.instance.addEventListener("LOGOUT_OK", onExit);
						break;
					case _startButton:
						dispose();
						var playView : PlayView = new PlayView();
						SceneManager.instance.addScene(playView);
						SceneManager.instance.sceneChange();
						break;
					case _exitButton:
						dispose();
						NativeApplication.nativeApplication.exit();
						break;
				}
			}

		}
		
		protected function onExit(event:Event):void
		{
			// TODO Auto-generated method stub
			dispose();

			NativeApplication.nativeApplication.exit(); 
		}
		
		public override function dispose():void
		{
			super.dispose();
			this.removeChildren(0, -1, true);
			this.removeEventListeners();
		}
	}
}