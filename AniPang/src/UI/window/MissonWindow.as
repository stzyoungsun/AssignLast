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
		
		private static var _temp : int = 50;
		
		private var _listVector : Vector.<Sprite> = new Vector.<Sprite>;
		public function MissonWindow()
		{
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_missonAtals = TextureManager.getInstance().atlasTextureDictionary["missonWindow.png"];
			
			super("Green", "오늘의 미션", _missonAtals.getTexture("back"));
			addEventListener("EXIT", onExit);
			this.init(AniPang.stageWidth*0.1, AniPang.stageHeight*0.2, AniPang.stageWidth*0.8, AniPang.stageHeight*0.6);
			
			drawUpPanel();
			drawListView();
			drawTodayTimer();
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
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
			
			addChild(informTextField);
			addChild(_upPanelImage);
			addChild(_completeProgress);
			addChild(allClearReward);
		}
		
		private function onEnterFrame():void
		{
			_completeProgress.calcValue(MAX_MISSON_COUNT, CurUserData.instance.userData.today_CompleteCount);
			_completeProgress.text = CurUserData.instance.userData.today_CompleteCount + "/" + String(MAX_MISSON_COUNT);
			calcRemainTime();
		}
		
		private function calcRemainTime():void
		{
			var curDate : Date = new Date();
			var midnight : Date = new Date();
			midnight.setHours(24, 0, 0, 0);	//테스트
			
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
		
		private function drawListView():void
		{
			var vectorCnt : int = 0;
			var i : int = 0;
			
			_listView = new ListView(AniPang.stageWidth*0.1, AniPang.stageHeight*0.48, AniPang.stageWidth*0.8, AniPang.stageHeight*0.31);
	
			for(i = 0; i < 10; i++)
			{
				if(CurUserData.instance.userData.today_CompleteString.charAt(i) == "O") continue;
				
				_listVector.push(new Sprite());
				_listVector[vectorCnt++].name = String(i);
			}
			
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
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "하트 1개"));
						CurUserData.instance.userData.today_CompleteString = "O" + CurUserData.instance.userData.today_CompleteString.substr(1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", true, posInvector));
						break;
					}
					
					case "1": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 300개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						break;
					}
					case "2": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 500개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						break;
					}
					case "3": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 1000개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						break;
					}
					case "4": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "하트 1개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						break;
					}
					case "5": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "하트 5개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						break;
					}
					case "6": 
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 1000개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						break;
					}
					case"7":
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "하트 1개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
							+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						break;
					}
					case "8":
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 500개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, tempName) + "O" 
																			+ CurUserData.instance.userData.today_CompleteString.substr(tempName+1, 9);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
						break;
					}	
					
					case "9":
					{
						(event.currentTarget as Sprite).dispatchEvent(new Event("GAIN_ITEM", false, "코인 1000개"));
						CurUserData.instance.userData.today_CompleteString = CurUserData.instance.userData.today_CompleteString.substr(0, 8) + "O";
						trace(CurUserData.instance.userData.today_CompleteString);
						_listView.dispatchEvent(new Event("LIST_REARRANGE", false, posInvector));
					}
				}
				
				(event.currentTarget as Sprite).removeEventListener(TouchEvent.TOUCH, onTouch);
			}
		}
		
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