package com.Ninja {
	import com.adamatomic.flixel.*;
	import com.adamatomic.flixel.data.FlxAnim;
	
	public class PlayState extends FlxState {
		[Embed(source = '../../data/Tiles.png')] private var ImgTiles:Class;
		[Embed(source = '../../data/map.txt', mimeType = "application/octet-stream")] private var DataMap:Class;
		[Embed(source = '../../data/hearts.png')] private var ImgHearts:Class;
		[Embed(source = '../../data/ninja.mp3')] private var SndNinja:Class;
		[Embed(source = '../../data/die.mp3')] private var SndDie:Class;
		
		private var _p:Player;
		private var _map:FlxTilemap;
		private var _pStars:FlxArray;
		
		private var _e:FlxArray;
		private var _eStars:FlxArray;
		
		public static var lyrStage:FlxLayer;
		public static var lyrSprites:FlxLayer;
		public static var lyrHUD:FlxLayer;
		
		private var _scoreDisplay:FlxText;
		private var _hearts:FlxArray;
		
		private var _spawners:FlxArray;
		private var _spawner:Spawner;
		
		public function PlayState():void {
			super();
			
			lyrStage = new FlxLayer;
			lyrSprites = new FlxLayer;
			lyrHUD = new FlxLayer;
			
			_pStars = new FlxArray;
			for (var n:int = 0; n < 40; n += 1) {
				_pStars.add(lyrSprites.add(new NinjaStar(0, 0, 0, 0)));
			}
			
			_eStars = new FlxArray;
			for (var en:int = 0; en < 40; en += 1) {
				_eStars.add(lyrSprites.add(new NinjaStar(0, 0, 0, 0)));
			}
			
			_p = new Player(32, 448, _pStars);
			lyrSprites.add(_p);
			
			_hearts = new FlxArray();
			var tmpH:FlxSprite;
			for (var hCount:Number = 0; hCount < _p._max_health; hCount++) {
				tmpH = new FlxSprite(ImgHearts, 2 + (hCount * 10), 2, true, false);
				tmpH.scrollFactor.x = tmpH.scrollFactor.y = 0;
				tmpH.addAnimation("on", [0]);
				tmpH.addAnimation("off", [1]);
				tmpH.play("on");
				_hearts.add(lyrHUD.add(tmpH));
			}
			
			FlxG.follow(_p, 2.5);
			FlxG.followAdjust(0.5, 0.5);
			FlxG.followBounds(1, 1, 640 - 1, 480 - 1);
			
			_map = new FlxTilemap(new DataMap, ImgTiles, 1);
			lyrStage.add(_map);
			
			this.add(lyrStage);
			this.add(lyrSprites);
			this.add(lyrHUD);
			
			_e = new FlxArray;
			_e.add(lyrSprites.add(new Enemy(576, 16, _p, _eStars)));
			
			_scoreDisplay = new FlxText(FlxG.width - 50, 2, 48, 40, FlxG.score.toString(), 0xffffffff, null, 16, "right");
			_scoreDisplay.scrollFactor.x = _scoreDisplay.scrollFactor.y = 0;
			lyrHUD.add(_scoreDisplay);
			
			_spawners = new FlxArray;
			RandomSpawner();
			
			FlxG.setMusic(SndNinja);
		}
		
		override public function update():void {
			var _old_health:uint = _p.health;
			var _old_score:uint = FlxG.score;
			
			super.update();			
			_map.collide(_p);
			FlxG.collideArray2(_map, _e);
			FlxG.overlapArray(_e, _p, EnemyHit);
			FlxG.collideArray2(_map, _pStars);
			FlxG.overlapArrays(_pStars, _e, StarHitsEnemy);
			FlxG.collideArray2(_map, _eStars);
			FlxG.overlapArray(_eStars, _p, StarHitsPlayer);
			
			if (_p.dead) {
				FlxG.flash(0xffffffff, 0.75);
				FlxG.play(SndDie);
				FlxG.stopMusic();
				FlxG.switchState(GameOverState);
			}
			
			if (_old_score != FlxG.score) {
				_scoreDisplay.setText(FlxG.score.toString());
				FlxG.play(SndDie);
			}
			
			if (_p.health != _old_health) {
				for (var i:Number = 0; i < _p._max_health; i++) {
					if (i >= _p.health) {
						_hearts[i].play("off");
					} else {
						_hearts[i].play("on");
					}
				}
			}
		}
		
		private function EnemyHit(E:Enemy, P:Player):void {
			FlxG.log(P._hurt_counter.toString());
			if (P._hurt_counter <= 0) {
				if (E.x > P.x) {
					P.velocity.x = -100;
					E.velocity.x = 100;
				} else {
					P.velocity.x = 100;
					E.velocity.x = -100;
				}
				
				P.hurt(1);
			}
		}
		
		private function RandomX():int {
			return (Math.random() * (576 - 16)) + 16;
		}
		
		private function RandomY():int {
			return (Math.random() * (464 - 16)) + 16;
		}
		
		private function StarHitsEnemy(colStar:FlxSprite, colEnemy:FlxSprite):void {
			colStar.kill();
			colEnemy.hurt(1);
			_spawner.kill();
			RandomSpawner();
		}
		
		private function StarHitsPlayer(colStar:FlxSprite, P:Player):void {
			if (P._hurt_counter <= 0) {
				if (colStar.x > P.x) {
					P.velocity.x = -100;
				} else {
					P.velocity.x = 100;
				}
				
				P.hurt(1);
				colStar.kill();
			}
		}
		
		private function RandomSpawner():void {
			_spawner = new Spawner(RandomX(), RandomY(), _e, _p, _eStars);
			_spawners.add(lyrStage.add(_spawner));
		}
	}
}