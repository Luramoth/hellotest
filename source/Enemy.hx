package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.math.FlxPoint;
import flixel.math.FlxVelocity;

using flixel.util.FlxSpriteUtil;

enum EnenmyType
{
	REGULAR;
	BOSS;
}

// state mechine that is the core of the eney AI
class FSM
{
	public var activeState:Float->Void;

	public function new(initialState:Float->Void)
	{
		activeState = initialState;
	}

	public function update(elapsed:Float)
	{
		activeState(elapsed);
	}
}

class Enemy extends FlxSprite
{
	static inline var WALK_SPEED:Float = 40;
	static inline var CHASE_SPEED:Float = 70;

	var action:String = "idle";

	public var type:EnenmyType;

	var brain:FSM;
	var idleTimer:Float;
	var moveDirection:Float;

	public var seesPlayer:Bool;
	public var playerPosition:FlxPoint;

	// idle state
	function idle(elapsed:Float)
	{
		if (seesPlayer)
		{
			brain.activeState = chase;
		}
		else if (idleTimer <= 0) //  if th timer has run out then make enamy move in a random direction for a random amount of time
		{
			// 95% chance to move
			if (FlxG.random.bool(95)) // if it can move, then wander to a random direction
			{
				moveDirection = FlxG.random.int(0, 8) * 45;

				velocity.setPolarDegrees(WALK_SPEED, moveDirection);
			}
			else // else just do nothing at all
			{
				moveDirection = -1;
				velocity.x = velocity.y = 0;
			}
			idleTimer = FlxG.random.int(1, 4);
		}
		else
			idleTimer -= elapsed;
	}

	function chase(elapsed:Float) // if the player is seen then just fucking bolt at them
	{
		if (!seesPlayer) // unless you do see them, in which case just idle
		{
			brain.activeState = idle;
		}
		else // move towards the player
		{
			FlxVelocity.moveTowardsPoint(this, playerPosition, CHASE_SPEED);
		}
	}

	public function changeType(type:EnenmyType)
	{
		if (this.type != type) // function changes enemy type
		{
			this.type = type;
			var graphic = if (type == BOSS) AssetPaths.boss__png else AssetPaths.enemy__png;
			loadGraphic(graphic, true, 16, 16);
		}
	}

	public function new(x:Float, y:Float, type:EnenmyType)
	{
		super(x, y);

		this.type = type; // i know how this works but i hate it

		// graphics for the enemy changes depending on what type they are
		var graphic = if (type == BOSS) AssetPaths.boss__png else AssetPaths.enemy__png;

		// actually load those graphics in
		loadGraphic(graphic, true, 16, 16);
		setFacingFlip(LEFT, false, false);
		setFacingFlip(RIGHT, true, false);

		// animation time
		animation.add("d_idle", [0]);
		animation.add("lr_idle", [3]);
		animation.add("u_idle", [6]);
		animation.add("d_walk", [0, 1, 0, 2], 6);
		animation.add("lr_walk", [3, 4, 3, 5], 6);
		animation.add("u_walk", [6, 7, 6, 8], 6);

		// give movement a bit of momentum
		drag.x = drag.y = 10;

		// set the size and position of the collider
		setSize(8, 8);
		offset.x = 4;
		offset.y = 8;

		// time for some brain-ing
		brain = new FSM(idle);
		idleTimer = 0;
		playerPosition = FlxPoint.get();
	}

	override public function update(elapsed:Float)
	{
		if (velocity.x != 0 || velocity.y != 0) // if enemy is moving then have them face in the direction that they are moving
		{
			if (this.isFlickering())
				return;

			if (Math.abs(velocity.x) > Math.abs(velocity.y))
			{
				if (velocity.x < 0)
					facing = LEFT;
				else
					facing = RIGHT;
			}
			else
			{
				if (velocity.y < 0)
					facing = UP;
				else
					facing = DOWN;
			}
		}

		switch (facing) // switch their animation based on what direction they are facing
		{
			case LEFT, RIGHT:
				animation.play("lr_" + action);
			case UP:
				animation.play("u_" + action);
			case DOWN:
				animation.play("d_" + action);
			case _:
		}

		brain.update(elapsed);

		super.update(elapsed);
	}
}
