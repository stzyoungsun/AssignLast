package gamescene
{
	import flash.desktop.NativeApplication;
	import flash.events.Event;
	
	import UI.Button.SideImageButton;
	import UI.ListView.ListView;
	import UI.popup.PopupWindow;
	import UI.window.BuyHeartWindow;
	import UI.window.ItemShopWindow;
	import UI.window.ItemWindow;
	import UI.window.MissonWindow;
	import UI.window.EventWindow;
	
	import gamescene.attend.AttendScene;
	
	import loader.TextureManager;
	
	import object.specialItem.ExpPotion;
	
	import scene.SceneManager;
	
	import score.ScoreManager;
	
	import sound.SoundManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	
	import user.CurUserData;
	
	import util.EventManager;
	import util.UtilFunction;

	public class MainScene extends Sprite
	{
		private var _mainImage : Image;
		private var _itemShopWindow : ItemShopWindow;
		//게임 시작 버튼
		private var _startButton : SideImageButton;
		//랭킹 버튼
		private var _rankButton : SideImageButton;
		//환경 설정 버튼
		private var _configButton : SideImageButton;
		//오늘의 미션 버튼
		private var _missonButton : SideImageButton;
		//출석 확인 버튼
		private var _attendButton : SideImageButton;
		//이벤트 확인 버튼
		private var _eventButton : SideImageButton;
		
		//메인 화면 상단에 게임 내 재화 상태를 출력 합니다.
		private var _heartWindow : ItemWindow;
		private var _coinWindow : ItemWindow;
		private var _starWindow : ItemWindow;
		
		private var _windowAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		private var _buttonAtals : TextureAtlas;
		private var _iconAtals : TextureAtlas;
		
		private var _popupWindow : PopupWindow;
		
		private var _remainExpPotionTextField : TextField;
		/**
		 * 게임의 시작 화면인 메인 씬
		 */		
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
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			eventTimeCheck();
		}
		
		private function onEnterFrame():void
		{
			if(ExpPotion.expPotionFlag == true)
			{
				_remainExpPotionTextField.visible = true;
				_remainExpPotionTextField.text = "경험치 2배 남은시간 : " + UtilFunction.makeTime(ExpPotion.remainSec);
			}
				
			else
			{
				_remainExpPotionTextField.visible = false;
			}
		}
		
		/** 
		 * 이벤트의 타입에 따라 이벤트 윈도우를 출력 합니다.
		 */		
		private function eventTimeCheck():void
		{
			switch(AniPang.evnetValue)
			{
				case EventManager.LAUNCH_EVENT:
				{
					_eventButton.visible = true;
					_eventButton.text = "점심 이벤트 중";
					addChild(new EventWindow(EventManager.LAUNCH_EVENT));
					break;
				}
					
				case EventManager.DINNER_EVENT:
				{
					_eventButton.visible = true;
					_eventButton.text = "저녁 이벤트 중";
					addChild(new EventWindow(EventManager.DINNER_EVENT));
					break;
				}
					
				case EventManager.NIGHT_EVENT:
				{
					_eventButton.visible = true;
					_eventButton.text = "야간 이벤트 중";
					addChild(new EventWindow(EventManager.NIGHT_EVENT));
					break;
				}
					
				default:
					_eventButton.visible = false;
					break;		
			}
			
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
			
			_attendButton = new SideImageButton(AniPang.stageWidth * 0.68, AniPang.stageHeight * 0.09, _mainImage.width/3.5, _mainImage.height/18, 
				_buttonAtals.getTexture("orangeButton"), null,"출석 확인");
			_attendButton.settingTextField(0xffffff,  _startButton.width/8);
			_attendButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_attendButton);
			
			_eventButton = new SideImageButton(AniPang.stageWidth * 0.38, AniPang.stageHeight * 0.09, _mainImage.width/3.5, _mainImage.height/18, 
				_buttonAtals.getTexture("redButton"), null, "");
			_eventButton.settingTextField(0xffffff,  _startButton.width/12);
			_eventButton.addEventListener(TouchEvent.TOUCH, onClicked);
			_eventButton.visible = false;
			addChild(_eventButton);
			
			_remainExpPotionTextField = new TextField(_mainImage.width/2, _mainImage.height/10);
			_remainExpPotionTextField.x = AniPang.stageWidth * 0.01;
			_remainExpPotionTextField.y = AniPang.stageHeight * 0.05;
			_remainExpPotionTextField.format.color = 0x0000FF;
			_remainExpPotionTextField.format.size = _remainExpPotionTextField.height/8;
			_remainExpPotionTextField.format.bold = true;
			_remainExpPotionTextField.format.horizontalAlign = Align.LEFT;
			_remainExpPotionTextField.visible = false;
		
			addChild(_remainExpPotionTextField);
		}
		
		/**
		 * 메인 씬의 있는 버튼들의 클릭 이벤트 입니다.
		 */		
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
						if(AniPang.evnetValue != EventManager.LAUNCH_EVENT)
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
					
					case _attendButton:
						dispose();
						var attendView : AttendScene = new AttendScene();
						SceneManager.instance.addScene(attendView);
						SceneManager.instance.sceneChange();
						break;
					
					case _eventButton:
						eventTimeCheck();
						break;
				}
			}

		}
		
		/**
		 * 하트가 부족 할 경우 작동 하는 콜백 함수
		 * 하트 구매 창을 화면에 출력 합니다.
		 */		
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