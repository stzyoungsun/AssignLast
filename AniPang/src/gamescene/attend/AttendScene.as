package gamescene.attend
{
	import flash.utils.getTimer;
	
	import UI.Button.SideImageButton;
	import UI.window.AttendBoxWindow;
	import UI.window.MainWindow;
	
	import gamescene.MainScene;
	
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;

	public class AttendScene extends Sprite
	{
		private var _itemwindowAtals : TextureAtlas;
		private var _attendAtals : TextureAtlas;
		
		private var _mainImage : Image;
		private var _attendPanelImage : Image;
		
		private var _mainWindow : MainWindow;
		private var _okButton : SideImageButton;
		
		private var _cotactFirstFlag : Boolean = false;
		private var _prevTimer : int = 0;
		
		private var _attendBoxVector : Vector.<AttendBoxWindow> = new Vector.<AttendBoxWindow>;
		
		/**
		 * @param contactFirstFlag		오늘 처음 접속 일 경우 보상 애니매이션 출력
		 */		
		public function AttendScene(contactFirstFlag : Boolean = false)
		{
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			_attendAtals = TextureManager.getInstance().atlasTextureDictionary["attend.png"];
		
			_cotactFirstFlag = contactFirstFlag;
			
			_mainImage = new Image(TextureManager.getInstance().textureDictionary["back.png"]);
			_mainImage.width = AniPang.stageWidth;
			_mainImage.height = AniPang.stageHeight;
			addChild(_mainImage);
			
			_mainWindow = new MainWindow("Red","애니팡 출석부", null, null, false);
			_mainWindow.init(AniPang.stageWidth*0.05, AniPang.stageHeight*0.1, AniPang.stageWidth*0.9, AniPang.stageHeight*0.8);
			addChild(_mainWindow);
			
			_attendPanelImage = new Image(_attendAtals.getTexture("attendPanel"));
			_attendPanelImage.x = AniPang.stageWidth*0.05;
			_attendPanelImage.y = AniPang.stageHeight*0.28;
			_attendPanelImage.width = AniPang.stageWidth*0.9;
			_attendPanelImage.height = AniPang.stageHeight*0.53;
			addChild(_attendPanelImage);
			
			_okButton = new SideImageButton(AniPang.stageWidth * 0.3, AniPang.stageHeight * 0.81, _mainImage.width/2.5, _mainImage.height/12, 
				_itemwindowAtals.getTexture("startButton"), null,"확인");
			_okButton.settingTextField(0xffffff,  _okButton.width/8);
			_okButton.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_okButton);
			
			_prevTimer = getTimer();
			//박스 출력
			drawAttendBox();
			//출석일에 맞는 출석 도장 출력
			drawAttendStamp();
			//오늘 처음 접속일 경우 보상 받는 애니매이션 출력
			if(_cotactFirstFlag == true)
			{
				addEventListener(Event.ENTER_FRAME, onEnterFrame);
				_attendBoxVector[CurUserData.instance.userData.attendCnt-1].attendStampImage.visible = true;
				_attendBoxVector[CurUserData.instance.userData.attendCnt-1].attendStampImage.alpha = 0;
			}	
		}
		
		private function onEnterFrame():void
		{
			var curTimer : int = getTimer();
			if(curTimer - _prevTimer > 100)
			{
				_attendBoxVector[CurUserData.instance.userData.attendCnt-1].attendStampImage.alpha += 0.1;
				_prevTimer = getTimer();
			}
			
			if(_attendBoxVector[CurUserData.instance.userData.attendCnt-1].attendStampImage.alpha >= 1)
			{
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				_attendBoxVector[CurUserData.instance.userData.attendCnt-1].drawPopUp();
				_attendBoxVector[CurUserData.instance.userData.attendCnt-1].getReward();
			}
				
		}
		
		/** 
		 * 미리 저장된 AttendData의 값을 이용하여 화면에 출석박스 출력
		 */		
		private function drawAttendBox():void
		{
			for(var i : int = 0 ; i < MainClass.MAX_ATTENTBOX_COUNT; i++)
			{
				MainClass.attendDataVector[i].settingAttendData();
				_attendBoxVector.push(new AttendBoxWindow(MainClass.attendDataVector[i].id));
				addChild(_attendBoxVector[i]);
			}
		}
		
		/** 
		 * 출석 일에 맞게 도장의 visible을 키고 꺼줌
		 */	
		private function drawAttendStamp():void
		{
			var i : int = 0;
			
			if(_cotactFirstFlag == true)
			{
				for(i = 0 ; i < CurUserData.instance.userData.attendCnt-1; i++)
				{
					_attendBoxVector[i].attendStampImage.visible = true;
				}
			}
			
			else
			{
				for(i = 0 ; i < CurUserData.instance.userData.attendCnt; i++)
				{
					_attendBoxVector[i].attendStampImage.visible = true;
				}
			}
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			if(touch)
			{
				switch(event.currentTarget)
				{
					case _okButton:
						dispose();
						var mainView : MainScene = new MainScene();
						SceneManager.instance.addScene(mainView);
						SceneManager.instance.sceneChange();
						break;
				}
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
			
			removeChildren(0, -1, true);
			removeEventListeners();
		}
	}
}