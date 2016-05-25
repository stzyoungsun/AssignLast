package blockobject
{
	import flash.utils.getTimer;
	
	import blockobject.blocktype.GeneralTypeBlock;
	
	import loader.TextureManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import util.BlockTypeSetting;

	public class Block extends Sprite
	{
		public static const WALL : int = -1;
		public static const BLOCK_REMOVE : int = 		0;
		public static const BLOCK_MONKEY : int = 		1;
		public static const BLOCK_CHICK : int = 		2;
		public static const BLOCK_DOG : int = 			3;
		public static const BLOCK_PIG : int = 			4;
		public static const BLOCK_RAT : int = 			5;
		public static const BLOCK_RABBIT : int = 		6;
		public static const BLOCK_CAT : int = 			7;
		
		public static const BLOCK_FIRE : int = 		8;
		public static const BLOCK_LINE : int = 		9;
		public static const BLOCK_CIRCLE : int = 		10;
		public static const BLOCK_RANDOM : int = 		11;
		
		public static const MAX_COL : uint = 9;
		public static const MAX_ROW : uint = 9;
		
		private var _blockX : Number;
		private var _blockY : Number;
		private var _blockType : int;
		
		private var _frames : Vector.<Texture>;
		
		private var _startX : Number;
		private var _startY : Number;
		private var _blockWidth : Number;
		private var _blockHeight : Number;
		
		private var _blockAtlas : TextureAtlas;
		private var _blockView : Image;
		
		public var _blockImage : Vector.<Texture>;
		private var _preTime : Number = 0;
		public function Block()
		{
			_blockAtlas = TextureManager.getInstance().atlasTextureDictionary["block.png"];
			
			_startX = 0;
			_startY =  AniPang.stageHeight*2/9;
			
			_blockWidth = AniPang.stageWidth/7;
			_blockHeight = AniPang.stageHeight*2/21;
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function get blockView():Image
		{
			return _blockView;
		}

		public function set blockView(value:Image):void
		{
			_blockView = value;
		}

		private function onEnterFrame():void
		{
			var curTime : Number = getTimer();
		
			_blockImage = checkblockType();
			
			if(_blockView.visible == false) return;
				
			if((this as GeneralTypeBlock).faceFlag == false)
				_blockView.texture = _blockImage[0];
			else
				_blockView.texture = _blockImage[1];
				
			_blockImage.length = 0;
			_blockImage = null;
			_preTime = getTimer();
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
			_blockY = posCol;
			_blockX = posRow;
		}
		
		/** 
		 * blockType에 맞게 블록을 그립니다.
		 */		
		public function drawBlock() : void
		{
			_blockImage = checkblockType();
			_blockView = new Image(_blockImage[0]);
			
			_blockView.width = _blockWidth;
			_blockView.height = _blockHeight;
			
			this.x = (_blockX-1)*_blockWidth + _startX
			this.y = (_blockY-1)*_blockHeight + _startY
			
			addChild(_blockView);
		}
		
		/** 
		 * @return 블록타입에 따라 리소스를 리턴합니다.
		 * 
		 */		
		private function checkblockType():Vector.<Texture>
		{
			if(_blockView != null)
				_blockView.visible = true;
			
			switch(_blockType)
			{
				case BLOCK_CHICK:
				{
					return _blockAtlas.getTextures("chick");
					break;
				}
					
				case BLOCK_MONKEY:
				{
					return _blockAtlas.getTextures("monkey");
					break;
				}
					
				case BLOCK_RAT:
				{
					return _blockAtlas.getTextures("rat");
					break;
				}
					
				case BLOCK_PIG:
				{
					return _blockAtlas.getTextures("pig");
					break;
				}
					
				case BLOCK_DOG:
				{
					return _blockAtlas.getTextures("dog");
					break;
				}
					
				case BLOCK_RABBIT:
				{
					return _blockAtlas.getTextures("rabbit");
					break;
				}
					
				case BLOCK_CAT:
				{
					return _blockAtlas.getTextures("cat");
					break;
				}
				case BLOCK_REMOVE:
				{
					_blockView.visible = false;
					break
				}
					
			}
			return null;
		}
		public function get blockType():int{return _blockType;}
		public function set blockType(value:int):void{_blockType = value;}
		
		public function get blockY():Number{return _blockY;}
		public function set blockY(value:Number):void{_blockY = value;}
		
		public function get blockX():Number{return _blockX;}
		public function set blockX(value:Number):void{_blockX = value;}
	}
}