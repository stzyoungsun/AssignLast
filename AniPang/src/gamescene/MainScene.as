package gamescene
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import UI.ListView.ListView;
	import UI.popup.PopupWindow;
	import UI.Button.SideImageButton;
	import UI.window.BuyHeartWindow;
	import UI.window.ItemShopWindow;
	import UI.window.ItemWindow;
	import UI.window.MissonWindow;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import score.ScoreManager;
	
	import sound.SoundManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;

	public class MainScene extends Sprite
	{
		private var _mainImage : Image;
		private var _itemShopWindow : ItemShopWindow;
		
		private var _startButton : SideImageButton;
		private var _rankButton : SideImageButton;
		private var _configButton : SideImageButton;
		private var _missonButton : SideImageButton;
		
		//메인 화면 상단에 게임 내 재화 상태를 출력 합니다.
		private var _heartWindow : ItemWindow;
		private var _coinWindow : ItemWindow;
		private var _starWindow : ItemWindow;
		
		private var _windowAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		private var _buttonAtals : TextureAtlas;
		private var _iconAtals : TextureAtlas;
		
		private var _popupWindow : PopupWindow;
		public function MainScene()
		{
			ScoreManager.instance.resetScore();
			
			_mainImage = new Image(TextureManager.getInstance().textureDictionary["back.png"]);
			_mainImage.width = AniPang.stageWidth;
			_mainImage.height = AniPang.stageHeight;
			addChild(_mainImage);
		
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["button.png"];
			_iconAtals = TextureManager.getInstance().atlasTextureDictionary["Icon.png"];
			
			drawWindow();
			
			SoundManager.getInstance().stopLoopedPlaying();
			SoundManager.getInstance().play("anipang_ui.mp3", true);
		}
		
		/** 
		 * 메인 화면을 출력 합니다.
		 */		
		private function drawWindow():void
		{
			_itemShopWindow = new ItemShopWindow("Red", "아이템샵");
			_itemShopWindow.init(0, _mainImage.height*0.15, _mainImage.width, _mainImage.height/1.8);
			addChild(_itemShopWindow);
			
			_heartWindow = new ItemWindow(_itemwindowAtals.getTexture("heart1"), AniPang.stageWidth*0.02, AniPang.stageHeight*0.03, AniPang.stageWidth/4, AniPang.stageHeight/30,0xf98677, "HEART");
			addChild(_heartWindow);
			
			_coinWindow = new ItemWindow(_itemwindowAtals.getTexture("coinIcon"), AniPang.stageWidth*0.37, AniPang.stageHeight*0.03, AniPang.stageWidth/4, AniPang.stageHeight/30,0xfeC532, "COIN");
			addChild(_coinWindow);
			
			_starWindow = new ItemWindow(_itemwindowAtals.getTexture("starIcon"), AniPang.stageWidth*0.72, AniPang.stageHeight*0.03, AniPang.stageWidth/4, AniPang.stageHeight/30,0x3edcf6, "STAR");
			addChild(_starWindow);
			
			_startButton = new SideImageButton(AniPang.stageWidth * 0.3, AniPang.stageHeight * 0.73, _mainImage.width/2.5, _mainImage.height/12, 
				_itemwindowAtals.getTexture("startButton"), null,"게임 시작");
			_startButton.settingTextField(0xffffff,  _startButton.width/8);
			_startButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_startButton);
			
			_missonButton = new SideImageButton(AniPang.stageWidth * 0.006, AniPang.stageHeight * 0.9, _mainImage.width/3, _mainImage.height/12, 
				_buttonAtals.getTexture("BlueButton"), _iconAtals.getTexture("rankIcon"),"오늘의 미션");
			_missonButton.settingTextField(0xffffff,  _startButton.width/10);
			_missonButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_missonButton);
			
			_rankButton = new SideImageButton(AniPang.stageWidth * 0.333, AniPang.stageHeight * 0.9, _mainImage.width/3, _mainImage.height/12, 
				_buttonAtals.getTexture("redButton"), _iconAtals.getTexture("rankIcon"),"랭킹 보기");
			_rankButton.settingTextField(0xffffff,  _startButton.width/8);
			_rankButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_rankButton);
		
			_configButton = new SideImageButton(AniPang.stageWidth * 0.66, AniPang.stageHeight * 0.9, _mainImage.width/3, _mainImage.height/12, 
				_buttonAtals.getTexture("orangeButton"), _iconAtals.getTexture("configIcon"),"환경 설정");
			_configButton.settingTextField(0xffffff,  _startButton.width/8);
			_configButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_configButton);
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			var itemPrice : int = 0;
			var itemCount : int = 0;
			if(touch)
			{
				SoundManager.getInstance().play("button.mp3", false);
				switch(event.currentTarget)
				{
					case _configButton:
						dispose();
						var configView : ConfigScene = new ConfigScene("Green", "환경 설정");
						SceneManager.instance.addScene(configView);
						SceneManager.instance.sceneChange();
						break;
					
					case _missonButton:
						var missonWindow : MissonWindow = new MissonWindow();
						addChild(missonWindow);
						break;
					
					case _startButton:
						
						if(ScoreManager.instance.maoItemUse == true)
						{
							itemCount++;
							itemPrice += 1200;
						}
							
						if(ScoreManager.instance.timeupItemUse == true)
						{
							itemCount++;
							itemPrice += 270;
						}
							
						if(CurUserData.instance.userData.heart <= 0)
						{
							_popupWindow = new PopupWindow("하트가 부족 합니다.", 2, new Array("x","buy"), null, onDrawBuyHeart);
							addChild(_popupWindow);
							return;
						}
						
						else if(CurUserData.instance.userData.gold < itemPrice)
						{
							_popupWindow = new PopupWindow("골드가 부족 합니다.", 1, new Array("x"));
							addChild(_popupWindow);
							return;
						}
						
						dispose();
						var playView : PlayScene = new PlayScene();
						SceneManager.instance.addScene(playView);
						SceneManager.instance.sceneChange();
						
						CurUserData.instance.userData.gold -= itemPrice;
						CurUserData.instance.userData.heart--;
						CurUserData.instance.userData.today_UseItemCount += itemCount;
						CurUserData.instance.userData.today_GameCount++;
						break;
					
					case _rankButton:
						dispose();
						var rankView : RankScene = new RankScene();
						SceneManager.instance.addScene(rankView);
						SceneManager.instance.sceneChange();
						break;
				}
			}

		}
		
		private function onDrawBuyHeart():void
		{
			var butHeartWindow : BuyHeartWindow = new BuyHeartWindow();
			butHeartWindow.initWindow(AniPang.stageWidth*0.1, AniPang.stageHeight*0.2, AniPang.stageWidth*0.8, AniPang.stageHeight*0.6);
			addChild(butHeartWindow);
		}
		
		protected function onExit(event:Event):void
		{
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