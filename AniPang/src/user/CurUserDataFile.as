package user
{
	import com.lpesign.KakaoExtension;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;

	public class CurUserDataFile
	{
		public function CurUserDataFile(){throw new Error("Abstract Class");}
		
		public static function saveData(curUserData : String) : void
		{
			if(curUserData == null || curUserData == "") return;
			var path : File = File.applicationStorageDirectory.resolvePath("data/current_user.data");
			var stream : FileStream = new FileStream();

			stream.open(path, FileMode.WRITE);
			stream.writeUTFBytes(curUserData);
			stream.close();
		}
		
		public static function loadData() : String
		{
			var stream : FileStream = new FileStream();
			var path:File = File.applicationStorageDirectory.resolvePath("data/current_user.data");
			var curUserData : String = "";
			
			if(path.exists)
			{
				stream.open(path,FileMode.READ);
				curUserData = stream.readMultiByte(stream.bytesAvailable,"utf-8");
			}
			if(curUserData == "")
			{
				curUserData = "$$$";
			}
			
			stream.close();
			return curUserData;
		}
	}
}