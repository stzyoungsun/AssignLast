package UI.window
{
	import UI.ListView.ListView;
	import UI.Progress.Progress;
	import UI.popup.PopupWindow;
	
	import loader.TextureManager;
	
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

	public class MissonWindow extends MainWindow
	{
		private const MAX_MISSON_COUNT : int = 10;
		
		private var _windowAtals : TextureAtlas;
		private var _missonAtals:TextureAtlas;
		
		private var _todayTimer : TextField;
		private var _listView : ListView;
		private var _popupWindow:PopupWindow;
		
		private var _upPanelImage : Image;
		private var _completeProgress : Progress;
		private var _allCompleteImage : Image
		private static var _temp : int = 50;
		
		private var _backImage : Image;
		
		private var _listVector : Vector.<Sprite> = new Vector.<Sprite>;
		
		/**
		 * 일일 미션의 윈도우
		 * 일일 미션을 담고 있는 리스트 뷰, 초기화 시간을 나타내는 텍스트 필드 등으로 구성
		 */		
		public function MissonWindow()
		{
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_missonAtals = TextureManager.getInstance().atlasTextureDictionary["missonWindow.png"];
			
			super("Green", "오늘의 미션", _missonAtals.getTexture("back"));
			
			_backImage = new Image(TextureManager.getInstance().textureDictionary["grey_screen.png"]);
			_backImage.width = AniPang.stageWidth;
			_backImage.height = AniPang.stageHeight;
			addChild(_backImage);
			
			addEventListener("EXIT", onExit);
			this.init(AniPang.stageWidth*0.1, AniPang.stageHeight*0.2, AniPang.stageWidth*0.8, AniPang.stageHeight*0.6);
			
			drawUpPanel();
			drawListView();
			drawTodayTimer();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/** 
		 * 미션의 달성도, 초기화까지 남은 시간 등을 화면에 출력
		 */		
		private function drawUpPanel():void
		{
			_upPanelImage = new Image(_missonAtals.getTexture("uppanel"));
			_upPanelImage.x = AniPang.stageWidth*0.18;
			_upPanelImage.y = AniPang.stageHeight*0.365;
			_upPanelImage.width = AniPang.stageWidth*0.65;
			_upPanelImage.height = AniPang.stageHeight*0.093;
			
			var informTextField : Image = new Image(_missonAtals.getTexture("text"));
			informTextField.width = _upPanelImage.width *0.9;
			informTextField.height = _upPanelImage.height *0.2;
			informTextField.x = _upPanelImage.x + informTextField.width*0.05;
			informTextField.y = _upPanelImage.y + _upPanelImage.height;
			
			_completeProgress = new Progress(true, _missonAtals.getTexture("progressback"), _missonAtals.getTexture("progress"));
			_completeProgress.ProgressInit(_upPanelImage.x + _upPanelImage.width*0.086, _upPanelImage.y + _upPanelImage.height*0.47, _upPanelImage.width*0.6, _upPanelImage.height*0.3);
			_completeProgress.text = "0/" + String(MAX_MISSON_COUNT);
			_completeProgress.calcValue(MAX_MISSON_COUNT, 0);
			
			var allClearReward : Image = new Image(_missonAtals.getTexture("coin5000"));
			allClearReward.width = _upPanelImage.width/5;
			allClearReward.height = allClearReward.width;
			allClearReward.x = _upPanelImage.x + _upPanelImage.width - allClearReward.width*1.18;
			allClearReward.y = _upPanelImage.y + _upPanelImage.height - allClearReward.height*1.1;
			
			_allCompleteImage = new Image(_missonAtals.getTexture("complete"));
			_allCompleteImage.x = _upPanelImage.x;
			_allCompleteImage.y = _upPanelImage.y;
			_allCompleteImage.width = _upPanelImage.width;
			_allCompleteImage.height = _upPanelImage.height;
			_allCompleteImage.visible = false;
			_allCompleteImage.addEventListener(TouchEvent.TOUCH, onTounchUpPanel);
			
			addChild(informTextField);
			addChild(_upPanelImage);
			addChild(_completeProgress);
			addChild(allClearReward);
			addChild(_allCompleteImage);
		}
		
		private function onEnterFrame():void
		{
			//남은 시간을 계산
			calcRemainTime();
			//미션 달성도를 나타내는 프로그래스 바
			_completeProgress.calcValue(MAX_MISSON_COUNT, CurUserData.instance.userData.today_CompleteCount);
			_completeProgress.text = CurUserData.instance.userData.today_CompleteCount + "/" + String(MAX_MISSON_COUNT);
			
			if(CurUserData.instance.userData.today_CompleteString == "Complete") return;
			
			if(CurUserData.instance.userData.today_CompleteCount == 10)
			{
				_allCompleteImage.visible = true;
			}
		}
		
		/**
		 * 모든 미션을 클리어 할 경우 클릭 하면 모든 미션 달성 보상 코인 5000 획득
		 */		
		private function onTounchUpPanel(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch((event.currentTarget as Image), TouchPhase.ENDED);

			if(touch)
			{
				_popupWindow = new PopupWindow("모든 미션 완료 하여 코인 5000개를 받았습니다.", 1, new Array("o"));
				parent.addChild(_popupWindow);
				CurUserData.instance.userData.gold += 5000;
				CurUserData.instance.userData.today_CompleteString = "Complete";
				(event.currentTarget as Image).removeEventListener(TouchEvent.TOUCH, onTounchUpPanel);
			}
		}
		
		/**
		 * 현재 시간과 자정까지의 시간을 비교하여 남은 시간을 화면에 출력
		 */		
		private function calcRemainTime():void
		{
			var curDate : Date = new Date();
			var midnight : Date = UtilFunction.getMidnight();
			
			var remainTime : int = midnight.getTime() - curDate.getTime();

			_todayTimer.text = "초기화까지 남은 시간   " + UtilFunction.makeTime(remainTime/1000);
			
			if(remainTime <= 100)
			{
				CurUserData.instance.initMission();
				_popupWindow = new PopupWindow("자정이 되어 미션을 초기화 합니다.", 1, new Array("o"));
				parent.addChild(_popupWindow);
				parent.removeChild(this, true);
			}
			
			curDate = null;
			midnight = null;
		}
		
		/**
		 * 타이머 텍스트 필드를 화면에 출력
		 */		
		private function drawTodayTimer():void
		{
			_todayTimer = new TextField(_upPanelImage.width*0.66, _upPanelImage.height/2);
			_todayTimer.x = _upPanelImage.x + _upPanelImage.width*0.05;
			_todayTimer.y = _upPanelImage.y + _upPanelImage.height*0.44;
			_todayTimer.format.verticalAlign = Align.BOTTOM;
			_todayTimer.format.size = _upPanelImage.height/8;
			_todayTimer.format.bold = true;
			_todayTimer.format.color = 0x847357;
			
			addChild(_todayTimer);
		}
		
		/**
		 * 사용자가 완료 한 일일 미션은 리스트에 제외 하고 완료 되었을 경우에는 완료 스템프를 찍어주는 작업을 하는 함수
		 */		
		private function drawListView():void
		{
			if(CurUserData.instance.userData.today_CompleteString == "Complete") return;
			
			var vectorCnt : int = 0;
			var i : int = 0;
			
			_listView = new ListView(AniPang.stageWidth*0.1, AniPang.stageHeight*0.48, AniPang.stageWidth*0.8, AniPang.stageHeight*0.31);
			//일일 미션이 완료가 아닌 부분안 리스트 벡터에 삽입
			for(i = 0; i < 10; i++)
			{
				if(CurUserData.instance.userData.today_CompleteString.charAt(i) == "O") continue;
				
				_listVector.push(new Sprite());
				_listVector[vectorCnt++].name = String(i);
			}
			//아직 완료가 안된 일일 미션의 리스트를 초기화 
			//완료 했을 경우 완료 스템프와 클릭 이벤트를 설정
			//미 완료 일 경우 현재 진행 상태를 출력
			for( i = 0; i < _listVector.length; i++)
			{
				var listImage : Image = new Image(_missonAtals.getTexture("list"));
				listImage.width = AniPang.stageWidth*0.8;
				listImage.height =  int(AniPang.stageHeight*0.1);
				_listVector[i].addChild(listImage);
				
				var itemIcon : Image = new Image(_missonAtals.getTexture("heart1"));
				
				var completeImage : Image = new Image(_missonAtals.getTexture("complete"));
				completeImage.visible = false;
				
				var textField : TextField = new TextField(listImage.width, listImage.height);
				textField.format.size = listImage.height/7;
				textField.format.bold = true;
				textField.format.color = 0x847357;
				
				_listVector[i].addChild(textField);
				_listVector[i].addChild(itemIcon);
				_listVector[i].addChild(completeImage);
				
				itemIcon.width = listImage.width/6;
				itemIcon.height = listImage.width/6;
				itemIcon.x = listImage.width - itemIcon.width;
				itemIcon.y = itemIcon.height/8;
				
				completeImage.width = listImage.width;
				completeImage.height = listImage.height;
				
				_listVector[i].addEventListener("GAIN_ITEM", onGainItem);
				
				switch(_listVector[i].name)
				{
					case "0":
					{
						itemIcon.texture = _missonAtals.getTexture("heart1");
						textField.text = "하루에 1회 접속하기!";
						_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
						completeImage.visible = true;
						break;
					}
					case "1":
					{
						itemIcon.texture = _missonAtals.getTexture("coint300");
						textField.text = "게임 1판 플레이! (" + CurUserData.instance.userData.today_GameCount +"/1)";
						
						if(CurUserData.instance.userData.today_GameCount >= 1)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}
					case "2":
					{
						itemIcon.texture = _missonAtals.getTexture("coin500");
						textField.text = "게임 3판 플레이! (" + CurUserData.instance.userData.today_GameCount +"/3)";
						
						if(CurUserData.instance.userData.today_GameCount >= 3)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}
					case "3":
					{
						itemIcon.texture = _missonAtals.getTexture("coin1000");
						textField.text = "게임 5판 플레이! (" + CurUserData.instance.userData.today_GameCount +"/5)";
						
						if(CurUserData.instance.userData.today_GameCount >= 5)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}
					case "4":
					{
						itemIcon.texture = _missonAtals.getTexture("heart1");
						textField.text = "50,000점 이상 기록 하기! (" + CurUserData.instance.userData.today_MaxScore +"/50000)";
						
						if(CurUserData.instance.userData.today_MaxScore >= 50000)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}
					case "5":
					{
						itemIcon.texture = _missonAtals.getTexture("heart5");
						textField.text = "500,000점 이상 기록 하기! (" + CurUserData.instance.userData.today_MaxScore +"/500000)";
						
						if(CurUserData.instance.userData.today_MaxScore >= 500000)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}
					case "6":
					{
						itemIcon.texture = _missonAtals.getTexture("coin1000");
						textField.text = "1,000,000점 이상 기록 하기! (" + CurUserData.instance.userData.today_MaxScore +"/1000000)";
						
						if(CurUserData.instance.userData.today_MaxScore >= 1000000)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}
					case "7":
					{
						itemIcon.texture = _missonAtals.getTexture("heart1");
						textField.text = "아이템 1회 사용하기! (" + CurUserData.instance.userData.today_UseItemCount +"/1)";
						
						if(CurUserData.instance.userData.today_UseItemCount >= 1)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}
					case "8":
					{
						itemIcon.texture = _missonAtals.getTexture("coin500");
						textField.text = "아이템 3회 사용하기! (" + CurUserData.instance.userData.today_UseItemCount +"/3)";
						
						if(CurUserData.instance.userData.today_UseItemCount >= 3)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}
					case "9":
					{
						itemIcon.texture = _missonAtals.getTexture("coin1000");
						textField.text = "아이템 5회 사용하기! (" + CurUserData.instance.userData.today_UseItemCount +"/5)";
						
						if(CurUserData.instance.userData.today_UseItemCount >= 5)
						{
							_listVector[i].addEventListener(TouchEvent.TOUCH, onTouch);
							completeImage.visible = true;
						}
						break;
					}		
				}
			}
		
			_listView.drawList(_listVector);
			addChild(_listView);
		}
		
		/**
		 * 일일 미션을 완료 했을 경우 생기는 클릭 이벤트
		 * 클릭 한 일일 미션 리스트에 따라 완료 된 리스트는 화면에서 지우라는 이벤트 발생
		 * 클릭 한 일일 미션 리스트에 따라 완료 보상을 획득 하라는 이벤트 발생
		 */				
		private function onTouch(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(event.currentTarget as Sprite, TouchPhase.ENDED);
			var posInvector : int = _listVector.indexOf((event.currentTarget as Sprite));
			trace(posInvector);
			
			var tempName : int = int((event.currentTarget as Sprite).name);
			
			if(touch)
			{
    			CurUserData.instance.userData.today_CompleteCount++;
				
				switch((event.currentTarget as Sprite).name)
				{
					case "0":
					{
						//완료 보상을 획득 하라는 이벤트 바생
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "하트 1개"));
						CurUserData.instance.userData.today_CompleteString = "O" + CurUserData.instance.userData.today_CompleteString.substr(1, 9);
						//완료 리스트를 화면에서 지우라는 이벤트 발생
						_listView.dispatchEvent(new Event("LIST_REARRANGE", true, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}
					
					case "1": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 300개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}
					case "2": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 500개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}
					case "3": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 1000개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}
					case "4": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "하트 1개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}
					case "5": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "하트 5개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}
					case "6": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 1000개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}
					case"7":
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "하트 1개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}
					case "8":
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 500개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
																			+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						trace(CurUserData.instance.userData.today_CompleteString);
						break;
					}	
					
					case "9":
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 1000개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, 9) + "O";
						trace(CurUserData.instance.userData.today_CompleteString);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
					}
				}
				
				(event.currentTarget as Sprite).removeEventListener(TouchEvent.TOUCH, onTouch);
			}
		}
		
		/**
		 * @param data		완료 보상의 타입
		 * 완료 보상의 타입에 따라 보상을 획득하여 사용자 데이터에 적용하는 콜백 함수
		 */		
		private function onGainItem(event : Event, data : String):void
		{
			switch(data)
			{
				case "하트 1개":
				{
					_popupWindow = new PopupWindow("보상으로 하트 1개를 받았습니다.", 1, new Array("o"));
					parent.addChild(_popupWindow);
					CurUserData.instance.userData.heart++;
					break;
				}
					
				case "하트 5개":
				{
					_popupWindow = new PopupWindow("보상으로 하트 5개를 받았습니다.", 1, new Array("o"));
					parent.addChild(_popupWindow);
					CurUserData.instance.userData.heart += 5;
					break;
				}
					
				case "코인 300개":
				{
					_popupWindow = new PopupWindow("보상으로 코인 300개를 받았습니다.", 1, new Array("o"));
					parent.addChild(_popupWindow);
					CurUserData.instance.userData.gold+=300;
					break;
				}
					
				case "코인 500개":
				{
					_popupWindow = new PopupWindow("보상으로 코인 500개를 받았습니다.", 1, new Array("o"));
					parent.addChild(_popupWindow);
					CurUserData.instance.userData.gold+=500;
					break;
				}
					
				case "코인 1000개":
				{
					_popupWindow = new PopupWindow("보상으로 코인 1000개를 받았습니다.", 1, new Array("o"));
					parent.addChild(_popupWindow);
					CurUserData.instance.userData.gold+=1000;
					break;
				}
					
				case "코인 5000개":
				{
					_popupWindow = new PopupWindow("보상으로 코인 5000개를 받았습니다.", 1, new Array("o"));
					parent.addChild(_popupWindow);
					CurUserData.instance.userData.gold+=5000;
					break;
				}
				(event.currentTarget as Sprite).removeEventListener("GAIN_ITEM", onGainItem)
			}
			
		}
		
		private function onExit():void
		{
			parent.removeChild(this, true);
		}
	}
}