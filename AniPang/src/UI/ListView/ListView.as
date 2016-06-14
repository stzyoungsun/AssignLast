package UI.ListView
{
	import flash.geom.Point;
	
	import loader.TextureManager;
	
	import starling.display.Image;
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	public class ListView extends Sprite
	{
		private var _windowAtals : TextureAtlas;
		private var _missonAtals : TextureAtlas;
		
		private var _mainImage : Image;
		private var _list : Vector.<Sprite> = new Vector.<Sprite>;
		
		private var _prevMousePoint : Point = new Point();
		
		private var _moveValue : int = 0;
		private var _autoScrolTime : int = 0;
		
		private var _onTouchFlag : Boolean = false;
		private var _minListIndex : int = 0;

		/**
		 * 일일 미션에서 사용되는 리스트 뷰입니다.
		 * 손의 움직임에 따라 리스트가 움직이고 손을 빠르게 올렸다가 때면 리스트가 자동으로 위로 움직입니다.
		 * 리스트가 젤 아래로 갔을 경우 자동으로 위로 팅겨져 올라 갑니다.
		 * 특정 상태일 경우 리스트를 하나 클릭하면 자동으로 삭제가 됩니다
		 */		
		public function ListView(x : int, y : int, width: int, height : int)
		{
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			_missonAtals = TextureManager.getInstance().atlasTextureDictionary["missonWindow.png"];
			
			this.x = x;
			this.y = y;
		
			_mainImage = new Image(_missonAtals.getTexture("back"));
			_mainImage.x = 0;
			_mainImage.y = 0;
			_mainImage.width = width;
			_mainImage.height = height;
			
			addChild(_mainImage);
			addEventListener(TouchEvent.TOUCH, onTouch);
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener("LIST_REARRANGE", onListReArrange)
			this.mask = new Quad(width,height);
		}
		
		/**
		 * 손의 움직임에 따라 리스트가 움직 입니다.
		 */		
		private function onEnterFrame():void
		{
			if(_list.length ==0) return;
			
			if(_onTouchFlag == true)
			{
				if(_list[0].y + _moveValue > 0)  _moveValue = 0;
				
				if(_list[_list.length-1].y + _list[_list.length-1].height <= 0)  
				{
					_moveValue = AniPang.stageHeight/100;
					_autoScrolTime = 50;
					_onTouchFlag = true;
				}
				
				for(var i : int = 0; i < _list.length; i++)
				{
					_list[i].y+=_moveValue;
				}
				_autoScrolTime--;
				
				if(_autoScrolTime <= 0)
				{
					_moveValue = 0;
					_onTouchFlag = false;
				}
			}
		}
		
		/**
		 * @param data 리스트의 번호
		 * 일일 미션 완료 한 리스트를 클릭하면 그 리스트가 사라집니다.
		 */		
		private function onListReArrange(event : Event, data : int):void
		{
			_list[data].visible = false;
			_list.removeAt(data);
			
			for(var i : int = data; i < _list.length; i++)
			{
				_list[i].y -= _list[i].height * 1.1;
			}
	
		}
		
		/**
		 * 리스트 하나 하나를 뷰에 출력 합니다.
		 */		
		public function drawList( list : Vector.<Sprite>):void
		{
			_list = list;
			var termlist : int = 0;
			for(var i : int = 0; i < _list.length; i++)
			{
				termlist = i-1;
				if(termlist < 0) termlist = 0;
				
				_list[i].y = i * _list[termlist].height*1.1;
				
				addChild(_list[i]);
			}
		}
		
		private function onTouch(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this);
			_onTouchFlag = true;
			if(touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.MOVED:
					{
						_moveValue = touch.globalY - _prevMousePoint.y;
					}
						
					case TouchPhase.BEGAN:
					{
						_prevMousePoint.x = touch.globalX;
						_prevMousePoint.y = touch.globalY;

						break;
					}
					
					case TouchPhase.ENDED:
					{
						if(Math.abs(_moveValue) < AniPang.stageHeight/300)
							_autoScrolTime = 1;
						else
							_autoScrolTime = 50;
						break;
					}
				}
			}
		}
	}
}