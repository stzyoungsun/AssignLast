package object.Progress
{

	import loader.TextureManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Progress extends Sprite
	{
		private var _backGoundImage : Image;
		private var _progressTexture : Image;
		
		private var _gameViewAtlas : TextureAtlas;
		private var _textField : TextField;
		private var _textFlag : Boolean;
		
		public function Progress(textFalg : Boolean = false, backTexture : Texture = null, ProgressTexture : Texture = null)
		{		
			_textFlag = textFalg;
			
			if(backTexture == null || ProgressTexture == null)
				_gameViewAtlas = TextureManager.getInstance().atlasTextureDictionary["gameView.png"];
			if(backTexture == null)
				_backGoundImage = new Image(_gameViewAtlas.getTexture("background"));
			else 
				_backGoundImage = new new Image(backTexture);
			
			if(ProgressTexture == null)
				_progressTexture = new Image(_gameViewAtlas.getTexture("bar"));
			else
				_progressTexture = new Image(ProgressTexture);
		}
			
		public function ProgressInit(x : int, y : int, witdh : int, height : int) : void
		{
			this.x = x;
			this.y = y;
			
			_backGoundImage.width = witdh;
			_backGoundImage.height = height;
			
			_progressTexture.width = witdh;
			_progressTexture.height = height;
			
			this.addChild(_backGoundImage);
			this.addChild(_progressTexture);
			
			if(_textFlag == true)
			{
				_textField = new TextField(_backGoundImage.width,_backGoundImage.height);
				_textField.format.color = 0xffffff;
				_textField.format.size = _backGoundImage.height*0.9;
				this.addChild(_textField);
			}
		}
		
		/**
		 * 
		 * @param maxHP 오브젝트의 최대 Value
		 * @param curHP 오브젝트의 현제 Value
		 * 
		 * Note @유영선 오브젝트의 체력의 퍼센트에 따른 Textrue 출력
		 */		
		public function calcValue(maxValue : Number, curValue:Number) : void
		{	
			_progressTexture.width = _backGoundImage.width*(curValue/maxValue);
		}
		
		public function get text() : String {return _textField.text;}
		public function set text(value : String) : void {_textField.text = value}
	}
}