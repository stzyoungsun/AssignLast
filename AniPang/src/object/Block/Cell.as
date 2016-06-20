package object.Block
{
	import loader.TextureManager;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class Cell extends Sprite
	{
		private var _cellX : int;
		private var _cellY : int;
		private var _cellType : int;
		
		private var _block : Block;
		private var _blockAtlas : TextureAtlas;
		
		public static const MAX_COL : uint = 9;
		public static const MAX_ROW : uint = 9;
		
		private var _frame : Vector.<Texture>;
		public function Cell()
		{
			_blockAtlas = TextureManager.getInstance().atlasTextureDictionary["block.png"];
		}
		
		/**
		 * @param posX 셀의 배열 세로 위치
		 * @param posY 셀의 배열 가로 위치
		 */		
		public function initCell(posCol : Number, posRow : Number) : void
		{
			_cellY = posCol;
			_cellX = posRow;
		}
		
		/** 
		 * cellType에 맞게 블록을 그립니다.
		 */		
		public function drawBlock() : void
		{
			checkcellType();
			_block = new Block(_frame, this);
			Starling.juggler.add(_block);
			_block.blockType = cellType;
			this.x = (_cellX-1)*_block.width;
			this.y = (_cellY-1)*_block.height;
			
			addChild(_block);
			_frame = null;
		}
		
		/** 
		 * @return 블록타입에 따라 리소스를 리턴합니다.
		 * 
		 */		
		private function checkcellType(): void
		{
			if(_block != null)
				_block.visible = true;
			
			switch(_cellType)
			{
				case Block.BLOCK_CHICK:
				{
					_frame = _blockAtlas.getTextures("chick");
					break;
				}
					
				case Block.BLOCK_MONKEY:
				{
					_frame = _blockAtlas.getTextures("monkey");
					break;
				}
					
				case Block.BLOCK_RAT:
				{
					_frame = _blockAtlas.getTextures("rat");
					break;
				}
					
				case Block.BLOCK_PIG:
				{
					_frame =  _blockAtlas.getTextures("pig");
					break;
				}
					
				case Block.BLOCK_DOG:
				{
					_frame =  _blockAtlas.getTextures("dog");
					break;
				}
					
				case Block.BLOCK_RABBIT:
				{
					_frame = _blockAtlas.getTextures("rabbit");
					break;
				}
					
				case Block.BLOCK_CAT:
				{
					_frame =  _blockAtlas.getTextures("cat");
					break;
				}
					
				case Block.BLOCK_MAO:
				{
					_frame = _blockAtlas.getTextures("mao");
					break;
				}
					
				case Block.BLOCK_RANDOM:
				{
					_frame = _blockAtlas.getTextures("random");
					break;
				}
					
				case Block.BLOCK_FIRE:
				{
					_frame = _blockAtlas.getTextures("fire");
					break;
				}
					
				case Block.BLOCK_PANG:
				{
					_frame = _blockAtlas.getTextures("pang");
					break;
				}
				
				case Block.BLOCK_REMOVE:
				{
					_block.visible = false;
					break
				}
			}
		}
		
		public function get cellType():int{return _cellType;}
		public function set cellType(value:int):void{
			_cellType = value;
			if(_block != null)
			{
				_block.stop();
				checkcellType();
				_block.blockType = _cellType;
				_block.frames = _frame;
				_block.drawFlag = true;
			}
		}
		
		public function get cellY():Number{return _cellY;}
		public function set cellY(value:Number):void{_cellY = value;}
		
		public function get cellX():Number{return _cellX;}
		public function set cellX(value:Number):void{_cellX = value;}
		
		public function get block():Block{return _block;}
		public function set block(value:Block):void{_block = value;}
	}
}