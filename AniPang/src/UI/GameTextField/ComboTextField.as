package UI.GameTextField
{
	import starling.events.Event;
	import starling.text.TextField;

	public class ComboTextField extends TextField
	{
		private var _showFlag : Boolean = false;
		
		/**
		 * 게임 씬에서 콤보 횟수를 출력 하는 텍스트 필드
		 */		
		public function ComboTextField(width : int, height : int)
		{
			super(width, height);
			this.format.color = 0xFF0000;
			this.format.bold = true;
			this.format.size = AniPang.stageHeight*0.03;
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * 화면에 출력 후 서서히 사라지는 텍스트 필드 입니다
		 */		
		private function onEnterFrame():void
		{
		  if(_showFlag == true)
			  this.alpha-=0.01;
		  
		  if(this.alpha <= 0)
			  this.visible = false;
		}
		
		public function showCombo(comboText : String) : void
		{
			this.alpha = 1;
			this.text = comboText;
	
			this.visible = true;
			
			_showFlag = true;
		}
	}
}