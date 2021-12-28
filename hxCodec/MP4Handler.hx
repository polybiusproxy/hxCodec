package hxcodec;

import flixel.FlxG;
import openfl.events.Event;

class MP4Handler extends hxcodec.vlc.VlcBitmap {
	public var readyCallback:Void->Void;
	public var finishCallback:Void->Void;

	var pauseMusic:Bool;

	public function new(width:Float = 320, height:Float = 240, autoScale:Bool = true) {
		super(width, height, autoScale);

		onVideoReady = onVLCVideoReady;
		onComplete = finishVideo;
		onError = onVLCError;

		FlxG.addChildBelowMouse(this);

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		FlxG.signals.focusGained.add(function() {
			resume();
		});
		FlxG.signals.focusLost.add(function() {
			pause();
		});
	}

	function update(e:Event) {
		if ((FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE) && isPlaying)
			finishVideo();

		if (FlxG.sound.muted || FlxG.sound.volume <= 0)
			volume = 0;
		else
			volume = FlxG.sound.volume + 0.4;
	}

	#if sys
	function checkFile(fileName:String):String {
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";

		if (fileName.indexOf(":") == -1)
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 || fileName.indexOf("http") == -1)
			pDir = "file:///";

		return pDir + fileName;
	}
	#end

	function onVLCVideoReady() {
		trace("Video loaded!");

		if (readyCallback != null)
			readyCallback();
	}

	function onVLCError() {
		throw "VLC caught an error!";
	}

	public function finishVideo() {
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();

		FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);

		dispose();

		if (FlxG.game.contains(this)) {
			FlxG.game.removeChild(this);

			if (finishCallback != null)
				finishCallback();
		}
	}

	public function playVideo(path:String, ?repeat:Bool = false, pauseMusic:Bool = false) {
		this.pauseMusic = pauseMusic;

		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.pause();

		#if sys
		play(checkFile(path));

		this.repeat = repeat ? -1 : 0;
		#else
		throw "Doesn't support sys";
		#end
	}
}
