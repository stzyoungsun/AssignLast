package UI.window
{
	import UI.checkbox.ImageCheckBox;
	
	import loader.TextureManager;
	
	import starling.display.Image;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.TextureAtlas;
	
	public class ItemShopWindow extends MainWindow
	{
		private var _windowAtals : TextureAtlas;
		private var _itemwindowAtals : TextureAtlas;
		
		private var _upPanel : Image;
		private var _mainPanel : Image;
		private var _downPanel : Image;
		
		private var _priceList : Image;
		private var _totalTextField : TextField;
		private var _coinImage : Image;
		private var _priceTextField : TextField;
		
		private var _maoCheckBox : ImageCheckBox;
		private var _timeCheckBox : ImageCheckBox;
		private var _maoImage : Image;
		private var _timeImage : Image;
		private var _maoprice : TextField;
		private var _timeprice : TextField;
		
		private var _notUpdateImages : Vector.<Image> = new Vector.<Image>;
		public function ItemShopWindow(nameWindowColor : String, nameWindowText : String)
		{
			super(nameWindowColor, nameWindowText)
			
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			
			_mainPanel = new Image(_windowAtals.getTexture("subWindow"));
			_downPanel = new Image(_itemwindowAtals.getTexture("informWindow"));
			_priceList = new Image(_itemwindowAtals.getTexture("subWindow1"));
			_coinImage = new Image(_itemwindowAtals.getTexture("coinIcon"));
			
			_maoCheckBox = new ImageCheckBox(_itemwindowAtals.getTexture("ItemIcon2"), _itemwindowAtals.getTexture("ItemIcon1"), "MAO");
			_timeCheckBox = new ImageCheckBox(_itemwindowAtals.getTexture("ItemIcon2"), _itemwindowAtals.getTexture("ItemIcon1"), "TIMEUP");
			_maoImage = new Image(_itemwindowAtals.getTexture("maoItem"));
			_timeImage = new Image(_itemwindowAtals.getTexture("timeItem"));
			
			for(var i : int = 0; i < 8; i ++)
				_notUpdateImages.push(new Image(_itemwindowAtals.getTexture("ItemIcon3")));
		}
		
		public override function init(x : int, y : int, width: int, height : int) : void
		{
			super.init(x, y, width, height);
			
			_mainPanel.width = width;
			_mainPanel.height = height*0.55;
			_mainPanel.x = x;
			_mainPanel.y = y*2.3;
			addChild(_mainPanel);
			
			_priceList.width = _mainPanel.width/2;
			_priceList.height = height*0.1;
			_priceList.x = _mainPanel.width*0.25;
			_priceList.y = _mainPanel.y + _mainPanel.height - _priceList.height;
			addChild(_priceList);

			_coinImage.width = _priceList.width/10;
			_coinImage.height = _coinImage.width;
			_coinImage.x = _priceList.x*1.6;
			_coinImage.y = _mainPanel.y + _mainPanel.height - _priceList.height*0.8;
			addChild(_coinImage);
			
			_totalTextField = new TextField(_priceList.width/3, _priceList.height);
			_totalTextField.text = "합계";
			_totalTextField.format.color = 0x5DB2AB;
			_totalTextField.format.size = _coinImage.height;
			_totalTextField.format.bold = true;
			_totalTextField.x = _priceList.x;
			_totalTextField.y = _coinImage.y*0.98;
			addChild(_totalTextField);
			
			_priceTextField = new TextField(_priceList.width*0.7, _priceList.height);
			_priceTextField.text = "0";
			_priceTextField.format.color = 0x767676;
			_priceTextField.format.size = _coinImage.height;
			_priceTextField.format.bold = true;
			_priceTextField.x = _coinImage.x;
			_priceTextField.y = _coinImage.y*0.98;
			addChild(_priceTextField);
			
			_downPanel.width = width;
			_downPanel.height = height*0.1;
			_downPanel.x = x;
			_downPanel.y = _mainPanel.y + _mainPanel.height;
			addChild(_downPanel);
			
			_maoCheckBox.width = _mainPanel.width/6;
			_maoCheckBox.height = _mainPanel.height/2.5;
			_maoCheckBox.x = _mainPanel.x + _mainPanel.width/38;
			_maoCheckBox.y = _mainPanel.y*1.01;
			_maoCheckBox.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_maoCheckBox);
			
			_maoImage.width = _maoCheckBox.width*0.6;
			_maoImage.height = _maoCheckBox.height*0.6;
			_maoImage.x = _maoCheckBox.x + _maoImage.width/3;
			_maoImage.y = _maoCheckBox.y + _maoImage.height/5;
			_maoImage.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_maoImage);
			
			_maoprice = new TextField(_maoCheckBox.width, _maoCheckBox.height/5);
			_maoprice.text = "1200";
			_maoprice.format.color = 0xffffff;
			_maoprice.format.size = _maoCheckBox.height/7;
			_maoprice.format.bold = true;
			_maoprice.x = _maoCheckBox.x*1.2;
			_maoprice.y = _maoCheckBox.y*1.26;
			addChild(_maoprice);
			
			_timeCheckBox.width = _mainPanel.width/6;
			_timeCheckBox.height = _mainPanel.height/2.5;
			_timeCheckBox.x = _mainPanel.x + _maoCheckBox.width + _mainPanel.width/38*2;
			_timeCheckBox.y = _mainPanel.y*1.01;
			_timeCheckBox.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_timeCheckBox);
			
			_timeImage.width = _timeCheckBox.width*0.6;
			_timeImage.height = _timeCheckBox.height*0.6;
			_timeImage.x = _timeCheckBox.x + _timeImage.width/3;
			_timeImage.y = _timeCheckBox.y + _timeImage.height/5;
			_timeImage.addEventListener(TouchEvent.TOUCH, onClicked);
			addChild(_timeImage);
			
			_timeprice = new TextField(_timeCheckBox.width, _timeCheckBox.height/5);
			_timeprice.text = "270";
			_timeprice.format.color = 0xffffff;
			_timeprice.format.size = _timeCheckBox.height/7;
			_timeprice.format.bold = true;
			_timeprice.x = _timeCheckBox.x*1.05;
			_timeprice.y = _timeCheckBox.y*1.26;
			addChild(_timeprice);
			
			var i : int;
			for(i = 0; i < 3; i ++)
			{
				_notUpdateImages[i].width = _mainPanel.width/6;
				_notUpdateImages[i].height = _mainPanel.height/2.5;
				_notUpdateImages[i].x = _mainPanel.x + _maoCheckBox.width*(i+2) + _mainPanel.width/38*(i+3);
				_notUpdateImages[i].y = _mainPanel.y*1.01;
				addChild(_notUpdateImages[i]);
			}
			
			for(i = 3; i < 8; i ++)
			{
				_notUpdateImages[i].width = _mainPanel.width/6;
				_notUpdateImages[i].height = _mainPanel.height/2.5;
				_notUpdateImages[i].x = _mainPanel.x + _maoCheckBox.width*(i-3) + _mainPanel.width/38*(i-2);
				_notUpdateImages[i].y = _mainPanel.y*1.01 + _maoCheckBox.height;
				addChild(_notUpdateImages[i]);
			}
		}
		
		private function onClicked(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);
			
			if(touch)
			{
				switch(event.currentTarget)
				{
					case _maoImage:
					case _maoCheckBox:
					{
						_maoCheckBox.dispatchEvent(new Event("CHECK"));
						if(_maoCheckBox.clickedFlag == false)
						{
							
						}
						break;
					}
					
					case _timeImage:
					case _timeCheckBox:
					{
						_timeCheckBox.dispatchEvent(new Event("CHECK"));
						break;
					}
				}
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
			
			removeChildren(0 , -1, true);
			removeEventListeners();
			
			_windowAtals.dispose();
			_windowAtals = null;
			
			_itemwindowAtals.dispose();
			_itemwindowAtals = null;
			
			_notUpdateImages = null;
		}
	}
}