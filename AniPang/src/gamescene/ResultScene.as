package gamescene
{
	import com.lpesign.KakaoExtension;
	
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import UI.window.ButtonWindow;
	import UI.window.MainWindow;
	
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
	import starling.utils.Align;
	
	import user.CurUserData;
	
	import util.UtilFunction;

	public class ResultScene extends Sprite
	{
		private var _buttonAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		
		private var _backImage : Image;
		private var _mainImage : Image;
		private var _upPanel : Image;
		private var _mainPanel : Image;
		
		
		private var _curScroeTextField : TextField;
		private var _lvBonusTextField : TextField;
		private var _maxScroeTextField : TextField;
		private var _goldTextField : TextField;
		private var _starTextField : TextField;
		
		private var _returnButton : ButtonWindow;
		private var _newRecordImage : Image;		//추후
		private var _newRankingImage : Image;		//추후
		
		private var _exitButton : Button;
		
		private var _prevTime : int = 0;
		
		private var _newScoreFlag : Boolean = false;
		private var _passFlag : Boolean = false;
		public function ResultScene()
		{
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["Button.png"];
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["back.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			_returnButton = new ButtonWindow(AniPang.stageWidth * 0.3, AniPang.stageHeight * 0.78, AniPang.stageWidth/2.5, AniPang.stageHeight/12, 
				_itemwindowAtals.getTexture("startButton"), null,"다시하기");
			_returnButton.settingTextField(0xffffff,  _returnButton.width/8);
			_returnButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_returnButton);
			
			_mainImage = new Image(_itemwindowAtals.getTexture("mainWindow"));
			_mainImage.width = AniPang.stageWidth*0.8;
			_mainImage.height = AniPang.stageHeight*0.5;
			_mainImage.x = AniPang.stageWidth*0.09;
			_mainImage.y = AniPang.stageHeight*0.2;
			addChild(_mainImage);

			_upPanel = new Image(_itemwindowAtals.getTexture("resultIcon"));
			_upPanel.width = AniPang.stageWidth*0.7;
			_upPanel.height = AniPang.stageHeight*0.1;
			_upPanel.x = AniPang.stageWidth*0.15;
			_upPanel.y = AniPang.stageHeight*0.15;
			addChild(_upPanel);
			
			_exitButton = new Button(_buttonAtals.getTexture("exit"));
			
			drawMainPanel();	
		}
		
		private function onEnterFrame():void
		{
			var curTimer : int = getTimer();
			
			if(curTimer - _prevTime > 800)
				_curScroeTextField.visible = true;
			
			if(curTimer - _prevTime > 1600 )
			{
				_lvBonusTextField.visible = true;
			}
				
			if(curTimer - _prevTime > 2400 && _passFlag == false)
			{
				var bonus : int = int(ScoreManager.instance.scoreCnt * (0.01 * CurUserData.instance.userData.lv));
				var curScore : int  = ScoreManager.instance.scoreCnt;
				
				_curScroeTextField.text = UtilFunction.makeCurrency(String(bonus + curScore));
				_passFlag = true;
			}
				
			if(curTimer - _prevTime > 3200 )
				_maxScroeTextField.visible = true;
			
			if(curTimer - _prevTime > 4000 )
				_goldTextField.visible = true;
			
			if(curTimer - _prevTime > 4800 )
			{
				_starTextField.visible = true;
				_returnButton.visible = true;
			}
				
		}
		
		private function drawMainPanel():void
		{
			var bonus : int = int(ScoreManager.instance.scoreCnt * (0.01 * CurUserData.instance.userData.lv));
			var curScore : int  = ScoreManager.instance.scoreCnt;
			
			_mainPanel = new Image(_itemwindowAtals.getTexture("resultWindow"));
			_mainPanel.width = AniPang.stageWidth*0.78;
			_mainPanel.height = AniPang.stageHeight*0.44;
			_mainPanel.x = AniPang.stageWidth*0.1;
			_mainPanel.y = AniPang.stageHeight*0.25;
			addChild(_mainPanel);
			
			//_destoryBlockTextField = new TextField(AniPang.stageWidth, AniPang.stageHeight/5);
			_curScroeTextField = new TextField(_mainPanel.width, AniPang.stageHeight/5);
			_lvBonusTextField = new TextField(_mainPanel.width*0.7, AniPang.stageHeight/10);
			_maxScroeTextField = new TextField(_mainPanel.width*0.7, AniPang.stageHeight/8);
			_goldTextField = new TextField(_mainPanel.width*0.4, AniPang.stageHeight/8);
			_starTextField = new TextField(_mainPanel.width*0.4, AniPang.stageHeight/8); 
			
			_returnButton.visible = false;

			//밑에 순서로 출력
			textFieldSetting(_curScroeTextField, 0xFFFC50 ,UtilFunction.makeCurrency(String(curScore)), _mainPanel.x, _mainPanel.y + _mainPanel.height*0.03);
			textFieldSetting(_lvBonusTextField, 0xFFFFFF, UtilFunction.makeCurrency(String(bonus)), _mainPanel.x + _mainPanel.width*0.3, _mainPanel.y + _mainPanel.height*0.32);
			textFieldSetting(_maxScroeTextField, 0X197276, UtilFunction.makeCurrency(String(CurUserData.instance.userData.curMaxScore)), _mainPanel.x + _mainPanel.width*0.3, _mainPanel.y + _mainPanel.height*0.51);
			textFieldSetting(_goldTextField, 0XFFFFFF, String(int(ScoreManager.instance.destoryBlockCount*2)), _mainPanel.x + _mainPanel.width*0.13, _mainPanel.y + _mainPanel.height*0.72);
			textFieldSetting(_starTextField, 0XFFFFFF, String(ScoreManager.instance.destoryBlockCount), _mainPanel.x + _mainPanel.width*0.61, _mainPanel.y + _mainPanel.height*0.72);
			
			CurUserData.instance.userData.gold += ScoreManager.instance.destoryBlockCount*2;
			CurUserData.instance.userData.totalStar += ScoreManager.instance.destoryBlockCount;
				
			_exitButton.width = _upPanel.width/10;
			_exitButton.height = _exitButton.width;
			_exitButton.x = _upPanel.x + _upPanel.width - _exitButton.width/2.5;
			_exitButton.y = _upPanel.y*1.1;
			_exitButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_exitButton);
			
			//현재 획득 한 점수가 맥스 점수보다 높은 경우 서버에 저장
			if(CurUserData.instance.userData.curMaxScore < bonus + curScore)
			{
				//KakaoExtension.instance.addEventListener("SAVE_OK", onSaveOK);
				//KakaoExtension.instance.saveUserScore(String(ScoreManager.instance.scoreCnt));
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
					case _returnButton:
					{
						dispose();
						var playVeiw : PlayScene = new PlayScene();
						SceneManager.instance.addScene(playVeiw);
						SceneManager.instance.sceneChange();
						break;
					}
						
					case _exitButton:
					{
						dispose();
						var mainView : MainScene = new MainScene();
						SceneManager.instance.addScene(mainView);
						SceneManager.instance.sceneChange();
						break;
					}

				}
			}
			touch = null;
		}
		
		public function textFieldSetting(textField : TextField, color : uint, text : String, x : int, y: int) : void
		{
			textField.visible = false;
			
			textField.x = x;
			textField.y = y;
			
			textField.text = text;
			
			textField.format.horizontalAlign = Align.CENTER;
			textField.format.verticalAlign = Align.CENTER;
			textField.format.color = color;
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