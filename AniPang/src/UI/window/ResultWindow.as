package UI.window
{
	import com.lpesign.KakaoExtension;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import gameview.MainView;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import score.ScoreManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;
	
	import util.UtilFunction;

	public class ResultWindow extends Sprite
	{
		private var _resultWindowAtlas : TextureAtlas;
		
		private var _backImage : Image;
		private var _mainWindow : MainWindow;
		
		private var _destoryBlockTextField : TextField;
		private var _curScroeTextField : TextField;
		private var _maxScroeTextField : TextField;
		
		private var _returnMainButton : Button;
		private var _newRecordImage : Image;		//추후
		private var _newRankingImage : Image;		//추후
		
		private var _prevTime : int = 0;
		
		private var _newScoreFlag : Boolean = false;
		public function ResultWindow()
		{
			_resultWindowAtlas = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_mainWindow = new MainWindow(null, null);
			_returnMainButton = new Button(_resultWindowAtlas.getTexture("redButton"),"메인 으로");
			_newRecordImage = new Image(TextureManager.getInstance().textureDictionary["kakaoButton.png"]);
			
			initWindow();	
		}
		
		private function onEnterFrame():void
		{
			var curTimer : int = getTimer();
			
			if(curTimer - _prevTime > 1000)
				_maxScroeTextField.visible = true;
			
			if(curTimer - _prevTime > 2000 )
			{
				_curScroeTextField.visible = true;
				if(_newScoreFlag == true)
					_newRecordImage.visible = true;
			}
				
			if(curTimer - _prevTime > 3000 )
				_destoryBlockTextField.visible = true;
			
			if(curTimer - _prevTime > 5000 )
				_returnMainButton.visible = true;
		}
		
		private function initWindow():void
		{
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			
			_mainWindow.init(0, AniPang.stageHeight*0.1, AniPang.stageWidth, AniPang.stageHeight*0.8);
			
			_destoryBlockTextField = new TextField(AniPang.stageWidth, AniPang.stageHeight/5);
			_curScroeTextField = new TextField(AniPang.stageWidth, AniPang.stageHeight/5);
			_maxScroeTextField = new TextField(AniPang.stageWidth, AniPang.stageHeight/5);
			_returnMainButton.visible = false;
			
			_returnMainButton.width = _mainWindow.width*0.6;
			_returnMainButton.height = AniPang.stageHeight/7;
			_returnMainButton.x = _returnMainButton.width*0.3;
			_returnMainButton.y = _mainWindow.y + _maxScroeTextField.height/4*14;
				
			addChild(_backImage);
			addChild(_mainWindow);
			addChild(_returnMainButton);
			_returnMainButton.addEventListener(TouchEvent.TOUCH, onClicked);
			//밑에 순서로 출력
			textFieldSetting(_maxScroeTextField, UtilFunction.makeCurrency(String(CurUserData.instance.userData.curMaxScore)) + " 점", AniPang.stageWidth/8, _mainWindow.y + _maxScroeTextField.height/4*6);
			textFieldSetting(_curScroeTextField, UtilFunction.makeCurrency(String(ScoreManager.instance.scoreCnt)) + " 점", AniPang.stageWidth/8, _mainWindow.y + _maxScroeTextField.height/4*7.6);
			textFieldSetting(_destoryBlockTextField,UtilFunction.makeCurrency(String(ScoreManager.instance.destoryBlockCount)) + " 개", AniPang.stageWidth/8, _mainWindow.y + _maxScroeTextField.height/4*9.2);
			
			_newRecordImage.width = _returnMainButton.width/3;
			_newRecordImage.height = _curScroeTextField.height;
			_newRecordImage.x = _returnMainButton.width*0.6;
			_newRecordImage.y = _curScroeTextField.y;
			_newRecordImage.visible = false;
			
			//현재 획득 한 점수가 맥스 점수보다 높은 경우 서버에 저장
			if(CurUserData.instance.userData.curMaxScore < ScoreManager.instance.scoreCnt)
			{
				//KakaoExtension.instance.addEventListener("SAVE_OK", onSaveOK);
				//KakaoExtension.instance.saveUserData(String(ScoreManager.instance.scoreCnt));
			}	
			
			else
			{
				addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
				_prevTime = getTimer();
			}
		}
		
		/**
		 * 서버 저장 완료 후 SAVE_OK 발생 하면 다음 진행
		 */		
		protected function onSaveOK(event:flash.events.Event):void
		{
			//KakaoExtension.instance.removeEventListener("SAVE_OK", onSaveOK);
			CurUserData.instance.initData(true);
			_newScoreFlag = true;	
			addEventListener(starling.events.Event.ENTER_FRAME, onEnterFrame);
			_prevTime = getTimer();
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				switch(event.currentTarget)
				{
					case _returnMainButton:
					{
						dispose();
						var mainView : MainView = new MainView();
						SceneManager.instance.addScene(mainView);
						SceneManager.instance.sceneChange();
						break;
					}

				}
			}
			touch = null;
		}
		
		public function textFieldSetting(textField : TextField, text : String, x : int, y: int) : void
		{
			textField.visible = false;
			
			textField.x = x;
			textField.y = y;
			
			textField.text = text;
			
			textField.format.color = 0x000000;
			textField.format.size = textField.height/4;
			textField.format.bold = true;
			
			addChild(textField);
		}
		
		public override function dispose():void
		{
			ScoreManager.instance.resetScore();
			super.dispose();
			removeChildren(0, -1, true);
			removeEventListeners();
		}
	}
}