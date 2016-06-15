package UI.window
{
	import UI.Button.SideImageButton;
	
	import loader.TextureManager;
	
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	
	import util.EventManager;

	public class EventWindow extends MainWindow
	{
		private var _windowAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		
		private var _backImage : Image;
		
		private var _eventContentsTextField : TextField;
		private var _eventContentsBox : Image;
		private var _evnetBoxTextField : TextField;
		
		private var _okButton : SideImageButton;
		
		/**
		 * @param evnetType		점심, 저녁, 야간 타입
		 * 이벤트 타입에 따라 화면에 이벤트 내용을 출력 합니다.
		 */		
		public function EventWindow(evnetType : int)
		{
			super("Blue", "깜짝 이벤트");
			
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			this.init(AniPang.stageWidth*0.1, AniPang.stageHeight*0.2, AniPang.stageWidth*0.8, AniPang.stageHeight*0.6);
			this.addEventListener("EXIT", onExit);	
			
			_eventContentsTextField = new TextField(mainWindowRect.width/4, mainWindowRect.height/10);
			_eventContentsTextField.x = mainWindowRect.x + mainWindowRect.width*0.01;
			_eventContentsTextField.y = mainWindowRect.y + mainWindowRect.height/3.5;
			_eventContentsTextField.text = "이벤트 내용";
			_eventContentsTextField.format.size = _eventContentsTextField.height/4;
			_eventContentsTextField.format.bold = true;
			addChild(_eventContentsTextField);
			
			_eventContentsBox = new Image(_windowAtals.getTexture("subWindow"));
			_eventContentsBox.width = mainWindowRect.width*0.98;
			_eventContentsBox.height = mainWindowRect.height/2.5;
			_eventContentsBox.x = _eventContentsTextField.x;
			_eventContentsBox.y = _eventContentsTextField.y + _eventContentsTextField.height;
			addChild(_eventContentsBox);
			
			_evnetBoxTextField = new TextField(_eventContentsBox.width, _eventContentsBox.height);
			_evnetBoxTextField.x = _eventContentsTextField.x;
			_evnetBoxTextField.y = _eventContentsTextField.y + _eventContentsTextField.height;
			_evnetBoxTextField.format.horizontalAlign = Align.CENTER;
			_evnetBoxTextField.format.verticalAlign = Align.CENTER;
			_evnetBoxTextField.format.size = _eventContentsTextField.height/3.5;
			_evnetBoxTextField.format.color = 0x197276;
			_evnetBoxTextField.format.bold = true;
			addChild(_evnetBoxTextField);
			
			_okButton = new SideImageButton(AniPang.stageWidth * 0.3, AniPang.stageHeight * 0.7, AniPang.stageWidth/2.5, AniPang.stageHeight/12, 
				_itemwindowAtals.getTexture("startButton"), null,"확인");
			_okButton.settingTextField(0xffffff,  _okButton.width/8);
			_okButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_okButton);
			
			drawWindow(evnetType);
		}
		
		/**
		 * 이벤트 타입에 따라 텍스트의 내용을 출력 합니다.
		 */		
		private function drawWindow(evnetType : int):void
		{
			switch(evnetType)
			{
				case EventManager.LAUNCH_EVENT:
				{
					_evnetBoxTextField.text = "점심 이벤트!\n[하트 무제한]\n2시간 동안 하트를 무제한으로\n사용 할 수 있는 이벤트 입니다.\n\n\n12:00 ~ 14:00 까지 진행 되는 이벤트 입니다.\n시간이 모두 경과 하면 이벤트는 자동으로 끝납니다.";
					break;
				}
					
				case EventManager.DINNER_EVENT:
				{
					_evnetBoxTextField.text = "저녁 이벤트!\n[코인 획득 2배]\n2시간 동안 게임 시 획득 하는 코인이\n2배가 되는 이벤트 입니다.\n\n\n18:00 ~ 20:00 까지 진행 되는 이벤트 입니다.\n시간이 모두 경과 하면 이벤트는 자동으로 끝납니다.";
					break;
				}
					
				case EventManager.NIGHT_EVENT:
				{
					_evnetBoxTextField.text = "야간 이벤트!\n[보너스 점수 30% 증가]\n2시간 동안 게임 시 획득 하는 보너스 점수가\n30% 증가 하는 이벤트 입니다.\n\n\n22:00 ~ 24:00 까지 진행 되는 이벤트 입니다.\n시간이 모두 경과 하면 이벤트는 자동으로 끝납니다.";
					break;
				}
			}
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);

			if(touch)
			{
				switch(event.currentTarget)
				{
					case _okButton:
						onExit();
						break;
				}
			}
		}
		
		private function onExit():void
		{
			parent.removeChild(this, true)
		}
		
		public override function dispose():void
		{
			super.dispose();
			removeChildren(0, -1, true);
			removeEventListeners();
		}
	}
}