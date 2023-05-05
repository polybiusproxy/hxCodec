package;

import flixel.FlxState;
import hxcodec.flixel.FlxVideoHandler;

class PlayState extends FlxState
{
	override public function create():Void
	{
		this.bgColor = 0xFFFF00FF;

		var video:FlxVideoHandler = new FlxVideoHandler();
		video.playVideo('assets/video.mp4');

		super.create();
	}
}
