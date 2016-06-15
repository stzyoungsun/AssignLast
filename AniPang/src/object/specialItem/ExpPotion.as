package object.specialItem
{
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import starling.events.Event;

	public class ExpPotion
	{
		private static var _expPotionFlag : Boolean = false;
		private static var _remainSec : int = 0;
		
		public function ExpPotion(){throw new Error("Abstract Class"); }

		public static function expPotionStart(remainmillsecons : int) : void
		{
			_remainSec = remainmillsecons/1000;
			//_remainSec = 5;
			_expPotionFlag = true;
			AniPang.prevExpTimer = getTimer();
		}
		
		public static function expPotionStop() : void
		{
			_expPotionFlag = false;
			MainClass.current.dispatchEvent(new starling.events.Event("STOP_EXP_POTION"));
		}
		
		public static function get expPotionFlag():Boolean {return _expPotionFlag;}
		
		public static function get remainSec():int{return _remainSec;}
		public static function set remainSec(value:int):void{_remainSec = value;}
	}
}