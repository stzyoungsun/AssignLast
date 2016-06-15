package gamescene
{
	import Animation.LoadingClip;
	
	import UI.window.RankWindow;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import sound.SoundManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	import user.AllUserData;
	import user.UserDataFormat;

	public class RankScene extends Sprite
	{
		
		private var _backImage : Image;
		private var _grayImage : Image;
		private var _userRankData : Vector.<UserDataFormat>;
		private var _randWindow : Vector.<RankWindow> = new Vector.<RankWindow>;
		
		private var _buttonAtals : TextureAtlas;
		
		private var _nextButton : Button;
		private var _prevButton : Button;
		private var _returnButton : Button;
		
		private var _start : int = 0;
		private var _end : int = 5;
		
		private var _loadingClip : LoadingClip;
		
		/**
		 * 카톡 서버에 등록 되어 있는 모든 사용자들의 점수를 내림 차순으로 정렬하여 화면에 출력하는 랭크 씬
		 */		
		public function RankScene()
		{
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["button.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["back.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			
			addChild(_backImage);
			
			_grayImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_grayImage.width = AniPang.stageWidth;
			_grayImage.height = AniPang.stageHeight;
			
			addChild(_grayImage);
			
			_loadingClip = new LoadingClip(AniPang.stageWidth/2 - AniPang.stageWidth/10, AniPang.stageHeight/2 - AniPang.stageWidth/10, AniPang.stageWidth/5, AniPang.stageWidth/5);
			addChild(_loadingClip);
			
			//모든 유저의 데이터를 로드합니다.
			AllUserData.instance.initRankData();
			//모든 유저의 데이터 로드가 완료되면 ALL_DATA_LOAD가 발생 됩니다.
			AllUserData.instance.addEventListener("ALL_DATA_LOAD", onAllDataLoad);
		}
		
		/**
		 * 모든 유저 데이터의 로드가 완료 되었을 경우 동작하는 콜백 함수
		 * 랭킹 씬 화면에 버튼, 유저 데이터 등을 출력 합니다.
		 */		
		private function onAllDataLoad():void
		{
			removeChild(_loadingClip, true);
			
			AllUserData.instance.removeEventListener("ALL_DATA_LOAD", onAllDataLoad);
			AllUserData.instance.upSort();
			
			_nextButton = new Button(_buttonAtals.getTexture("redButton"),"다음");
			_nextButton.x = AniPang.stageWidth*0.6;
			_nextButton.y = AniPang.stageHeight*0.8;
			_nextButton.width = AniPang.stageWidth/7;
			_nextButton.height = AniPang.stageWidth/8;
			_nextButton.textFormat.color = 0xffffff;
			_nextButton.textFormat.size = AniPang.stageHeight/20;
			_nextButton.textFormat.bold = true;
			
			_prevButton = new Button(_buttonAtals.getTexture("BlueButton"),"이전");
			_prevButton.x = AniPang.stageWidth*0.25;
			_prevButton.y = AniPang.stageHeight*0.8;
			_prevButton.width = AniPang.stageWidth/7;
			_prevButton.height = AniPang.stageWidth/8;
			_prevButton.textFormat.color = 0xffffff;
			_prevButton.textFormat.size = AniPang.stageHeight/20;
			_prevButton.textFormat.bold = true;
			_prevButton.visible = false;
			
			_returnButton = new Button(_buttonAtals.getTexture("orangeButton"),"돌아가기");
			_returnButton.x = AniPang.stageWidth*0.3;
			_returnButton.y = AniPang.stageHeight*0.9;
			_returnButton.width = AniPang.stageWidth/3;
			_returnButton.height = AniPang.stageWidth/6;
			_returnButton.textFormat.color = 0xffffff;
			_returnButton.textFormat.size = AniPang.stageHeight/20;
			_returnButton.textFormat.bold = true;
			
			addChild(_nextButton);
			addChild(_prevButton);
			addChild(_returnButton);
			
			_nextButton.addEventListener(TouchEvent.TOUCH, onClicked);
			_prevButton.addEventListener(TouchEvent.TOUCH, onClicked);
			
			_returnButton.addEventListener(TouchEvent.TOUCH, onClicked);
			
			_userRankData = AllUserData.instance.userData;
			
			var temp : int = 0;
			for(var i : int = 0; i < AllUserData.instance.userCount; i++)
			{
				_randWindow.push(new RankWindow(_userRankData[i], i+1, 0, AniPang.stageHeight*0.05 + AniPang.stageHeight*0.15*temp++));
				addChild(_randWindow[i]);
				
				if(temp == 5)
					temp = 0;
			}
			
			drawRankWindow(_start, _end);
		}
		
		/**
		 * @param start		한 화면에 보여줄 유저 랭킹 시작 번호
		 * @param end		한 화면에 보여중 유저 랭킹 마지막 번호
		 * 순위, 유저이름, 유저사진, 유저점수를 RankWindow Sprite
		 */		
		private function drawRankWindow(start : int, end : int) : void
		{
			var i : int = 0;
			
			for(i  = 0; i < AllUserData.instance.userCount; i++)
				_randWindow[i].visible = false;
			
			for(i = start; i < end; i++)
				_randWindow[i].visible = true;
		}
		
		/**
		 * 한 화면에 5명의 유저가 출력 되면 다음/이전 버튼으로 조절이 가능 합니다.
		 */		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				SoundManager.getInstance().play("button.mp3", false);
				switch(event.currentTarget)
				{
					case _nextButton:
					{
						_prevButton.visible = true;
						_end += 5;
						_start += 5;
						
						if(_end > AllUserData.instance.userCount)
						{
							_end = AllUserData.instance.userCount;
							_nextButton.visible = false;
						}
						
						drawRankWindow(_start, _end);
						break;
					}
						
					case _prevButton:
					{
						if(_nextButton.visible == false)
						{
							_nextButton.visible = true;
							_end = _start;
							_start -= 5;
						}
						
						else
						{
							_start -= 5;
							_end -= 5;
						}
						
						if(_start <= 0)
						{
							_start = 0;
							_end = 5;
							_prevButton.visible = false;
						}
							
						drawRankWindow(_start, _end);
						break;
					}
						
					case _returnButton:
					{
						AllUserData.instance.dispose();
						dispose();
						var mainView : MainScene = new MainScene();
						SceneManager.instance.addScene(mainView);
						SceneManager.instance.sceneChange();
						break;
					}
				}
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
			
			removeChildren(0, -1 ,true);
			removeEventListeners();
		}
	}
}