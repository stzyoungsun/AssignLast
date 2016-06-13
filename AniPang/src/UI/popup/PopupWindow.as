package UI.popup
{
	import loader.TextureManager;
	
	import sound.SoundManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;

	public class PopupWindow extends Sprite
	{
		private var _buttonAtals : TextureAtlas;
		
		private var _backImage : Image;
		private var _mainWindow : Image;
		private var _contentTextField : TextField;
		private var _goButton : Button;
		
		private var _oneButton : Button;
		private var _twoButton : Button;
		
		private var _oneFunction : Function;
		private var _twoFunction : Function;
		/**
		 * 
		 * @param popupContent	팝업 창에 출력 할 텍스트
		 * @param buttonCnt		팝업 창에 들록 할 버튼의 개수 (2개 최대)
		 * @param buttonNames	팝업 창에 등록 할 버튼의 종류 (x, o, buy)
		 */
		public function PopupWindow(popupContent : String, buttonCnt : int, buttonNames : Array, oneFunc : Function = null, twoFunc : Function = null)
		{
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["button.png"];
			
			_oneFunction = oneFunc;
			_twoFunction = twoFunc;
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			_mainWindow = new Image(TextureManager.getInstance().textureDictionary["popup.png"]);
			_mainWindow.width = AniPang.stageWidth*0.7;
			_mainWindow.height = AniPang.stageHeight*0.4;
			_mainWindow.x = AniPang.stageWidth/2 - _mainWindow.width/2;
			_mainWindow.y = AniPang.stageHeight/2 - _mainWindow.height/2;
			addChild(_mainWindow);
			
			_contentTextField = new TextField(_mainWindow.width, _mainWindow.height/5);
			_contentTextField.x = _mainWindow.x;
			_contentTextField.y = _mainWindow.y + _mainWindow.height*0.5;
			_contentTextField.text = popupContent;
			_contentTextField.format.color = 0x197276;
			_contentTextField.format.bold = true;
			_contentTextField.format.size = _contentTextField.height/4;
			addChild(_contentTextField);
			
			_goButton = new Button(_buttonAtals.getTexture("go"));
			_goButton.width = AniPang.stageWidth/12;
			_goButton.height = AniPang.stageWidth/12;
			_goButton.x = _mainWindow.x + _mainWindow.width*0.8;
			_goButton.y = _mainWindow.y + _mainWindow.height*0.25;
			addChild(_goButton);
			
			createButton(buttonCnt, buttonNames);
		}
		
		private function createButton(buttonCnt : int, buttonNames : Array) : void
		{
			switch(buttonCnt)
			{
				case 1:
				{
					_oneButton = new Button(_buttonAtals.getTexture(buttonNames[0]));
					_oneButton.width = AniPang.stageWidth/9;
					_oneButton.height = AniPang.stageWidth/9;
					_oneButton.x = _mainWindow.x + _mainWindow.width*0.43;
					_oneButton.y = _mainWindow.y + _mainWindow.height*0.75;
					
					_oneButton.addEventListener(TouchEvent.TOUCH, onClicked);
					addChild(_oneButton);
					break;
				}
					
				case 2:
				{
					_oneButton = new Button(_buttonAtals.getTexture(buttonNames[0]));
					_oneButton.width = AniPang.stageWidth/9;
					_oneButton.height = AniPang.stageWidth/9;
					_oneButton.x = _mainWindow.x + _mainWindow.width*0.2;
					_oneButton.y = _mainWindow.y + _mainWindow.height*0.75;
					
					_oneButton.addEventListener(TouchEvent.TOUCH, onClicked);
					addChild(_oneButton);
					
					_twoButton = new Button(_buttonAtals.getTexture(buttonNames[1]));
					_twoButton.width = AniPang.stageWidth/9;
					_twoButton.height = AniPang.stageWidth/9;
					_twoButton.x = _mainWindow.x + _mainWindow.width*0.6;
					_twoButton.y = _mainWindow.y + _mainWindow.height*0.75;
					
					_twoButton.addEventListener(TouchEvent.TOUCH, onClicked);
					addChild(_twoButton);
					break;
				}
			}
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				SoundManager.getInstance().play("button.mp3", false);
				switch(event.currentTarget)
				{
					case _oneButton:
					{
						if(_oneFunction == null)
							dispose();
						break;
					}
					
					case _twoButton:
					{
						if(_twoFunction == null)
							dispose();
						else
							_twoFunction();
					} 
				}
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
			removeChildren(0, -1, true);
			removeEventListeners();
		}
	}
}