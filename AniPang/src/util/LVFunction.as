package util
{
	import user.CurUserData;

	public class LVFunction
	{
		private static var _lvTable : Array = new Array(200, 250, 270, 290, 310, 360, 400, 500, 600, 700,
												800, 1000, 1500, 2000, 2500, 3500, 4500, 5500, 8000);
		public function LVFunction(){throw new Error("Abstract Class");}
		
		public static function calcLV(starCount : int) : void
		{
			for(var i : int = 0; i < _lvTable.length; i ++)
			{
				if(starCount  >= _lvTable[i])
				{
					starCount -= _lvTable[i];
					CurUserData.instance.userData.lv = i+1;
					CurUserData.instance.userData.remainStar = starCount;
				}
				else
				{
					CurUserData.instance.userData.lv = i+1;
					CurUserData.instance.userData.remainStar = starCount;
					return;
				}
			}
			
			CurUserData.instance.userData.lv = _lvTable.length;
			CurUserData.instance.userData.remainStar = 0;
		}
		
		public static function calcRemainPercent(curLV : int, curRemainStar) : int
		{
			var percent : int = 0;
			
			percent = curRemainStar/_lvTable[curLV-1]*100;
			
			return percent;
		}
	}
}