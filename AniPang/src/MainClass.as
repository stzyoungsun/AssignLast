package
{
	import gameview.TitleView;
	
	import loader.ResourceLoader;
	import loader.TextureManager;
	
	import scene.SceneManager;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MainClass extends Sprite
	{
		private static var _sceneStage : Sprite = new Sprite();
		private static var _current : Sprite
		//Note @유영선 리소스를 로드하는 LoaderControl 생성
		private var _resourceLoader : ResourceLoader;
		
		public function MainClass()
		{
			_current = this;
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
			_resourceLoader = new ResourceLoader(onLoaderComplete, onProgress);
			_resourceLoader.resourceLoad("PrevLoadResource");
			
			
			addChild(_sceneStage);
		}		
		
		private function onProgress(progressCount : Number):void
		{

			
		}
		
		private function onLoaderComplete():void
		{
			TextureManager.getInstance().createAtlasTexture();
			
			var titleView : TitleView = new TitleView();
			SceneManager.instance.addScene(titleView);
			SceneManager.instance.sceneChange(false);
			
			_resourceLoader = null;
		}
		
		public static function get sceneStage():Sprite{return _sceneStage;}
		public static function set sceneStage(value:Sprite):void{_sceneStage = value;}
		
		public static function get current():Sprite{return _current;}
		public static function set current(value:Sprite):void{_current = value;}
	}
}