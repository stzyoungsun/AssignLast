package gameview
{
	import UI.window.MainWindow;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;

	public class ConfigVeiw extends Sprite
	{
		private var _backImage : Image;
		private var _mainWindow : MainWindow;
		
		private var _logoutButton : Button;
		
		private var _buttonAtals : TextureAtlas;
		public function ConfigVeiw(nameWindowColor : String, nameWindowText : String)
		{
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["Button.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["back.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			_mainWindow = new MainWindow("Green","환경 설정");
			_mainWindow.init(AniPang.stageWidth*0.1, AniPang.stageHeight*0.2, AniPang.stageWidth*0.8, AniPang.stageHeight*0.6);
			_mainWindow.addEventListener("EXIT", onExit);
			addChild(_mainWindow);
			
			_logoutButton = new Button(_buttonAtals.getTexture("logout"));
			
			drawUpPanel();
			drawDownPanel();
		}
		
		private function onExit():void
		{
			dispose();
			var mainView : MainView = new MainView();
			SceneManager.instance.addScene(mainView);
			SceneManager.instance.sceneChange();
		}
		
		private function drawDownPanel():void
		{
			var titleTextField : TextField = new TextField(_mainWindow.mainWindowRect.width, _mainWindow.mainWindowRect.height/10);
			
		}
		
		private function drawUpPanel():void
		{
			_logoutButton.width = _mainWindow.mainWindowRect.width;
			_logoutButton.height = _mainWindow.mainWindowRect.height/8;
			_logoutButton.x = _mainWindow.mainWindowRect.x;
			_logoutButton.y = _mainWindow.mainWindowRect.y + _mainWindow.mainWindowRect.height - _logoutButton.height;
			addChild(_logoutButton);
		}
		
		public function settingTextField(textField : TextField, x : int, y :int, color : uint, size : Number) : void
		{
			textField.x = x;
			textField.y = y;
			textField.format.color = color;
			textField.format.size = size;
			textField.format.bold = true;
		}
		
		public override function dispose() : void
		{
			super.dispose();
			
			removeChildren(0 , -1, true);
			removeEventListeners();
		}
	}
}