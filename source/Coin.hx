package;

import flixel.FlxSprite;

class Coin extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		loadGraphic(AssetPaths.coin__png, false, 8, 8);
	}
}