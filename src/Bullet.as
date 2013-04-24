package  
{
	import org.flixel.FlxSprite;
	/**
	 * ...
	 * @author Christian Stewart
	 */
	public class Bullet extends FlxSprite
	{
		[Embed(source = '../assets/xray skull bullet.png')] static private var bulletPNG:Class;
		public function Bullet(initx:int, inity:int) 
		{
			super(initx, inity)
			loadGraphic(bulletPNG, false, false, 5, 5);
		}
		override public function update():void
		{
			super.update();
			if (x > 320 || x < 0 || y > 240 || y < 0)
			{
				kill();
			}
		}
	}

}