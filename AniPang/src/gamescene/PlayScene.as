package gamescene
{
	import flash.utils.getTimer;
	
	import Animation.EndClip;
	import Animation.StartClip;
	
	import UI.window.PauseWindow;
	
	import loader.TextureManager;
	
	import object.Block.Block;
	import object.Block.Cell;
	import UI.GameTextField.ComboTextField;
	import UI.Progress.Progress;
	
	import scene.SceneManager;
	
	import score.ScoreManager;
	
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import timer.Timer;
	
	import util.BlockTypeSetting;
	import util.UtilFunction;

	public class PlayScene extends Sprite
	{
		//파이어팡이 등장하는 블록 제거 개수
		private static const FIRE_DRAW_CONUT : Number = 50;
		
		private var _startClip : StartClip;
		private var _endClip : EndClip;
		//게임 텍스쳐 아틀라스
		private var _gameViewAtlas : TextureAtlas;
		//블록을 담고 있는 셀의 배열
		private var _cellArray : Array = new Array();
		//화면을 3부분으로 나눔
		private var _upPannel : Sprite = new Sprite();
		private var _downPannel : Sprite = new Sprite();
		private var _mainPannel : Sprite = new Sprite();
		//클릭 된 셀
		private var _clickedCell : Vector.<Cell> = new Vector.<Cell>;
		
		private var _globalX : Number;
		private var _globalY : Number;
		//힌트 시간
		private var _preHintTimer : Number = 0;
		//배경 화면 이미지
		private var _backGround : Image;
		//게임 판 이미지
		private var _gameWindowImage : Image;
		//게임 판의 스프라이트
		private var _gameWindow : Sprite;
		//위쪽 화면 이미지
		private var _upPannelImage : Image;
		//파이어 팡 게이지 및 애니메이션
		private var _fireBlockAnimaiton : MovieClip;
		private var _fireProgress : Progress;
		//정지 이미지
		private var _pauseImage : Button;
		
		private var _timer : Timer;
		//점수 텍스트 필드
		private var _scoreTextField : TextField;
		//콤보 텍스트 필드
		private var _comboTextField : ComboTextField;
		//블록이 살아 졌을 경우 true
		private var _findFlag : Boolean  = false;
		
		private static var _pauseFlag : Boolean = false;
		public function PlayScene()
		{
			_pauseFlag = true;
			
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
			initMainPannel();
			
			addChild(_upPannel);
			
			_startClip = new StartClip(AniPang.stageWidth/2 - AniPang.stageWidth/6, AniPang.stageHeight/2 - AniPang.stageWidth/6, AniPang.stageWidth/3, AniPang.stageWidth/2);
			_startClip.addEventListener("START", onStart);

			addChild(_startClip);
		}
		
		private function onStart():void
		{
			_startClip.removeEventListener("START", onStart);
			pauseFlag = false;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame():void
		{
			//점수텍스터 필드에 변화되는 점수를 계속 출력 합니다.	
			_scoreTextField.text = UtilFunction.makeCurrency(String(ScoreManager.instance.scoreCnt));
			drawFirePang();
			
			//한 번의 움직으로 팡이 가능여부 판단
			if(BlockTypeSetting.checkPossiblePang(_cellArray) == true)
			{
				var curHintTimer : Number = getTimer();
				
				//팡이 가능 하면 힌트 팡 3초마다 출력
				if(curHintTimer - _preHintTimer > 2000)
				{
					ScoreManager.instance.comboCnt = 0;
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
			
			//블록이 사라 졋을 경우
			if(_findFlag == true)
			{
				//블록에 빈공간이 있을 경우 다운
				if(checkFull() == false)
					downMovingBlock();
				//블록에 빈공간이 없을 경우 제거 할 블록 체크
				else
					pangCheck();
			}
		}
		
		/**
		 * 모든 블록을 순회하면서 제거 할 부분을 찾습니다.
		 */		
		private function pangCheck():void
		{
			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
				{
					BlockTypeSetting.checkMovePang(_cellArray[i][j], null, _cellArray, Block.DOWN_MOVE);
					BlockTypeSetting.checkMovePang(_cellArray[i][j], null, _cellArray, Block.UP_MOVE);
					BlockTypeSetting.checkMovePang(_cellArray[i][j], null, _cellArray, Block.LEFT_MOVE);
					BlockTypeSetting.checkMovePang(_cellArray[i][j], null, _cellArray, Block.RIGHT_MOVE);
				}
			}
			
			_findFlag = false;
		}
		
		/**
		 * 블록 파괴 개수가 50개가 될 경우 파이어 팡을 생성합니다.
		 */		
		private function drawFirePang():void
		{
			var randomX : int = UtilFunction.random(1,7,1);
			var randomY : int = UtilFunction.random(1,7,1);
			
			_fireProgress.calcValue(FIRE_DRAW_CONUT,ScoreManager.instance.pangCount);
			
			if(ScoreManager.instance.pangCount > FIRE_DRAW_CONUT)
			{
				ScoreManager.instance.fireInit();
				_cellArray[randomY][randomX].cellType = Block.BLOCK_FIRE;
			}
		}
		
		/**
		 * 블록을 랜덤하게 생성 (마오 아이템 구매 했을 경우 마오도 생성)
		 */		
		private function createRandomBlock(rowValue : int):void
		{
			var randomType : int;
			
			if(ScoreManager.instance.maoItemUse == true)
				randomType = UtilFunction.random(2,8,1);
			else
				randomType = UtilFunction.random(1,7,1);
			
			_cellArray[1][rowValue].cellType = randomType;	
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
					  || _cellArray[i][j].cellType == Block.BLOCK_PANG)
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
					//바로 아래쪽의 블록이 REMOVE 일 경우 시행
					if(_cellArray[i+1][j].cellType == Block.BLOCK_REMOVE)
					{
						_cellArray[i][j].y += AniPang.stageHeight/30;
						if(_cellArray[i][j].y >= _cellArray[i+1][j].y)
						{
							_cellArray[i][j].y = _cellArray[i+1][j].y - _cellArray[i][j].height;
					
							var swapTemp : int = _cellArray[i][j].cellType;
							_cellArray[i][j].cellType = _cellArray[i+1][j].cellType;
							_cellArray[i+1][j].cellType = swapTemp;
						}
					}
				}
			}
		}
		
		/** 
		 * 실제 게임을 하는 중앙 화면
		 */		
		private function initMainPannel():void
		{
			_comboTextField = new ComboTextField(AniPang.stageWidth/3,AniPang.stageHeight/10);

			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				for(var j : int = 1; j < Cell.MAX_ROW-1; j++)
				{
					_cellArray[i][j].drawBlock();
					_gameWindow.addChild(_cellArray[i][j] as Cell);
					_cellArray[i][j].addEventListener(TouchEvent.TOUCH, onBlockClicked);
				}
			}
			_comboTextField.x = AniPang.stageWidth*0.15;
			_comboTextField.y = AniPang.stageHeight*0.15;
			addChild(_comboTextField);
		}
		
		/**
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
						//블록이 랜덤팡일 경우 
						if((event.currentTarget as Cell).cellType == Block.BLOCK_RANDOM)
						{
							(event.currentTarget as Cell).cellType = Block.BLOCK_PANG;
							(event.currentTarget as Cell).block.showIdleState();
							clickedRandomBlock();
							return;
						}
						//블록이 파이어 팡일 경우
						if((event.currentTarget as Cell).cellType == Block.BLOCK_FIRE)
						{
							(event.currentTarget as Cell).cellType = Block.BLOCK_PANG;
							(event.currentTarget as Cell).block.showIdleState();
							clickedFireBlock(event.currentTarget as Cell);
							return;
						}
						
						var intervalX : Number = touch.globalX - _globalX;
						var intervalY : Number = touch.globalY - _globalY;
						//BEGAM, ENDED의 차이를 구해서 어느 정도 차이가 날 경우 Move로 인식
						//각각 블록의 모션에 따라 block의 moveState를 설정
						if(Math.abs(intervalX) >= Math.abs(intervalY) && (Math.abs(intervalX) > 10 || Math.abs(intervalY) > 10))
						{
							if(intervalX <= 0)
							{
								if(_clickedCell[0].cellX-1 <= 0) return;
								_clickedCell[0].block.moveState = Block.LEFT_MOVE;
								_cellArray[_clickedCell[0].cellY][_clickedCell[0].cellX-1].block.moveState =  Block.RIGHT_MOVE;
							}
							
							else
							{
								if(_clickedCell[0].cellX+1 >= Cell.MAX_ROW-1) return;
								_clickedCell[0].block.moveState = Block.RIGHT_MOVE;
								_cellArray[_clickedCell[0].cellY][_clickedCell[0].cellX+1].block.moveState =  Block.LEFT_MOVE;
							}
						}
						else if(Math.abs(intervalX) < Math.abs(intervalY) && (Math.abs(intervalX) > 10 || Math.abs(intervalY) > 10))
						{
							if(intervalY <= 0)
							{
								if(_clickedCell[0].cellY-1 <= 0) return;
								_clickedCell[0].block.moveState = Block.UP_MOVE;
								_cellArray[_clickedCell[0].cellY-1][_clickedCell[0].cellX].block.moveState =  Block.DOWN_MOVE;
							}
							
							else
							{
								if(_clickedCell[0].cellY+1 >= Cell.MAX_COL-1) return;
								_clickedCell[0].block.moveState = Block.DOWN_MOVE;
								_cellArray[_clickedCell[0].cellY+1][_clickedCell[0].cellX].block.moveState =  Block.UP_MOVE;
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
		 * @param cell 클릭 한 파이어팡의 셀입니다
		 * 파이어 팡 클릭 시 파이어 팡을 기준으로 십자가 방향의 모든 블록을 파괴합니다.
		 */		
		private function clickedFireBlock(cell : Cell):void
		{
			_preHintTimer = getTimer();
			var randomValue : int = UtilFunction.random(1,7,1);
			for(var i : int = 1; i < Cell.MAX_COL-1; i++)
			{
				_cellArray[cell.cellY][i].cellType = Block.BLOCK_PANG;
				_cellArray[i][cell.cellX].cellType = Block.BLOCK_PANG;
			}
		}
		
		/** 
		 * 랜덤판 클릭 했을 경우 랜덤으로 한 종류 모두 파괴
		 */		
		private function clickedRandomBlock():void
		{
			_preHintTimer = getTimer();
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
		 */		
		public function swapCell(curCell : Cell, targetCell : Cell, moveDirect : int) : void
		{
			if(targetCell.cellType == Block.WALL) return;
			if(targetCell.cellType == Block.BLOCK_PANG) return;
			if(targetCell.cellType == Block.BLOCK_REMOVE) return;
			
			var swapTemp : int = curCell.cellType;
			curCell.cellType = targetCell.cellType;
			targetCell.cellType = swapTemp;
			var checkFlag : Boolean;
			
			if(BlockTypeSetting.checkMovePang(targetCell, curCell, _cellArray, moveDirect) == false)
			{
				swapTemp  = curCell.cellType;
				curCell.cellType = targetCell.cellType;
				targetCell.cellType = swapTemp;
			}
			
			else
			{
				ScoreManager.instance.comboCnt++;
				_comboTextField.showCombo("Combo "+String(ScoreManager.instance.comboCnt));
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
			
			_timer.addEventListener("TIMEOUT", onTimeout);
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
			
			_pauseImage = new Button(_gameViewAtlas.getTexture("stopbtn"));
			_pauseImage.width = _fireBlockAnimaiton.width;
			_pauseImage.height = _fireBlockAnimaiton.height;
			_pauseImage.x = _upPannelImage.width - _pauseImage.width*1.5;
			_pauseImage.y = _fireBlockAnimaiton.y;
			_pauseImage.addEventListener(TouchEvent.TOUCH, onTounchPause);
			
			_scoreTextField = new TextField(_upPannelImage.width, _upPannelImage.height, "0");
			_scoreTextField.format.color = 0xffffff;
			_scoreTextField.format.size = _upPannelImage.height*0.2;
			
			_fireProgress = new Progress();
			_fireProgress.ProgressInit(_fireBlockAnimaiton.x,_fireBlockAnimaiton.y + _fireBlockAnimaiton.height, _fireBlockAnimaiton.width, _fireBlockAnimaiton.height/3);
			_fireProgress.calcValue(FIRE_DRAW_CONUT,0);
			
			_upPannel.addChild(_upPannelImage);
			_upPannel.addChild(_fireBlockAnimaiton);
			_upPannel.addChild(_scoreTextField);
			_upPannel.addChild(_fireProgress);
			_upPannel.addChild(_pauseImage);
		}
		
		/**
		 * 일시 중지 버튼을 클릭 합니다.
		 */		
		private function onTounchPause(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				switch(event.currentTarget)
				{
					case _pauseImage:
					{
						_pauseFlag = true;
					 	var pauseWindow : PauseWindow = new PauseWindow();
						pauseWindow.init(AniPang.stageWidth/2, AniPang.stageHeight/2, AniPang.stageWidth/1.5, AniPang.stageHeight/2);
						addChild(pauseWindow);
						break;
					}
						
				}
			}
			
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
					_cellArray[i][j].addEventListener("hintInit", onHintInit);
					_cellArray[i][j].addEventListener("move", onMove);
				}
			}
			BlockTypeSetting.startBlockSetting(_cellArray);
		}
		
		/**
		 * @param event 이동 시킨 셀
		 * 셀의 이동에 따라 발생하는 콜백함수입니다.
		 */		
		private function onMove(event:Event):void
		{
			onHintInit();
			var cell : Cell = (event.currentTarget as Cell);
			
			switch(cell.block.moveState)
			{
				case Block.LEFT_MOVE:
				{
					//블록의 움직임이 블록의 크기보다 커지면 이동 완료
					//이동 완료 후 이동 방향에 따라 블록 제거 체크 후 제거
					if( Math.abs(cell.block.x) >= Math.abs(cell.width))
					{
						cell.block.x = 0;
						swapCell(cell, _cellArray[cell.cellY][cell.cellX-1], Block.LEFT_MOVE);
						cell.block.moveState = Block.STOP_MOVE;
					}
					
					break;
				}
					
				case Block.RIGHT_MOVE:
				{
					if(Math.abs(cell.block.x) >= Math.abs(cell.width))
					{
						cell.block.x = 0;
						swapCell(cell, _cellArray[cell.cellY][cell.cellX+1], Block.RIGHT_MOVE);
						cell.block.moveState = Block.STOP_MOVE;
					}
					
					break;
				}
				
				case Block.UP_MOVE:
				{
					if(Math.abs(cell.block.y) >= Math.abs(cell.height))
					{
						cell.block.y = 0;
						swapCell(cell, _cellArray[cell.cellY-1][cell.cellX], Block.UP_MOVE);
						cell.block.moveState = Block.STOP_MOVE;
					}
					
					break;
				}
					
				case Block.DOWN_MOVE:
				{
					if(Math.abs(cell.block.y) >= Math.abs(cell.height))
					{
						cell.block.y = 0;
						swapCell(cell, _cellArray[cell.cellY+1][cell.cellX], Block.DOWN_MOVE);
						cell.block.moveState = Block.STOP_MOVE;
					}
					
					break;
				}
			}
		}
		
		/**
		 * 팡이 됬을 경 후 호출 되는 콜백 함수입니다.
		 * 힌트 값의 초기화하 탐색 플래그를 true 시킵니다.
		 */		
		private function onHintInit():void
		{
			_findFlag = true;
			_preHintTimer = getTimer();
			BlockTypeSetting.hintPang.block.showIdleState();
		}
		
		private function onTimeout() : void
		{
			_pauseFlag = true;
			_endClip = new EndClip(AniPang.stageWidth/2 - AniPang.stageWidth/4, AniPang.stageHeight/2 - AniPang.stageWidth/6, AniPang.stageWidth/2, AniPang.stageWidth/2);
			_endClip.addEventListener("RESULT", onResult);
			
			addChild(_endClip);
		}
		
		/**
		 * 결과 창입니다
		 */		
		private function onResult():void
		{
			dispose();
			
			var resultView : ResultScene = new ResultScene();
			SceneManager.instance.addScene(resultView);
			SceneManager.instance.sceneChange();
		}
		
		public static function get pauseFlag():Boolean{return _pauseFlag;}
		public static function set pauseFlag(value:Boolean):void{_pauseFlag = value;}
	}
}