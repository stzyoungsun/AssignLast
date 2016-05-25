package util
{
	import flash.geom.Point;
	import blockobject.Block;

	public class pattern
	{
		public function pattern(){throw new Error("Abstract Class");}
		
		/**
		 * @param blockArray 	블록 배열
		 * @param index			블록 배열의 인덱스
		 * @return 				모든 패턴 검사 결과
		 * 
		 */		
		public static function checkAllPattern(blockArray : Array, index : Point) : Boolean
		{
			
			if(checkOnePattern(blockArray[index.y][index.x].blockType, index, blockArray))
				return true;
			
			if(checkTwoPattern(blockArray[index.y][index.x].blockType, index, blockArray))
				return true;
			
			if(checkThreePattern(blockArray[index.y][index.x].blockType, index, blockArray))
				return true;
			
			if(checkFourPattern(blockArray[index.y][index.x].blockType, index, blockArray))
				return true;
		
			return false
		}
		
		/**
		 * 
		 * @param curBlockType 	현재 블록의 타입
		 * @param index			현재 블록의 인덱스     	
		 * @param blockArray	블록 배열
		 * @return 				첫 번째 패턴 검사 여부
		 * 
		 */		
		private static function checkOnePattern(curBlockType : int,index : Point, blockArray : Array) : Boolean
		{
			//현재 블록의 오른쪽으로 한번 움직일 경우 팡이 되는 패턴
			var colValue : Array = new Array(0,0,1,-1,1,2,-1,-2);
			var rawValue : Array = new Array(2,3,1,1,1,1,1,1);
			
			for(var i : int =0; i < 8 ;i+=2)
			{
				if(index.y+colValue[i] <= 0 || index.y+colValue[i] >= Block.MAX_COL 
					|| index.x+rawValue[i] <= 0 || index.x+rawValue[i] >= Block.MAX_ROW
					|| index.y+colValue[i+1] <= 0 || index.y+colValue[i+1] >= Block.MAX_COL 
					|| index.x+rawValue[i+1] <= 0 || index.y+rawValue[i+1] >= Block.MAX_ROW)
					return false;
				
				if(blockArray[index.y+colValue[i]][index.x+rawValue[i]].blockType == curBlockType 
					&& blockArray[index.y+colValue[i+1]][index.x+rawValue[i+1]].blockType == curBlockType)
					return true;
			}
			return false;
		}
		
		private static function checkTwoPattern(curBlockType : int,index : Point, blockArray : Array) : Boolean
		{
			//현재 블록의 왼쪽으로 한번 움직일 경우 팡이 되는 패턴
			var colValue : Array = new Array(0,0,1,-1,1,2,-1,-2);
			var rawValue : Array = new Array(-2,-3,-1,-1,-1,-1,-1,-1);
			
			for(var i : int =0; i < 8 ;i+=2)
			{
				if(index.y+colValue[i] <= 0 || index.y+colValue[i] >= Block.MAX_COL 
					|| index.x+rawValue[i] <= 0 || index.x+rawValue[i] >= Block.MAX_ROW
					|| index.y+colValue[i+1] <= 0 || index.y+colValue[i+1] >= Block.MAX_COL 
					|| index.x+rawValue[i+1] <= 0 || index.y+rawValue[i+1] >= Block.MAX_ROW)
					return false;
				
				if(blockArray[index.y+colValue[i]][index.x+rawValue[i]].blockType == curBlockType 
					&& blockArray[index.y+colValue[i+1]][index.x+rawValue[i+1]].blockType == curBlockType)
					return true;
			}
			return false;
		}
		
		private static function checkThreePattern(curBlockType : int,index : Point, blockArray : Array) : Boolean
		{
			//현재 블록의 위쪽으로 한번 움직일 경우 팡이 되는 패턴
			var colValue : Array = new Array(2,3,1,1,1,1,1,1);
			var rawValue : Array = new Array(0,0,1,-1,1,2,-1,-2);
			
			for(var i : int =0; i < 8 ;i+=2)
			{
				if(index.y+colValue[i] <= 0 || index.y+colValue[i] >= Block.MAX_COL 
					|| index.x+rawValue[i] <= 0 || index.x+rawValue[i] >= Block.MAX_ROW
					|| index.y+colValue[i+1] <= 0 || index.y+colValue[i+1] >= Block.MAX_COL 
					|| index.x+rawValue[i+1] <= 0 || index.y+rawValue[i+1] >= Block.MAX_ROW)
					return false;
				
				if(blockArray[index.y+colValue[i]][index.x+rawValue[i]].blockType == curBlockType 
					&& blockArray[index.y+colValue[i+1]][index.x+rawValue[i+1]].blockType == curBlockType)
					return true;
			}
			return false;
		}
		
		private static function checkFourPattern(curBlockType : int,index : Point, blockArray : Array) : Boolean
		{
			//현재 블록의 아래쪽으로 한번 움직일 경우 팡이 되는 패턴
			var colValue : Array = new Array(-2,-3,-1,-1,-1,-1,-1,-1);
			var rawValue : Array = new Array(0,0,1,-1,1,2,-1,-2);
			
			for(var i : int =0; i < 8 ;i+=2)
			{
				if(index.y+colValue[i] <= 0 || index.y+colValue[i] >= Block.MAX_COL 
					|| index.x+rawValue[i] <= 0 || index.x+rawValue[i] >= Block.MAX_ROW
					|| index.y+colValue[i+1] <= 0 || index.y+colValue[i+1] >= Block.MAX_COL 
					|| index.x+rawValue[i+1] <= 0 || index.y+rawValue[i+1] >= Block.MAX_ROW)
					return false;
				
				if(blockArray[index.y+colValue[i]][index.x+rawValue[i]].blockType == curBlockType 
					&& blockArray[index.y+colValue[i+1]][index.x+rawValue[i+1]].blockType == curBlockType)
					return true;
			}
			return false;
		}	
	}
}