package ranking
{
	import com.lpesign.KakaoExtension;
	
	import flash.events.StatusEvent;
	
	import json.JSON;
	public class SettingRankData
	{
		private static var _instance : SettingRankData;
		private static var _constructed : Boolean;
		
		public function SettingRankData()
		{
			if(!_constructed) throw new Error("Singleton, use ScoreManager.instance");
		}
		
		public static function get instance(): SettingRankData
		{
			if(_instance == null)
			{
				_constructed = true;
				_instance = new SettingRankData();
				_constructed = false;
			}
			return _instance;
		}
		
		private var _userIDList : Object = new Object();
		
		public function initRankData() : void
		{
			KakaoExtension.instance.addEventListener("GET_IDLIST", onGetIDList);
			KakaoExtension.instance.getIDList();
		}
		
		/**
		 * 서버로 부터 유저리스트를 성공적으로 받으면 불려지는 콜백 함수
		 */		
		private function onGetIDList(event:StatusEvent):void
		{
			_userIDList = json.JSON.decode(event.code);
			
			trace(_userIDList.elements[0]);
			trace(_userIDList.elements[1]);
			trace(_userIDList.elements[2]);
			trace(_userIDList.elements[3]);
		}
	}
}