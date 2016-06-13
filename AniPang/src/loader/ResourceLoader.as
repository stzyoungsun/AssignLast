package loader
{
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.media.Sound;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import avmplus.getQualifiedClassName;
	
	import starling.textures.Texture;
	import sound.SoundManager;
	
	
	/**
	 * 이미지와 xml 2가지를  분리하여 Dictionary에 저장
	 * 기존에 구현 했던 Loaderclass 수정
	 */		
	public class ResourceLoader
	{
		// 로더에서 이미지 로드가 완료 된 xml과 image 파일이 저장 된 객체
		private var _urlImageArray:Array;

		private var _urlSoundArray:Array;
		// XML 한 개씩 출력으르 조절 하기 위한 변수
		private var _urlXmlVector : Vector.<String>;
		private var _loaderXML:URLLoader;

		private var _onCompleteFunction:Function;
		private var _onProgressFunction:Function;
		
		private var _imageLength:Number;
		private var _currentCount:int;
		
		private var _textureManager:TextureManager;
		
		public static var _sImageMaxCount:int;
		
		public function ResourceLoader(onCompleteFunction : Function, onProgressFunction : Function)
		{
			_onCompleteFunction = onCompleteFunction;
			_onProgressFunction = onProgressFunction;
			
			_urlImageArray = new Array();
			_urlSoundArray = new Array();
			_urlXmlVector = new Vector.<String>();
			
			_textureManager = TextureManager.getInstance();
			
			_currentCount = 0;
			_imageLength = 0;
		}
		
		public function resourceLoad(directoryName:String) : void
		{
			getFolderResource(File.applicationDirectory.resolvePath(directoryName));
			
			buildSoundLoader();
			buildImageLoader();
			buildXMLLoader();
		}
		
		/** 
		 * @return 
		 * Note @유영선 불러올 폴더명 지정
		 * 폴더를 끝까지 탐색하여 폴더 안에 있는 모든 이미지, xml을 탐색
		 * Note @jihwan.ryu mp3 파일도 검색하도록 수정
		 */
		private function getFolderResource(...files):void
		{
			for each(var file:Object in files)
			{
				if(file["isDirectory"])
					getFolderResource.apply(this, file["getDirectoryListing"]());
				else if(getQualifiedClassName(file) == "flash.filesystem::File")
				{
					var url:String = file["url"] as String;
					var extension:String = url.substr(url.lastIndexOf(".")+1, url.length);
					
					// Note @jihwan.ryu if-else 문구조를 switch-case문으로 변경했습니다
					switch(extension)
					{
						case "png":
						case "PNG": 
						case "jpg":
						case "JPG":
							_imageLength++;
							_urlImageArray.push(url);
							break;
						case "xml":
						case "XML":
							_urlXmlVector.push(url);
							break;
						// Note @jihwan.ryu 사운드 파일목록을 추가하는 구문
						case "mp3":
						case "MP3":
							_urlSoundArray.push(url);
							break;
						default:
							continue;
					}
				}
				files = null;
			}
		}
		
		/**
		 * Note @유영선 이미지 파일 로드 
		 */		
		private function buildImageLoader():void
		{
			if(_urlImageArray.length == 0 )
			{
				return;
			}
			
			_sImageMaxCount =_urlImageArray.length; 
			
			for(var i:int = 0; i<_urlImageArray.length; ++i)
			{
				var imageLoader:Loader = new Loader();
				imageLoader.load(new URLRequest(_urlImageArray[i]));
				imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadImageComplete);	
			}
		}
	
		/**
		 * Note @유영선 XML 로드 
		 * (병훈님이 말씀하신 파일 실제 존재 유무는 LoadeImage 내에서 체크하는 함수를 만들었습니다. isSpriteSheet) 
		 */		
		private function buildXMLLoader():void
		{
			if(_urlXmlVector.length == 0)
			{
				return;
			}
			
			_sImageMaxCount += _urlXmlVector.length;
			_loaderXML = new URLLoader(new URLRequest(_urlXmlVector[0]));
			_loaderXML.addEventListener(Event.COMPLETE, onLoadXMLComplete);
		}
		
		/**
		 * Note @jihwan.ryu 사운드 파일을 로딩하는 메서드
		 */
		private function buildSoundLoader():void
		{
			if(_urlSoundArray.length == 0 )
			{
				return;
			}
			
			for(var i:int = 0; i < _urlSoundArray.length; ++i)
			{
				var gameSound:Sound = new Sound();
				gameSound.load(new URLRequest(_urlSoundArray[i]));
				gameSound.addEventListener(Event.COMPLETE, onLoadSoundComplete);
			}
		}
		
		/**
		 * @param e
		 * Note @유영선 한 이미지가 완료 후 다른 이미지 로딩 진행
		 */		
		private function onLoadImageComplete(e:Event):void
		{
			var loaderInfo:LoaderInfo = LoaderInfo(e.target);
			loaderInfo.removeEventListener(Event.COMPLETE, onLoadImageComplete);
			var extension:Array = decodeURIComponent(loaderInfo.url).split('/');

			var bitmap:Bitmap = e.target.content as Bitmap;
			_textureManager.textureDictionary[extension[extension.length-1]] = Texture.fromBitmapData(bitmap.bitmapData);
			
			loaderInfo.loader.unload();
			loaderInfo = null;
			
			chedckedImage();
		}
		
		/**
		 * @param e
		 * Note @유영선 XML 로딩 진행 (순서에 따라 로딩을 위해 한개씩 로딩 진행)
		 */		
		private function onLoadXMLComplete(e:Event):void
		{
			_loaderXML.removeEventListener(Event.COMPLETE, onLoadXMLComplete);
			_loaderXML = null;
		
			var extension:Array = _urlXmlVector[0].split('/');
			
			_textureManager.xmlDictionary[extension[extension.length-1]] =  e.currentTarget.data;
			_urlXmlVector.removeAt(0);
			
			chedckedImage();
			
			if(_urlXmlVector.length != 0)
			{
				_loaderXML = new URLLoader(new URLRequest(_urlXmlVector[0]));
				_loaderXML.addEventListener(Event.COMPLETE, onLoadXMLComplete)
			}	
		}
		
		/**
		 * Note @jihwan.ryu 사운드 파일의 로딩이 완료되면 호출되는 메서드. 로딩된 사운드 리소스는 SoundManager에 등록된다. 
		 * @param event - 이벤트 정보를 가진 Event 객체
		 */
		private function onLoadSoundComplete(event:Event):void
		{
			var gameSound:Sound = event.currentTarget as Sound;
			gameSound.removeEventListener(Event.COMPLETE, onLoadSoundComplete);
			
			var extension:Array = decodeURIComponent(gameSound.url).split('/');
			
			// 사운드 매니저에 입력
			var soundManager:SoundManager = SoundManager.getInstance();
			soundManager.addSound(extension[extension.length - 1], gameSound);
			gameSound.close();
		}
		
		/**
		 * Note @유영선 이미지가 모두 로딩 된 후에 Mainclass에 완료 함수 호출
		 */		
		private function chedckedImage() : void
		{
			_currentCount++;
			
			if(_currentCount == 1)
				_onProgressFunction(60);
				
			if(_currentCount == Math.round(_sImageMaxCount * (0.6)))
				_onProgressFunction(90);
				
			if(_currentCount == _sImageMaxCount) 
			{
				_textureManager.createAtlasTexture();
				_onCompleteFunction();
				_onCompleteFunction = null;
				_onProgressFunction = null;
			}
		}
		
		public function dispose() : void
		{
			// TODD @유영선 해제 필요 하면 여기다 추가
			_loaderXML.removeEventListener(Event.COMPLETE,onLoadXMLComplete);
			
			_urlXmlVector = null;
			_urlImageArray = null;
			_urlSoundArray = null;
		}
	}
}