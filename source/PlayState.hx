package;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxState;

class PlayState extends FlxState
{
	var player: Player;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	var coins:FlxTypedGroup<Coin>;

	// place down all the entities based on the tilemap
	function placeEntities(entity:EntityData)
	{
		if (entity.name == 'player')// find where the player is according to the tilemap and put then in place
		{
			player.setPosition(entity.x, entity.y);
		}
		else if (entity.name == "coin")// find coins in the tilemap and place then down
		{
			coins.add(new Coin(entity.x + 4, entity.y + 4));
		}
	}

	// if coin is touched then call the coin's kill function
	function playerTouchCoin(player:Player, coin:Coin)
	{
		if (player.alive && player.exists && coin.alive && coin.exists)
		{
			coin.kill();
		}
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

		// create player
		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);

		// make camera follow player
		FlxG.camera.follow(player, TOPDOWN, 1);

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		// detect collisions for walls
		FlxG.collide(player, walls);
		// detect collisions for coins
		FlxG.overlap(player, coins, playerTouchCoin);
	}
}
