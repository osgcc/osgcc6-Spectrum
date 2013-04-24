package  
{
	import org.flixel.*;
	import flash.text.TextField;
	public class MainMenuState extends FlxState
	{
		
		[Embed(source = '../assets/title screen.png')] static private var menuPNG:Class;
		[Embed(source = '../assets/title screen chord.mp3')] static private var menuMP3:Class;
		public function MainMenuState() 
		{		
		}
		override public function create():void
		{
			var theMenu:FlxSprite = new FlxSprite(0, 0, menuPNG);
			add(theMenu);
			FlxG.play(menuMP3);
		}
		override public function update():void
		{
			super.update();
			
			if (FlxG.keys.justPressed("Z"))
			{
				FlxG.switchState(new Playstate);
			}
		}
	}
}