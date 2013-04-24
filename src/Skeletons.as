package  
{
	/**
	 * ...
	 * @author Christian Stewart
	 */
	import org.flixel.*;
	public class Skeletons extends Boss 
	{
		
		[Embed(source = '../assets/xray.png')] static private var skeletonPNG:Class;
		private var state:Playstate = FlxG.state as Playstate;
		private var xspeed:int;
		private var anger:Boolean = false;
		private var walking:Boolean = false;
		public function Skeletons(initx:int, inity:int, speed:int) 
		{
			super(initx, inity);
			loadGraphic(skeletonPNG, true, false, 19, 29);	
			addAnimation("redEye", [0, 1, 2, 3], 3);
			addAnimation("walk", [4, 5, 6, 7], 7);
			xspeed = speed;
			
		}
		override public function update():void
		{
			super.update();
			if (anger)
			{
					play("redEye");
				if (_curIndex == 3)
				{
					anger = false;
					walking = true;
					play("walk");
					y += xspeed;
				}
			}
			else if (walking)
			{
				alpha -= 0.01;
				y += xspeed;
			}
			else if (state.player.overlaps(state.angerRange))
			{
				anger = true;
			}
			if (overlaps(state.player.attackBox))
			{
				kill();
			}
			if (alpha <= 0)
			{
				kill();
			}
		}
		
	}
}