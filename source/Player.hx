package;

import flixel.FlxG;
import flixel.FlxSprite;

class Player extends FlxSprite
{
	static inline var SPEED:Float = 100;

	public function new(x:Float =0, y:Float = 0)
	{
		super(x,y);

		// load player sprite graphics
		loadGraphic(AssetPaths.player__png, true, 16, 16);

		// give movement some drag
		drag.x = drag.y = 800;

		//make it so the sprite will flip around based on what direction it faces
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT,true, false);

		// make the hitbox match the graphics
		setSize(8,8);
		offset.set(4,4);

		//add in some animations
		animation.add("d_idle", [0]);
		animation.add("lr_idle", [3]);
		animation.add("u_idle", [6]);
		animation.add("d_walk", [0,1,0,2], 6);
		animation.add("lr_walk", [3,4,3,5], 6);
		animation.add("u_walk", [6,7,6,8], 6);
	}

	//this function checks for if movement is being done
	function updateMovement ()
	{
		var action:String = "idle";

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
				facing = UP;
			}
			else if (down)
			{
				newAngle = 90;
				if (left)
					newAngle += 45;
				else if (right)
					newAngle -= 45;
				facing = DOWN;
			}
			else if (left)
				{
					newAngle = 180;
					facing = LEFT;
				}
			else if (right)
				{
					newAngle = 0;
					facing = RIGHT;
				}

			//now set velocity based on our genorated angle
			velocity.setPolarDegrees(SPEED, newAngle);
		}

		if ((velocity.x != 0 || velocity.y != 0) && touching == NONE)
		{
			action = "walk";
		}

		switch (facing)
		{
			case LEFT, RIGHT:
				animation.play("lr_" + action);
			case UP:
				animation.play("u_" + action);
			case DOWN:
				animation.play("d_" + action);
			case _:
		}
	}

	override function update(elapsed:Float)
	{
		updateMovement();
		super.update(elapsed);
	}
}