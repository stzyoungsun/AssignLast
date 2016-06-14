package timer
{
	import flash.utils.getTimer;
	
	import UI.Progress.Progress;
	
	import gamescene.PlayScene;
	
	import score.ScoreManager;

	import starling.events.Event;

	public class Timer extends Progress
	{
		private static const MAX_TIME : Number = 60;
		private static const UP_MAX_TIME : Number = 70;
		
		private var _curTime : int = 0;
		private var _startFlag : Boolean = false;
		
		private var _preTime : Number = 0;
		
		/**
		 * 게임 씬에서 타이머 부분을 관리하는 클래스 입니다 
		 * 프로그래스 클래스를 상속 받아 시간을 프로그래스 형태로 출력 합니다.
		 */		
		public function Timer()
		{
			super(true);
			_preTime = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 
		 * @param x			타임 프로그레스를 출력 할 x 좌표
		 * @param y			타임 프로그레스를 출력 할 y 좌표
		 * @param witdh		타임 프로그레스의 witdh 값
		 * @param height	타임 프로그레스의 height 값
		 * 
		 */		
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
					//타이머의 시간이 0이 됬을 경우 TIMEOUT 이벤트 발생
					if(_curTime == 0)
					{
						dispatchEvent(new Event("TIMEOUT"));
					}
						
				}
			}
		}
		
		public function start() : void {_startFlag = true;}
		public function stop() : void {_startFlag = false;}
	}
}