package object.Block
{
	import score.ScoreManager;
	
	import sound.SoundManager;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.events.Event;
	import starling.textures.Texture;

	public class Block extends MovieClip
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
		public static const BLOCK_MAO : int = 			8;
		
		public static const BLOCK_FIRE : int = 		20;
		public static const BLOCK_RANDOM : int = 	21;
		public static const BLOCK_PANG : int = 100;
		
		public static const STOP_MOVE : int = 0;
		public static const UP_MOVE : int = 1;
		public static const DOWN_MOVE : int = 2;
		public static const LEFT_MOVE : int = 3;
		public static const RIGHT_MOVE : int = 4;
		
		private var _frames : Vector.<Texture>;

		private var _preTime : Number = 0;
		private var _blockType : int;
		
		private var _faceFlag : Boolean = false;
		private var _drawFlag : Boolean = false;
		
		private var _animationFlag : Boolean = false;
		private var _cell : Cell; 
		
		private var _moveState : int = STOP_MOVE;
		public function Block(frame : Vector.<Texture>, cell : Cell)
		{
			super(frame);
			_cell = cell;
			_frames = frame;
			
			this.width = AniPang.stageWidth/7;
			this.height = AniPang.stageHeight*2/21;
			this.stop();

			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function showIdleState() : void
		{
			_faceFlag = false;
		}
		
		public function showCryState() : void
		{
			_faceFlag= true;
		}
		
		private function onEnterFrame():void
		{
			if(this.visible == false){return;}
			//블록의 frame을 설정 합니다.
			if(_drawFlag == true)
				drawBlock();
			//애니메이션 블록일 경우
			if(_blockType == BLOCK_PANG || _blockType == BLOCK_RANDOM || _blockType == BLOCK_FIRE)
				AnimationPang();
			else
			{
				_animationFlag = false;
				this.stop();
			}
			//무브 상태가 스탑이 아닌 경우
			if(_moveState != STOP_MOVE)
				moveBlock();
			
			if(this.faceFlag == false && _blockType >=1 && _blockType <= 8)
				this.texture = this.getFrameTexture(0);
			else if(this.faceFlag == true && _blockType >=1 && _blockType <= 8)
				this.texture = this.getFrameTexture(1);
		}
		
		/**
		 * 무브 상태에 따라 블록을 이동 시킵니다.
		 */		
		private function moveBlock():void
		{
			switch(_moveState)
			{
				case LEFT_MOVE:
				{
					this.x -= AniPang.stageHeight/80;
					this.parent.dispatchEvent(new Event("move"));
					break;
				}
					
				case RIGHT_MOVE:
				{
					this.x += AniPang.stageHeight/80; 
					this.parent.dispatchEvent(new Event("move"));
					break;
				}
					
				case UP_MOVE:
				{
					this.y -= AniPang.stageHeight/80;
					this.parent.dispatchEvent(new Event("move"));
					break;
				}
					
				case DOWN_MOVE:
				{
					this.y += AniPang.stageHeight/80;
					this.parent.dispatchEvent(new Event("move"));
					break;
				}
			}
			
		}
		
		/** 
		 * 애니매이션이 필요 한 팡일 경우 (터지는 모션, 랜덤팡, 파이어팡)
		 */		
		private function AnimationPang():void
		{
			switch(_blockType)
			{
				case BLOCK_FIRE:
				case BLOCK_RANDOM:
				{
					if(_animationFlag == false)
					{
						this.fps = 10;
						_animationFlag = true;
					}
					break;
				}
					
				case BLOCK_PANG:
				{
					this.fps = 10;
					addEventListener(starling.events.Event.COMPLETE, onAnimationComplete);
					break;
				}
			}
		}
		
		private function onAnimationComplete():void
		{
			removeEventListener(starling.events.Event.COMPLETE, onAnimationComplete);
			ScoreManager.instance.scoreCnt = 10;
			ScoreManager.instance.pangCount = 1;
			ScoreManager.instance.destoryBlockCount = 1;
			
			this.parent.dispatchEvent(new Event("hintInit"));
			SoundManager.getInstance().play("pang.mp3", false);
			this.stop();
			_cell.cellType = BLOCK_REMOVE;
		}
		
		/**
		 * frame을 재설정 합니다.
		 * (중요)frame을 재설정 하고 현재 텍스쳐도 바꿔 줍니다.
		 */		
		private function drawBlock() : void
		{
			this.texture = _frames[0];
			
			var frameCount : int = _frames.length;
			
			while(this.numFrames <  _frames.length)
			{
				this.addFrame(_frames[this.numFrames]);
			}
			
			while(this.numFrames > _frames.length)
			{
				this.removeFrameAt(frameCount++);
			}
			
			for(var i : int= 0; i < this.numFrames; i ++)
			{
				this.setFrameTexture(i, _frames[i]);
			}
			
			_drawFlag = false;
			this.play();
		}
		
		public function set frames(value:Vector.<Texture>):void{_frames = value;}
		public function set blockType(value:int):void{_blockType = value;}
		public function get faceFlag():Boolean{return _faceFlag;}
		public function set drawFlag(value:Boolean):void{_drawFlag = value;}
		
		public function get moveState():int{return _moveState;	}
		public function set moveState(value:int):void{_moveState = value;}
	}
}