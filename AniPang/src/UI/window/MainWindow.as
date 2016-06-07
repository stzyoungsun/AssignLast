package UI.window
{
	import flash.geom.Rectangle;
	
	import loader.TextureManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	
	import user.CurUserData;

	public class MainWindow extends Sprite
	{
		private var _mainImage : Image;
		private var _userImage : Image;
		private var _userPanel : Image;
		private var _upPanel : Image;
		
		private var _exitButton : Button;
		
		private var _userNameTextField : TextField;
		//윈도우 창의 이름입니다
		private var _nameTextField : TextField;
		private var _nameText : String;
		
		private var _windowAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		private var _buttonAtals : TextureAtlas;
		
		private var _mainWindowRect : Rectangle;
		public function MainWindow(nameWindowColor : String, nameWindowText : String)
		{
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["Button.png"];
			
			_mainImage = new Image(_windowAtals.getTexture("mainWindow"));
			_userImage = new Image(CurUserData.instance.userData.profileTexture);
			
			_nameText = nameWindowText;
			switch(nameWindowColor)
			{
				case "Green":
				{
					_upPanel = new Image(_windowAtals.getTexture("nameWindow1"));
					break;
				}	
				case "Red":
				{
					_upPanel = new Image(_windowAtals.getTexture("nameWindow2"));
					break;
				}	
				case "Blue":
				{
					_upPanel = new Image(_windowAtals.getTexture("nameWindow3"));
					break;
				}
			}
			
			_userPanel = new Image(_windowAtals.getTexture("List"));
			_exitButton = new Button(_buttonAtals.getTexture("exit"));
		}
		
		public function init(x : int, y : int, width: int, height : int) : void
		{
			_mainWindowRect = new Rectangle(x, y, width, height);
				
			_mainImage.x = x;
			_mainImage.y = y;
			_mainImage.width = width;
			_mainImage.height = height;
			addChild(_mainImage);
			
			_upPanel.width = _mainImage.width;
			_upPanel.height = AniPang.stageHeight/12;
			_upPanel.x = _mainImage.x;
			_upPanel.y = _mainImage.y;
			addChild(_upPanel);
			
			_nameTextField = new TextField(_upPanel.width, _upPanel.height);
			_nameTextField.text = _nameText;
			_nameTextField.format.color = 0xffffff;
			_nameTextField.format.size = _userImage.height/3;
			_nameTextField.format.horizontalAlign = Align.CENTER;
			_nameTextField.format.verticalAlign = Align.CENTER;
			_nameTextField.format.bold = true;
			_nameTextField.x = _upPanel.x;
			_nameTextField.y = _upPanel.y;
			addChild(_nameTextField);
			
			_exitButton.width = _upPanel.width/10;
			_exitButton.height = _exitButton.width;
			_exitButton.x = _upPanel.x + _upPanel.width - _exitButton.width;
			_exitButton.y = _upPanel.y*1.05;
			_exitButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_exitButton);
			
			_userPanel.width = _mainImage.width;
			_userPanel.height = _mainImage.width/6;
			_userPanel.x = _mainImage.x;
			_userPanel.y = _mainImage.y + _upPanel.height;
			addChild(_userPanel);
			
			_userImage.width = _userPanel.width/7;
			_userImage.height = _userImage.width;
			_userImage.x = _userPanel.x  + _userImage.width*0.1;
			_userImage.y = _userPanel.y * 1.024;
			addChild(_userImage);
			
			_userNameTextField = new TextField(_userPanel.width - _userImage.width, _userPanel.height);
			_userNameTextField.text = CurUserData.instance.userData.name;
			_userNameTextField.format.horizontalAlign = Align.CENTER;
			_userNameTextField.format.verticalAlign = Align.CENTER;
			_userNameTextField.format.color = 0xffffff;
			_userNameTextField.format.size = _userImage.height/2.5;
			_userNameTextField.format.bold = true;
			_userNameTextField.x = _userPanel.x + _userImage.width;
			_userNameTextField.y = _userImage.y;
			addChild(_userNameTextField);
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			var totalPrice : Number;
			if(touch)
			{
				switch(event.currentTarget)
				{
					case _exitButton:
						dispatchEvent(new Event("EXIT"));
						break;
				}
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
	
			removeChildren(0, -1, true);
			removeEventListeners();
			
		}
		
		public function get mainWindowRect():Rectangle {return _mainWindowRect;}
	}
}