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

		//create a button on screen and center it
		PlayButton = new FlxButton(0,0, "play", clickPlay);
		add(PlayButton);
		PlayButton.screenCenter();
	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);
	}

	//when called (called by PlayButton when pressed) then change the games overall state to playState
	function clickPlay(){
		FlxG.switchState(new PlayState());
	}
}
