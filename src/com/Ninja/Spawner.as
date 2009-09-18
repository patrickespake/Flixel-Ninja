package com.Ninja {
	import com.adamatomic.flixel.*;
	
	public class Spawner extends FlxSprite {
		[Embed(source = '../../data/Spawner.png')] private var ImgSpawner:Class;
		
		private var _p:Player;
		private var _e:FlxArray;
		private var _eStars:FlxArray;
		private var _create_counter:Number = 5;
		
		public function Spawner(X:Number, Y:Number, Enemies:FlxArray, ThePlayer:Player, Stars:FlxArray):void {
			super(ImgSpawner, X, Y, true, true);
			_e = Enemies;
			_p = ThePlayer;
			_eStars = Stars;
		}
		
		override public function update():void {
			super.update();
			
			if (_create_counter > 0) {
				_create_counter -= FlxG.elapsed;
			}
			
			if (_create_counter <= 0) {
				_create_counter = 5;
				spawn();
			}
		}
		
		private function spawn():void {
			for (var i:uint = 0; i < _e.length; i++) {
				if (!_e[i].exists) {
					_e[i].reset(x, y);
					return;
				}
			}
			
			var enemy:Enemy = new Enemy(x, y, _p, _eStars);
			_e.add(PlayState.lyrSprites.add(enemy));
		}
	}
}