package
{
	import gameview.PlayView;
	
	import loader.ResourceLoader;
	import loader.TextureManager;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MainClass extends Sprite
	{
		private var _playView : PlayView = null;
		//Note @유영선 리소스를 로드하는 LoaderControl 생성
		private var _resourceLoader : ResourceLoader;
		
		public function MainClass()
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
			_resourceLoader = new ResourceLoader(onLoaderComplete, onProgress);
			_resourceLoader.resourceLoad("resource");
		}		
		
		private function onProgress(progressCount : Number):void
		{

			
		}
		
		private function onLoaderComplete():void
		{
			TextureManager.getInstance().createAtlasTexture();
			
			if(_playView == null)
				_playView = new PlayView();
			
			addChild(_playView);
		}
		
	}
}