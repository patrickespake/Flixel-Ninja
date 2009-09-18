package com.Ninja {
	import com.adamatomic.flixel.*;

	public class Enemy extends FlxSprite {
		[Embed(source = '../../data/Enemy.png')] private var ImgEnemy:Class;
		
		private var _move_speed:int = 400;
		private var _jump_power:int = 800;
		private var _max_health:int = 10;
		private var _hurt_counter:Number = 0;
		private var _can_jump:Boolean = true;
		private var _last_jump:Number = 0;
		private var _p:FlxSprite;
		private var _eStars:FlxArray;
		private var _attack_counter:Number = 0;
		
		public function Enemy(X:Number, Y:Number, ThePlayer:FlxSprite, EnemyStars:FlxArray):void {
			super(ImgEnemy, X, Y, true, true);
			
			_eStars = EnemyStars;
			
			// Max speeds
			_p = ThePlayer;
			maxVelocity.x = 200;
			maxVelocity.y = 200;
			
			health = 1;
			acceleration.y = 420;
			drag.x = 200;
			width = 8;
			height = 14;
			offset.x = 4;
			offset.y = 2;
			addAnimation("normal", [0, 1, 2, 3], 10);
			addAnimation("jump", [2]);
			addAnimation("attack", [4, 5, 6], 10);
			addAnimation("stopped", [0]);
			addAnimation("hurt", [2, 7], 10);
			addAnimation("dead", [7, 7, 7], 5);
		}
		
		override public function update():void {
			if (dead) {
				if (finished) {
					exists = false;
				} else {
					super.update();
				}
				
				return;
			}
			
			if (_hurt_counter > 0) {
				_hurt_counter -= FlxG.elapsed * 3;
			}
			
			if (_attack_counter <= 0 && _p.y > y - 1 && _p.y < y + 1) {
				_attack_counter = 2;
				play("attack");
				throwStar(facing);
			}
			
			if (_p.x < x - 36) {
				facing = false;
				velocity.x -= _move_speed * FlxG.elapsed;
			} else if (_p.x > x + 36) {
				facing = true;
				velocity.x += _move_speed * FlxG.elapsed;
			}
			
			if (_last_jump > 0) {
				_last_jump -= FlxG.elapsed;
			}
			
			if (velocity.y != 0 || _last_jump > 0) {
				_can_jump = false;
			}
			
			if (_p.y < y && _can_jump) {
				velocity.y = -_jump_power;
				_can_jump = false;
				_last_jump = 2;
			}
			
			if (_hurt_counter > 0) {
				play("hurt");
			} else {
				if (_attack_counter > 0) {
					play("attack");
				} else {
					if (velocity.y != 0) {
						play("jump");
					} else {
						if (velocity.x == 0) {
							play("stopped");
						} else {
						play("normal");
						}
					}
				}
			}
			super.update();
		}
		
		override public function hitFloor():Boolean {
			_can_jump = true;
			return super.hitFloor();
		}
		
		override public function hurt(Damage:Number):void {
			_hurt_counter = 1;
			return super.hurt(Damage);
		}
		
		private function throwStar(dir:Boolean):void {
			var XVelocity:Number;
			if (dir) {
				XVelocity = 150;
			} else {
				XVelocity = -150;
			}
			
			for (var i:uint = 0; i < _eStars.length; i++) {
				if (!_eStars[i].exists) {
					_eStars[i].reset(x, y + 2, XVelocity, 0);
					return;
				}
			}
			
			var star:NinjaStar = new NinjaStar(x, y + 2, XVelocity, 0);
			star.reset(x, y, XVelocity, 0);
			_eStars.add(PlayState.lyrSprites.add(star));
		}
		
		override public function kill():void {
			if (dead) {
				return;
			}
			
			FlxG.score += 10;
			super.kill();
		}
		
		public function reset(X:Number, Y:Number):void {
			x = X;
			y = Y;
			dead = false;
			exists = true;
			visible = true;
			play("normal");
		}
	}
}