package;

import openfl.events.Event;
import flixel.FlxG;

/**
 * The cpp version of playing a video
 * Use bitmap to return to a sprite or use `MP4Sprite`
 */
class MP4Handler extends vlc.VlcBitmap
{
	public var readyCallback:Void->Void;
	public var finishCallback:Void->Void;

	/**
	 * Native video support for Flixel & OpenFL
	 * @param path Example: `your/video/here.mp4`
	 * @param repeat Repeat the video.
	 */
	public function new(path:String, ?repeat:Bool = false)
	{
		super(FlxG.stage.stageWidth, FlxG.stage.stageHeight);

		if (FlxG.sound.music.playing)
			FlxG.sound.music.pause();

		onVideoReady = onVLCVideoReady;
		onComplete = finishVideo;
		onError = onVLCError;

		this.repeat = repeat ? -1 : 0;

		FlxG.addChildBelowMouse(this);

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		// TODO: Remove this
		playVideo(path);
	}

	function update(e:Event)
	{
		// TODO: Add so you press two times to skip
		if (FlxG.keys.justPressed.ANY && isPlaying)
			finishVideo();

		volume = FlxG.sound.volume + 0.4;
	}

	#if sys
	function checkFile(fileName:String):String
	{
		var pDir = "";
		var appDir = "file:///" + Sys.getCwd() + "/";

		if (fileName.indexOf(":") == -1) // Not a path
			pDir = appDir;
		else if (fileName.indexOf("file://") == -1 || fileName.indexOf("http") == -1) // C:, D: etc? ..missing "file:///" ?
			pDir = "file:///";

		return pDir + fileName;
	}
	#end

	function onVLCVideoReady()
	{
		trace("Video loaded!");

		if (readyCallback != null)
			readyCallback();
	}

	function onVLCError()
	{
		// TODO: Catch the error
		throw "VLC caught an error!";
	}

	public function finishVideo()
	{
		if (FlxG.sound.music != null)
			FlxG.sound.music.resume();

		dispose();

		if (FlxG.game.contains(this))
		{
			FlxG.game.removeChild(this);

			if (finishCallback != null)
				finishCallback();
		}
	}

	public function playVideo(path:String)
	{
		#if sys
		play(checkFile(path));
		#else
		throw "Doesn't support sys";
		#end
	}
}
