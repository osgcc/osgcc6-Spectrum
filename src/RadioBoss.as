package  
{
	import org.flixel.*;
	import org.flixel.plugin.photonstorm.FlxDelay;
	/**
	 * ...
	 * @author Christian Stewart
	 */
	public class RadioBoss extends Boss
	{
		[Embed(source = '../assets/radio.png')] static private var radioPNG:Class;
		[Embed(source = '../assets/ground static.png')] static private var groundStaticPNG:Class;
		[Embed(source = '../assets/ground pound.mp3')] static private var groundpoundMP3:Class;
		[Embed(source = '../assets/radio phase.mp3')] static private var radioPhaseMP3:Class;
		private var state:Playstate = FlxG.state as Playstate;
		
		private var rangePrevious:Boolean = false;
		private var switchStateTime:FlxDelay;
		
		public var stillState:Boolean = true;
		public var angryState:Boolean = false;
		public var rangedState:Boolean = false;
		public var meleeState:Boolean = false;
		
		private var groundPoundTime:FlxDelay;
		private var previousX:int;
		private var previousY:int;
		private var groundhits:FlxGroup;
		private var counter:Number = 0;
		private var healthEnemy:Number = 20;
		
		
		private var recoverTime:FlxDelay;
		
		private var handbox:FlxSprite;
		private var handbox2:FlxSprite;
		
		private var hide:Boolean = true;
		private var reshow:Boolean = false;
		private var hideback:Boolean = false;
		private var attack:Boolean = false;
		private var finalShow:Boolean = false;
		
		private var ghost1:RadioGhost;
		private var ghost2:RadioGhost;
		private var ghost3:RadioGhost;
		
		public function RadioBoss(initx:int, inity:int) 
		{
			super(initx, inity);
			loadGraphic(radioPNG, true, true, 50, 28);
			offset.x = 15;
			width = 19;
			
			handbox = new FlxSprite(x-15, y + 10).makeGraphic(10, 10, 0x00000000);
			state.enemies.add(handbox);
			
			handbox2 = new FlxSprite(x+25, y + 10).makeGraphic(10, 10, 0x00000000);
			state.enemies.add(handbox2);
			
			switchStateTime = new FlxDelay(1000);
			switchStateTime.callback = switchFightState;
			groundPoundTime = new FlxDelay(10);
			groundPoundTime.callback = addGroundPound;
			
			
			groundhits = new FlxGroup(25);
			state.enemies.add(groundhits);
			
			addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7], 7);
			addAnimation("angry", [14, 15], 20, true);
			addAnimation("stomp", [8, 9, 10], 9);
			addAnimation("stompPause", [11, 12], 7);
			addAnimation("handsUp", [13], 7);
			play("idle");
			
			recoverTime = new FlxDelay(200);
			recoverTime.callback = recover;
			
		}
		override public function update():void
		{
			super.update();
			if (state.player.playerHealth == 0)
			{
				
			}
			if (angryState)
			{
				play("angry");
				if (!switchStateTime.isRunning)
					switchStateTime.start();
			}
			else if (rangedState)
			{
				if (_curIndex == 9)
					FlxG.play(groundpoundMP3, 0.1);
				if (_curIndex == 10 || _curAnim.name == "stompPause")
				{
					play("stompPause");
					if (healthEnemy <= 10)
					{
						groundPoundTime.abort();
						trace(healthEnemy);
						groundhits.clear();
						if (finalShow)
						{
							rangePrevious = false;
						}
						angryState = true;
						rangedState = false;
					}
					if (!groundPoundTime.isRunning)
						groundPoundTime.start();
				}
				else
				{
					
					if (facing == RIGHT)
						previousX = x - 10;
					else
						previousX = x + width + 5;
					previousY = y + height;
					play("stomp");
				}
			}
			else if (meleeState)
			{
				if (healthEnemy <= 5)
				{
					reshow = false;
					attack = false;
					hideback = true;
				}
				if (hide)
				{
					FlxG.play(radioPhaseMP3, 0.1);
					handbox.exists = false;
					handbox2.exists = false;
					play("handsUp");
					if (alpha > 0)
					{
						alpha -= 0.02;
					}
					else
					{
						hide = false;
						reshow = true;
						play("idle");
						x = Math.random() * 260 + 20;
						y = Math.random() * 180 + 20;
						ghost1 = new RadioGhost(0, 0);
						ghost1.x = Math.random() * 260 + 20;
						ghost1.y = Math.random() * 180 + 20;
						ghost1.alpha = 0;
						state.enemies.add(ghost1);
						ghost2 = new RadioGhost(0, 0);
						ghost2.x = Math.random() * 260 + 20;
						ghost2.y = Math.random() * 180 + 20;
						ghost2.alpha = 0;
						state.enemies.add(ghost2);
						ghost3 = new RadioGhost(0, 0);
						ghost3.x = Math.random() * 260 + 20;
						ghost3.y = Math.random() * 180 + 20;
						ghost3.alpha = 0;
						state.enemies.add(ghost3);
					}
				}
				if (reshow)
				{
					if (alpha < 1)
					{
						alpha += 0.02;
						ghost1.alpha += 0.02;
						ghost2.alpha += 0.02;
						ghost3.alpha += 0.02;
						
					}
					else
					{
						reshow = false;
						attack = true;
					}
				}
				if (attack)
				{
					
				}
				if (hideback)
				{
					play("handsUp");
					if (alpha > 0)
					{
						alpha -= 0.2;
					}
					else
					{
						finalShow = true;
						hideback = false;
						x = 150;
						y = 20;
					}
				}
				if (finalShow)
				{
					if (alpha > 1)
					{
						alpha += 0.2;
					}
					else
					{
						finalShow = true;
						angryState = true;
						meleeState = false;
					}
				}
			}
			else if (stillState)
			{
				
			}
			FlxG.overlap(state.player.attackBox, handbox, movePlayer);
			FlxG.overlap(state.player.attackBox, handbox2, movePlayer);
		}
		public function switchFightState():void
		{
			angryState = false;
			if (rangePrevious)
				meleeState = true;
			else
				rangedState = true;
			rangePrevious = !rangePrevious;
		}
		public function addGroundPound():void
		{
			var ranNum:Number = Math.floor(Math.random() * 5);
			var extraNum:Number = 0;
			var groundstatic:FlxSprite = groundhits.recycle(FlxSprite) as FlxSprite;
			groundstatic.x = previousX; 
			groundstatic.y = previousY;
			groundstatic.loadGraphic(groundStaticPNG, true, false, 6, 6);
			
			if (ranNum == 0)
			{
				groundstatic.addAnimation("middle", [1, 4], 7);
				groundstatic.play("middle");
				
			}
			else if (ranNum == 1)
			{
				groundstatic.addAnimation("left", [0, 3], 7);
				groundstatic.play("left");
				groundstatic.x -= 1;
				extraNum = -5;
			}
			else if (ranNum == 2)
			{
				groundstatic.addAnimation("right", [2, 5], 7);
				groundstatic.play("right");
				groundstatic.x += 1;
				extraNum = 5;
			}
			else if (ranNum == 3)
			{
				groundstatic.addAnimation("left", [0, 3], 7);
				groundstatic.play("left");
				groundstatic.x -= 1;
				extraNum = -5;
			}
			else if (ranNum == 4)
			{
				groundstatic.addAnimation("right", [2, 5], 7);
				groundstatic.play("right");
				groundstatic.x += 1;
				extraNum = 5;
			}
			//groundhits.add(groundstatic);
			previousX = groundstatic.x + extraNum;
			previousY = groundstatic.y + 6;
			counter++;
			if (counter == 25)
			{
				groundhits.clear();
				play("stomp");
				counter = 0;
				if (facing == LEFT)
					facing = RIGHT;
				else
					facing = LEFT;
			}
			else
			{
				groundPoundTime.reset(10);
			}
		}
		override public function getHit():void
		{
			if (!recoverTime.isRunning && _curAnim.name != "handsUp" && _curAnim.name != "angry")
			{
				flashColor(0xFFFFFFFF);
				healthEnemy--;
				recoverTime.start();
				if (healthEnemy <= 0)
				{
					kill();
					Registry.level = 3;
					FlxG.fade(0xff000000, 1, nextLevel);
				}
			}
		}
		private function recover():void
		{
			unFlashColor();
			//recoverTime.reset(200);
		}
		private function movePlayer(player:FlxSprite, handsy:FlxSprite):void
		{
			if (state.player.rightBool)
				state.player.x -= 1;
			else if (state.player.leftBool)
				state.player.x += 1;
			else
				state.player.y += 1;
			
		}
		override public function bootup():void
		{
			stillState = false;
			angryState = true;
		}
		public function nextLevel():void
		{
			FlxG.switchState(new Playstate);
		}
	}
}