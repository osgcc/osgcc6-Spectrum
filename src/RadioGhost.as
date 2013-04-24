package  
{
	import org.flixel.*;
	/**
	 * ...
	 * @author Christian Stewart
	 */
	public class RadioGhost extends Boss
	{
		private var state:Playstate = FlxG.state as Playstate;
		[Embed(source = '../assets/radio.png')] static private var radioPNG:Class;
		public function RadioGhost(initx:int, inity:int) 
		{
			super(initx, inity);
			loadGraphic(radioPNG, true, true, 50, 28);
			offset.x = 15;
			width = 19;
			
			addAnimation("idle", [0, 1, 2, 3, 4, 5, 6, 7], 7);
			play("idle");
		}
		override public function update():void
		{
			super.update();
			if (overlaps(state.player.attackBox))
			{
				kill();
			}
		}
	}
}