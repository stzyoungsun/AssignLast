package util
{
	import gameview.PlayView;

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
	}
}