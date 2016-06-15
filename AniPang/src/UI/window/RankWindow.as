package UI.window
{
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.utils.Align;
	
	import user.UserDataFormat;
	
	import util.UtilFunction;

	public class RankWindow extends Sprite
	{ 
		private var _userRankNum : TextField;
		private var _userImage : Image;
		private var _userDataTextField : TextField;
		
		/**
		 * @param userRankData		유저 데이터
		 * @param userRank			유저의 랭킹
		 * AllUserData  클래스에 나오는 서버의 모든 유저 데이터를 이용하여 랭크 Sprite 생성
		 * 생성도니 랭킹 Sprite는 랭크 씬에서 출력
		 */		
		public function RankWindow(userRankData : UserDataFormat, userRank : int, x : int, y : int)
		{
			_userRankNum = new TextField(AniPang.stageWidth/7, AniPang.stageHeight/7);
			_userImage = new Image(userRankData.profileTexture);
			_userDataTextField = new TextField(AniPang.stageWidth/2, AniPang.stageHeight/7);
			
			_userRankNum.text = String(userRank);
			_userDataTextField.text = String(userRankData.name + "  :  " + UtilFunction.makeCurrency(String(userRankData.curMaxScore)));
			
			_userRankNum.x = x;
			_userRankNum.y = y;
			_userRankNum.format.color = 0xffffff;
			_userRankNum.format.size =  AniPang.stageHeight/15;
			_userRankNum.format.bold = true;
			
			_userImage.x = _userRankNum.x + AniPang.stageWidth/6.5;
			_userImage.y = y;
			_userImage.width = AniPang.stageHeight/9;
			_userImage.height = AniPang.stageHeight/9;
			
			_userDataTextField.x = _userImage.x + _userImage.width*1.5;
			_userDataTextField.y = y;
			_userDataTextField.format.color = 0xffffff;
			_userDataTextField.format.size =  AniPang.stageHeight/40;
			_userDataTextField.format.bold = true;
			_userDataTextField.format.horizontalAlign = Align.LEFT;
			
			addChild(_userRankNum);
			addChild(_userDataTextField);
			addChild(_userImage);
			this.visible = false;
		}
	}
}