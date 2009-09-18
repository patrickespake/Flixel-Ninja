package {
	import com.adamatomic.flixel.*;
	import com.Ninja.MenuState;
	
	[SWF(width = "320", height = "280", backgroundColor = "#000000")]
	[Frame(factoryClass = "Preloader")]
	
	public class Ninja extends FlxGame {
		public function Ninja():void {
			super(320, 280, MenuState, 2, 0xff000000, true, 0xffffffff);
			help("Jump", "Shoot", "Nothing");
		}
	}
}