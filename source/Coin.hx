package;

import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxSprite;

class Coin extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);
		// load the image for the coin
		loadGraphic(AssetPaths.coin__png, false, 8, 8);
	}

	override function kill()
	{
		alive = false;
		// animate the coin to go up and fade
		FlxTween.tween(this, {alpha:0, y: y - 16}, 0.33, {ease: FlxEase.circOut, onComplete: finishKill});
	}
	function finishKill(_)
	{
		exists = false;// actually kill the coin
	}
}