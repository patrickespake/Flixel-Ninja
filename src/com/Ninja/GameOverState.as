package com.Ninja {
	import com.adamatomic.flixel.*;
	
	public class GameOverState extends FlxState {
		[Embed(source = "../../data/menu_hit_2.mp3")] private var SndHit2:Class;
		
		public function GameOverState():void {
			this.add(new FlxText(0, (FlxG.width / 2) - 80, FlxG.width, 80, "Game Over", 0xffffffff, null, 16, "center")) as FlxText;
			this.add(new FlxText(0, (FlxG.width / 2) - 48, FlxG.width, 80, "SCORE: " + FlxG.score, 0xff1a4691, null, 16, "center")) as FlxText;
			this.add(new FlxText(0, FlxG.height - 24, FlxG.width, 8, "PRESS X TO RESTART", 0xffffffff, null, 8, "center"));
		}
		
		override public function update():void {
			if (FlxG.kA) {
				FlxG.play(SndHit2);
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 1, onFade);
			}
			
			super.update();
		}
		
		private function onFade():void {
			FlxG.score = 0;
			FlxG.switchState(PlayState);
		}
	}
}