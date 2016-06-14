package UI.window
{
	import UI.popup.PopupWindow;
	
	import loader.TextureManager;
	
	import sound.SoundManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	
	import user.CurUserData;

	public class BuyHeartWindow extends MainWindow
	{
		private var _backImage : Image;
		
		private var _windowAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		private var _buttonAtals : TextureAtlas;
		
		private var _popupWindow : PopupWindow;
		
		/**
		 * 게임의 시작이나 재시작 버튼 등에 하트를 사용 했을 경우에 하트가 부족 하면 팝업 창을 통해 구매가 가능
		 * 아이템 상점에 하트 구매 버튼이 존재
		 * 하트 구매창 클래스
		 */		
		public function BuyHeartWindow()
		{
			super("Blue", "하트 구매");
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["button.png"];
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			addEventListener("EXIT", onExit);
		}
		
		private function onExit():void
		{
			this.dispose();
			parent.removeChild(this);
		}
		
		public function initWindow(x : int, y : int, width: int, height : int) : void
		{
			super.init(x, y, width, height);
			
			for(var i : int = 0; i < 4; i++)
				drawList(i, x, y, width, height);
		}
		
		public function drawList(listNum : int, x : int, y : int, width: int, height : int) : void
		{
			var listImage : Image = new Image(_windowAtals.getTexture("List"));
			listImage.width = width;
			listImage.height = height/6;
			listImage.x = x;
			listImage.y = y + (height*0.29) + listImage.height*listNum*1.05;
			addChild(listImage);
			
			var heartIcon : Image = new Image(_itemwindowAtals.getTexture("heart2"));
			heartIcon.width = listImage.width/10;
			heartIcon.height = listImage.width/10;
			heartIcon.x = listImage.x + heartIcon.width/2;
			heartIcon.y = listImage.y + heartIcon.height*0.5;
			addChild(heartIcon);
			
			var countTextField : TextField = new TextField(heartIcon.width*1.5, listImage.height);
			countTextField.x = listImage.x + heartIcon.width*1.8;
			countTextField.y = listImage.y;
			countTextField.text = "X" + String((listNum + 1)*5);
			countTextField.format.size = heartIcon.height/2;
			countTextField.format.bold = true;
			countTextField.format.color = 0xffffff;
			countTextField.format.horizontalAlign = Align.LEFT;
			countTextField.format.verticalAlign = Align.CENTER;
			addChild(countTextField);
			
			var smallListImage : Image = new Image(_windowAtals.getTexture("smallList"));
			smallListImage.width = listImage.width/3;
			smallListImage.height = listImage.height/2.5;
			smallListImage.x = listImage.x + heartIcon.width*4;
			smallListImage.y = listImage.y + smallListImage.height/1.3;
			addChild(smallListImage);
			
			var goldIcon : Image = new Image(_itemwindowAtals.getTexture("coinIcon"));
			goldIcon.width = smallListImage.height*0.8;
			goldIcon.height = smallListImage.height*0.8;
			goldIcon.x = smallListImage.x*1.01;
			goldIcon.y = smallListImage.y*1.005;
			addChild(goldIcon);
			
			var goldTextField : TextField = new TextField(smallListImage.width*0.9, smallListImage.height);
			goldTextField.x = smallListImage.x;
			goldTextField.y = smallListImage.y;
			goldTextField.text = String((listNum + 1)*500);
			goldTextField.format.size = heartIcon.height/3;
			goldTextField.format.bold = true;
			goldTextField.format.color = 0xfeC532;
			goldTextField.format.horizontalAlign = Align.RIGHT;
			goldTextField.format.verticalAlign = Align.CENTER;
			addChild(goldTextField);
			
			var buyButton : Button = new Button(_buttonAtals.getTexture("buy"));
			buyButton.width = listImage.width/6;
			buyButton.height = listImage.width/6;
			buyButton.x = goldTextField.x + goldTextField.width*1.3;
			buyButton.y = listImage.y + buyButton.height*0.1;
			addChild(buyButton);
			
			buyButton.name = String(listNum+1);
			buyButton.addEventListener(TouchEvent.TOUCH, onClicked);
		}
		
		/**
		 * 하트를 구매 할 경우 그에 맞는 팝업 창을 출력
		 * 하트의 구매 개수, 구매 가격에 따라 사용자 아이템 재화 조절
		 */		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);

			if(touch)
			{
				SoundManager.getInstance().play("button.mp3", false);
				switch((event.currentTarget as Button).name)
				{
					case "1":
						if(CurUserData.instance.userData.gold - 500 < 0)
						{
							_popupWindow = new PopupWindow("골드가 부족 합니다.", 1, new Array("x"));
							addChild(_popupWindow);
						}
						else
						{
							_popupWindow = new PopupWindow("하트 5개 구입 완료", 1, new Array("o"));
							addChild(_popupWindow);
							
							CurUserData.instance.userData.gold-= 500;
							CurUserData.instance.userData.heart += 5;
						}
						break;
					case "2":
						if(CurUserData.instance.userData.gold - 1000 < 0)
						{
							_popupWindow = new PopupWindow("골드가 부족 합니다.", 1, new Array("x"));
							addChild(_popupWindow);
						}
						else
						{
							_popupWindow = new PopupWindow("하트 10개 구입 완료", 1, new Array("o"));
							addChild(_popupWindow);
							
							CurUserData.instance.userData.gold-= 1000;
							CurUserData.instance.userData.heart += 10;
						}
						break;
					case "3":
						if(CurUserData.instance.userData.gold - 1500 < 0)
						{
							_popupWindow = new PopupWindow("골드가 부족 합니다.", 1, new Array("x"));
							addChild(_popupWindow);
						}
						else
						{
							_popupWindow = new PopupWindow("하트 15개 구입 완료", 1, new Array("o"));
							addChild(_popupWindow);
							
							CurUserData.instance.userData.gold-= 1500;
							CurUserData.instance.userData.heart += 15;
						}
						break;
					
					case "4":
						if(CurUserData.instance.userData.gold - 2000 < 0)
						{
							_popupWindow = new PopupWindow("골드가 부족 합니다.", 1, new Array("x"));
							addChild(_popupWindow);
						}
						else
						{
							_popupWindow = new PopupWindow("하트 20개 구입 완료", 1, new Array("o"));
							addChild(_popupWindow);
							
							CurUserData.instance.userData.gold-= 2000;
							CurUserData.instance.userData.heart += 20;
						}
						break;
				}
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
			removeChildren(0, -1, true)
			removeEventListeners();
		}
	}
}