package util
{
	import flash.geom.Point;
	
	import object.Block.Block;
	import object.Block.Cell;
	
	import score.ScoreManager;
	

	public class BlockTypeSetting
	{
		//힌트팡의 위치를 저장
		private static var _hintPang : Cell;
		
		//3개 이상의 블럭이 가로 배열일 경우
		private static var _rowFlag : Boolean = false;
		//3개 이상의 블럭이 세로 배열일 경우
		private static var _colFlag : Boolean = false;
		
		public function BlockTypeSetting(){throw new Error("Abstract Class");}
		
		/**
		 * @param cellTypeArray : 게임 시작 셀 타입을 저장 할 배열
		 * 게임 시작전 셀의 타입을 설정하여 그 타입에 맞게 그려줍니다 
		 * 팡되는 경우를 제외 합니다.
		 */		
		public static function startBlockSetting(cellArray : Array) : void
		{
			for(var i : int = 0; i < Cell.MAX_COL; i++)
			{
				
				for(var j : int = 0; j < Cell.MAX_ROW; j++)
				{
					if(i == 0 || i == Cell.MAX_COL-1 || j == 0 || j == Cell.MAX_ROW-1)
					{
						cellArray[i][j].cellType = Block.WALL;
						continue;
					}
							
					while(true)
					{
						if(ScoreManager.instance.maoItemUse == true)
							cellArray[i][j].cellType = UtilFunction.random(2, 8, 1);
						else
							cellArray[i][j].cellType = UtilFunction.random(1, 7, 1);
							
						if(i - 2 > 0)
						{
							if(cellArray[i-1][j].cellType == cellArray[i][j].cellType 
								&& cellArray[i-2][j].cellType == cellArray[i][j].cellType) 
								continue;
						}
						
						if(j - 2 > 0)
						{
							if(cellArray[i][j-1].cellType == cellArray[i][j].cellType 
								&& cellArray[i][j-2].cellType == cellArray[i][j].cellType) 
								continue;
						}
							
						break;
					}
				}
			}
		}
		
		/**
		 * 팡이 되는 경우가 있는 지 검사 합니다.
		 * @param cellArray 게임 셀의 배열
		 * @return 검사 여부 
		 */		
		public static function checkEmptyPang(cellArray : Array) : Boolean
		{
			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
				{
					if(i - 2 > 0)
					{
						if(cellArray[i-1][j].cellType == cellArray[i][j].cellType 
							&& cellArray[i-2][j].cellType == cellArray[i][j].cellType) 
							return false;
					}
					
					if(j - 2 > 0)
					{
						if(cellArray[i][j-1].cellType == cellArray[i][j].cellType 
							&& cellArray[i][j-2].cellType == cellArray[i][j].cellType) 
							return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 한 번의 움직임으로 팡의 가능 여부를 검사합니다. (총 16가지의 패턴검사)
		 * @param cellArray 셀의 배열
		 * @return 팡가능 여부 리턴
		 * 
		 */		
		public static function checkPossiblePang(cellArray : Array) : Boolean
		{
			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
				{
					var index : Point = new Point(i,j);
					
					if(pattern.checkAllPattern(cellArray,index))
					{
						//한 번의 움직임으로 팡이 가능 할 경우의 셀을 힌트셀에 담습니다.
						_hintPang = cellArray[j][i];
						return true;
					}
						
					
					index = null;
				}
			}
			
			return false;
		}
		
		/**
		 * 사용자가 움직인 셀의 방향에 따라 팡을 체크하고 팡이 될 경우 제거 합니다.
		 * @param curCell 		사용자가 움직인 셀
		 * @param targetCell	사용자가 움직인 방향에 있는 블록
		 * @param cellArray     게임내 블록 배열
		 * @param moveDirect    움직인 방향
		 * @return 
		 * 
		 */		
		public static function checkMovePang(curCell : Cell, targetCell : Cell, cellArray : Array, moveDirect : int) : Boolean
		{
			if(curCell.cellType == Block.BLOCK_PANG || curCell.cellType == Block.BLOCK_REMOVE) return false;
			
			_rowFlag = false;
			_colFlag = false;
			
			if(targetCell != null)
				if(targetCell.cellType == Block.BLOCK_PANG || targetCell.cellType == Block.BLOCK_REMOVE) return false;
			
			var curCellX : int = curCell.cellX;
			var curCellY : int= curCell.cellY;
			
			var removecurCellVector : Vector.<Cell>;
			var removetargetCellVector : Vector.<Cell>;
			
			switch(moveDirect)
			{
				case Block.UP_MOVE:
				{
					removecurCellVector = verticalMoveCheck(curCell, cellArray, Block.UP_MOVE);
					if(targetCell != null)
						removetargetCellVector = verticalMoveCheck(targetCell, cellArray, Block.DOWN_MOVE);
					break;
				}
				
				case Block.DOWN_MOVE:
				{
					removecurCellVector = verticalMoveCheck(curCell, cellArray, Block.DOWN_MOVE);
					if(targetCell != null)
						removetargetCellVector = verticalMoveCheck(targetCell, cellArray, Block.UP_MOVE);
					break;
				}
					
				case Block.LEFT_MOVE:
				{
					removecurCellVector = horizonMoveCheck(curCell, cellArray, Block.LEFT_MOVE);
					if(targetCell != null)
						removetargetCellVector = horizonMoveCheck(targetCell, cellArray, Block.RIGHT_MOVE);
					break;
				}
					
				case Block.RIGHT_MOVE:
				{
					removecurCellVector = horizonMoveCheck(curCell, cellArray, Block.RIGHT_MOVE);
					if(targetCell != null)
						removetargetCellVector = horizonMoveCheck(targetCell, cellArray, Block.LEFT_MOVE);
					break;
				}
			}
			
			if(removecurCellVector != null || removetargetCellVector != null)
			{
				romoveBlock(cellArray, removecurCellVector, removetargetCellVector, moveDirect);
				return true;
			}
			else
				return false;
		}
		
		/**
		 * @param removecurCellVector		사용자가 움직인 블록을 기준으로 팡이 되어서 사라질 블록들
		 * @param removetargetCellVector   사용자가 움직인 곳에 있던 블록의 팡이 되어서 사라질 블록들
		 */		
		private static function romoveBlock(cellArray : Array, removecurCellVector : Vector.<Cell>, removetargetCellVector : Vector.<Cell>,  moveDirect : int) : void
		{
			var i :int = 0;
			if(removecurCellVector != null)
			{
				var curlenght : int = removecurCellVector.length;
			
				if(removecurCellVector[0].cellType != Block.BLOCK_MAO)
				{
					if(curlenght >= 4)
					{
						removecurCellVector.pop().cellType = Block.BLOCK_RANDOM;
						curlenght--;
					}
					
					for(i = 0; i < curlenght; i ++)
						removecurCellVector.pop().cellType = Block.BLOCK_PANG;
				}
				else
				{
					pangMaoBlock(cellArray, removecurCellVector, curlenght);
				}	
			}
				
			if(removetargetCellVector != null)
			{
				var targetlenght : int = removetargetCellVector.length;
				
				if(removetargetCellVector[0].cellType != Block.BLOCK_MAO)
				{
					if(targetlenght >= 4)
					{
						removetargetCellVector.pop().cellType = Block.BLOCK_RANDOM;
						targetlenght--;
					}
					
					for(i  = 0; i < targetlenght; i ++)
						removetargetCellVector.pop().cellType = Block.BLOCK_PANG;
				}
				
				else
				{
					pangMaoBlock(cellArray, removetargetCellVector, targetlenght);
				}
			}
			
			removecurCellVector = null;
			removetargetCellVector = null;
		}
		
		/**
		 * 삭제 배열에 들어온 셀들의 타입이 마오 인경우 배열이 세로배열이면 모든 가로에 있는 블록을 다 없애고 가로배열이면 모든 세로 블럭을 없앱니다.
		 * @param cellArray		전체의 셀 배열
		 * @param curCellVector	삭제 벡터에 들어온 셀
		 * @param curLenght		삭제 벡터의 크기
		 */		
		private static function pangMaoBlock(cellArray : Array, curCellVector : Vector.<Cell>, curLenght : int) : void
		{
			var i : int = 0;
			var tempCellPos : int;
			
			//가로 배열인경우 블록을 기준으로 모든 세로 블록을 없앰
			if(_rowFlag == true)
			{
				for(i = 0; i < curLenght; i++)
				{
					tempCellPos = curCellVector[i].cellX;
					
					while(tempCellPos > 0)
					{
						cellArray[curCellVector[i].cellY][tempCellPos].cellType = Block.BLOCK_PANG;
						tempCellPos--;
					}
					
					tempCellPos = curCellVector[i].cellX;
					
					while(tempCellPos < Cell.MAX_ROW)
					{
						cellArray[curCellVector[i].cellY][tempCellPos].cellType = Block.BLOCK_PANG;
						tempCellPos++;
					}		
				}
			}
			
			//세로 배열인경우 블록을 기준으로 모든 가로 배열을 없앰
			if(_colFlag == true)
			{
				for(i = 0; i < curLenght; i++)
				{
					tempCellPos = curCellVector[i].cellY;
					
					while(tempCellPos > 0)
					{
						cellArray[tempCellPos][curCellVector[i].cellX].cellType = Block.BLOCK_PANG;
						tempCellPos--;
					}
					
					tempCellPos = curCellVector[i].cellY;
					while(tempCellPos < Cell.MAX_COL)
					{
						cellArray[tempCellPos][curCellVector[i].cellX].cellType = Block.BLOCK_PANG;
						tempCellPos++;
					}
				}
			}		
		}
		
		/**
		 * 사용자가 블록을 움직인 방향이 수평일 경우
		 * @param cell			사용자가 선택 한 블록
		 * @param cellArray	        게임내 블록
		 * @param moveDirect    왼쪽, 오른쪽
		 * @return 
		 * 
		 */		
		private static function horizonMoveCheck(cell : Cell, cellArray : Array, moveDirect : Number) : Vector.<Cell>
		{
			var cellY : int = cell.cellY;
			var cellX : int = cell.cellX;
			var removeBlockVector : Vector.<Cell> = new Vector.<Cell>;

			while(cellY >= 1)
			{
				cellY--;
				
				if(cell.cellType == cellArray[cellY][cellX].cellType)
				{
					removeBlockVector.push(cellArray[cellY][cellX]);
				}
				else
					break;
			}
			
			cellY = cell.cellY;
			
			while(cellY <= Cell.MAX_COL - 1)
			{
				cellY++;
				if(cell.cellType == cellArray[cellY][cellX].cellType)
				{
					removeBlockVector.push(cellArray[cellY][cellX]);
				}
				else
					break;
			}
			
			var xCnt : Number = 0;
			
			cellY = cell.cellY;
			
			if(removeBlockVector.length < 2)
			{
				removeBlockVector = null;
				removeBlockVector = new Vector.<Cell>;	
			}
			else if(cell.cellType == Block.BLOCK_MAO)
				_rowFlag = true;
			
			if(moveDirect == Block.RIGHT_MOVE)
			{
				while(cellX <= Cell.MAX_ROW - 1)
				{
					cellX++;
					if(cell.cellType == cellArray[cellY][cellX].cellType)
					{
						removeBlockVector.push(cellArray[cellY][cellX]);
						xCnt++;
					}
					else
						break;
				}
			}
			
			else
			{
				while(cellX >= 1)
				{
					cellX--;
					if(cell.cellType == cellArray[cellY][cellX].cellType)
					{
						removeBlockVector.push(cellArray[cellY][cellX]);
						xCnt++;
					}
					else
						break;
				}
			}
			
			if(xCnt == 1)
				removeBlockVector.pop();
			else if(xCnt != 0 && cell.cellType == Block.BLOCK_MAO)
				_colFlag = true;
			
			if(removeBlockVector.length >= 2)
			{
				removeBlockVector.push(cell);
				return removeBlockVector;
			}
			else
				return null;
		}
		
		/**
		 * 사용자가 블록을 움직인 방향이 수직인 경우
		 * @param block			사용자가 선택 한 블록
		 * @param cellArray	게임내 블록
		 * @param moveDirect    위쪽, 아래쪽
		 * @return 
		 * 
		 */	
		private static function verticalMoveCheck(cell : Cell, cellArray : Array, moveDirect : Number) : Vector.<Cell>
		{
			var cellY : int = cell.cellY;
			var cellX : int = cell.cellX;
			var removeBlockVector : Vector.<Cell> = new Vector.<Cell>;
			
			while(cellX >= 1)
			{
				cellX--;
				
				if(cell.cellType == cellArray[cellY][cellX].cellType)
				{
					removeBlockVector.push(cellArray[cellY][cellX]);
				}
				else
					break;
			}
			
			cellX = cell.cellX;
			
			while(cellX <= Cell.MAX_ROW - 1)
			{
				cellX++;
				if(cell.cellType == cellArray[cellY][cellX].cellType)
				{
					removeBlockVector.push(cellArray[cellY][cellX]);
				}
				else
					break;
			}
			
			var yCnt : Number = 0;
			
			cellX = cell.cellX;
			
			if(removeBlockVector.length < 2)
			{
				removeBlockVector = null;
				removeBlockVector = new Vector.<Cell>;	
			}
			
			else if(cell.cellType == Block.BLOCK_MAO)
					_colFlag = true;
			
			if(moveDirect == Block.UP_MOVE)
			{
				while(cellY >= 2)
				{
					cellY--;
					if(cell.cellType == cellArray[cellY][cellX].cellType)
					{
						removeBlockVector.push(cellArray[cellY][cellX]);
						yCnt++;
					}
					else
						break;
				}
			}
				
			else
			{
				while(cellY <= Cell.MAX_COL - 1)
				{
					cellY++;
					if(cell.cellType == cellArray[cellY][cellX].cellType)
					{
						removeBlockVector.push(cellArray[cellY][cellX]);
						yCnt++;
					}
					else
						break;
				}
			}
			
			if(yCnt == 1) 
				removeBlockVector.pop();
			else if(yCnt != 0 && cell.cellType == Block.BLOCK_MAO)
				_rowFlag = true;
			
			if(removeBlockVector.length >= 2)
			{
				
				
				removeBlockVector.push(cell);
				return removeBlockVector;
			}
			else
				return null;
		}
		
		public static function get hintPang():Cell{return _hintPang;}
	}
}