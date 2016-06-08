package score
{
	public class ScoreManager
	{
		private static var _instance : ScoreManager;
		private static var _constructed : Boolean;
		
		/**
		 * 현재 게임의 점수를 관리 합니다.
		 */		
		public function ScoreManager()
		{
			if(!_constructed) throw new Error("Singleton, use ScoreManager.instance");
		}
		
		public static function get instance(): ScoreManager
		{
			if(_instance == null)
			{
				_constructed = true;
				_instance = new ScoreManager();
				_constructed = false;
			}
			return _instance;
		}
		
		private var _comboCnt : int = 0;
		private var _scoreCnt : int = 0;
		private var _pangCount : int = 0;
		private var _preTimer : int = 0;
		private var _destoryBlockCount : int = 0;
		
		private var _maoItemUse : Boolean = false;
		private var _timeupItemUse : Boolean = false;
		public function resetScore() : void
		{
		 	 _comboCnt = 0;
			 _scoreCnt = 0;
			 _pangCount = 0;
			 _preTimer = 0;
			 _destoryBlockCount = 0;
			 _maoItemUse = false;
			 _timeupItemUse = false;
		}
		
		public function get scoreCnt():int
		{
			return _scoreCnt;
		}
		
		public function set scoreCnt(value:int):void
		{
			_scoreCnt =_scoreCnt + value*(Math.pow(1.4,(_comboCnt+1))+300);
		}
		public function get comboCnt():int
		{
			return _comboCnt;
		}
		
		public function set comboCnt(value:int):void
		{
			_comboCnt = value;
			//trace(_comboCnt);
		}
		
		public function fireInit() : void
		{
			_pangCount = 0;
		}
		
		public function set pangCount(value:int):void
		{
			_pangCount+=value;
		}
		public function set destoryBlockCount(value:int):void
		{
			_destoryBlockCount += value;
		}
		
		public function get pangCount():int{return _pangCount;}
		public function get destoryBlockCount():int{return _destoryBlockCount;}
		
		public function get timeupItemUse():Boolean{return _timeupItemUse;}
		public function set timeupItemUse(value:Boolean):void{_timeupItemUse = value;}
		
		public function get maoItemUse():Boolean{return _maoItemUse;}
		public function set maoItemUse(value:Boolean):void{_maoItemUse = value;}
	}
}