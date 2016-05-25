package util
{
	import flash.geom.Point;
	
	import blockobject.Block;
	import blockobject.blocktype.GeneralTypeBlock;
	
	import gameview.PlayView;

	public class BlockTypeSetting
	{
		//힌트팡의 위치를 저장
		private static var _hintPang : GeneralTypeBlock;
		
		public function BlockTypeSetting(){throw new Error("Abstract Class");}
		
		/**
		 * @param blockTypeArray : 게임 시작 블록 타입을 저장 할 배열
		 * 게임 시작전 블록의 타입을 설정하여 그 타입에 맞게 그려줍니다 
		 * 팡되는 경우를 제외 합니다.
		 */		
		public static function startBlockSetting(blockTypeArray : Array) : void
		{
			for(var i : int = 0; i < Block.MAX_COL; i++)
			{
				for(var j : int = 0; j < Block.MAX_ROW; j++)
				{
					if(i == 0 || i == Block.MAX_COL-1 || j == 0 || j == Block.MAX_ROW-1)
					{
						blockTypeArray[i][j] = Block.WALL;
						continue;
					}
							
					while(true)
					{
						blockTypeArray[i][j] = UtilFunction.random(1, 7, 1);
							
						if(i - 2 > 0)
						{
							if(blockTypeArray[i-1][j] == blockTypeArray[i][j] 
								&& blockTypeArray[i-2][j] == blockTypeArray[i][j]) 
								continue;
						}
						
						if(j - 2 > 0)
						{
							if(blockTypeArray[i][j-1] == blockTypeArray[i][j] 
								&& blockTypeArray[i][j-2] == blockTypeArray[i][j]) 
								continue;
						}
							
						break;
					}
				}
			}
		}
		
		/**
		 * 팡이 되는 경우가 있는 지 검사 합니다.
		 * @param blockArray 게임 블록의 배열
		 * @return 검사 여부 
		 */		
		public static function checkEmptyPang(blockArray : Array) : Boolean
		{
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
					if(i - 2 > 0)
					{
						if(blockArray[i-1][j].blockType == blockArray[i][j].blockType 
							&& blockArray[i-2][j].blockType == blockArray[i][j].blockType) 
							return false;
					}
					
					if(j - 2 > 0)
					{
						if(blockArray[i][j-1].blockType == blockArray[i][j].blockType 
							&& blockArray[i][j-2].blockType == blockArray[i][j].blockType) 
							return false;
					}
				}
			}
			return true;
		}
		
		/**
		 * 한 번의 움직임으로 팡의 가능 여부를 검사합니다. (총 16가지의 패턴검사)
		 * @param blockArray 블록의 배열
		 * @return 팡가능 여부 리턴
		 * 
		 */		
		public static function checkPossiblePang(blockArray : Array) : Boolean
		{
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
					var index : Point = new Point(i,j);
					
					if(pattern.checkAllPattern(blockArray,index))
					{
						//한 번의 움직임으로 팡이 가능 할 경우의 블록을 힌트블록에 담습니다.
						_hintPang = blockArray[j][i];
						return true;
					}
						
					
					index = null;
				}
			}
			
			return false;
		}
		
		/**
		 * 사용자가 움직인 블록의 방향에 따라 팡을 체크하고 팡이 될 경우 제거 합니다.
		 * @param curBlock 		사용자가 움직인 블록
		 * @param targetBlock	사용자가 움직인 방향에 있는 블록
		 * @param blockArray    게임내 블록 배열
		 * @param moveDirect    움직인 방향
		 * @return 
		 * 
		 */		
		public static function checkMovePang(curBlock : Block, targetBlock : Block, blockArray : Array, moveDirect : int) : Boolean
		{
			var curBlockX : int = curBlock.blockX;
			var curBlockY : int= curBlock.blockY;
			
			var removecurBlockVector : Vector.<Block>;
			var removetargetBlockVector : Vector.<Block>;
			
			switch(moveDirect)
			{
				case PlayView.UP_MOVE:
				{
					removecurBlockVector = verticalMoveCheck(curBlock, blockArray, PlayView.UP_MOVE);
					if(targetBlock != null)
						removetargetBlockVector = verticalMoveCheck(targetBlock, blockArray, PlayView.DOWN_MOVE);
					break;
				}
				
				case PlayView.DOWN_MOVE:
				{
					removecurBlockVector = verticalMoveCheck(curBlock, blockArray, PlayView.DOWN_MOVE);
					if(targetBlock != null)
						removetargetBlockVector = verticalMoveCheck(targetBlock, blockArray, PlayView.UP_MOVE);
					break;
				}
					
				case PlayView.LEFT_MOVE:
				{
					removecurBlockVector = horizonMoveCheck(curBlock, blockArray, PlayView.LEFT_MOVE);
					if(targetBlock != null)
						removetargetBlockVector = horizonMoveCheck(targetBlock, blockArray, PlayView.RIGHT_MOVE);
					break;
				}
					
				case PlayView.RIGHT_MOVE:
				{
					removecurBlockVector = horizonMoveCheck(curBlock, blockArray, PlayView.RIGHT_MOVE);
					if(targetBlock != null)
						removetargetBlockVector = horizonMoveCheck(targetBlock, blockArray, PlayView.LEFT_MOVE);
					break;
				}
			}
			
			if(removecurBlockVector != null || removetargetBlockVector != null)
			{
				romoveBlock(removecurBlockVector, removetargetBlockVector);
				return true;
			}
			else
				return false;
		}
		
		/**
		 * @param removecurBlockVector		사용자가 움직인 블록을 기준으로 팡이 되어서 사라질 블록들
		 * @param removetargetBlockVector   사용자가 움직인 곳에 있던 블록의 팡이 되어서 사라질 블록들
		 */		
		private static function romoveBlock(removecurBlockVector : Vector.<Block>, removetargetBlockVector : Vector.<Block>) : void
		{
			if(removecurBlockVector != null)
			{
				var curlenght : int = removecurBlockVector.length;
				for(var i : int = 0; i < curlenght; i ++)
					removecurBlockVector.pop().blockType = 0;
			}
			
			if(removetargetBlockVector != null)
			{
				var targetlenght : int = removetargetBlockVector.length;
				for(var j : int = 0; j < targetlenght; j ++)
					removetargetBlockVector.pop().blockType = 0;
			}
			
			removecurBlockVector = null;
			removetargetBlockVector = null;
		}
		
		/**
		 * 사용자가 블록을 움직인 방향이 수평일 경우
		 * @param block			사용자가 선택 한 블록
		 * @param blockArray	게임내 블록
		 * @param moveDirect    왼쪽, 오른쪽
		 * @return 
		 * 
		 */		
		private static function horizonMoveCheck(block : Block, blockArray : Array, moveDirect : Number) : Vector.<Block>
		{
			var blockY : int = block.blockY;
			var blockX : int = block.blockX;
			var removeBlockVector : Vector.<Block> = new Vector.<Block>;

			while(blockY >= 1)
			{
				blockY--;
				
				if(block.blockType == blockArray[blockY][blockX].blockType)
				{
					removeBlockVector.push(blockArray[blockY][blockX]);
				}
				else
					break;
			}
			
			blockY = block.blockY;
			
			while(blockY <= Block.MAX_COL - 1)
			{
				blockY++;
				if(block.blockType == blockArray[blockY][blockX].blockType)
				{
					removeBlockVector.push(blockArray[blockY][blockX]);
				}
				else
					break;
			}
			
			var xCnt : Number = 0;
			
			blockY = block.blockY;
			
			if(removeBlockVector.length < 2)
			{
				removeBlockVector = null;
				removeBlockVector = new Vector.<Block>;	
			}
			
			if(moveDirect == PlayView.RIGHT_MOVE)
			{
				while(blockX <= Block.MAX_ROW - 1)
				{
					blockX++;
					if(block.blockType == blockArray[blockY][blockX].blockType)
					{
						removeBlockVector.push(blockArray[blockY][blockX]);
						xCnt++;
					}
					else
						break;
				}
			}
			
			else
			{
				while(blockX >= 1)
				{
					blockX--;
					if(block.blockType == blockArray[blockY][blockX].blockType)
					{
						removeBlockVector.push(blockArray[blockY][blockX]);
						xCnt++;
					}
					else
						break;
				}
			}
			
			if(xCnt == 1) removeBlockVector.pop();
			
			if(removeBlockVector.length >= 2)
			{
				removeBlockVector.push(block);
				return removeBlockVector;
			}
			else
				return null;
		}
		
		/**
		 * 사용자가 블록을 움직인 방향이 수직인 경우
		 * @param block			사용자가 선택 한 블록
		 * @param blockArray	게임내 블록
		 * @param moveDirect    위쪽, 아래쪽
		 * @return 
		 * 
		 */	
		private static function verticalMoveCheck(block : Block, blockArray : Array, moveDirect : Number) : Vector.<Block>
		{
			var blockY : int = block.blockY;
			var blockX : int = block.blockX;
			var removeBlockVector : Vector.<Block> = new Vector.<Block>;
			
			while(blockX >= 1)
			{
				blockX--;
				
				if(block.blockType == blockArray[blockY][blockX].blockType)
				{
					removeBlockVector.push(blockArray[blockY][blockX]);
				}
				else
					break;
			}
			
			blockX = block.blockX;
			
			while(blockX <= Block.MAX_ROW - 1)
			{
				blockX++;
				if(block.blockType == blockArray[blockY][blockX].blockType)
				{
					removeBlockVector.push(blockArray[blockY][blockX]);
				}
				else
					break;
			}
			
			var yCnt : Number = 0;
			
			blockX = block.blockX;
			
			if(removeBlockVector.length < 2)
			{
				removeBlockVector = null;
				removeBlockVector = new Vector.<Block>;	
			}
			
			if(moveDirect == PlayView.UP_MOVE)
			{
				while(blockY >= 2)
				{
					blockY--;
					if(block.blockType == blockArray[blockY][blockX].blockType)
					{
						removeBlockVector.push(blockArray[blockY][blockX]);
						yCnt++;
					}
					else
						break;
				}
			}
				
			else
			{
				while(blockY <= Block.MAX_COL - 1)
				{
					blockY++;
					if(block.blockType == blockArray[blockY][blockX].blockType)
					{
						removeBlockVector.push(blockArray[blockY][blockX]);
						yCnt++;
					}
					else
						break;
				}
			}
			
			if(yCnt == 1) removeBlockVector.pop();
			
			if(removeBlockVector.length >= 2)
			{
				removeBlockVector.push(block);
				return removeBlockVector;
			}
			else
				return null;
		}
		
		public static function get hintPang():GeneralTypeBlock{return _hintPang;}
	}
}