package loader
{
	import flash.utils.Dictionary;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;

	public class TextureManager
	{
		private var _textureDictionary:Dictionary;
		private var _xmlDictionary:Dictionary;
		private var _atlasTextureDictionary:Dictionary;
		private var _created:Boolean;
		
		private static var _sInstance:TextureManager;
		private static var _sAllowCreateInstance:Boolean = false;
		
		public function TextureManager()
		{
			if (!_sAllowCreateInstance) throw new Error("Use SoundManager.getInstance method");

			_textureDictionary = new Dictionary();
			_xmlDictionary = new Dictionary();
			_atlasTextureDictionary = new Dictionary();
			_created = false;
		}
		
		public static function getInstance():TextureManager
		{
			// 최초 호출 시에 TextureManager 객체 생성
			if (_sInstance == null)
			{
				_sAllowCreateInstance = true;
				_sInstance = new TextureManager();
				_sAllowCreateInstance = false;
			}
			// 객체 반환
			return _sInstance;
		}
		
		public function addTexture(textureName:String, texture:Texture):void
		{
			if(_textureDictionary[textureName])
			{
				throw new Error(textureName + " already added to Texture manager.");
			}
			_textureDictionary[textureName] = texture;
		}
		
		public function removeTexture(textureName:String):void
		{
			if(_textureDictionary[textureName])
			{
				delete _textureDictionary[textureName];
			}
			else
			{
				throw new Error("Invalid texture name. Check your texture name");
			}
		}
		
		public function createAtlasTexture():void
		{
			if(_created)
			{
				return;
			}
			
			for(var textureName:String in _textureDictionary)
			{
				var xmlName:String = textureName.substring(0, textureName.lastIndexOf(".")) + ".xml";
				if(checkXml(xmlName))
				{
					_atlasTextureDictionary[textureName] = new TextureAtlas(_textureDictionary[textureName], XML(_xmlDictionary[xmlName]));
				}
			}
			_created = true;
		}
		
		//이미지와 이름이 같은 xml이 존재하는지 검사합니다.
		private function checkXml(xmlName:String):Boolean
		{
			if(_xmlDictionary[xmlName]) return true;
			else return false;
		}
		
		public function get xmlDictionary():Dictionary{ return _xmlDictionary; }
		public function get textureDictionary():Dictionary{ return _textureDictionary; }
		public function get atlasTextureDictionary():Dictionary { return _atlasTextureDictionary; }
	}
}