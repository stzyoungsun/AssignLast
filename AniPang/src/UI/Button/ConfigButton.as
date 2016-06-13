package UI.Button
{
	import loader.TextureManager;
	
	import sound.SoundManager;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.Align;
	
	import user.CurUserData;

	public class ConfigButton extends Sprite
	{
		private var _buttonAtals : TextureAtlas;
		private var _windowAtals : TextureAtlas;
		
		private var _onButton : Button;
		private var _offButton : Button;
		
		private var _configName : String;
		
		public function ConfigButton(x : int, y :int, width : int, height :int, configIcon : Texture, configName : String, onFlag : String)
		{
			_buttonAtals = TextureManager.getInstance().atlasTextureDictionary["button.png"];
			_windowAtals = TextureManager.getInstance().atlasTextureDictionary["Window.png"];
			
			this.x = x;
			this.y = y;
			_configName = configName;
			
			var configIconImage : Image = new Image(configIcon);
			configIconImage.width = height;
			configIconImage.height = height;
			
			var configTextField : TextField = new TextField(width*0.3, height); 
			configTextField.x = configIconImage.width*2;
			configTextField.format.size = configTextField.height/2;
			configTextField.format.bold = true;
			configTextField.format.color = 0x197276;
			configTextField.text = configName;
			configTextField.format.horizontalAlign = Align.LEFT;
			
			var buttonLineImage : Image = new Image(_windowAtals.getTexture("onoff"));
			buttonLineImage.x = configTextField.x + configTextField.width;
			buttonLineImage.width = width/3;
			buttonLineImage.height = height;
			
			_onButton = new Button(_buttonAtals.getTexture("on"));
			_onButton.x = buttonLineImage.x;
			_onButton.width = buttonLineImage.width/2;
			_onButton.height = buttonLineImage.height;
			
			_offButton = new Button(_buttonAtals.getTexture("off"));
			_offButton.x = buttonLineImage.x + _onButton.width*0.9;
			_offButton.width = buttonLineImage.width/2;
			_offButton.height = buttonLineImage.height;

			if(onFlag == "ON")
			{
				_onButton.visible = true;
				_offButton.visible = false;
			}
			else
			{
				_onButton.visible = false;
				_offButton.visible = true;
			}
			
			_onButton.addEventListener(TouchEvent.TOUCH, onTouch);
			_offButton.addEventListener(TouchEvent.TOUCH, onTouch);
			
			addChild(configIconImage);
			addChild(configTextField);
			addChild(buttonLineImage);
			addChild(_onButton);
			addChild(_offButton);
		}
		
		private function onTouch(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this, TouchPhase.ENDED);

			if(touch)
			{
				SoundManager.getInstance().play("button.mp3", false);
				switch(event.currentTarget)
				{
					case _onButton:
						offFunction();
						_onButton.visible = false;
						_offButton.visible = true;
						break;
					
					case _offButton:
						onFunction();
						_onButton.visible = true;
						_offButton.visible = false;
						break;
				}
			}
		}
		
		private function offFunction():void
		{
			switch(_configName)
			{
				case "배경음":
				{
					SoundManager.getInstance().stopLoopedPlaying();
					CurUserData.instance.userData.backGoundSound = "OFF";
					break;
				}
					
				case "효과음":
				{
					CurUserData.instance.userData.effectSound = "OFF";
					break;
				}
					
				case "푸쉬 알림":
				{
					CurUserData.instance.userData.permitPush = "OFF";
					break;
				}
			}
		}
		
		private function onFunction():void
		{
			switch(_configName)
			{
				case "배경음":
				{
					SoundManager.getInstance().playLoopedPlaying();
					CurUserData.instance.userData.backGoundSound = "ON";
					break;
				}
					
				case "효과음":
				{
					CurUserData.instance.userData.effectSound = "ON";
					break;
				}
					
				case "푸쉬 알림":
				{
					CurUserData.instance.userData.permitPush = "ON";
					break;
				}
			}
		}
	}
}