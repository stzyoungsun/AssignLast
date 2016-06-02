package
{

	import com.lpesign.KakaoExtension;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
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
	
			//KakaoExtension.instance.init();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			
			_mainStarling = new Starling(MainClass, stage);
			_mainStarling.showStats = true;
			_mainStarling.start();
			
			addEventListener(Event.ACTIVATE, activateListener);
			addEventListener(Event.DEACTIVATE, deactivateListener);
		}
		
		private function deactivateListener(event:Event):void
		{
			//CurUserDataFile.saveData(KakaoExtension.instance.curUserData());
		}
		
		private function activateListener(event:Event):void
		{
			
			
		}
	}
}