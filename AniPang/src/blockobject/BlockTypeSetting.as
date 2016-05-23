package blockobject
{
	import util.UtilFunction;

	public class BlockTypeSetting
	{
		public function BlockTypeSetting(){throw new Error("Abstract Class");}
		
		public static function startBlockSetting(blockArray : Array) : void
		{
			while(true)
			{
				for(var i : int = 1; i < Block.MAX_COL-1; i++)
				{
					for(var j : int = 1; j < Block.MAX_ROW-1; j++)
					{
						while(true)
						{
							blockArray[i][j].blockType = UtilFunction.random(1, 100, 1);
							
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
				trace(pangCheck(blockArray));
				if(pangCheck(blockArray) == true) break;
				else continue;
			}
			var temp : String;
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				temp += "\n";
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
					temp += String(blockArray[i][j].blockType) +",";
				}
				temp += "\n";
			}
			trace(temp);
		}
		
		public static function pangCheck(blockArray : Array) : Boolean
		{
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
					try
					{
						//오른쪽 이동시 팡이 될 경우                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
						if(blockArray[i-1][j+1].blockType == blockArray[i][j].blockType && blockArray[i+1][j+1].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i][j+2].blockType == blockArray[i][j].blockType && blockArray[i][j+3].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i+1][j+1].blockType == blockArray[i][j].blockType && blockArray[i+2][j+1].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i-1][j+1].blockType == blockArray[i][j].blockType && blockArray[i-2][j+1].blockType == blockArray[i][j].blockType) return true;
						
						//왼쪽 이동시 팡이 될 경우                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
						if(blockArray[i+1][j-1].blockType == blockArray[i][j].blockType && blockArray[i-1][j-1].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i+1][j-1].blockType == blockArray[i][j].blockType && blockArray[i+2][j-1].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i-1][j-1].blockType == blockArray[i][j].blockType && blockArray[i-2][j+1].blockType == blockArray[i][j].blockType) return true;
						
						
						//위족 이동시 팡이 될 경우                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
						if(blockArray[i-1][j-1].blockType == blockArray[i][j].blockType && blockArray[i-1][j+1].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i-1][j+1].blockType == blockArray[i][j].blockType && blockArray[i-1][j+2].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i-1][j-1].blockType == blockArray[i][j].blockType && blockArray[i-1][j-2].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i+1][j-1].blockType == blockArray[i][j].blockType && blockArray[i+1][j-2].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i-2][j].blockType == blockArray[i][j].blockType && blockArray[i-3][j].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i][j-2].blockType == blockArray[i][j].blockType && blockArray[i][j-3].blockType == blockArray[i][j].blockType) return true;
						
						//아래쪽 이동시 팡이 될 경우                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
						if(blockArray[i+1][j-1].blockType == blockArray[i][j].blockType && blockArray[i+1][j+1].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i+1][j+1].blockType == blockArray[i][j].blockType && blockArray[i+1][j+2].blockType == blockArray[i][j].blockType) return true;
						if(blockArray[i+2][j].blockType == blockArray[i][j].blockType && blockArray[i+3][j].blockType == blockArray[i][j].blockType) return true;
					}
					
				   catch(blockArray)
				   {
					
				   }
				}
			}
			return false;
		}
	}
}