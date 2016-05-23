package gameview
{
	import blockobject.Block;
	import blockobject.BlockTypeSetting;
	
	import starling.display.Sprite;

	public class PlayView extends Sprite
	{
		private var _blockArray : Array = new Array();
		
		public function PlayView()
		{
			initBlockArray();
		}
		
		private function initBlockArray() : void
		{
			for(var i : int = 0; i < Block.MAX_COL; i++)
			{
				_blockArray[i] = new Array();
				for(var j : int = 0; j < Block.MAX_ROW; j++)
				{
					_blockArray[i][j] = new Block();
					_blockArray[i][j].initBlock(i, j);
				}
			}
			
			BlockTypeSetting.startBlockSetting(_blockArray);
		}
	}
}