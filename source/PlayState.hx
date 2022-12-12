package;

import Hud.HUD;
import flixel.FlxG;
import flixel.FlxState;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.tile.FlxTilemap;

using flixel.util.FlxSpriteUtil;

class PlayState extends FlxState
{
	var hud:HUD;
	var money:Int = 0;
	var health:Int = 3;

	var inCombat:Bool = false;
	var combatHud:CombatHUD;

	var player:Player;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var coins:FlxTypedGroup<Coin>;

	var enemies:FlxTypedGroup<Enemy>;

	// place down all the entities based on the tilemap
	function placeEntities(entity:EntityData)
	{
		var x = entity.x;
		var y = entity.y;

		switch (entity.name)
		{
			case "player":
				player.setPosition(x, y);

			case "coin":
				coins.add(new Coin(x + 4, y + 4));

			case "enemy":
				enemies.add(new Enemy(x + 4, y, REGULAR));

			case "boss":
				enemies.add(new Enemy(x + 4, y, BOSS));
		}
	}

	// if coin is touched then call the coin's kill function
	function playerTouchCoin(player:Player, coin:Coin)
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();

			// add more moeny to the counter
			money++;
			hud.updateHUD(health, money);
		}
	}

	function checkEnemyVision(enemy:Enemy)
	{
		if (walls.ray(enemy.getMidpoint(), player.getMidpoint()))
		{
			enemy.seesPlayer = true;
			enemy.playerPosition = player.getMidpoint();
		}
		else
		{
			enemy.seesPlayer = false;
		}
	}

	function playerTouchEnemy(player:Player, enemy:Enemy)
	{
		if (player.alive && player.exists && enemy.alive && enemy.exists && !enemy.isFlickering())
		{
			startCombat(enemy);
		}
	}

	function startCombat(enemy:Enemy)
	{
		inCombat = true;
		player.active = false;
		enemies.active = false;
		combatHud.initCombat(health, enemy);
	}

	override public function create()
	{
		// load tile map
		map = new FlxOgmo3Loader(AssetPaths.turnBasedRPG__ogmo, AssetPaths.room001__json);
		walls = map.loadTilemap(AssetPaths.tiles__png, "walls");
		// lock camera in place
		walls.follow();
		// set floor collisions to none and wall colisions to collide with all
		walls.setTileProperties(1, NONE);
		walls.setTileProperties(2, ANY);
		add(walls);

		// create coins
		coins = new FlxTypedGroup<Coin>();
		add(coins);

		// create enemies
		enemies = new FlxTypedGroup<Enemy>();
		add(enemies);

		// create player
		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);

		// make camera follow player
		FlxG.camera.follow(player, TOPDOWN, 1);

		hud = new HUD();
		add(hud);

		combatHud = new CombatHUD();
		add(combatHud);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		if (inCombat)
		{
			if (!combatHud.visible)
			{
				health = combatHud.playerHealth;
				hud.updateHUD(health, money);
				if (combatHud.outcome == VICTORY)
				{
					combatHud.enemy.kill();
				}
				else
				{
					combatHud.enemy.flicker();
				}
				inCombat = false;
				player.active = true;
				enemies.active = true;
			}
		}
		else
		{
			super.update(elapsed);
			// detect collisions for walls
			FlxG.collide(player, walls);
			// detect collisions for coins
			FlxG.overlap(player, coins, playerTouchCoin);

			// make enemies collide with walls
			FlxG.collide(enemies, walls);
			enemies.forEachAlive(checkEnemyVision); // check if the enemy is seeing the player

			FlxG.overlap(player, enemies, playerTouchEnemy);
		}
	}
}