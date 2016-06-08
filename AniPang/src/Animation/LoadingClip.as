package Animation
{
	import loader.TextureManager;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.textures.TextureAtlas;

	public class LoadingClip extends Sprite
	{
		private var _loadingClip : MovieClip;
		private var _backImage : Image;
		
		private var _iconAtals : TextureAtlas;
		public function LoadingClip(x : int, y : int, width : int, height :int)
		{
			_iconAtals = TextureManager.getInstance().atlasTextureDictionary["Icon.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			_loadingClip = new MovieClip(_iconAtals.getTextures("loadingAni"),8);
			_loadingClip.x = x;
			_loadingClip.y = y;
			_loadingClip.width = width;
			_loadingClip.height = height;
			_loadingClip.play();
			Starling.juggler.add(_loadingClip);
			addChild(_loadingClip);
		}
		
		public override function dispose():void
		{
			super.dispose();
			_loadingClip.stop();
			Starling.juggler.remove(_loadingClip);
			
			removeChildren(0 , -1, true);
			removeEventListeners();
		}
	}
}