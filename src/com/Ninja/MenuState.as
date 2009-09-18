package com.Ninja {
	import com.adamatomic.flixel.*;

	public class MenuState extends FlxState {
		[Embed(source="../../data/menu_hit.mp3")] private var SndHit:Class;
		[Embed(source="../../data/menu_hit_2.mp3")] private var SndHit2:Class;
		
		private var _e:FlxEmitter;
		private var _t1:FlxText;
		private var _t2:FlxText;
		private var _t3:FlxText;
		private var _ok:Boolean;
		
		override public function MenuState():void {
			var i:uint;
			var j:uint;
			var a:FlxArray = new FlxArray();
			j = 0;
			for(i = 0; i < 2000; i++) {
				if (i % 3) {
					if (j % 2 == 0) {
						this.add(a.add(new FlxSprite(null, 0, 0, false, false, 16, 16, 0xff1a911f)) as FlxSprite);
					} else {
						this.add(a.add(new FlxSprite(null, 0, 0, false, false, 16, 16, 0xff1a4691)) as FlxSprite);
					}
					
					j++;
				} else {
					this.add(a.add(new FlxSprite(null, 0, 0, false, false, 2, 2, 0xffffffff)) as FlxSprite);
				}
			}
			_e = new FlxEmitter(FlxG.width/2 - 50, FlxG.height / 2 - 10, 100, 30, a, -5, -100, 100, -800, -100, 0, 0, 400);
			_e.kill();
			this.add(_e);
			
			_t1 = this.add(new FlxText(0, (FlxG.width / 2) - 80, FlxG.width, 80, "Green ninja", 0xff1a911f, null, 16, "center")) as FlxText;
			_t2 = this.add(new FlxText(0, (FlxG.width / 2) - 64, FlxG.width, 80, "don't like the", 0xffffffff, null, 16, "center")) as FlxText;
			_t3 = this.add(new FlxText(0, (FlxG.width / 2) - 48, FlxG.width, 80, "blue ninja", 0xff1a4691, null, 16, "center")) as FlxText;
			this.add(new FlxText(0, FlxG.height - 24, FlxG.width, 8, "PRESS X TO START", 0xffffffff, null, 8, "center"));
			
			_ok = false;
		}
		
		private function onFade():void {
			FlxG.switchState(PlayState);
		}
		
		override public function update():void {
			if (FlxG.kA) {
				FlxG.play(SndHit2);
				FlxG.flash(0xffffffff, 0.75);
				FlxG.fade(0xff000000, 1, onFade);
			}
			
			if (!_ok) {
				FlxG.play(SndHit);
				_e.reset();
				_ok = true;
			}
			
			super.update();
		}
	}
}