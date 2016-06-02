package gameview
{
	import com.lpesign.KakaoExtension;
	
	import flash.events.StatusEvent;
	
	import loader.ResourceLoader;
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;
	import user.CurUserDataFile;


	public class TitleView extends Sprite
	{
		//Note @유영선 리소스를 로드하는 LoaderControl 생성
		private var _resourceLoader : ResourceLoader;
		
		//Note @유영선 메뉴 화면 이미지
		private var _titleImage:Image;
		//로딩 중 이미지
		private var _loadingImage:Image;
		//Note @유영선 화면을 터치해주세요 이미지
		private var _titleText:MovieClip;
		
		private var _loadingGaugeTexture:TextureAtlas;
		public function TitleView()
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{	
			
			removeEventListener(Event.ADDED_TO_STAGE, initialize);
			
			_titleImage = new Image(TextureManager.getInstance().textureDictionary["titleView.png"]);
			_titleImage.width = AniPang.stageWidth;
			_titleImage.height = AniPang.stageHeight;
			addChild(_titleImage);
//			
//			if(KakaoExtension.instance.loginState() == "LOGIN_OFF")
//			{
//				KakaoExtension.instance.login();
//				KakaoExtension.instance.addEventListener("LOGIN_OK", onLoginOK);
//			}
//			
//			else
//			{
				var curUserData : String = CurUserDataFile.loadData();
				//trace(curUserData);
				if(curUserData != "")
				{
					CurUserData.instance.addEventListener("PROFILE_LOAD_OK",onLoadOK);
					CurUserData.instance.initData(curUserData);
				}
			//}	
		}		
		
		private function onLoginOK(event : StatusEvent) : void
		{
//			KakaoExtension.instance.removeEventListener("LOGIN_OK", onLoginOK);
//			
//			trace("유저 데이터 : " + KakaoExtension.instance.curUserData());
//			CurUserData.instance.addEventListener("PROFILE_LOAD_OK",onLoadOK);
//			CurUserData.instance.initData(KakaoExtension.instance.curUserData());
		}
		
		private function onLoadOK():void
		{
			CurUserData.instance.removeEventListener("PROFILE_LOAD_OK",onLoadOK);
			
			_loadingGaugeTexture = TextureManager.getInstance().atlasTextureDictionary["loading_gauge.png"];
			_loadingImage = new Image(_loadingGaugeTexture.getTexture("30"));
			_loadingImage.x = _titleImage.width / 4;
			_loadingImage.y = _titleImage.height * 3 / 4;
			_loadingImage.width = _titleImage.width / 2;
			_loadingImage.height = _titleImage.height / 20;
			addChild(_loadingImage);
			
			_resourceLoader = new ResourceLoader(onLoaderComplete, onProgress);
			_resourceLoader.resourceLoad("resource");
		}
		
		private function onProgress(progressCount : Number):void
		{
			//Note @유영선 각각 상태 카운터에 따라 로딩 이미지를 설정
			if(progressCount == 60)
			{
				_loadingImage.texture = _loadingGaugeTexture.getTexture("60");

			}
			else
			{
				_loadingImage.texture = _loadingGaugeTexture.getTexture("90");
			}
		}
		
		private function onLoaderComplete():void
		{
			removeChild(_loadingImage);
			_loadingImage.dispose();
			_loadingImage = null;
			
			TextureManager.getInstance().created = false;
			TextureManager.getInstance().createAtlasTexture();			
			 
			_titleText = new MovieClip(TextureManager.getInstance().atlasTextureDictionary["press_touch.png"].getTextures("press_touch"));
			_titleText.x = _titleImage.width / 4;
			_titleText.y = _titleImage.height * 3 / 4;
			_titleText.width = AniPang.stageWidth/2;
			_titleText.height = AniPang.stageHeight/10;
			_titleText.play();
			Starling.juggler.add(_titleText);
			addChild(_titleText);
			
			addEventListener(TouchEvent.TOUCH, onTouch);
			
			_resourceLoader = null;
		
		}
		
		private function onTouch(event : TouchEvent):void
		{
			var touch : Touch = event.getTouch(this);
			
			if(touch)
			{
				switch(touch.phase)
				{
					case TouchPhase.ENDED:
					{
						var mainView : MainView = new MainView();
						SceneManager.instance.addScene(mainView);
						SceneManager.instance.sceneChange();
						break;
					}
				}
			}
		}
		
	}
}