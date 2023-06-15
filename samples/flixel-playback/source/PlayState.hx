package;

import flixel.FlxState;
import hxcodec.flixel.FlxVideo;

class PlayState extends FlxState
{
	override public function create():Void
	{
		var video:FlxVideo = new FlxVideo();
		video.onEndReached.add(video.dispose);
		video.play('assets/video.mp4');

		super.create();
	}
}
