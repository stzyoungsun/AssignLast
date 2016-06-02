package ui
{
	import loader.TextureManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;

	public class MainWindow extends Sprite
	{
		private var _mainImage : Image;
		private var _userNameTextField : TextField;
		private var _userImage : Image;
		
		private var _windowAtals : TextureAtlas;
		
		public function MainWindow()
		{
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			
			_mainImage = new Image(_windowAtals.getTexture("dialog"));
			
			if(CurUserData.instance.profileTexture == null)
			{
				_userImage = new Image(TextureManager.getInstance().textureDictionary["notProfile.png"]);
			}
			else
				_userImage = new Image(CurUserData.instance.profileTexture);
		}
		
		public function init(x : int, y : int, width: int, height : int) : void
		{
			_mainImage.x = x;
			_mainImage.y = y;
			_mainImage.width = width;
			_mainImage.height = height;
			
			addChild(_mainImage);
			
			_userImage.width = _mainImage.width/6;
			_userImage.height = _userImage.width;
			_userImage.x = _mainImage.x + _mainImage.width/11;
			_userImage.y = _mainImage.y + _mainImage.height/4.5;
			
			addChild(_userImage);
			
			_userNameTextField = new TextField(_mainImage.width/3, _userImage.height);
			_userNameTextField.text = CurUserData.instance.name;
			_userNameTextField.format.color = 0x000000;
			_userNameTextField.format.size = _userImage.height/3;
			_userNameTextField.format.bold = true;
			_userNameTextField.x = _userImage.width*1.4;
			_userNameTextField.y = _userImage.y;
			
			addChild(_userNameTextField);
		}
	}
}