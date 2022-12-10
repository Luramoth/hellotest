package;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 100;

	public function new(x:Float =0, y:Float = 0)
	{
		super(x,y);

		makeGraphic(16,16,FlxColor.BLUE);
		drag.x = drag.y = 800;
	}

	//this function checks for if movement is being done
	function updateMovement ()
	{
		var up:Bool = false;
		var down:Bool = false;
		var left:Bool = false;
		var right:Bool = false;

		//check if any keys are actually being pressed
		up = FlxG.keys.anyPressed([UP,W]);
		down = FlxG.keys.anyPressed([DOWN,S]);
		left = FlxG.keys.anyPressed([LEFT,A]);
		right = FlxG.keys.anyPressed([RIGHT,D]);

		// cancel any opposing movements
		if (up && down)
			up = down = false;
		if (left && right)
			left = right = false;

		// now it's time to move
		if (up || down || left || right)
		{
			var newAngle:Float = 0;

			// change movmeent angle based on keys pressed using a pseudo normalisation
			if (up)
			{
				newAngle = -90;
				if (left)
					newAngle -= 45;
				else if (right)
					newAngle += 45;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
			}
			else if (left)
				newAngle = 180;
			else if (right)
				newAngle = 0;

			//now set velocity based on our genorated angle
			velocity.setPolarDegrees(SPEED, newAngle);
		}
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}
}