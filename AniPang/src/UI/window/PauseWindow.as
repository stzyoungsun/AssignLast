package UI.window
{
	import UI.popup.PopupWindow;
	
	import gamescene.MainView;
	import gamescene.PlayView;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import score.ScoreManager;
	
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
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				switch(event.currentTarget)
				{
					case _continueImage:
					{
						PlayView.pauseFlag = false;
						dispose();
						break;
					}
					case _restartImage:
					{
						dispose();
						ScoreManager.instance.resetScore();
						
						if(CurUserData.instance.userData.heart <= 0)
						{
							_popupWindow = new PopupWindow("하트가 부족 합니다.", 1, new Array("x"));
							addChild(_popupWindow);
							return;
						}
						
						CurUserData.instance.userData.heart--;		
						var playView : PlayView = new PlayView();
						SceneManager.instance.addScene(playView);
						SceneManager.instance.sceneChange();
						break;
					}
					case _menuImage:
					{
						dispose();
						var mainView : MainView = new MainView();
						SceneManager.instance.addScene(mainView);
						SceneManager.instance.sceneChange();
						break;
					}
				}
			}
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