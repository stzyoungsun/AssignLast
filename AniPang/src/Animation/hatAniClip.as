package Animation
{
	import loader.TextureManager;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.textures.TextureAtlas;

	public class hatAniClip extends MovieClip
	{
		private var _iconAtals : TextureAtlas;
		
		public function hatAniClip(x : int, y : int, width : int, height :int)
		{
			_iconAtals = TextureManager.getInstance().atlasTextureDictionary["Icon.png"];
			super(_iconAtals.getTextures("hatAni"),2);
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			this.play();
			Starling.juggler.add(this);
		}
		
		public override function dispose():void
		{
			super.dispose();
			this.stop();
			Starling.juggler.remove(this);
		}
	}
}