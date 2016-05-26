package util
{
	import flash.geom.Point;
	
	import object.Cell;

	public class pattern
	{
		public function pattern(){throw new Error("Abstract Class");}
		
		/**
		 * @param cellArray 	블록 배열
		 * @param index			블록 배열의 인덱스
		 * @return 				모든 패턴 검사 결과
		 * 
		 */		
		public static function checkAllPattern(cellArray : Array, index : Point) : Boolean
		{
			
			if(checkOnePattern(cellArray[index.y][index.x].cellType, index, cellArray))
				return true;
			
			if(checkTwoPattern(cellArray[index.y][index.x].cellType, index, cellArray))
				return true;
			
			if(checkThreePattern(cellArray[index.y][index.x].cellType, index, cellArray))
				return true;
			
			if(checkFourPattern(cellArray[index.y][index.x].cellType, index, cellArray))
				return true;
		
			return false
		}
		
		/**
		 * 
		 * @param curCellType 	현재 블록의 타입
		 * @param index			현재 블록의 인덱스     	
		 * @param cellArray	블록 배열
		 * @return 				첫 번째 패턴 검사 여부
		 * 
		 */		
		private static function checkOnePattern(curCellType : int,index : Point, cellArray : Array) : Boolean
		{
			//현재 블록의 오른쪽으로 한번 움직일 경우 팡이 되는 패턴
			var colValue : Array = new Array(0,0,1,-1,1,2,-1,-2);
			var rawValue : Array = new Array(2,3,1,1,1,1,1,1);
			
			for(var i : int =0; i < 8 ;i+=2)
			{
				if(index.y+colValue[i] <= 0 || index.y+colValue[i] >= Cell.MAX_COL 
					|| index.x+rawValue[i] <= 0 || index.x+rawValue[i] >= Cell.MAX_ROW
					|| index.y+colValue[i+1] <= 0 || index.y+colValue[i+1] >= Cell.MAX_COL 
					|| index.x+rawValue[i+1] <= 0 || index.y+rawValue[i+1] >= Cell.MAX_ROW)
					return false;
				
				if(cellArray[index.y+colValue[i]][index.x+rawValue[i]].cellType == curCellType 
					&& cellArray[index.y+colValue[i+1]][index.x+rawValue[i+1]].cellType == curCellType)
					return true;
			}
			return false;
		}
		
		private static function checkTwoPattern(curCellType : int,index : Point, cellArray : Array) : Boolean
		{
			//현재 블록의 왼쪽으로 한번 움직일 경우 팡이 되는 패턴
			var colValue : Array = new Array(0,0,1,-1,1,2,-1,-2);
			var rawValue : Array = new Array(-2,-3,-1,-1,-1,-1,-1,-1);
			
			for(var i : int =0; i < 8 ;i+=2)
			{
				if(index.y+colValue[i] <= 0 || index.y+colValue[i] >= Cell.MAX_COL 
					|| index.x+rawValue[i] <= 0 || index.x+rawValue[i] >= Cell.MAX_ROW
					|| index.y+colValue[i+1] <= 0 || index.y+colValue[i+1] >= Cell.MAX_COL 
					|| index.x+rawValue[i+1] <= 0 || index.y+rawValue[i+1] >= Cell.MAX_ROW)
					return false;
				
				if(cellArray[index.y+colValue[i]][index.x+rawValue[i]].cellType == curCellType 
					&& cellArray[index.y+colValue[i+1]][index.x+rawValue[i+1]].cellType == curCellType)
					return true;
			}
			return false;
		}
		
		private static function checkThreePattern(curCellType : int,index : Point, cellArray : Array) : Boolean
		{
			//현재 블록의 위쪽으로 한번 움직일 경우 팡이 되는 패턴
			var colValue : Array = new Array(2,3,1,1,1,1,1,1);
			var rawValue : Array = new Array(0,0,1,-1,1,2,-1,-2);
			
			for(var i : int =0; i < 8 ;i+=2)
			{
				if(index.y+colValue[i] <= 0 || index.y+colValue[i] >= Cell.MAX_COL 
					|| index.x+rawValue[i] <= 0 || index.x+rawValue[i] >= Cell.MAX_ROW
					|| index.y+colValue[i+1] <= 0 || index.y+colValue[i+1] >= Cell.MAX_COL 
					|| index.x+rawValue[i+1] <= 0 || index.y+rawValue[i+1] >= Cell.MAX_ROW)
					return false;
				
				if(cellArray[index.y+colValue[i]][index.x+rawValue[i]].cellType == curCellType 
					&& cellArray[index.y+colValue[i+1]][index.x+rawValue[i+1]].cellType == curCellType)
					return true;
			}
			return false;
		}
		
		private static function checkFourPattern(curCellType : int,index : Point, cellArray : Array) : Boolean
		{
			//현재 블록의 아래쪽으로 한번 움직일 경우 팡이 되는 패턴
			var colValue : Array = new Array(-2,-3,-1,-1,-1,-1,-1,-1);
			var rawValue : Array = new Array(0,0,1,-1,1,2,-1,-2);
			
			for(var i : int =0; i < 8 ;i+=2)
			{
				if(index.y+colValue[i] <= 0 || index.y+colValue[i] >= Cell.MAX_COL 
					|| index.x+rawValue[i] <= 0 || index.x+rawValue[i] >= Cell.MAX_ROW
					|| index.y+colValue[i+1] <= 0 || index.y+colValue[i+1] >= Cell.MAX_COL 
					|| index.x+rawValue[i+1] <= 0 || index.y+rawValue[i+1] >= Cell.MAX_ROW)
					return false;
				
				if(cellArray[index.y+colValue[i]][index.x+rawValue[i]].cellType == curCellType 
					&& cellArray[index.y+colValue[i+1]][index.x+rawValue[i+1]].cellType == curCellType)
					return true;
			}
			return false;
		}	
	}
}