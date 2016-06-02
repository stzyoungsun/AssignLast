package timer
{
	import flash.utils.getTimer;
	
	import gameview.PlayView;
	
	import object.Progress.Progress;
	
	import starling.events.Event;

	public class Timer extends Progress
	{
		private static const MAX_TIME : Number = 60;
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
			_curTime = MAX_TIME;
		}
		
		private function onEnterFrame():void
		{
			if(PlayView.pauseFlag == true) return;
			
			if(_startFlag == true)
			{
				var curTimer : Number = getTimer();
				
				if(curTimer - _preTime > 1000)
				{
					calcValue(MAX_TIME,--_curTime);
					text = String(_curTime);
					_preTime = getTimer();
					
					if(_curTime == 0)
						dispatchEvent(new Event("exit"));
				}
			}
		}
		
		public function start() : void {_startFlag = true;}
		public function stop() : void {_startFlag = false;}
	}
}