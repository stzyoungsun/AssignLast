package Animation
{
	import flash.utils.getTimer;
	
	import loader.TextureManager;
	
	import sound.SoundManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.TextureAtlas;

	public class EndClip extends Sprite
	{
		private var _backImage : Image;
		
		private var _iconAtals : TextureAtlas;
		private var _AniImage : Image;
		private var _textImage : Image;
		
		private var _prevTimer : int;
		public function EndClip(x : int, y : int, width : int, height :int)
		{
			_iconAtals = TextureManager.getInstance().atlasTextureDictionary["Icon.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			_AniImage = new Image(_iconAtals.getTexture("timeoverAni1"));
			_AniImage.x = x;
			_AniImage.y = y;
			_AniImage.width = width;
			_AniImage.height = height;
			addChild(_AniImage);
			
			_textImage = new Image(_iconAtals.getTexture("timeoverText"));
			_textImage.x = x;
			_textImage.y = y * 0.6;
			_textImage.width = width;
			_textImage.height = height/2;
			_textImage.visible = false;
			addChild(_textImage);
			
			_prevTimer = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			var curTimer : int = getTimer();
			
			if(curTimer - _prevTimer > 1000 && curTimer - _prevTimer < 3000 && _textImage.visible == false)
			{
				SoundManager.getInstance().stopLoopedPlaying();
				SoundManager.getInstance().play("timeover.mp3", false);
				
				_AniImage.texture = _iconAtals.getTexture("timeoverAni2")
				_textImage.visible = true;
			}
				
			else if(curTimer - _prevTimer > 3000)
			{
				dispatchEvent(new Event("RESULT"));
				dispose();
			}
		}
	}
}