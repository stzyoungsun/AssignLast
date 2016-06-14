package UI.Button
{
	import flash.geom.Rectangle;
	
	import starling.display.Button;
	import starling.display.Image;
	import starling.textures.Texture;

	public class SideImageButton extends Button
	{
		private var _sideImge : Image;
		
		/**
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @param buttonTexture		버튼의 back 텍스쳐
		 * @param sideTexture		버튼의 side 텍스쳐
		 * @param text
		 * 버튼 사이드에 이미지를 넣을 수 있는 클래스
		 */		
		public function SideImageButton(x : int, y: int, width : int, height : int, buttonTexture : Texture, sideTexture : Texture = null, text : String = "")
		{
			super(buttonTexture,text);
			
			this.x = x;
			this.y = y;
			this.width = width;
			this.height = height;
			
			if(sideTexture != null)
			{
				_sideImge = new Image(sideTexture);
				_sideImge.width = this.height/2;
				_sideImge.height = this.height/2;
				_sideImge.x = _sideImge.width*0.3;
				_sideImge.y = _sideImge.height/2;
				
				this.textBounds = new Rectangle(_sideImge.width, 0, this.width - _sideImge.width*1.1, this.height);
				this.addChild(_sideImge);
			}
		}
		
		public function settingTextField(color : uint, size : Number) : void
		{
			
			this.textFormat.color = color;
			this.textFormat.size = size;
			this.textFormat.bold = true;
		}
	}
}