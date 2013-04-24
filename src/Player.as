package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	/**
	 * ...
	 * @author Christian Stewart
	 */
	public class Player extends FlxSprite
	{
		private var state:Playstate = FlxG.state as Playstate;
		[Embed(source = '../assets/visible light.png')] static private var playerPNG:Class;
		[Embed(source = '../assets/getting hit.mp3')] static private var gettinghitMP3:Class;
		[Embed(source = '../assets/sword.mp3')] static private var swordMP3:Class;

		
		
		private var moveState:Boolean = true;
		private var attackState:Boolean = false;
		
		public var attackBox:FlxSprite;
		private var attackDelay:FlxDelay;
		
		public var leftBool:Boolean = false;
		public var rightBool:Boolean = false;
		public var upBool:Boolean = false;
		public var downBool:Boolean = true;
		
		public var playerHealth:Number = 8;
		
		public function Player(initx:int, inity:int) 
		{
			super(initx, inity);
			loadGraphic(playerPNG, true, false, 28, 31);
			width = 13;
			height = 16;
			offset.y = 2;
			attackBox = new FlxSprite(0, 0).makeGraphic(13, 12, 0x00000000);
			attackBox.exists = false;
			attackDelay = new FlxDelay(125);
			
			addAnimation("up", [8, 9], 7);
			addAnimation("down", [0, 1], 7);
			addAnimation("left", [4, 5], 7);
			addAnimation("right", [15, 14], 7);
			
			addAnimation("upStill", [8], 7);
			addAnimation("downStill", [0], 7);
			addAnimation("leftStill", [4], 7);
			addAnimation("rightStill", [15], 7);
			
			
			addAnimation("upAttack", [10, 11, 18], 15, false);
			addAnimation("downAttack", [2, 3, 16], 15, false);
			addAnimation("leftAttack", [6, 7, 17], 15, false);
			addAnimation("rightAttack", [13, 12, 19], 15, false);
			
			attackDelay.callback = endAttack;
		}
		override public function update():void
		{
			if (moveState)
			{
				if (FlxG.keys.justPressed("Z"))
				{
					moveState = false;
					attackState = true;
					FlxG.play(swordMP3);
				}
				else if (FlxG.keys.DOWN)
				{
					y += 2;
					play("down");
					leftBool = false;
					rightBool = false;
					upBool = false;
					downBool = true;
				}
				else if (FlxG.keys.UP)
				{
					y -= 2;
					play("up");
					leftBool = false;
					rightBool = false;
					upBool = true;
					downBool = false;
				}
				else if (FlxG.keys.LEFT)
				{
					x -= 2;
					play("left");
					leftBool = true;
					rightBool = false;
					upBool = false;
					downBool = false;
				}
				else if (FlxG.keys.RIGHT)
				{
					x += 2;
					play("right");
					leftBool = false;
					rightBool = true;
					upBool = false;
					downBool = false;
				}
				else
				{
					
					if (upBool)
					{
						play("upStill");
					}
					else if (downBool)
					{
						play("downStill");
					}
					else if (leftBool)
					{
						play("leftStill");
					}
					else if (rightBool)
					{
						play("rightStill");
					}
				}
			}
			if (attackState)
			{
				if (!attackDelay.isRunning)
				{
					attackDelay.reset(125);
					if (upBool)
					{
						attackBox.x = x;
						attackBox.y = y - 11;
						offset.y += 10;
						play("upAttack");
					}
					else if (downBool)
					{
						attackBox.x = x;
						attackBox.y = y + 19;
						offset.x += 4;
						play("downAttack");
					}
					else if (leftBool)
					{
						attackBox.x = x - 13;
						attackBox.y = y;
						offset.x += 12;
						play("leftAttack");
					}
					else if (rightBool)
					{
						attackBox.x = x + 16;
						attackBox.y = y;
						play("rightAttack");
					}
					attackBox.exists = true;
				}
			}
		}
		private function endAttack():void
		{
			attackBox.exists = false;
			attackState = false;
			if (downBool)
				offset.x -= 4;
			else if (leftBool)
				offset.x -= 12;
			else if (upBool)
				offset.y -= 10;
			moveState = true;
		}
		public function getHit():void
		{
			flicker(1);
			state.healthBar.frame += 1;
			playerHealth--;
			FlxG.play(gettinghitMP3, 0.8);
			if (playerHealth == 0)
			{
				state.enemies.clear();
				if (Registry.level == 4 || Registry.level == 2)
				{
				FlxG.switchState(new Playstate);
				}
				else
				{
					FlxG.resetState();
				}
			}
		}
	}
}