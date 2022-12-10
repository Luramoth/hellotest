package;

import flixel.ui.FlxButton;
import flixel.FlxState;
import flixel.FlxG;

class MenuState extends FlxState
{
    var PlayButton:FlxButton;
	override public function create()
	{
		super.create();

		PlayButton = new FlxButton(0,0, "play", clickPlay);
        add(PlayButton);

        PlayButton.screenCenter();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

    function clickPlay(){
        FlxG.switchState(new PlayState());
    }
}
