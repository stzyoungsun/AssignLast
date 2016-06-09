package scene
{
	import starling.display.Sprite;

	public class SceneManager
	{
		private static var _instance : SceneManager;
		private static var _constructed : Boolean;
		private var _sceneVector : Vector.<Sprite> = new Vector.<Sprite>;
		private var _sceneNumber : Number;
		
		/**
		 * 생성자 - 싱글톤 패턴으로 설계되어 일반적인 방법으로 객체 생성이 불가능하기 때문에 생성자 대신 instance 메서드를 사용해서 객체 생성한다
		 */
		public function SceneManager()
		{
			if (!_constructed) throw new Error("Singleton, use Scene.instance");
		}

		/**
		 * SceneManager 객체를 생성하는 메서드. 프로그램 중에 단 한번만 생성됨
		 * @return SceneManager 객체 반환
		 */
		public static function get instance():SceneManager
		{
			if (_instance == null)
			{
				_constructed = true;
				_instance = new SceneManager();
				_constructed = false;
			}
			return _instance;
		}

		/**
		 * @param scene - Vector 객체에 저장할 Scene 객체 (Sprite)
		 */
		public function addScene(scene : Sprite) : void
		{
			_sceneVector.push(scene);
		}
		
		/**
		 * _sceneVector에 저장된 Scene을 현재 렌더링할 Scene으로 바꿔줌
		 */
		public function sceneChange() : void
		{
			MainClass.current.removeChild(MainClass.sceneStage, true);

			MainClass.sceneStage = _sceneVector.pop();

			MainClass.current.addChild(MainClass.sceneStage);
		}
	}
}