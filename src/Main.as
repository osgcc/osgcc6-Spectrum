package
{
	import org.flixel.*;
	import flash.events.Event;
	[SWF(width = "640", height = "480", backgroundColor = "#000000")]
	//[Frame(factoryClass="Preloader")]

	public class Main extends FlxGame
	{	
		public function Main():void
		{
			super(320, 240, MainMenuState, 2, 60, 60);
			forceDebugger = true;
			//useSoundHotKeys = false;
		}
		override protected function create(FlashEvent:Event):void
        {
            super.create(FlashEvent);
            stage.removeEventListener(Event.DEACTIVATE, onFocusLost);
            stage.removeEventListener(Event.ACTIVATE, onFocus);
        }
	}
}