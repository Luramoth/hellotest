package;

import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		trace("Hello, World!");

		//start up the game as well as HaxeFlixel
		addChild(new FlxGame(0, 0, MenuState));
	}
}
