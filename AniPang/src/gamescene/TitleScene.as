package gamescene
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
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	
	import user.CurUserData;

	public class TitleScene extends Sprite
	{
		//Note @유영선 리소스를 로드하는 LoaderControl 생성
		private var _resourceLoader : ResourceLoader;
		
		//Note @유영선 메뉴 화면 이미지
		private var _titleClip:MovieClip;
		//로딩 중 이미지
		private var _loadingImage:Image;
		//Note @유영선 화면을 터치해주세요 이미지
		private var _titleText:MovieClip;
		
		private var _loadingGaugeTexture:TextureAtlas;
		
		private var _titleFrame : Vector.<Texture> = new Vector.<Texture>;
		
		public static var sTitleViewLoadFlag : Boolean = false;
		public function TitleScene()
		{
			sTitleViewLoadFlag = false;
			
			//KakaoExtension.instance.addEventListener("LOGIN_OK", onLoginOK);
			addEventListener(Event.ADDED_TO_STAGE, initialize);
			
			//타이틀 이미지 저장
			_titleFrame.push(TextureManager.getInstance().textureDictionary["titleView1.png"]);
			_titleFrame.push(TextureManager.getInstance().textureDictionary["titleView2.png"]);
			_titleFrame.push(TextureManager.getInstance().textureDictionary["titleView3.png"]);
			_titleFrame.push(TextureManager.getInstance().textureDictionary["titleView4.png"]);
			_titleFrame.push(TextureManager.getInstance().textureDictionary["titleView5.png"]);
			_titleFrame.push(TextureManager.getInstance().textureDictionary["titleView6.png"]);
			_titleFrame.push(TextureManager.getInstance().textureDictionary["titleView7.png"]);
			
			_titleClip = new MovieClip(_titleFrame, 5);
			_titleClip.width = AniPang.stageWidth;
			_titleClip.height = AniPang.stageHeight;
			_titleClip.play();
			Starling.juggler.add(_titleClip);
			addChild(_titleClip);
		}
		
		private function initialize():void
		{	
			removeEventListener(Event.ADDED_TO_STAGE, initialize);

			//로그인 체크
//			if(KakaoExtension.instance.loginState() == "LOGIN_OFF")
//			{
//				//로그 아웃 상태 일 경우 로그인
//				KakaoExtension.instance.login();
//			}
//			
//			else
//			{
//				KakaoExtension.instance.dispatchEvent(new StatusEvent("LOGIN_OK"));
//			}
			onLoginOK(null); // 테스트용
		}	
		
		/**
		 * LOGIN_OK 전달 받으면 다음 단계 진행
		 */		
		private function onLoginOK(event : StatusEvent) : void
		{
			//KakaoExtension.instance.removeEventListener("LOGIN_OK", onLoginOK);
			
			_loadingGaugeTexture = TextureManager.getInstance().atlasTextureDictionary["loading_gauge.png"];
			_loadingImage = new Image(_loadingGaugeTexture.getTexture("30"));
			_loadingImage.x = _titleClip.width / 4;
			_loadingImage.y = _titleClip.height * 3 / 4;
			_loadingImage.width = _titleClip.width / 2;
			_loadingImage.height = _titleClip.height / 20;
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
			 
			//로그인 된 사용자 정보 입력
			CurUserData.instance.initData();
			CurUserData.instance.addEventListener("PROFILE_LOAD_OK",onLoadOK);
			onLoadOK(); //테스트용 코드
		}
		
		/**
		 * 프로필 사진의 업로드가 완료 후 다음 진행 
		 */		
		private function onLoadOK():void
		{
			sTitleViewLoadFlag = true;
			CurUserData.instance.removeEventListener("PROFILE_LOAD_OK",onLoadOK);
			
			_titleText = new MovieClip(TextureManager.getInstance().atlasTextureDictionary["press_touch.png"].getTextures("press_touch"));
			_titleText.x = _titleClip.width / 4;
			_titleText.y = _titleClip.height * 3 / 4;
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
						dispose();
						var mainView : MainScene = new MainScene();
						SceneManager.instance.addScene(mainView);
						SceneManager.instance.sceneChange();
						break;
					}
				}
			}
		}
		
		public override function dispose():void
		{
			super.dispose();
			
			removeChildren(0, -1, true);
			removeEventListeners();
			
			Starling.juggler.remove(_titleText);
			Starling.juggler.remove(_titleClip);
		}
		
	}
}