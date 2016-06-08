package Animation
{
	import flash.utils.getTimer;
	
	import loader.TextureManager;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class StartClip extends Sprite
	{
		private var _readyClip : MovieClip;
		private var _startImage : Image;
		private var _textImage : Image;
		
		private var _backImage : Image;
		
		private var _iconAtals : TextureAtlas;
		
		private var _prevTimer : int;
		public function StartClip(x : int, y : int, width : int, height :int)
		{
			_iconAtals = TextureManager.getInstance().atlasTextureDictionary["Icon.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			_readyClip = new MovieClip(_iconAtals.getTextures("readAni"),8);
			_readyClip.x = x;
			_readyClip.y = y;
			_readyClip.width = width;
			_readyClip.height = height;
			_readyClip.play();
			Starling.juggler.add(_readyClip);
			addChild(_readyClip);
			
			_startImage = new Image(_iconAtals.getTexture("startAni"));
			_startImage.x = x;
			_startImage.y = y;
			_startImage.width = width;
			_startImage.height = height;
			_startImage.visible = false;
			addChild(_startImage);
			
			_textImage = new Image(_iconAtals.getTexture("ready"));
			_textImage.x = x;
			_textImage.y = y * 0.7;
			_textImage.width = width;
			_textImage.height = height/3;
			addChild(_textImage);
			
			_prevTimer = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			var curTimer : int = getTimer();
			
			if(curTimer - _prevTimer > 1600 && curTimer - _prevTimer < 2400)
			{
				_readyClip.visible = false;
				_startImage.visible = true;
				_textImage.texture = _iconAtals.getTexture("go")
			}
			
			else if(curTimer - _prevTimer > 2400)
			{
				dispatchEvent(new Event("START"));
				dispose();
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
			_readyClip.stop();
			Starling.juggler.remove(_readyClip);
			
			removeChildren(0 , -1, true);
			removeEventListeners();
		}
	}
}