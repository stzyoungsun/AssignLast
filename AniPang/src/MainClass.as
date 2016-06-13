package
{
	import com.lpesign.Extension;
	
	import flash.desktop.NativeApplication;
	import flash.ui.Keyboard;
	
	import UI.popup.PopupWindow;
	
	import gamescene.TitleScene;
	
	import loader.ResourceLoader;
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import starling.core.Starling;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.KeyboardEvent;
	
	public class MainClass extends Sprite
	{
		private static var _sceneStage : Sprite = new Sprite();
		private static var _current : Sprite
		//Note @유영선 리소스를 로드하는 LoaderControl 생성
		private var _resourceLoader : ResourceLoader;
		
		private  var _exitPopupWindow : PopupWindow;
		
		public function MainClass()
		{
			_current = this;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
			_resourceLoader = new ResourceLoader(onLoaderComplete, onProgress);
			_resourceLoader.resourceLoad("PrevLoadResource");
			Starling.current.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
		}		
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			if(event.keyCode == Keyboard.BACK)
			{
				event.preventDefault();
				drawExitPopup();
			}
		}
		
		public function drawExitPopup():void
		{
			// TODO Auto Generated method stub
			_exitPopupWindow = new PopupWindow("정말 종료 하실 껀가요 ㅠㅠ", 2, new Array("x","o"), null, onExit);
			addChild(_exitPopupWindow);
		}
		
		public function onExit() : void
		{
			AniPang.exitFlag = true;
			dispose();
			//Extension.instance.exitDialog();
			NativeApplication.nativeApplication.exit();
		}
		
		private function onProgress(progressCount : Number):void{}
		
		private function onLoaderComplete():void
		{
			TextureManager.getInstance().createAtlasTexture();
			
			var titleView : TitleScene = new TitleScene();
			SceneManager.instance.addScene(titleView);
			SceneManager.instance.sceneChange();
			
			_resourceLoader = null;
		}
		
		public override function dispose():void
		{
			super.dispose();
			removeChildren(0, -1, true);
			removeEventListeners();
		}
		
		public static function get sceneStage():Sprite{return _sceneStage;}
		public static function set sceneStage(value:Sprite):void{_sceneStage = value;}
		
		public static function get current():Sprite{return _current;}
		public static function set current(value:Sprite):void{_current = value;}
	}
}