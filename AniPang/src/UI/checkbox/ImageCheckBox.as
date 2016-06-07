package UI.checkbox
{
	import starling.display.Image;
	import starling.textures.Texture;

	public class ImageCheckBox extends Image
	{
		private var _clickedFlag : Boolean = false;
		private var _name : String;
		
		private var _onTexture : Texture;
		private var _offTexture : Texture;
		
		public function ImageCheckBox(clickedON : Texture, clickedOFF : Texture, name : String)
		{
			super(clickedOFF);
			
			_name = name;
			_onTexture = clickedON;
			_offTexture = clickedOFF;
			
			this.addEventListener("CHECK" , onCheck);
		}
		
		private function onCheck():void
		{
			switch(_clickedFlag)
			{
				case false:
				{
					this.texture = _onTexture;
					_clickedFlag = true;
					break;
				}
					
				case true:
				{
					_clickedFlag = false;
					this.texture = _offTexture;
					break;
				}
			}
		}
		
		public function get clickedFlag():Boolean{return _clickedFlag;}
	}
}