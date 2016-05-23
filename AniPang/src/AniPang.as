package
{
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	
	import starling.core.Starling;
	
	public class AniPang extends Sprite
	{
		private var _mainStarling:Starling;
		
		public function AniPang()
		{
			super();
			
			// support autoOrients
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_mainStarling = new Starling(MainClass, stage);
			_mainStarling.showStats = true;
			_mainStarling.start();
		}
	}
}