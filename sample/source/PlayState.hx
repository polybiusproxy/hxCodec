package;

import flixel.FlxState;
import hxcodec.VideoHandler;

class PlayState extends FlxState
{
	override public function create():Void
	{
		var video:VideoHandler = new VideoHandler();
		video.playVideo('assets/video.mp4');

		super.create();
	}
}
