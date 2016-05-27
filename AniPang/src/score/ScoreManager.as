package score
{
	public class ScoreManager
	{
		private static var _instance : ScoreManager;
		private static var _constructed : Boolean;
		
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
		public function get scoreCnt():int
		{
			return _scoreCnt;
		}
		
		public function set scoreCnt(value:int):void
		{
			_scoreCnt =_scoreCnt + value*(Math.pow(2,(comboCnt+1)));
		}
		
		public function get comboCnt():int
		{
			return _comboCnt;
		}
		
		public function set comboCnt(value:int):void
		{
			_comboCnt = value;
			trace(_comboCnt);
		}
		
		public function fireInit() : void
		{
			_pangCount = 0;
		}
		
		public function set pangCount(value:int):void
		{
			_pangCount+=value;
		}
		
		public function get pangCount():int{return _pangCount;}
		
	}
}