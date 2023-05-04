package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import hxcodec.flixel.VideoHandler;

class PlayState extends FlxState {
	var video:VideoHandler;

	override public function create():Void {
		this.bgColor = 0xFFFF00FF;

		video = new VideoHandler();
		video.playVideo('assets/video.mp4');

		var text:FlxText = new FlxText(0, 0, FlxG.width, "");
		text.setFormat(null, 16, 0xFFFFFFFF, "center");

		text.text += "hxCodec Flixel Sample";
		text.text += "\nPress Q to play video";
		text.text += "\n";

		super.create();
	}

	public override function update(elapsed:Float) {
		super.update(elapsed);

		if (FlxG.keys.justPressed.Q) {
			video.playVideo('assets/video.mp4');
		}

		if (FlxG.keys.justPressed.A) {
			video.pause();
		}

		if (FlxG.keys.justPressed.S) {
			video.resume();
		}

		if (FlxG.keys.justPressed.D) {
			video.stop();
		}

		if (FlxG.keys.justPressed.F) {
			video.time -= 5000;
		}

		if (FlxG.keys.justPressed.G) {
			video.time += 5000;
		}

		if (FlxG.keys.justPressed.H) {
			video.position = 0.0;
		}

		if (FlxG.keys.justPressed.J) {
			video.playbackRate = 0.5;
		}

		if (FlxG.keys.justPressed.K) {
			video.playbackRate = 1.0;
		}

		if (FlxG.keys.justPressed.L) {
			video.playbackRate = 2.0;
		}
	}
}
