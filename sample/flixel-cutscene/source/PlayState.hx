package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import hxcodec.flixel.FlxCutsceneState;

class PlayState extends FlxState
{
	var hasPlayed:Bool;

	public function new(hasPlayed:Bool = false) {
		super();

		this.hasPlayed = hasPlayed;
	}

	override public function create():Void
	{
		this.bgColor = hasPlayed ? 0xFF00FF00 : 0xFFFF00FF;

		var text:FlxText = new FlxText(0, 0, FlxG.width, "");
		text.setFormat(null, 16, 0xFFFFFFFF, "center");

		if (!hasPlayed) {
			text.text += "hxCodec Flixel Cutscene Sample";
			text.text += "\nPress SPACE to play cutscene";
			text.text += "\n";
		} else {
			text.text += "Cutscene complete!";
			text.text += "\nPress SPACE to play again";
			text.text += "\n";
		}

		add(text);

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		if (FlxG.keys.justPressed.SPACE)
		{
			FlxG.switchState(new FlxCutsceneState('assets/video.mp4', new PlayState(true)));
		}

		super.update(elapsed);
	}
}
