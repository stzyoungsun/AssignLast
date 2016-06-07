package gameview
{
	import com.lpesign.KakaoExtension;
	
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import UI.window.ButtonWindow;
	import UI.window.ItemWindow;
	import UI.window.MainWindow;
	
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
	import UI.window.ItemShopWindow;

	public class MainView extends Sprite
	{
		private var _mainImage : Image;
		private var _itemShopWindow : ItemShopWindow;
		
		private var _startButton : ButtonWindow;
		private var _rankButton : Button;
		
		private var _heartWindow : ItemWindow;
		private var _coinWindow : ItemWindow;
		private var _starWindow : ItemWindow;
		
		private var _windowAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		
		private var _undateTextField : TextField;
		
		public function MainView()
		{
			_mainImage = new Image(TextureManager.getInstance().textureDictionary["back.png"]);
			_mainImage.width = AniPang.stageWidth;
			_mainImage.height = AniPang.stageHeight;
			addChild(_mainImage);
		
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			
			drawWindow();
		}
		
		private function drawWindow():void
		{
			_itemShopWindow = new ItemShopWindow("Red", "아이템샵");
			_itemShopWindow.init(0, _mainImage.height*0.15, _mainImage.width, _mainImage.height/1.8);
			addChild(_itemShopWindow);
			
			_heartWindow = new ItemWindow(TextureManager.getInstance().textureDictionary["heart.png"], AniPang.stageWidth*0.05, AniPang.stageHeight*0.03, AniPang.stageWidth/4, AniPang.stageHeight/25);
			addChild(_heartWindow);
			
			_coinWindow = new ItemWindow(TextureManager.getInstance().textureDictionary["coin.png"], AniPang.stageWidth*0.4, AniPang.stageHeight*0.03, AniPang.stageWidth/4, AniPang.stageHeight/25);
			addChild(_coinWindow);
			
			_starWindow = new ItemWindow(TextureManager.getInstance().textureDictionary["star.png"], AniPang.stageWidth*0.75, AniPang.stageHeight*0.03, AniPang.stageWidth/4, AniPang.stageHeight/25);
			addChild(_starWindow);
			

			
			//_logoutButton.addEventListener(TouchEvent.TOUCH, onClicked);
			//addChild(_logoutButton);
			
			_startButton = new ButtonWindow(AniPang.stageWidth * 0.3, AniPang.stageHeight * 0.73, _mainImage.width/2.5, _mainImage.height/12, 
				_itemwindowAtals.getTexture("startButton"), null,"게임 시작");
			_startButton.settingTextField(0xffffff,  _startButton.width/8);
			_startButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_startButton);
			

//			
//			_rankButton = new Button(_windowAtals.getTexture("orangeButton.png"),"랭킹 보기");
//			_rankButton.width = _logoutButton.width;
//			_rankButton.height = _logoutButton.height;
//			_rankButton.x = _logoutButton.x - _logoutButton.width;
//			_rankButton.y = _logoutButton.y; 
//			_rankButton.textFormat.color = 0xffffff;
//			_rankButton.textFormat.size = _logoutButton.height/4;
//			_rankButton.textFormat.bold = true;	
//			_rankButton.addEventListener(TouchEvent.TOUCH, onClicked);
		
			
			//addChild(_undateTextField);
			//addChild(_rankButton);
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				switch(event.currentTarget)
				{
//					case _logoutButton:
//						//KakaoExtension.instance.logout();
//						//KakaoExtension.instance.addEventListener("LOGOUT_OK", onExit);
//						break;
					case _startButton:
						dispose();
						var playView : PlayView = new PlayView();
						SceneManager.instance.addScene(playView);
						SceneManager.instance.sceneChange();
						break;
//					case _exitButton:
//						dispose();
//						NativeApplication.nativeApplication.exit();
//						break;
//					case _rankButton:
//						dispose();
//						var rankView : RankView = new RankView();
//						SceneManager.instance.addScene(rankView);
//						SceneManager.instance.sceneChange();
//						break;
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