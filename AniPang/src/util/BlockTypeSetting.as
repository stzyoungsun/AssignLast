package util
{
	import flash.geom.Point;
	
	import blockobject.Block;
	import blockobject.pattern;
	import blockobject.blocktype.GeneralTypeBlock;
	
	import gameview.PlayView;

	public class BlockTypeSetting
	{
		private static var _hintPang : GeneralTypeBlock;
		
		public function BlockTypeSetting(){throw new Error("Abstract Class");}
		
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
							
						if(i - 2 <= 0 && j - 2 <= 0) break;
							
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
		
		public static function checkPossiblePang(blockArray : Array) : Boolean
		{
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
					var index : Point = new Point(i,j);
					
					if(pattern.checkAllPattern(blockArray,index))
					{
						_hintPang = blockArray[j][i];
						return true;
					}
						
					
					index = null;
				}
			}
			
			return false;
		}
		
		public static function checkPang(curBlock : Block, targetBlock : Block, blockArray : Array, moveDirect : int) : Boolean
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