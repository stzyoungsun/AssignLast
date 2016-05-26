package object
{
	import flash.utils.getTimer;
	
	import starling.core.Starling;
	import starling.display.MovieClip;
	import starling.display.Sprite;
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
		
		public static const BLOCK_FIRE : int = 		8;
		public static const BLOCK_RANDOM : int = 	9;

		public static const BLOCK_PANG : int = 100;
		private var _frames : Vector.<Texture>;

		private var _preTime : Number = 0;
		private var _blockType : int;
		
		private var _faceFlag : Boolean = false;
		private var _drawFlag : Boolean = false;
		
		private var _pangStartFlag : Boolean = false;
		private var _randomFlag : Boolean = false;
		private var _cell : Cell; 
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
			if(this.isPlaying == true)
			{
				trace(_blockType);
			}
			
			if(this.visible == false) return;
			
			if(_drawFlag == true)
				drawBlock();
			
			if(_blockType == BLOCK_PANG || _blockType == BLOCK_RANDOM)
				AnimationPang();
			else
			{
				_pangStartFlag = false;
				_randomFlag = false;
				this.stop();
				Starling.juggler.remove(this);
			}
			
			if(this.faceFlag == false && _blockType >=1 && _blockType <= 7)
				this.texture = this.getFrameTexture(0);
			else if(this.faceFlag == true && _blockType >=1 && _blockType <= 7)
				this.texture = this.getFrameTexture(1);
		}
		
		private function AnimationPang():void
		{
			
			
			switch(_blockType)
			{
				case BLOCK_RANDOM:
				{
					if(_randomFlag == false)
					{
						this.stop();
						Starling.juggler.remove(this);
						
						this.fps = 10;
						Starling.juggler.add(this);
						this.play();
						_randomFlag = true;
						break;
					}
				
				}
					
				case BLOCK_PANG:
				{
					if(_pangStartFlag == false)
					{
						this.fps = 10;
						Starling.juggler.add(this);
						this.play();
						_pangStartFlag = true;
					}
					
					if(this.currentFrame >= 2)
					{
						_cell.cellType = BLOCK_REMOVE;
					}
					break;
				}
			}
			
		}
		
		private function drawBlock() : void
		{
			if(_blockType == 9)
				trace("123");
			var frameCount : int = _frames.length;
			while(this.numFrames <  _frames.length)
			{
				this.addFrame(_frames[this.numFrames]);
			}
			
			while(this.numFrames >   _frames.length)
			{
				this.removeFrameAt(frameCount++);
			}
			
			for(var i : int= 0; i < this.numFrames; i ++)
			{
				this.setFrameTexture(i, _frames[i]);
			}
			
			_drawFlag = false;
		}
		
		public function set frames(value:Vector.<Texture>):void{_frames = value;}
		public function set blockType(value:int):void{_blockType = value;}
		public function get faceFlag():Boolean{return _faceFlag;}
		public function set drawFlag(value:Boolean):void{_drawFlag = value;}
	}
}