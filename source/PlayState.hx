package;

import flixel.addons.editors.tiled.TiledLayer;
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

	function placeEntities(entity:EntityData)
	{
		if (entity.name == 'player')
		{
			player.setPosition(entity.x, entity.y);
			trace('player placed');
		}
		else if (entity.name == "coin")
		{
			coins.add(new Coin(entity.x + 4, entity.y + 4));
			trace('coin placed');
		}
	}

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

		player = new Player();
		map.loadEntities(placeEntities, "entities");
		add(player);

		FlxG.camera.follow(player, TOPDOWN, 1);

		coins = new FlxTypedGroup<Coin>();
		add(coins);
		trace('coins created');

		super.create();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);
		FlxG.overlap(player, coins, playerTouchCoin);
	}
}
