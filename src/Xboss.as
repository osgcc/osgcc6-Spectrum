package  
{
	/**
	 * ...
	 * @author Christian Stewart
	 */
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	import org.flixel.plugin.photonstorm.FlxWeapon;
	public class Xboss extends Boss
	{
		[Embed(source = '../assets/xray skull.png')] static private var skullPNG:Class;
		[Embed(source = '../assets/xray skull bullet.png')] static private var bulletPNG:Class;
		private var state:Playstate = FlxG.state as Playstate;
		private var skeletonTime:FlxDelay;
		private var healthEnemy:Number = 30;
		private var skullMove:Boolean = false;
		private var recoverTime:FlxDelay;
		private var shmupMoves:Boolean = false;
		private var bulletGroup:FlxGroup;
		private var bullet:FlxGroup;
		private var bulletDelay:FlxDelay;
		
		public function Xboss(initx:int, inity:int) 
		{
			super(140, -100);
			bulletDelay = new FlxDelay(1000);
			
			bulletGroup = new FlxGroup(150);
			
			state.enemies.add(bulletGroup);
			
			recoverTime = new FlxDelay(200);
			recoverTime.callback = recover;
			
			allowCollisions = NONE;
			
			
			//state.add(skullGun);
			
			loadGraphic(skullPNG, true, false, 43, 60);
			skeletonTime = new FlxDelay(2500);
			skeletonTime.callback = skullSpawn;
			addAnimation("jaw", [0, 1], 1, true);
			play("jaw");
			offset.x += 1;
			width = 40;
			height = 58;
			for (var i:int = 0; i < 16; i++)
			{
				var rand:int = (Math.random() * 3) + 1;
				var skeleton:Skeletons = new Skeletons((15*i) + 40, 30, rand);
				state.enemies.add(skeleton);
			}
		}
		override public function update():void
		{
			super.update();
			if (skullMove)
			{
				if (y < 80)
				{
					flicker(1);
					y++;
				}
				else
				{
					_flickerTimer = 0;
					skullMove = false;
					shmupMoves = true;
					allowCollisions = ANY;
				}
			}
			if (shmupMoves)
			{
				if (!bulletDelay.isRunning)
				{
				var hurt:int = 10;
					
				if (healthEnemy < 40)
				{
					hurt = 40;
				}
				if (healthEnemy < 30)
				{
					hurt = 80;
				}
				for (var i:int = 0; i < 10; i++)
				{
					var newbullet:FlxSprite = bulletGroup.recycle(FlxSprite) as FlxSprite;
					newbullet.loadGraphic(bulletPNG, false, false, 5, 5);
					newbullet.x = x + 7;
					newbullet.y = y + 20;
					var newbullet2:FlxSprite = bulletGroup.recycle(FlxSprite) as FlxSprite;
					newbullet2.loadGraphic(bulletPNG, false, false, 5, 5);
					newbullet2.x = x + 28;
					newbullet2.y = y + 20;
					var ran:Number = Math.floor((Math.random() * 4));
					if (ran == 0)
					{
						newbullet.velocity.x = (Math.random() * 50);
						newbullet.velocity.y = (Math.random() * 50);
						newbullet2.velocity.x = (Math.random() * 50);
						newbullet2.velocity.y = (Math.random() * 50);
					}
					else if (ran == 1)
					{
						newbullet.velocity.x = -(Math.random() * 50);
						newbullet.velocity.y = -(Math.random() * 50);
						newbullet2.velocity.x = -(Math.random() * 50);
						newbullet2.velocity.y = -(Math.random() * 50);
					}
					else if (ran == 2)
					{
						newbullet.velocity.x = (Math.random() * 50);
						newbullet.velocity.y = -(Math.random() * 50);
						newbullet2.velocity.x = (Math.random() * 50);
						newbullet2.velocity.y = -(Math.random() * 50);
					}
					else
					{
						newbullet.velocity.x = -(Math.random() * 50);
						newbullet.velocity.y = (Math.random() * 50);
						newbullet2.velocity.x = -(Math.random() * 50);
						newbullet2.velocity.y = (Math.random() * 50);
					}
					state.add(newbullet);
					state.add(newbullet2);
					bulletDelay.start();
				}
				}
			}
		}
		override public function bootup():void
		{
			skeletonTime.start();
		}
		private function skullSpawn():void
		{
			skullMove = true;
		}
		override public function getHit():void
		{
			if (!recoverTime.isRunning &&  !flickering)
			{
				flashColor(0xFFFFFFFF);
				healthEnemy--;
				recoverTime.start();
				if (healthEnemy <= 0)
				{
					color = 0xFFFF0000;
					kill();
				}
			}
		}
		private function recover():void
		{
			unFlashColor();
			//recoverTime.reset(200);
		}
	}

}