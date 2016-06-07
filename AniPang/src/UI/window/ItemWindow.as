package UI.window
{
	import loader.TextureManager;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	import starling.textures.Texture;

	public class ItemWindow extends Sprite
	{
		private var _mainImage : Image;
		private var _itemImage : Image;
		private var _itemTextField : TextField;
		
		public function ItemWindow(itemTexture : Texture, x : int, y : int, width : int, height : int, plusFlag : Boolean = false)
		{
			_mainImage = new Image(TextureManager.getInstance().textureDictionary["ItemWindow.png"]);
			_mainImage.x = x;
			_mainImage.y = y;
			_mainImage.width = width;
			_mainImage.height = height;
			
			_itemImage = new Image(itemTexture);
			_itemImage.width = _mainImage.width/3;
			_itemImage.height = _itemImage.width;
			_itemImage.x = _mainImage.x - _itemImage.width/2;
			_itemImage.y = _mainImage.y;
			
			_itemTextField = new TextField(_mainImage.width, _mainImage.height);
			_itemTextField.x = _mainImage.x;
			_itemTextField.y = _mainImage.y;
			_itemTextField.text = "0";
			_itemTextField.format.color = 0xffffff;
			_itemTextField.format.bold = true;
			_itemTextField.format.size = _itemImage.width/3;
			
			addChild(_mainImage);
			addChild(_itemImage);
			addChild(_itemTextField);
		}
	}
}