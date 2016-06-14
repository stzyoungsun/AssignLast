package UI.window
{
	import loader.TextureManager;

	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;
	
	import util.LVFunction;
	import util.UtilFunction;

	public class ItemWindow extends Sprite
	{
		private var _mainImage : Image;
		private var _itemImage : Image;
		private var _itemTextField : TextField;
		
		private var _itemwindowAtals : TextureAtlas;
		private var _itemName : String;
		
		private var _timerTextField : TextField;
	
		private var _lvTextField : TextField;
		private var _remainStarTextField : TextField;
		
		/**
		 * 
		 * @param color
		 * @param itemName
		 * @param plusFlag
		 * 
		 */		
		public function ItemWindow(itemTexture : Texture, x : int, y : int, width : int, height : int, color : uint, itemName : String)
		{
			_itemwindowAtals = TextureManager.getInstance().atlasTextureDictionary["itemAndreslutWindow.png"];
			
			_itemName = itemName;
			_mainImage = new Image(_itemwindowAtals.getTexture("itemWindow"));
			_mainImage.x = x;
			_mainImage.y = y;
			_mainImage.width = width;
			_mainImage.height = height;
			
			_itemImage = new Image(itemTexture);
			_itemImage.width = _mainImage.width/5;
			_itemImage.height = _itemImage.width;
			_itemImage.x = _mainImage.x;
			_itemImage.y = _mainImage.y;
			
			_itemTextField = new TextField(_mainImage.width, _mainImage.height);
			_itemTextField.x = _mainImage.x;
			_itemTextField.y = _mainImage.y;
			_itemTextField.text = "0";
			_itemTextField.format.color = color;
			_itemTextField.format.bold = true;
			_itemTextField.format.size = _itemImage.width/2;
			
			addChild(_mainImage);
			addChild(_itemImage);
			addChild(_itemTextField);
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if(_itemName == "HEART")
				drawTimer();
			
			if(_itemName == "STAR")
				drawStar();
		}
		
		/** 
		 * 아이템 윈도우 종류에 따라 데이터의 변경을 관찰하고 변환된 값을 화면에 출력
		 */		
		private function onEnterFrame():void
		{
			switch(_itemName)
			{
				case "HEART":
				{
					if(CurUserData.instance.userData.heart >= 5)
					{
						_timerTextField.visible = false;
						_itemTextField.text = "MAX + " + String(CurUserData.instance.userData.heart - 5);
						AniPang.heartTimer = AniPang.HEART_TIME;
					}
					
					else
					{
						_timerTextField.visible = true;
						_itemTextField.text = UtilFunction.makeCurrency((String(CurUserData.instance.userData.heart)));
						_timerTextField.text = UtilFunction.makeTime(AniPang.heartTimer);
					}
					break;
				}
					
				case "COIN":
				{
					_itemTextField.text = UtilFunction.makeCurrency((String(CurUserData.instance.userData.gold)));
					break;
				}
					
				case "STAR":
				{
					LVFunction.calcLV(CurUserData.instance.userData.totalStar);
					_lvTextField.text = String(CurUserData.instance.userData.lv);
					_itemTextField.text = String(LVFunction.calcRemainPercent(CurUserData.instance.userData.lv, CurUserData.instance.userData.remainStar)) + "%";
					break;
				}
			}
			
		}
		
		private function drawTimer() : void
		{
			_itemTextField.text = UtilFunction.makeCurrency((String(CurUserData.instance.userData.heart)));
			
			_timerTextField = new TextField(_itemTextField.width/4, _itemTextField.height);
			_timerTextField.x = _itemTextField.x + _itemTextField.width*0.7;
			_timerTextField.y = _itemTextField.y;
			_timerTextField.text = UtilFunction.makeTime(AniPang.heartTimer);
			_timerTextField.format.size = _itemTextField.height/3;
			
			addChild(_timerTextField);
		}
		
		private function drawStar():void
		{
			_lvTextField = new TextField(_itemTextField.width/4, _itemTextField.height);
			_lvTextField.x = _itemTextField.x*0.993;
			_lvTextField.y = _itemTextField.y*0.98;
			_lvTextField.text = "1";
			_lvTextField.format.size = _itemTextField.height/3;
			_lvTextField.format.bold = true;
			
			addChild(_lvTextField);
			
		}
	}
}