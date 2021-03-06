package UI.window
{
	import com.lpesign.Extension;
	
	import UI.Button.SideImageButton;
	import UI.checkbox.ImageCheckBox;
	import UI.popup.PopupWindow;
	
	import loader.TextureManager;
	
	import object.specialItem.ExpPotion;
	
	import score.ScoreManager;
	
	import sound.SoundManager;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;
	
	public class ItemShopWindow extends MainWindow
	{
		private var _windowAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		
		private var _upPanel : Image;
		private var _mainPanel : Image;
		
		private var _downPanel : Image;
		private var _informTextField : TextField;
		
		private var _priceList : Image;
		private var _totalTextField : TextField;
		private var _coinImage : Image;
		private var _priceTextField : TextField;
		
		private var _maoCheckBox : ImageCheckBox;
		private var _timeCheckBox : ImageCheckBox;
		private var _maoImage : Image;
		private var _timeImage : Image;
		private var _maoprice : TextField;
		private var _timeprice : TextField;
		
		private var _notUpdateImages : Vector.<Image> = new Vector.<Image>;
		
		private var _buyHeartButton : SideImageButton;
		private var _butHeartWindow : BuyHeartWindow;
		
		private var _buyExpPotion : SideImageButton;
		private var _popUpWindow : PopupWindow;
		/**
		 * 메인 윈도우 클래스를 기반으로 만든 아이템 상점
		 * 화면에 각각 아이템을 이미지 체크 박스 형태로 출력
		 * 여러 버튼들이 존재
		 */		
		public function ItemShopWindow(nameWindowColor : String, nameWindowText : String)
		{
			super(nameWindowColor, nameWindowText, null, null, false)
			addEventListener("EXIT", onExit);
			
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			
			_mainPanel = new Image(_windowAtals.getTexture("subWindow"));
			_downPanel = new Image(_itemwindowAtals.getTexture("informWindow"));
			_priceList = new Image(_itemwindowAtals.getTexture("subWindow1"));
			_coinImage = new Image(_itemwindowAtals.getTexture("coinIcon"));
			
			_maoCheckBox = new ImageCheckBox(_itemwindowAtals.getTexture("ItemIcon2"), _itemwindowAtals.getTexture("ItemIcon1"), "MAO");
			_timeCheckBox = new ImageCheckBox(_itemwindowAtals.getTexture("ItemIcon2"), _itemwindowAtals.getTexture("ItemIcon1"), "TIMEUP");
			_maoImage = new Image(_itemwindowAtals.getTexture("maoItem"));
			_timeImage = new Image(_itemwindowAtals.getTexture("timeItem"));
			
			for(var i : int = 0; i < 8; i ++)
				_notUpdateImages.push(new Image(_itemwindowAtals.getTexture("ItemIcon3")));
		}
		
		public override function init(x : int, y : int, width: int, height : int) : void
		{
			super.init(x, y, width, height);
			
			_mainPanel.width = width;
			_mainPanel.height = height*0.55;
			_mainPanel.x = x;
			_mainPanel.y = y*2.3;
			addChild(_mainPanel);
			
			_priceList.width = _mainPanel.width/2;
			_priceList.height = height*0.1;
			_priceList.x = _mainPanel.width*0.25;
			_priceList.y = _mainPanel.y + _mainPanel.height - _priceList.height;
			addChild(_priceList);

			_coinImage.width = _priceList.width/10;
			_coinImage.height = _coinImage.width;
			_coinImage.x = _priceList.x*1.6;
			_coinImage.y = _mainPanel.y + _mainPanel.height - _priceList.height*0.8;
			addChild(_coinImage);
			
			_totalTextField = new TextField(_priceList.width/3, _priceList.height);
			_totalTextField.text = "합계";
			_totalTextField.format.color = 0x5DB2AB;
			_totalTextField.format.size = _coinImage.height;
			_totalTextField.format.bold = true;
			_totalTextField.x = _priceList.x;
			_totalTextField.y = _coinImage.y*0.98;
			addChild(_totalTextField);
			
			_priceTextField = new TextField(_priceList.width*0.7, _priceList.height);
			_priceTextField.text = "0";
			_priceTextField.format.color = 0x767676;
			_priceTextField.format.size = _coinImage.height;
			_priceTextField.format.bold = true;
			_priceTextField.x = _coinImage.x;
			_priceTextField.y = _coinImage.y*0.98;
			addChild(_priceTextField);
			
			_downPanel.width = width;
			_downPanel.height = height*0.1;
			_downPanel.x = x;
			_downPanel.y = _mainPanel.y + _mainPanel.height;
			addChild(_downPanel);
			
			_informTextField = new TextField(_downPanel.width, _downPanel.height);
			_informTextField.text = "[힌트] 아이템을 사용해서 더 높은 점수를 획득해봐!!";
			_informTextField.format.color = 0xECDC31;
			_informTextField.format.size = _coinImage.height/2;
			_informTextField.format.bold = true;
			_informTextField.x = _downPanel.x;
			_informTextField.y = _downPanel.y;
			addChild(_informTextField);
			
			_maoCheckBox.width = _mainPanel.width/6;
			_maoCheckBox.height = _mainPanel.height/2.5;
			_maoCheckBox.x = _mainPanel.x + _mainPanel.width/38;
			_maoCheckBox.y = _mainPanel.y*1.01;
			_maoCheckBox.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_maoCheckBox);
			
			_maoImage.width = _maoCheckBox.width*0.6;
			_maoImage.height = _maoCheckBox.height*0.6;
			_maoImage.x = _maoCheckBox.x + _maoImage.width/3;
			_maoImage.y = _maoCheckBox.y + _maoImage.height/5;
			_maoImage.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_maoImage);
			
			_maoprice = new TextField(_maoCheckBox.width, _maoCheckBox.height/5);
			_maoprice.text = "1200";
			_maoprice.format.color = 0xffffff;
			_maoprice.format.size = _maoCheckBox.height/7;
			_maoprice.format.bold = true;
			_maoprice.x = _maoCheckBox.x*1.2;
			_maoprice.y = _maoCheckBox.y*1.26;
			addChild(_maoprice);
			
			_timeCheckBox.width = _mainPanel.width/6;
			_timeCheckBox.height = _mainPanel.height/2.5;
			_timeCheckBox.x = _mainPanel.x + _maoCheckBox.width + _mainPanel.width/38*2;
			_timeCheckBox.y = _mainPanel.y*1.01;
			_timeCheckBox.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_timeCheckBox);
			
			_timeImage.width = _timeCheckBox.width*0.6;
			_timeImage.height = _timeCheckBox.height*0.6;
			_timeImage.x = _timeCheckBox.x + _timeImage.width/3;
			_timeImage.y = _timeCheckBox.y + _timeImage.height/5;
			_timeImage.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_timeImage);
			
			_timeprice = new TextField(_timeCheckBox.width, _timeCheckBox.height/5);
			_timeprice.text = "270";
			_timeprice.format.color = 0xffffff;
			_timeprice.format.size = _timeCheckBox.height/7;
			_timeprice.format.bold = true;
			_timeprice.x = _timeCheckBox.x*1.05;
			_timeprice.y = _timeCheckBox.y*1.26;
			addChild(_timeprice);
			
			_buyHeartButton = new SideImageButton(_mainPanel.x + _mainPanel.width*0.78, _mainPanel.y + _mainPanel.height*0.82, _mainPanel.width/5, _mainPanel.width/11, 
				_itemwindowAtals.getTexture("startButton"), _itemwindowAtals.getTexture("heart2"),"구매");
			_buyHeartButton.settingTextField(0xffffff,  _buyHeartButton.width/8);
			_buyHeartButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_buyHeartButton);
			
			_buyExpPotion = new SideImageButton(_mainPanel.x , _mainPanel.y+ _mainPanel.height*0.82, _mainPanel.width/5, _mainPanel.width/11, 
				_itemwindowAtals.getTexture("startButton"), null, "경험치 물약");
			_buyExpPotion.settingTextField(0xffffff,  _buyHeartButton.width/8);
			_buyExpPotion.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_buyExpPotion);
			
			if(ExpPotion.expPotionFlag == true)
				_buyExpPotion.visible = false;
			else
				_buyExpPotion.visible = true;
			
			var i : int;
			for(i = 0; i < 3; i ++)
			{
				_notUpdateImages[i].width = _mainPanel.width/6;
				_notUpdateImages[i].height = _mainPanel.height/2.5;
				_notUpdateImages[i].x = _mainPanel.x + _maoCheckBox.width*(i+2) + _mainPanel.width/38*(i+3);
				_notUpdateImages[i].y = _mainPanel.y*1.01;
				addChild(_notUpdateImages[i]);
			}
			
			for(i = 3; i < 8; i ++)
			{
				_notUpdateImages[i].width = _mainPanel.width/6;
				_notUpdateImages[i].height = _mainPanel.height/2.5;
				_notUpdateImages[i].x = _mainPanel.x + _maoCheckBox.width*(i-3) + _mainPanel.width/38*(i-2);
				_notUpdateImages[i].y = _mainPanel.y*1.01 + _maoCheckBox.height;
				addChild(_notUpdateImages[i]);
			}
			
			MainClass.current.addEventListener("STOP_EXP_POTION", onStopExpPotion);
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			var totalPrice : Number;
			if(touch)
			{
				SoundManager.getInstance().play("button.mp3", false);
				switch(event.currentTarget)
				{
					case _maoImage:
					case _maoCheckBox:
					{
						_maoCheckBox.dispatchEvent(new Event("CHECK"));
						if(_maoCheckBox.clickedFlag == true)
						{
							ScoreManager.instance.maoItemUse = true;
							totalPrice = Number(_priceTextField.text) + 1200;
							_priceTextField.text = String(totalPrice);
							_informTextField.text = "[트리플 마오] 마오 블록을 매치하면 세줄이 한방에!";
						}
						else
						{
							ScoreManager.instance.maoItemUse = false;
							totalPrice = Number(_priceTextField.text) - 1200;
							_priceTextField.text = String(totalPrice);
						}
						break;
					}
					
					case _timeImage:
					case _timeCheckBox:
					{
						_timeCheckBox.dispatchEvent(new Event("CHECK"));
						if(_timeCheckBox.clickedFlag == true)
						{
							ScoreManager.instance.timeupItemUse = true;
							totalPrice = Number(_priceTextField.text) + 270;
							_priceTextField.text = String(totalPrice);
							_informTextField.text = "[시간 보너스] 시작 시간이 10초 증가!!";
						}
						else
						{
							ScoreManager.instance.timeupItemUse = false;
							totalPrice = Number(_priceTextField.text) - 270;
							_priceTextField.text = String(totalPrice);
						}
						break;
					}
						
					case _buyHeartButton:
					{
						_butHeartWindow = new BuyHeartWindow();
						_butHeartWindow.initWindow(AniPang.stageWidth*0.1, AniPang.stageHeight*0.2, AniPang.stageWidth*0.8, AniPang.stageHeight*0.6);
						MainClass.sceneStage.addChild(_butHeartWindow);
						break;
					}
				
					case _buyExpPotion:
					{
						if(CurUserData.instance.userData.gold - 5000 < 0)
						{
							_popUpWindow = new PopupWindow("5000 골드가 필요 합니다.", 1, new Array("x"));
							addChild(_popUpWindow);
						}
						else
						{
							_popUpWindow = new PopupWindow("24시간 경험치 물약을 5천 골드에 구매?", 2, new Array("x", "o"), null, onBuyExpPotion);
							addChild(_popUpWindow);
						}
						
						break;
					}
				}
			}
		}
		
		private function onBuyExpPotion():void
		{
			CurUserData.instance.userData.gold -= 5000;
			
			_buyExpPotion.visible = false;
			var millisecondsPerDay:int = 1000 * 60 * 60 * 24;
			
			ExpPotion.expPotionStart(millisecondsPerDay);
			CurUserData.instance.userData.startTimeExpPotion = (new Date()).toString();
			removeChild(_popUpWindow, true);
		}
		
		/**
		 * 
		 */		
		private function onStopExpPotion():void
		{
			_buyExpPotion.visible = true;
		}
		
		private function onExit():void
		{
			parent.dispose();
			Extension.instance.exitDialog();
		}
		
		public override function dispose():void
		{
			super.dispose();
			
			removeChildren(0 , -1, true);
			removeEventListeners();
			
			_notUpdateImages = null;
		}
	}
}