package UI.window
{
	import UI.popup.PopupWindow;
	
	import gamescene.MainScene;
	import gamescene.PlayScene;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import score.ScoreManager;
	
	import sound.SoundManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;

	public class PauseWindow extends Sprite
	{
		private var _pauseWindowAtlas : TextureAtlas;
		
		private var _mainImage : Image;
		private var _continueImage : Button;
		private var _menuImage : Button;
		private var _restartImage : Button;
		private var _backImage : Image;
		
		private var _popupWindow : PopupWindow;
		
		/**
		 * 게임 씬에서 일시 정지 버튼을 눌렀을 경우 출력 되는 정지 윈도우
		 */		
		public function PauseWindow()
		{
			_pauseWindowAtlas = TextureManager.getInstance().atlasTextureDictionary["pauseWindow.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_mainImage = new Image(_pauseWindowAtlas.getTexture("settingPopup"));
			_continueImage = new Button(_pauseWindowAtlas.getTexture("continue"));
			_menuImage = new Button(_pauseWindowAtlas.getTexture("menu"));
			_restartImage = new Button(_pauseWindowAtlas.getTexture("restart"));
		}
		
		public function init(x : int, y : int, width : int, height : int) : void
		{
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			
			_mainImage.x = x - width/2;
			_mainImage.y = y - height/2;
			_mainImage.width = width;
			_mainImage.height = height;
			
			_continueImage.width = _mainImage.width*0.96;
			_continueImage.height = _mainImage.height/4;
			_continueImage.x = _mainImage.x + _mainImage.width*0.02;
			_continueImage.y = _mainImage.y*0.9 + _continueImage.height;
			
			_restartImage.width = _mainImage.width*0.96;
			_restartImage.height = _mainImage.height/4;
			_restartImage.x = _mainImage.x + _mainImage.width*0.02;
			_restartImage.y = _mainImage.y*0.9 + _continueImage.height * 2.05;
			
			_menuImage.width = _mainImage.width*0.96;
			_menuImage.height = _mainImage.height/4;
			_menuImage.x = _mainImage.x + _mainImage.width*0.02;
			_menuImage.y = _mainImage.y*0.9 + _continueImage.height * 3.1;
			
			addChild(_backImage);
			addChild(_mainImage);
			addChild(_continueImage);
			addChild(_restartImage);
			addChild(_menuImage);
			
			_continueImage.addEventListener(TouchEvent.TOUCH, onClicked);
			_restartImage.addEventListener(TouchEvent.TOUCH, onClicked);
			_menuImage.addEventListener(TouchEvent.TOUCH, onClicked);
		}
		
		/**
		 * 게속하기, 다시하기, 메인 화면으로 3버튼이 존재
		 * 다시 하기 할 경우 하트가 감소 하고 하트 부족시 하트 구매 팝업 출력
		 */		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				SoundManager.getInstance().play("button.mp3", false);
				switch(event.currentTarget)
				{
					case _continueImage:
					{
						PlayScene.pauseFlag = false;
						dispose();
						break;
					}
					case _restartImage:
					{
						dispose();
						ScoreManager.instance.resetScore();
						
						if(CurUserData.instance.userData.heart <= 0)
						{
							_popupWindow = new PopupWindow("하트가 부족 합니다.", 2, new Array("x","buy"), null, onDrawBuyHeart);
							addChild(_popupWindow);
							return;
						}
						
						CurUserData.instance.userData.heart--;		
						var playView : PlayScene = new PlayScene();
						SceneManager.instance.addScene(playView);
						SceneManager.instance.sceneChange();
						break;
					}
					case _menuImage:
					{
						dispose();
						var mainView : MainScene = new MainScene();
						SceneManager.instance.addScene(mainView);
						SceneManager.instance.sceneChange();
						break;
					}
				}
			}
		}
		
		private function onDrawBuyHeart():void
		{
			var butHeartWindow : BuyHeartWindow = new BuyHeartWindow();
			butHeartWindow.initWindow(AniPang.stageWidth*0.1, AniPang.stageHeight*0.2, AniPang.stageWidth*0.8, AniPang.stageHeight*0.6);
			addChild(butHeartWindow);
		}
		
		public override function dispose():void
		{
			_pauseWindowAtlas = null;
			
			super.dispose();
			removeChildren(0, -1, true);
			removeEventListeners();
		}
	}
}