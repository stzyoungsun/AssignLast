package blockobject
{
	import util.UtilFunction;

	public class BlockTypeSetting
	{
		public function BlockTypeSetting(){throw new Error("Abstract Class");}
		
		public static function startBlockSetting(blockArray : Array) : void
		{
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
					while(true)
					{
						blockArray[i][j].blockType = UtilFunction.random(1, 2, 1);
						
						if(i - 2 <= 0 && j - 2 <= 0) break;
						
						if(i - 2 > 0)
						{
							if(blockArray[i-1][j].blockType == blockArray[i][j].blockType 
								&& blockArray[i-2][j].blockType == blockArray[i][j].blockType) 
								continue;
						}
							
						if(j - 2 > 0)
						{
							if(blockArray[i][j-1].blockType == blockArray[i][j].blockType 
								&& blockArray[i][j-2].blockType == blockArray[i][j].blockType) 
								continue;
						}
							
						break;
					}
				}
			}
		}
		
	}
}