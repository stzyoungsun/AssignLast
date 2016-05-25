package gameview
{
	import flash.utils.getTimer;
	
	import blockobject.Block;
	import blockobject.blocktype.GeneralTypeBlock;
	
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	
	import util.BlockTypeSetting;
	import util.UtilFunction;

	public class PlayView extends Sprite
	{
		private var _blockArray : Array = new Array();
		private var _blockTypeArray : Array = new Array();
		
		private var _upPannel : Sprite = new Sprite();
		private var _downPannel : Sprite = new Sprite();
		private var _mainPannel : Sprite = new Sprite();
		
		private var _clickedBlock : Vector.<Block> = new Vector.<Block>;
		
		public static const UP_MOVE : int = 0;
		public static const DOWN_MOVE : int = 1;
		public static const LEFT_MOVE : int = 2;
		public static const RIGHT_MOVE : int = 3;
		
		private static const DOWN_START : Number = 0;
		private static const DOWN_MOVING : Number = 1;
		private static const DOWN_COMPLETE : Number = 2;
		
		private var _globalX : Number;
		private var _globalY : Number;
	
		private var _preHintTimer : Number = 0;
		
		public function PlayView()
		{
			for(var i : int = 0; i < Block.MAX_COL; i++)
			{
				_blockTypeArray[i] = new Array();
				for(var j : int = 0; j < Block.MAX_ROW; j++)
				{
					_blockTypeArray[i][j] = new Array();
				}
			}
			//블록 배열을 초기화 합니다.
			initBlockArray();
			//위쪽 패널을 초기화 합니다.
			initUpPannel();
			//아래쪽 패널을 초기화 합니다.
			initDownPannel();
			//게임 화면을 초기화 합니다.
			ininMainPannel();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			//한 번의 움직으로 팡이 가능여부 판단
			if(BlockTypeSetting.checkPossiblePang(_blockArray) == true)
			{
				var curHintTimer : Number = getTimer();
				
				//팡이 가능 하면 힌트 팡 2초마다 출력 (현재 테스트로 0.2초)
				if(curHintTimer - _preHintTimer > 200)
				{
					BlockTypeSetting.hintPang.showCryState();
				}
				
				else
				{
					BlockTypeSetting.hintPang.showIdleState();
				}	
			}
			//한 번의 움직으로 팡이 가능 한 경우가 없으면
			else
			{
				//모든 불록이 가득 찰 경우
				if(checkFull() == true)
				{
					//블록을 랜덤으로 섞음
					trace("터질 꺼 없음");
					_preHintTimer = getTimer();
					BlockTypeSetting.hintPang.showIdleState();
					UtilFunction.shuffle(_blockArray, 8);
				}
			}
			//위쪽 라인이 비었을 경우
			if(checkEmpty() == true)
			{
				//새로운 블록 생성
				trace("터질 꺼 있음");
				createRandomBlock();
			}
			//블록은 중력의 중력
			downMovingBlock();
		}
		
		/**
		 * 블록을 랜덤하게 생성 후 아래쪽 팡여부 체크
		 */		
		private function createRandomBlock():void
		{
			for(var j : int = 1; j < Block.MAX_ROW-1; j++)
			{
				var randomType : int = UtilFunction.random(1,7,1);
				if(_blockArray[1][j].blockType == 0)
					_blockArray[1][j].blockType = randomType;
				
				BlockTypeSetting.checkMovePang(_blockArray[1][j], null, _blockArray, DOWN_MOVE);
			}
		}
		
		/**
		 * 모든 블록들이 가득 차있는 경우 판단
		 * return 가득 차 있을 경우 true
		 */		
		private function checkFull():Boolean
		{
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
					if(_blockArray[i][j].blockType == 0)
						return false;
				}
			}
			return true;
		}
		
		/**
 		 * 위쪽 라인이 비었을 경우 체크
		 * @return 위쪽 라인이 비었을 경우 true
		 */		
		private function checkEmpty():Boolean
		{
			for(var j : int = 1; j < Block.MAX_ROW-1; j++)
			{
				if(_blockArray[1][j].blockType == 0)
					return true;
			}
			return false;
		}
		
		/**
		 * 블록의 중력 작용 블록은 항상 아래쪽으로 힘을 받고 있음
		 */		
		private function downMovingBlock():void
		{
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
				
					if(_blockArray[i+1][j].blockType == Block.BLOCK_REMOVE)
					{
						_blockArray[i][j].y += AniPang.stageHeight/30;
						BlockTypeSetting.hintPang.showIdleState();
						if(_blockArray[i][j].y >= _blockArray[i+1][j].y)
						{
							_blockArray[i][j].y = _blockArray[i+1][j].y - _blockArray[i][j].height;
								
							var swapTemp : int = _blockArray[i][j].blockType;
							_blockArray[i][j].blockType = _blockArray[i+1][j].blockType;
							_blockArray[i+1][j].blockType = swapTemp;
							
							if(_blockArray[i+2][j].blockType != Block.BLOCK_REMOVE)	
							{
								BlockTypeSetting.checkMovePang(_blockArray[i+1][j], null, _blockArray, DOWN_MOVE);
							}	
						}
					}
				}
			}
		}
		
		/** 
		 * 실제 게임을 하는 중앙 화면
		 */		
		private function ininMainPannel():void
		{

			while(BlockTypeSetting.checkPossiblePang(_blockArray) == false)
			{
				UtilFunction.shuffle(_blockArray, 8);
			}
			
			for(var i : int = 1; i < Block.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Block.MAX_ROW-1; j++)
				{
					_blockArray[i][j].drawBlock();
					addChild(_blockArray[i][j] as Block);
					_blockArray[i][j].addEventListener(TouchEvent.TOUCH, onBlockClicked);
				}
			}
		}
		
		/**
		 * @param event
		 * 블록이 클릭 되었을 경우
		 */		
		private function onBlockClicked(event : TouchEvent) : void
		{
			var touch : Touch = event.getTouch(this);
			
			if(touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
					{
						//전에 클릭 된 블록이 있을 경우 전에 클릭 된 블록은 일반 상태로 변경
						if(_clickedBlock.length != 0)
						{
							_clickedBlock[0].showIdleState();
							_clickedBlock.pop();
						}
						//클릭 된 블록은 cry 상태로 변경
						_clickedBlock.push(event.currentTarget);
						_clickedBlock[0].showCryState();
						
						_globalX = touch.globalX;
						_globalY = touch.globalY;
						break;
					}
					
					case TouchPhase.ENDED:
					{
						var intervalX : Number = touch.globalX - _globalX;
						var intervalY : Number = touch.globalY - _globalY;
						//BEGAM, ENDED의 차이를 구해서 어느 정도 차이가 날 경우 Move로 인식
						if(Math.abs(intervalX) >= Math.abs(intervalY) && (Math.abs(intervalX) > 10 || Math.abs(intervalY) > 10))
						{
							if(intervalX <= 0)
							{
								swapBlock(_clickedBlock[0], _blockArray[_clickedBlock[0].blockY][_clickedBlock[0].blockX-1], LEFT_MOVE);
							}
							else
							{
								swapBlock(_clickedBlock[0], _blockArray[_clickedBlock[0].blockY][_clickedBlock[0].blockX+1], RIGHT_MOVE);
							}
						}
						else if(Math.abs(intervalX) < Math.abs(intervalY) && (Math.abs(intervalX) > 10 || Math.abs(intervalY) > 10))
						{
							if(intervalY <= 0)
							{
								swapBlock(_clickedBlock[0], _blockArray[_clickedBlock[0].blockY - 1][_clickedBlock[0].blockX],UP_MOVE);
							}
							else
							{
								swapBlock(_clickedBlock[0], _blockArray[_clickedBlock[0].blockY + 1][_clickedBlock[0].blockX], DOWN_MOVE);
							}
						}
					}
						
					default:
					{
						break;
					}
				}
			}
				
		}
		
		/**
		 * 
		 * @param curBlock 		사용자가 클릭 한 블록
		 * @param targetBlock	사용자가 움직인 곳에 놓여있는 블록
		 * @param moveDirect    사용자가 움직인 방향
		 * 
		 */		
		public function swapBlock(curBlock : Block, targetBlock : Block, moveDirect : int) : void
		{
			var swapTemp : int = curBlock.blockType;
			curBlock.blockType = targetBlock.blockType;
			targetBlock.blockType = swapTemp;
		
			if(BlockTypeSetting.checkMovePang(targetBlock, curBlock, _blockArray, moveDirect) == false)
			{
				swapTemp  = curBlock.blockType;
				curBlock.blockType = targetBlock.blockType;
				targetBlock.blockType = swapTemp;
			}
			else
			{
				BlockTypeSetting.hintPang.showIdleState();
				_preHintTimer = getTimer();
			}
			
			(curBlock as GeneralTypeBlock).showIdleState();
			(targetBlock as GeneralTypeBlock).showIdleState();
		}
		
		/** 
		 * 아래쪽 화면
		 */		
		private function initDownPannel():void
		{
		
			
		}
		
		/** 
		 * 점수, 시간 등이 나오는 위쪽 화면
		 */		
		private function initUpPannel():void
		{
			
			
		}
		
		/** 
		 * 블록의 초기화
		 */		
		private function initBlockArray() : void
		{
			BlockTypeSetting.startBlockSetting(_blockTypeArray);
			
			for(var i : int = 0; i < Block.MAX_COL; i++)
			{
				_blockArray[i] = new Array();
				for(var j : int = 0; j < Block.MAX_ROW; j++)
				{
					//블록의 타입 배열에 따라 객체 생성
					switch(_blockTypeArray[i][j])
					{
						case Block.WALL:
						{
							_blockArray[i][j] = new Block();
							_blockArray[i][j].initBlock(i, j);
							_blockArray[i][j].blockType = _blockTypeArray[i][j]
							break;
						}
						
						default:
						{
							_blockArray[i][j] = new GeneralTypeBlock();
							_blockArray[i][j].initBlock(i, j);
							_blockArray[i][j].blockType = _blockTypeArray[i][j];
							break;
						}
					}
				}
			}
		}
	}
}