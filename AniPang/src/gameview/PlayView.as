package gameview
{
	import flash.utils.getTimer;
	
	import loader.TextureManager;
	
	import object.Block.Block;
	import object.Block.Cell;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	import timer.Timer;
	
	import util.BlockTypeSetting;
	import util.UtilFunction;

	public class PlayView extends Sprite
	{
		private var _gameViewAtlas : TextureAtlas;
		private var _cellArray : Array = new Array();
		
		private var _upPannel : Sprite = new Sprite();
		private var _downPannel : Sprite = new Sprite();
		private var _mainPannel : Sprite = new Sprite();
		
		private var _clickedCell : Vector.<Cell> = new Vector.<Cell>;
		
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
		
		private var _backGround : Image;
		private var _gameWindowImage : Image;
		private var _gameWindow : Sprite;
		
		private var _upPannelImage : Image;
		private var _fireBlockAnimaiton : MovieClip;
		private var _pauseImage : Image;
		
		private var _timer : Timer;
		
		public function PlayView()
		{
			_gameViewAtlas = TextureManager.getInstance().atlasTextureDictionary["gameView.png"];
			
			_backGround = new Image(TextureManager.getInstance().textureDictionary["back.png"]);
			_backGround.width = AniPang.stageWidth;
			_backGround.height = AniPang.stageHeight;
			
			_gameWindow = new Sprite();
			_gameWindow.x = 0;
			_gameWindow.y = AniPang.stageHeight*2/9;
			_gameWindow.width = AniPang.stageWidth;
			_gameWindow.height = AniPang.stageHeight*2/3;
			
			_gameWindowImage = new Image(TextureManager.getInstance().textureDictionary["place.png"])
			_gameWindowImage.width = AniPang.stageWidth;
			_gameWindowImage.height = AniPang.stageHeight*2/3;
			
			addChild(_backGround);
			addChild(_gameWindow);
			_gameWindow.addChild(_gameWindowImage);
			//블록 배열을 초기화 합니다.
			initBlockArray();
			//위쪽 패널을 초기화 합니다.
			initUpPannel();
			//아래쪽 패널을 초기화 합니다.
			initDownPannel();
			//게임 화면을 초기화 합니다.
			ininMainPannel();
			
			addChild(_upPannel);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			//한 번의 움직으로 팡이 가능여부 판단
			if(BlockTypeSetting.checkPossiblePang(_cellArray) == true)
			{
				var curHintTimer : Number = getTimer();
				
				//팡이 가능 하면 힌트 팡 2초마다 출력 (현재 테스트로 0.2초)
				if(curHintTimer - _preHintTimer > 2000)
				{
					BlockTypeSetting.hintPang.block.showCryState();
				}
				
				else
				{
					BlockTypeSetting.hintPang.block.showIdleState();
				}	
			}
			//한 번의 움직으로 팡이 가능 한 경우가 없으면
			else
			{
				//모든 불록이 가득 찰 경우
				if(checkFull() == true)
				{
					//블록을 랜덤으로 섞음
					_preHintTimer = getTimer();
					BlockTypeSetting.hintPang.block.showIdleState();
					UtilFunction.shuffle(_cellArray, 8);
				}
			}
			
			//위쪽 라인이 비었을 경우
			var rowValue : int = checkEmpty();
			if(rowValue != -1)
			{
				//새로운 블록 생성
				createRandomBlock(rowValue);
			}
			
			//블록에 빈공간이 있을 경우 다운
			if(checkFull() == false)
				downMovingBlock();
		}
		
		/**
		 * 블록을 랜덤하게 생성 후 아래쪽 팡여부 체크
		 */		
		private function createRandomBlock(rowValue : int):void
		{
			var randomType : int = UtilFunction.random(1,7,1);
			_cellArray[1][rowValue].cellType = randomType;
			BlockTypeSetting.checkMovePang(_cellArray[1][rowValue], null, _cellArray, DOWN_MOVE);	
		}
		
		/**
		 * 모든 블록들이 가득 차있는 경우 판단
		 * return 가득 차 있을 경우 true
		 */		
		private function checkFull():Boolean
		{
			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
				{
					if(_cellArray[i][j].cellType == Block.BLOCK_REMOVE
						||_cellArray[i][j].cellType == Block.BLOCK_PANG)
						return false;
				}
			}
			return true;
		}
		
		/**
 		 * 위쪽 라인이 비었을 경우 체크
		 * @return 위쪽 라인이 비었을 경우 true
		 */		
		private function checkEmpty(): int
		{
			for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
			{
				if(_cellArray[1][j].cellType == Block.BLOCK_REMOVE)
					return j;
			}
			return -1;
		}
		
		/**
		 * 빈공간이 생겼을 경우 아래쪽으로 내려감
		 */		
		private function downMovingBlock():void
		{
			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
				{
				
					if(_cellArray[i+1][j].cellType == Block.BLOCK_REMOVE)
					{
						_cellArray[i][j].y += AniPang.stageHeight/30;
						BlockTypeSetting.hintPang.block.showIdleState();
						if(_cellArray[i][j].y >= _cellArray[i+1][j].y)
						{
							_cellArray[i][j].y = _cellArray[i+1][j].y - _cellArray[i][j].height;
					
							var swapTemp : int = _cellArray[i][j].cellType;
							_cellArray[i][j].cellType = _cellArray[i+1][j].cellType;
							_cellArray[i+1][j].cellType = swapTemp;
							
							if(_cellArray[i+2][j].cellType != Block.BLOCK_REMOVE 
								|| _cellArray[i+2][j].cellType != Block.BLOCK_PANG)	
							{
								BlockTypeSetting.checkMovePang(_cellArray[i+1][j], null, _cellArray, DOWN_MOVE);
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

			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
				{
					_cellArray[i][j].drawBlock();
					_gameWindow.addChild(_cellArray[i][j] as Cell);
					_cellArray[i][j].addEventListener(TouchEvent.TOUCH, onBlockClicked);
				}
			}
		}
		
		/**
		 * @param event
		 * 블록이 클릭 되었을 경우
		 */		
		private function onBlockClicked(event : TouchEvent) : void
		{
			var touch : Touch = event.getTouch(_gameWindow);
			if(touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.BEGAN:
					{
						if((event.currentTarget as Cell).cellType == Block.BLOCK_RANDOM)
						{
							BlockTypeSetting.hintPang.block.showIdleState();
							(event.currentTarget as Cell).cellType = Block.BLOCK_PANG;
							clickedRandomBlock();
							return;
						}
							
						//전에 클릭 된 블록이 있을 경우 전에 클릭 된 블록은 일반 상태로 변경
						if(_clickedCell.length != 0)
						{
							_clickedCell[0].block.showIdleState();
							_clickedCell.pop();
						}
						//클릭 된 블록은 cry 상태로 변경
						_clickedCell.push(event.currentTarget);
						_clickedCell[0].block.showCryState();
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
								swapCell(_clickedCell[0], _cellArray[_clickedCell[0].cellY][_clickedCell[0].cellX-1], LEFT_MOVE);
							}
							else
							{
								swapCell(_clickedCell[0], _cellArray[_clickedCell[0].cellY][_clickedCell[0].cellX+1], RIGHT_MOVE);
							}
						}
						else if(Math.abs(intervalX) < Math.abs(intervalY) && (Math.abs(intervalX) > 10 || Math.abs(intervalY) > 10))
						{
							if(intervalY <= 0)
							{
								swapCell(_clickedCell[0], _cellArray[_clickedCell[0].cellY - 1][_clickedCell[0].cellX],UP_MOVE);
							}
							else
							{
								swapCell(_clickedCell[0], _cellArray[_clickedCell[0].cellY + 1][_clickedCell[0].cellX], DOWN_MOVE);
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
		
		private function clickedRandomBlock():void
		{
			var randomValue : int = UtilFunction.random(1,7,1);
			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
				{
					if(_cellArray[i][j].cellType == randomValue)
						_cellArray[i][j].cellType = Block.BLOCK_PANG;
				}
			}
		}
		
		/**
		 * 
		 * @param curCell 		사용자가 클릭 한 블록
		 * @param targetCell	사용자가 움직인 곳에 놓여있는 블록
		 * @param moveDirect    사용자가 움직인 방향
		 * 
		 */		
		public function swapCell(curCell : Cell, targetCell : Cell, moveDirect : int) : void
		{
			if(targetCell.cellType == Block.WALL) return;
			if(targetCell.cellType == Block.BLOCK_PANG) return;
			if(targetCell.cellType == Block.BLOCK_REMOVE) return;
			
			var swapTemp : int = curCell.cellType;
			curCell.cellType = targetCell.cellType;
			targetCell.cellType = swapTemp;
		
			if(BlockTypeSetting.checkMovePang(targetCell, curCell, _cellArray, moveDirect) == false)
			{
				swapTemp  = curCell.cellType;
				curCell.cellType = targetCell.cellType;
				targetCell.cellType = swapTemp;
			}
			else
			{
				BlockTypeSetting.hintPang.block.showIdleState();
				_preHintTimer = getTimer();
			}
			
			curCell.block.showIdleState();
			targetCell.block.showIdleState();
		}
		
		/** 
		 * 아래쪽 화면
		 */		
		private function initDownPannel():void
		{
			_timer = new Timer();
			_timer.timeInit(0, AniPang.stageHeight*0.92, AniPang.stageWidth, AniPang.stageHeight*0.05);
			_timer.start();
			
			_timer.addEventListener("exit", onExit);
			addChild(_timer);
		}
		
		/** 
		 * 점수, 시간 등이 나오는 위쪽 화면
		 */		
		private function initUpPannel():void
		{
			_upPannel.x = 0;
			_upPannel.y = AniPang.stageHeight/30;
				
			_upPannelImage = new Image(_gameViewAtlas.getTexture("statusbar"));
			_upPannelImage.width = AniPang.stageWidth;
			_upPannelImage.height = AniPang.stageHeight/6;
			
			_fireBlockAnimaiton = new MovieClip(_gameViewAtlas.getTextures("fire"),5);
			_fireBlockAnimaiton.width = _upPannelImage.height/2;
			_fireBlockAnimaiton.height = _upPannelImage.height/2;
			_fireBlockAnimaiton.x = _fireBlockAnimaiton.width*0.42;
			_fireBlockAnimaiton.y = _fireBlockAnimaiton.height*0.42;
			_fireBlockAnimaiton.play();
			Starling.juggler.add(_fireBlockAnimaiton);
			
			_pauseImage = new Image(_gameViewAtlas.getTexture("stopbtn"));
			_pauseImage.width = _fireBlockAnimaiton.width;
			_pauseImage.height = _fireBlockAnimaiton.height;
			_pauseImage.x = _upPannelImage.width - _pauseImage.width*1.5;
			_pauseImage.y = _fireBlockAnimaiton.y;
			
			_upPannel.addChild(_pauseImage);
			_upPannel.addChild(_upPannelImage);
			_upPannel.addChild(_fireBlockAnimaiton);
		}
		
		/** 
		 * 블록의 초기화
		 */		
		private function initBlockArray() : void
		{
			for(var i : int = 0; i < Cell.MAX_COL; i++)
			{
				_cellArray[i] = new Array();
				for(var j : int = 0; j < Cell.MAX_ROW; j++)
				{
					//블록의 타입 배열에 따라 객체 생성
					_cellArray[i][j] = new Cell();
					_cellArray[i][j].initCell(i, j);
				}
			}
			BlockTypeSetting.startBlockSetting(_cellArray);
		}
		
		private function onExit():void
		{
			_timer.stop();
			
			trace("종료");
		}
	}
}