package;

import flixel.math.FlxVelocity;
import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.FlxSprite;

enum EnenmyType
{
	REGULAR;
	BOSS;
}

class FSM
{
	public var activeState:Float -> Void;

	public function new (initialState:Float -> Void)
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

	var type:EnenmyType;

	var brain:FSM;
	var idleTimer:Float;
	var moveDirection:Float;
	public var seesPlayer:Bool;
	public var playerPosition:FlxPoint;

	function idle(elapsed:Float)
	{
		if (seesPlayer)
		{
			brain.activeState = chase;
		}
		else if (idleTimer <= 0)
		{
			//95% chance to move
			if (FlxG.random.bool(95))
			{
				moveDirection = FlxG.random.int(0,8) * 45;

				velocity.setPolarDegrees(WALK_SPEED, moveDirection);
			}
			else
			{
				moveDirection = -1;
				velocity.x = velocity.y = 0;
			}
			idleTimer =  FlxG.random.int(1, 4);
		}
		else
			idleTimer -= elapsed;
	}

	function chase(elapsed:Float)
	{
		if (!seesPlayer)
		{
			brain.activeState = idle;
		}
		else
		{
			FlxVelocity.moveTowardsPoint(this, playerPosition, CHASE_SPEED);
		}
	}

	public function new(x:Float, y:Float, type:EnenmyType)
	{
		super(x,y);

		this.type = type;
		var graphic = if (type == BOSS) AssetPaths.boss__png else AssetPaths.enemy__png;
		loadGraphic(graphic, true, 16, 16);
		setFacingFlip(LEFT,false,false);
		setFacingFlip(RIGHT,true,false);
		animation.add("d_idle", [0]);
		animation.add("lr_idle", [3]);
		animation.add("u_idle", [6]);
		animation.add("d_walk", [0, 1, 0, 2], 6);
		animation.add("lr_walk", [3, 4, 3, 5], 6);
		animation.add("u_walk", [6, 7, 6, 8], 6);
		drag.x = drag.y = 10;
		setSize(8,8);
		offset.x = 4;
		offset.y = 8;

		// time for some brain-ing
		brain = new FSM(idle);
		idleTimer = 0;
		playerPosition = FlxPoint.get();
	}

	override public function update(elapsed:Float)
	{
		if (velocity.x != 0 || velocity.y != 0)
		{
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

		brain.update(elapsed);

		super.update(elapsed);
	}
}