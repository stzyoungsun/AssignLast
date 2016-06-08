package user
{
	import loader.TextureManager;
	
	import starling.textures.Texture;

	public class UserDataFormat
	{
		public var id : int = 0;
		public var name : String = "익명";
		public var profilePath : String = "";
		public var profileTexture : Texture = TextureManager.getInstance().textureDictionary["notProfile.png"];
		public var curMaxScore : int = 0;
		public var gold : int = 0;  //테스트용
		public var heart : int = 0;
		public var lv : int = 0;
		public var remainStar : int = 0;
		public var totalStar : int = 0;
		
		public function UserDataFormat(){}
	}
}