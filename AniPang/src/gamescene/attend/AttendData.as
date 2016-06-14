package gamescene.attend
{
	import flash.geom.Rectangle;
	
	import UI.popup.PopupWindow;
	
	import loader.TextureManager;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;

	public class AttendData
	{
		public static const TYPE_HEART1 : int = 	0;
		public static const TYPE_HEART5 : int = 	1;
		public static const TYPE_COIN300 : int = 	2;
		public static const TYPE_COIN500 : int = 	3;
		public static const TYPE_COIN1000 : int = 	4;
		public static const TYPE_COIN5000 : int = 	5;
		
		private var _missonAtals:TextureAtlas;
		private var _attendAtals : TextureAtlas;
		
		private var _id : int;
		private var _rewardType : int = 0;
		private var _rectAttendBox : Rectangle;
		private var _itemTexture : Texture;

		private var _popUpWindow : PopupWindow;
		
		/**
		 * @param id		출석 데이터의 아이디 (1~7)
		 * @param type		출석일에 맞는 보상 타입
		 * @param x			출석 일에 맞는 AttendBoxWindow의 x좌표
		 * @param y			출석 일에 맞는 AttendBoxWindow의 y좌표
		 * @param width		출석 일에 맞는 AttendBoxWindow의 width
		 * @param height	출석 일에 맞는 AttendBoxWindow의 height
		 */		
		public function AttendData(id : int, type : int,  x : int, y :int, width : int, height : int)
		{
			_id = id;
			_rewardType = type;
			_rectAttendBox = new Rectangle(x, y, width, height);
		}
		
		/**
		 * 타입에 맞게 팝업 창과 보상 텍스쳐 세팅
		 */		
		public function settingAttendData():void
		{
			_missonAtals = TextureManager.getInstance().atlasTextureDictionary["missonWindow.png"];
			
			switch(_rewardType)
			{
				case TYPE_HEART1:
				{
					_popUpWindow = new PopupWindow("출석 보상으로 하트 1개를 받았어요", 1, new Array("o")); 
					_itemTexture = _missonAtals.getTexture("heart1");
					break;
				}
				case TYPE_HEART5:
				{
					_popUpWindow = new PopupWindow("출석 보상으로 하트 5개를 받았어요", 1, new Array("o")); 
					_itemTexture = _missonAtals.getTexture("heart5");
					break;
				}
				case TYPE_COIN300:
				{
					_popUpWindow = new PopupWindow("출석 보상으로 코인 300개를 받았어요", 1, new Array("o")); 
					_itemTexture = _missonAtals.getTexture("coint300");
					break;
				}
				case TYPE_COIN500:
				{
					_popUpWindow = new PopupWindow("출석 보상으로 코인 500개를 받았어요", 1, new Array("o")); 
					_itemTexture = _missonAtals.getTexture("coin500");
					break;
				}
				case TYPE_COIN1000:
				{
					_popUpWindow = new PopupWindow("출석 보상으로 코인 1000개를 받았어요", 1, new Array("o")); 
					_itemTexture = _missonAtals.getTexture("coin1000");
					break;
				}
				case TYPE_COIN5000:
				{
					_popUpWindow = new PopupWindow("출석 보상으로 코인 5000개를 받았어요", 1, new Array("o")); 
					_itemTexture = _missonAtals.getTexture("coin5000");
					break;
				}
			}
		}
		
		/**
		 * 타입에 맞게 보상값 불러옴
		 */		
		public function getReward():void
		{
			switch(_rewardType)
			{
				case TYPE_HEART1:
				{
					CurUserData.instance.userData.heart +=1;
					break;
				}
				case TYPE_HEART5:
				{
					CurUserData.instance.userData.heart +=5;
					break;
				}
				case TYPE_COIN300:
				{
					CurUserData.instance.userData.gold += 300;
					break;
				}
				case TYPE_COIN500:
				{
					CurUserData.instance.userData.gold += 500;
					break;
				}
				case TYPE_COIN1000:
				{
					CurUserData.instance.userData.gold += 1000;
					break;
				}
				case TYPE_COIN5000:
				{
					CurUserData.instance.userData.gold += 5000;
					break;
				}
			}
		}		
		
		public function get id():int{return _id;}

		public function get rectAttendBox():Rectangle{return _rectAttendBox;}
		
		public function get itemTexture():Texture{return _itemTexture;}
		
		public function get popUpWindow():PopupWindow{return _popUpWindow;}
	}
}