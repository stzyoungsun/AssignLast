package sound
{
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.utils.Dictionary;
	
	import starling.core.starling_internal;
	
	import user.CurUserData;
	import user.UserDataFormat;
	
	/**
	 * 사운드 리소스를 관리하는 클래스. 싱글턴 패턴을 적용해서 전체 어플리케이션에서 단 하나의 객체만 생성된다.
	 */
	public class SoundManager
	{
		private var _gameSound:Sound;
		
		private var _soundResource:Dictionary;
		private var _currentChannel:SoundChannel;
		private var _currentResourceName:String;
		private var _loopedPlayingState:String;
		
		private static var _sInstance:SoundManager;
		private static var _sAllowCreateInstance:Boolean = false;
		
		private static const STOP:String = "stop";
		private static const PLAY:String = "play";
		
		/**
		 * 생성자 - 멤버 변수, 객체 초기화
		 */
		public function SoundManager()
		{
			if (!_sAllowCreateInstance) throw new Error("Use SoundManager.getInstance method");
			
			_soundResource = new Dictionary();
			_currentChannel = new SoundChannel();
			_loopedPlayingState = STOP;
		}
		
		/**
		 * SoundManager의 객체를 반환하는 메서드
		 * @return SoundManager 객체
		 */
		public static function getInstance():SoundManager
		{
			// 최초 호출 시에 SoundManager 객체 생성
			if (_sInstance == null)
			{
				_sAllowCreateInstance = true;
				_sInstance = new SoundManager();
				_sAllowCreateInstance = false;
			}
			// 객체 반환
			return _sInstance;
		}
		
		/**
		 * 사운드 매니저에 사운드 리소스를 등록하는 메서드. 이미 등록된 이름으로 다시 추가할 수 없다.
		 * @param resourceName - 추가하려는 리소스의 이름
		 * @param sound - 추가하려는 Sound 객체
		 */
		public function addSound(resourceName:String, sound:Sound):void
		{
			if(_soundResource[resourceName])
			{
				throw new Error(resourceName + " already added to Sound manager.");
			}
			_soundResource[resourceName] = sound;
		}
		
		/**
		 * 사운드 매니저에 등록된 리소스를 제거하는 메서드 
		 * @param resourceName - 제거하려는 리소스의 이름
		 */
		public function removeSound(resourceName:String):void
		{
			if(_soundResource[resourceName])
			{
				delete _soundResource[resourceName];
			}
			else
			{
				throw new Error("Invalid sound resource name. Check your sound resource name");
			}
		}
		
		/**
		 * resourceName에 해당하는 사운드 리소스를 재생시키는 메서드 . loop가 true이면 반복 재생한다.
		 * @param resourceName - 재생시키려는 리소스의 이름
		 */
		public function play(resourceName:String, loop:Boolean = false):void
		{
			// loop가 false이면 단순 재생
			if(!loop)
			{
				var effectSound : Sound = _soundResource[resourceName];
				
				if(effectSound == null)
				{
					throw new Error("Invalid sound resource name. Check your sound resource name");
				}
				
				if(CurUserData.instance.userData.effectSound == "ON")
					effectSound.play();
			}
				// loop가 true이고, _loopedPlayingState가 STOP이면 반복 재생 설정
			else if(loop && _loopedPlayingState == STOP && CurUserData.instance.userData.backGoundSound == "ON")
			{
				_gameSound = _soundResource[resourceName];
				
				if(_gameSound == null)
				{
					throw new Error("Invalid sound resource name. Check your sound resource name");
				}
				
				_currentChannel = _gameSound.play();
				_currentChannel.addEventListener(Event.SOUND_COMPLETE, onComplete);
				_currentResourceName = resourceName;
				_loopedPlayingState = PLAY;
			}
		}
		
		/**
		 * 현재 반복 재생되고 있는 사운드를 멈추는 메서드 
		 */
		public function playLoopedPlaying():void
		{
			// _loopedPlayingState가 PLAY 상태일때만 구문 실행
			if(_loopedPlayingState == STOP)
			{
				_currentChannel = _gameSound.play(_currentChannel.position);
				_loopedPlayingState = PLAY;
			}
		}
		
		/**
		 * 현재 반복 재생되고 있는 사운드를 멈추는 메서드 
		 */
		public function stopLoopedPlaying():void
		{
			// _loopedPlayingState가 PLAY 상태일때만 구문 실행
			if(_loopedPlayingState == PLAY)
			{
				_currentChannel.stop();
				_loopedPlayingState = STOP;
			}
		}
		
		/**
		 * 사운드 재생이 완료되면 호출되는 메서드. play를 호출해서 다시 사운드를 재생하도록 한다.
		 * @param event - 발생한 이벤트 정보를 갖고있는 Event 객체
		 */
		private function onComplete(event:Event):void
		{
			_currentChannel.removeEventListener(event.type, onComplete);
			_loopedPlayingState = STOP;
			// play 호출
			play(_currentResourceName, true);
		}
		
		public function get loopedPlayingState():String{return _loopedPlayingState;}
	}
}