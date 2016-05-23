package
{
	import gameview.PlayView;
	
	import starling.display.Sprite;
	import starling.events.Event;
	
	public class MainClass extends Sprite
	{
		private var _playView : PlayView = null;
		
		public function MainClass()
		{
			addEventListener(Event.ADDED_TO_STAGE, initialize);
		}
		
		private function initialize():void
		{
			if(_playView == null)
				_playView = new PlayView();
			
			addChild(_playView);
		}		
		
	}
}