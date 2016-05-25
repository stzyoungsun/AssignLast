package blockobject.blocktype
{
	import blockobject.Block;

	public class GeneralTypeBlock extends Block
	{
		private var _faceFlag : Boolean = false;
		
		public function GeneralTypeBlock()
		{
			
		}
		
		public function showIdleState() : void
		{
			_faceFlag = false;
		}
		
		public function showCryState() : void
		{
			_faceFlag= true;
		}
		
		public function get faceFlag():Boolean{return _faceFlag;}
	}
}