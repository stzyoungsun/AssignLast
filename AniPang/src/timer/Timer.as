package timer
{
	import flash.utils.getTimer;
	
	import gamescene.PlayScene;
	
	import UI.Progress.Progress;
	
	import score.ScoreManager;
	
	import starling.events.Event;

	public class Timer extends Progress
	{
		private static const MAX_TIME : Number = 60;
		private static const UP_MAX_TIME : Number = 70;
		
		private var _curTime : int = 0;
		private var _startFlag : Boolean = false;
		
		private var _preTime : Number = 0;
		public function Timer()
		{
			super(true);
			_preTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function timeInit(x : int, y : int, witdh : int, height : int) : void
		{
			ProgressInit(x, y, witdh, height);
			
			if(ScoreManager.instance.timeupItemUse == true)
				_curTime = UP_MAX_TIME;
			else
				_curTime = MAX_TIME;
		}
		
		private function onEnterFrame():void
		{
			if(PlayScene.pauseFlag == true) return;
			
			if(_startFlag == true)
			{
				var curTimer : Number = getTimer();
				
				if(curTimer - _preTime > 1000)
				{
					if(ScoreManager.instance.timeupItemUse == true)
						calcValue(UP_MAX_TIME,--_curTime);
					else
						calcValue(MAX_TIME,--_curTime);
			
					text = String(_curTime);
					_preTime = getTimer();
					
					if(_curTime == 0)
						dispatchEvent(new Event("TIMEOUT"));
				}
			}
		}
		
		public function start() : void {_startFlag = true;}
		public function stop() : void {_startFlag = false;}
	}
}