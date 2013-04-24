package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Christian Stewart
	 */
	public class Playstate extends FlxState
	{
		[Embed(source = '../assets/prism background.png')] static private var level1PNG:Class;
		[Embed(source = '../assets/woodsyroom.png')] static private var level2PNG:Class;
		[Embed(source = '../assets/radiotower.png')] static private var towerPNG:Class;
		[Embed(source = '../assets/orangeroom1.png')] static private var level3PNG:Class;
		[Embed(source = '../assets/xrayroom.png')] static private var level4PNG:Class;
		[Embed(source = '../assets/health bar.png')] static private var healthbarPNG:Class;
		[Embed(source = '../assets/radio boss.mp3')] static private var radiobossMP3:Class;
		[Embed(source = '../assets/microwave.mp3')] static private var microwaveMP3:Class;
		[Embed(source = '../assets/xray.mp3')] static private var xrayMP3:Class;
		[Embed(source = '../assets/prism room.mp3')] static private var prismroomMP3:Class;
		[Embed(source = '../assets/crystal.png')] static private var crystalPNG:Class;
		
		
		public var player:Player;
		private var background:FlxSprite;
		private var boss:Boss;
		public var enemies:FlxGroup;
		private var level:Number;
		public var collideables:FlxGroup;
		public var angerRange:FlxSprite;
		private var notStart:Boolean = true;
		public var healthBar:FlxSprite;
		public function Playstate() 
		{
		}
		override public function create():void
		{
			super.create();
			level = Registry.level;
			enemies = new FlxGroup();
			collideables = new FlxGroup();
			player = new Player(150, 150);
			
			if (level == 1)
			{
				background = new FlxSprite(0, 0).loadGraphic(level1PNG, false, false, 320, 240);
				FlxG.playMusic(prismroomMP3);
				var prism:FlxSprite = new FlxSprite (50, 30);
				prism.loadGraphic(crystalPNG, true, false, 9, 33);
				prism.addAnimation("shone", [0, 1, 2, 3, 4, 5], 4, true);
				prism.immovable = true;
				prism.play("shone");
				collideables.add(prism);
				prism = new FlxSprite (257, 30);
				prism.loadGraphic(crystalPNG, true, false, 9, 33);
				prism.addAnimation("shone", [0, 1, 2, 3, 4, 5], 4, true);
				prism.immovable = true;
				prism.play("shone");
				collideables.add(prism);
				prism = new FlxSprite (50, 150);
				prism.loadGraphic(crystalPNG, true, false, 9, 33);
				prism.addAnimation("shone", [0, 1, 2, 3, 4, 5], 4, true);
				prism.immovable = true;
				prism.play("shone");
				collideables.add(prism);
				prism = new FlxSprite (257, 150);
				prism.loadGraphic(crystalPNG, true, false, 9, 33);
				prism.addAnimation("shone", [0, 1, 2, 3, 4, 5], 4, true);
				prism.immovable = true;
				prism.play("shone");
				collideables.add(prism);
			}
			else if (level == 2)
			{
				background = new FlxSprite(0, 0).loadGraphic(level2PNG, false, false, 320, 240);
				boss = new RadioBoss(150, 20);
				FlxG.playMusic(radiobossMP3);
				var towerSprite:FlxSprite = new FlxSprite(30, 30);
				towerSprite.loadGraphic(towerPNG, true, false, 25, 56);
				towerSprite.immovable = true;
				towerSprite.addAnimation("sup", [0, 1, 2, 3], 7);
				//25, 56
				towerSprite.play("sup");
				collideables.add(towerSprite);
				towerSprite = new FlxSprite(257, 30);
				towerSprite.loadGraphic(towerPNG, true, false, 25, 56);
				towerSprite.immovable = true;
				towerSprite.addAnimation("sup", [0, 1, 2, 3], 7);
				towerSprite.play("sup");
				collideables.add(towerSprite);
			}
			else if (level == 3)
			{
				background = new FlxSprite(0, 0).loadGraphic(level3PNG, false, false, 320, 240);
				boss = new MicroBoss(150, 20);
				FlxG.playMusic(microwaveMP3);
			}
			else if (level == 4)
			{
				background = new FlxSprite(0, 0).loadGraphic(level4PNG, false, false, 320, 240);
				boss = new Xboss(150, 20);
				FlxG.playMusic(xrayMP3);
				
			}
			var leftBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(33, 240, 0x000000);
			leftBar.immovable = true;
			collideables.add(leftBar);
			var bottomBar:FlxSprite = new FlxSprite(0, 199).makeGraphic(320, 41, 0x000000);
			bottomBar.immovable = true;
			collideables.add(bottomBar);
			var rightBar:FlxSprite = new FlxSprite(287, 0).makeGraphic(33, 240, 0x000000);
			rightBar.immovable = true;
			collideables.add(rightBar);
			var topBar:FlxSprite = new FlxSprite(0, 0).makeGraphic(320, 41, 0x000000);
			topBar.immovable = true;
			collideables.add(topBar);
			
			if (Registry.level == 1)
			{
				angerRange = new FlxSprite(130, 12).makeGraphic(50, 30, 0x000000000);
			}
			else
			{
				angerRange = new FlxSprite(110, 30).makeGraphic(100, 80, 0x00000000);
			}
			
			
			
			add(background);
			add(angerRange);
			add(collideables);
			add(boss);
			add(enemies);
			add(player);
			add(player.attackBox);
			healthBar = new FlxSprite(10, 10).loadGraphic(healthbarPNG, true, false, 69, 13);
			add(healthBar);
			
		}
		override public function update():void
		{
			super.update();	
			FlxG.overlap(player, boss, makeHit);
			FlxG.overlap(player, enemies, makeHit);
			FlxG.overlap(player.attackBox, boss, makeEnemyHit);
			FlxG.collide(player, collideables);
			FlxG.collide(boss, collideables);
			if (notStart)
			{
				if (player.overlaps(angerRange))
				{
					notStart = false;
					if (level != 1)
						boss.bootup();
					else
					{
						Registry.level = 2;
						FlxG.switchState(new Playstate);
					}
				}
			}
		}
		private function makeHit(thePlayer:Player, enemy:FlxSprite):void
		{
			if (!thePlayer.flickering)
			{
				thePlayer.getHit();
			}
		}
		private function makeEnemyHit(box:FlxSprite, enemy:Boss):void
		{
			enemy.getHit();
		}
	}

}