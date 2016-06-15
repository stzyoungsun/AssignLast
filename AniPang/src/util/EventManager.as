package util
{
	import object.specialItem.ExpPotion;
	
	import user.CurUserData;

	public class EventManager
	{
		public static const NONE_EVENT : int = 0;
		public static const LAUNCH_EVENT : int = 1;
		public static const DINNER_EVENT : int = 2;
		public static const NIGHT_EVENT : int = 3;
		
		public function EventManager(){throw new Error("Abstract Class");}
		
		/**
		 * 경험치 물약의 사용 여부를 체크 합니다.
		 */		
		public static function expPotionCheck():void
		{
			var millisecondsPerDay:int = 1000 * 60 * 60 * 24; 
			
			var curDate : Date = new Date();
			var startTimeExpPotion : Date = new Date(CurUserData.instance.userData.startTimeExpPotion);
			
			if(curDate.getTime() - startTimeExpPotion.getTime() >= millisecondsPerDay && CurUserData.instance.userData.startTimeExpPotion != "null")
			{
				ExpPotion.expPotionStop();
			}
			else
				ExpPotion.expPotionStart(millisecondsPerDay - (curDate.getTime() - startTimeExpPotion.getTime()));
		}
		
		/**
		 * 오늘 출석 보상을 받았는지 체크 하고 오늘 첫 접속이면 리턴 true
		 */		
		public static function attendCheck():Boolean
		{
			var curDate : Date = new Date();
			trace(CurUserData.instance.userData.exitTime);
			var prevDate : Date = new Date(CurUserData.instance.userData.exitTime);
			prevDate.setHours(24, 0, 0, 0);
			
			if(curDate.getTime() > prevDate.getTime() || CurUserData.instance.userData.exitTime == "null")
			{
				CurUserData.instance.userData.attendCnt++;
				
				if(CurUserData.instance.userData.attendCnt == MainClass.MAX_ATTENTBOX_COUNT+1) CurUserData.instance.userData.attendCnt = 1;
						
				return true;
			}
			
			return false;
		}
		
		/**
		 * @return		이벤트 타입
		 * 시간에 따라 이벤트의 타입을 결정 합니다.
		 */		
		public static function timeEventcheck() : int
		{
			var curTime : Date = new Date();
			
			if(curTime.hours >= 12 && curTime.hours < 14)
				return LAUNCH_EVENT;
			else if(curTime.hours >= 18 && curTime.hours < 20)
				return DINNER_EVENT;
			else if(curTime.hours >= 22 && curTime.hours < 24)
				return NIGHT_EVENT;
			else
				return NONE_EVENT;
		}
	}
}