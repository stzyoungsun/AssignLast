package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	[SWF(width="600", height="999", frameRate="60", backgroundColor="#ffffff")]
	public class AniPang extends Sprite
	{
		private var _mainStarling:Starling;
		
		public static var stageWidth : Number;
		public static var stageHeight : Number;
		
		public function AniPang()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stageWidth = stage.stageWidth;
			stageHeight = stage.stageHeight;
			
			_mainStarling = new Starling(MainClass, stage);
			_mainStarling.showStats = true;
			_mainStarling.start();
		}
	}
}