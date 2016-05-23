package blockobject
{
	public class Block 
	{
		private static const WALL : int = -1;
		private static const BLOCK_MONKEY : int = 		1;
		private static const BLOCK_CHICK : int = 		2;
		private static const BLOCK_DOG : int = 			3;
		private static const BLOCK_RABBIT : int = 		4;
		private static const BLOCK_RAT : int = 			5;
		private static const BLOCK_PIG : int = 			6;
		private static const BLOCK_CAT : int = 			7;
		
		private static const BLOCK_FIRE : int = 		8;
		private static const BLOCK_LINE : int = 		9;
		private static const BLOCK_CIRCLE : int = 		10;
		private static const BLOCK_RANDOM : int = 		11;
		
		public static const MAX_COL : uint = 9;
		public static const MAX_ROW : uint = 9;
		
		private var _blockX : Number;
		private var _blockY : Number;
		private var _blockType : int;
		
		public function Block()
		{
			
		}
		
		/**
		 * 
		 * @param posX 블럭의 배열 세로 위치
		 * @param posY 블럭의 배열 가로 위치
		 * @param blockType 블럭의 타입
		 * 
		 */		
		public function initBlock(posCol : Number, posRow : Number) : void
		{
			if(posCol == 0 || posCol == MAX_COL-1 || posRow == 0 || posRow == MAX_ROW-1)
				_blockType = WALL;
			
			_blockX = posCol;
			_blockY = posRow;
		}
		
		public function get blockType():int{return _blockType;}
		public function set blockType(value:int):void{_blockType = value;}
	}
}