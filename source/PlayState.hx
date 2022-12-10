package;

import flixel.FlxG;
import flixel.tile.FlxTilemap;
import flixel.addons.editors.ogmo.FlxOgmo3Loader;
import flixel.FlxState;

class PlayState extends FlxState
{
	var player: Player;

	var map:FlxOgmo3Loader;
	var walls:FlxTilemap;

	function placeEntities(entity:EntityData)
	{
		if (entity.name == 'player')
		{
			player.setPosition(entity.x, entity.y);
		}
	}

	override public function create()
	{
		super.create();

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
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
		FlxG.collide(player, walls);
	}
}
