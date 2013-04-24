package  
{
	/**
	 * ...
	 * @author Christian Stewart
	 */
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	public class MicroBoss extends Boss
	{
		[Embed(source = '../assets/microwave.png')] static private var microPNG:Class;
		[Embed(source = '../assets/microwave beam.png')] static private var beamPNG:Class;
		[Embed(source = '../assets/laser.mp3')] static private var laserMP3:Class;
		private var state:Playstate = FlxG.state as Playstate;
		private var attack:Boolean = false;
		private var walking:Boolean = false;
		private var beamStill:Boolean = false;
		private var idle:Boolean = false;
		private var beam:FlxSprite;
		private var beam2:FlxSprite;
		private var healthEnemy:Number = 30;
		private var recoverTime:FlxDelay;
		private var goingx:int = 1;
		private var goingy:int = 1;
		private var switchMode:FlxDelay;
		
		private var beamTimer:FlxDelay;
		public function MicroBoss(initx:int, inity:int) 
		{
			super(initx, inity);
			loadGraphic(microPNG, true, false, 29, 75);
			width = 21;
			height = 46;
			offset.x = 4;
			offset.y = 29;
			
			switchMode = new FlxDelay(3000);
			switchMode.callback = switchnow;
			
			immovable = true;
			
			beam = new FlxSprite(0, 0, beamPNG);
			beam.exists = false;
			state.enemies.add(beam);
			beam2 = new FlxSprite(0, 0, beamPNG);
			beam2.exists = false;
			state.enemies.add(beam2);
			
			recoverTime = new FlxDelay(200);
			recoverTime.callback = recover;
			
			addAnimation("idle", [2], 0, false);
			addAnimation("bootup", [3, 4, 5, 6, 7, 8, 9], 9, false);
			addAnimation("attack", [10, 11, 12], 3, false);
			addAnimation("beamattack", [12, 12 , 12 , 12, 12, 12, 11], 30, false);
			addAnimation("walk", [0, 1], 12);
			play("idle");
			
		}
		override public function update():void
		{
			super.update();
			if (idle)
			{
				if (_curIndex == 9)
				{
					idle = false;
					attack = true;
				}
			}
			else if (attack)
			{
				if (_curAnim.name != "attack")
				{
					
					play("attack");
				}
				if (_curIndex == 12)
				{
					play("beamattack");
					FlxG.play(laserMP3, 1);
					attack = false;
					beamStill = true;
					beam.y = y + height;
					beam.exists = true;
					beam2.y = beam.y + beam.height;
					beam2.exists = true;
				}
				if (state.player.x < x)
				{
					x -= 1.5;
				}
				else
				{
					x += 1.5;
				}
				if (y > 50)
				{
					y -= 5;
				}
			}
			else if (beamStill)
			{
				if (_curIndex == 11)
				{
					beam.exists = false;
					beam2.exists = false;
					attack = false;
					walking = true;
				}
			}
			if (walking)
			{
				if (!switchMode.isRunning)
					switchMode.start();
				play("walk");
				if (x > 260)
				{
					goingx = -2;
				}
				else if (x < 30)
				{
					goingx = 2;
				}
				if (y > 150)
				{
					goingy =  -2;
				}
				else if (y < 30)
				{
					goingy = 2;
				}
				x += goingx;
				y += goingy;
			}
		}
		override public function bootup():void
		{
			play("bootup");
			idle = true;
		}
		override public function postUpdate():void
		{
			super.postUpdate();
			beam.x = x - 2;
			beam2.x = x - 2;
		}
		override public function getHit():void
		{
			if (!recoverTime.isRunning &&  _curAnim.name != "bootup")
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
		private function switchnow():void
		{
			walking = false;
			attack = true;
		}
	}

}