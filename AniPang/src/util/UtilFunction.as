package util
{
	public class UtilFunction
	{
		public function UtilFunction() { throw new Error("Abstract Class"); }
		
		private static var _minimum : Number;
		private static var _maximum : Number;
		private static var _roundTolnerval : Number;
		
		/**
		 * @param minimum 큰 수
		 * @param maximum 작 은수
		 * @param roundTolnerval 범위
		 * @return 랜덤 수
		 * 랜덤 수를 구하는 함수입니다
		 */		
		public static function random(minimum : Number = 0, maximum : Number = 0, roundTolnerval : Number = 1) : Number
		{
			_minimum = minimum;
			_maximum = maximum;
			_roundTolnerval = roundTolnerval;
			
			return (minimum != 0 || maximum != 0) ? original() : section();	
		}
		
		/**
		 * 
		 * @param randomArray 셔플을 적용 할 배열
		 * @param maxNum 셔플을 적용 할 값으 최대 값
		 * 배열의 값들을 랜덤하게 섞어 줍니다.
		 */		
		public static function shuffle(cellArray : Array, maxNum : Number) : void
		{
			var ny :Number;
			var nx : Number;
			
			var nTmp : Number;
			
			while(true)
			{
				for(var i : Number = maxNum-1; i > 0; --i)
				{
					for(var j : Number = maxNum-1; j > 0; --j)
					{
						ny = random(1,7,1);
						nx = random(1,7,1);
						
						nTmp = cellArray[i][j].cellType;
						cellArray[i][j].cellType = cellArray[ny][nx].cellType;
						cellArray[ny][nx].cellType = nTmp;
					}
				}
				//섞인 블록들 중에 팡이 되는 경우가 있는지 검사합니다.
				if(BlockTypeSetting.checkEmptyPang(cellArray) == true) break;
			}
		}
									
		private static function section():Number
		{
			return Math.random();
		}
		
		private static function original():Number
		{
			if(_minimum > _maximum)
			{
				var tmp : Number = _minimum;
				_minimum = _maximum;
				_maximum = tmp;
			}
			
			var nDeltaRange : Number = (_maximum - _minimum) + (1 * _roundTolnerval);
			var nRandomNumber : Number = Math.random() * nDeltaRange;
			nRandomNumber += _minimum;
			
			return Math.floor(nRandomNumber / _roundTolnerval) * _roundTolnerval;
		}
		
		/** 
		 * @param str 숫자를 담은 문자열
		 * @return 콤마 정리가 된 문자열
		 * 천단위에 콤마를 삽입하는 문자열
		 */		
		public static function makeCurrency(str:String):String
		{
			var arr:Array = str.split("");
			var len:uint = arr.length;
			
			for(var i:int=len-1, cnt:int=1; i>0; i--, cnt++){
				if((cnt % 3)==0){
					arr[i] = "," + arr[i];
				}
			}
			str = arr.join("");
			return str;
		}
		
		/**
		 * @param sec		초
		 * @return 			초를 이용하여 시간 스트링 출력
		 */		
		public static function makeTime(sec : int) : String
		{
			var time : String;
			
			var min : int;
			var hour : int;
			
			min=sec/60; // 입력받은 sec를 60으로 나누면 분(min)
			hour=min/60; // min의 값을 60으로 나누면 시(hour)
			sec=sec%60; // 시분초로 바꿔주는 것이므로, sec를 60으로 나눠 그 나머지가 남은 초
			min=min%60; // 12줄과 마찬가지로, min을 60으로 나눠 그 나머지가 남은 분
			
			if(hour != 0)
				time = hour + ":" + min + ":" + sec;
			else
				time = min + ":" + sec;
			
			return time;
		}
		
		/**
		 * @return 현재 시간을 기준으로 자정 Date 
		 */		
		public static function getMidnight() : Date
		{
			var midnight : Date = new Date();
			midnight.setHours(24, 0, 0, 0);	
			
			return midnight;
		}
	}
}