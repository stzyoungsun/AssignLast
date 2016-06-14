package UI.window
{
	import gamescene.attend.AttendData;
	
	import loader.TextureManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;

	public class AttendBoxWindow extends Sprite
	{
		private var _attendAtals : TextureAtlas;
		//미리 저장 해둔 출석 데이터
		private var _attendData : AttendData;
		//출석 박스 이미지
		private var _attendBoxImage : Image;
		//출석 보상 이미지
		private var _attendItemImage : Image;
		//출석일의 텍스트 필드
		private var _idTextField : TextField;
		//출석 도장 이미지
		private var _attendStampImage : Image;
		
		/**
		 * @param id 출석 데이터의 id
		 * 출석 데이터의 id에 따라 저장 되어 있는 정보를 가지고 Sprite를 생성
		 */		
		public function AttendBoxWindow(id : int)
		{
			_attendAtals = TextureManager.getInstance().atlasTextureDictionary["attend.png"];
			
			_attendData = MainClass.attendDataVector[id - 1];
			
			this.x = _attendData.rectAttendBox.x;
			this.y = _attendData.rectAttendBox.y;
			
			_attendBoxImage = new Image(_attendAtals.getTexture("attendBox"));
			_attendBoxImage.width = _attendData.rectAttendBox.width;
			_attendBoxImage.height = _attendData.rectAttendBox.height;
			
			addChild(_attendBoxImage);
			
			_attendItemImage = new Image(_attendData.itemTexture);
			_attendItemImage.x = _attendData.rectAttendBox.x*0.01;
			_attendItemImage.y = _attendData.rectAttendBox.y*0.01;
			_attendItemImage.width = _attendData.rectAttendBox.width/1.1;
			_attendItemImage.height = _attendData.rectAttendBox.height/1.1;
			
			addChild(_attendItemImage);
			
			_idTextField = new TextField(_attendItemImage.width/4, _attendItemImage.width/4);
			_idTextField.text = String(_attendData.id);
			_idTextField.format.size = _attendItemImage.width/7;
			_idTextField.format.color = 0x197276;	
			_idTextField.format.bold = true;
			
			addChild(_idTextField);
			
			_attendStampImage = new Image(_attendAtals.getTexture("attendStamp"));
			_attendStampImage.width = _attendData.rectAttendBox.width;
			_attendStampImage.height = _attendData.rectAttendBox.height;
			_attendStampImage.visible = false;
			addChild(_attendStampImage);
		}
		
		/**
		 * 해당 출석 박스에 맞는 보상 팝업을 출력합니다.
		 */		
		public function drawPopUp() : void
		{
			MainClass.current.addChild(_attendData.popUpWindow);
		}
		
		/**
		 * 해당 출석 박스에 맞는 보상을 수령합니다.
		 */	
		public function getReward() : void
		{
			_attendData.getReward();
		}
		
		public function get attendStampImage():Image{return _attendStampImage;}
	}
}