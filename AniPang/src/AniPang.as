package
{

	import com.lpesign.KakaoExtension;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	import gameview.TitleView;
	
	import starling.core.Starling;
	
	import user.CurUserDataFile;

	[SWF(width="600", height="999", frameRate="60", backgroundColor="#ffffff")]
	public class AniPang extends Sprite
	{
		private var _mainStarling:Starling;

		public static var stageWidth : Number;
		public static var stageHeight : Number;
		
		public function AniPang()
		{
			super();
	
			KakaoExtension.instance.init();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			
			_mainStarling = new Starling(MainClass, stage);
			_mainStarling.showStats = true;
			_mainStarling.start();
			
			addEventListener(flash.events.Event.ACTIVATE, activateListener);
			addEventListener(flash.events.Event.DEACTIVATE, deactivateListener);
		}
		
		private function deactivateListener(event:flash.events.Event):void
		{
			if(TitleView.sTitleViewLoadFlag == true)
			{
				Starling.current.stop(true);
			}
		}
		
		private function activateListener(event:flash.events.Event):void
		{
			if(Starling.current.isStarted == false)
				Starling.current.start();
		}
	}
}