package user
{
	import loader.TextureManager;
	
	import starling.textures.Texture;

	public class UserDataFormat
	{
		//카톡 관련 데이터
		public var id : int = 0;
		public var name : String = "익명";
		public var profilePath : String = "";
		public var profileTexture : Texture = TextureManager.getInstance().textureDictionary["notProfile.png"];
		public var curMaxScore : int = 0;
		
		//일반 적인 유저 데이터
		public var gold : int = 5000;  //테스트용
		public var heart : int = 1;
		public var lv : int = 0;
		public var remainStar : int = 0;
		public var totalStar : int = 0;
		
		//오늘의 미션 관련 데이터
		public var today_GameCount : int = 0;
		public var today_MaxScore : int = 0;
		public var today_UseItemCount : int = 0;
		public var today_CompleteString : String ="XXXXXXXXXX";
		public var today_CompleteCount : int = 0;
		
		//게임 세팅 데이터
		public var backGoundSound : String = "ON";
		public var effectSound : String = "ON";
		public var permitPush : String = "ON";
		
		//출석 데이터
		public var attendCnt : int = 0;
		
		//경험치 물약 시작 시간
		public var startTimeExpPotion : String;
		
		//유저 접속 시간
		public var exitTime : String;
		
		public function UserDataFormat(){}
	}
}