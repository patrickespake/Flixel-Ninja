package com.Ninja {
	import com.adamatomic.flixel.*;
	
	public class NinjaStar extends FlxSprite {
		[Embed(source = '../../data/NinjaStar.png')] private var ImgStar:Class;
		[Embed(source = '../../data/Spark.png')] private var ImgSpark:Class;
		[Embed(source = '../../data/SonicPunch1.mp3')] private var SndStar:Class;
		[Embed(source = '../../data/IceCubeExploding.mp3')] private var SndKillStar:Class;
		
		private var _sparks:FlxEmitter;
		
		public function NinjaStar(X:Number, Y:Number, XVelocity:Number, YVelocity:Number):void {
			super(ImgStar, X, Y, true, true);
			
			// Basic movement speeds
			// How fast left and right it can travel
			maxVelocity.x = 200;
			// How fast up and down it can travel
			maxVelocity.y = 200;
			// How many degrees the object rotates
			angularVelocity = 100;
			// Bouding box tweaks
			// Width of the bounding box
			width = 5;
			// Height of the bounding box
			height = 5;
			// Where in the sprite the bouding box starts on the X axis
			offset.x = 6;
			// Where in the sprite the bouding box starts on the Y axis
			offset.y = 6;
			// Create and name and animation "normal"
			addAnimation("normal", [0]);
			_sparks = FlxG.state.add(new FlxEmitter(0, 0, 0, 0, null, -0.1, -150, 150, -200, 0, -720, 720, 400, 0, ImgSpark, 10, true, PlayState.lyrSprites)) as FlxEmitter;
			facing = true;
			// The object now is removed from the render and update functions. It returns only when reset is called.
			// We do this so we can precreate serveral instances of this object to help speed things up a little
			exists = false;
		}
		
		override public function hitFloor():Boolean {
			kill();
			return super.hitFloor();
		}
		
		override public function hitWall():Boolean {
			kill();
			return super.hitWall();
		}
		
		override public function hitCeiling():Boolean {
			kill();
			return super.hitCeiling();
		}
		
		override public function kill():void {
			if (dead) {
				return;
			}
			
			_sparks.x = x + 5;
			_sparks.y = y + 5;
			_sparks.reset();
			FlxG.play(SndKillStar);
			super.kill();
		}
		
		public function reset(X:Number, Y:Number, XVelocity:Number, YVelocity:Number):void {
			x = X;
			y = Y;
			dead = false;
			exists = true;
			visible = true;
			// Set the left and right speed
			velocity.x = XVelocity;
			// Play the animation
			play("normal");
			FlxG.play(SndStar);
		}
	}
}