package vlc;

#if android
import android.AndroidTools;
#end
import openfl.events.Event;
import flixel.FlxG;
import vlc.bitmap.LibVLCBitmap;

/**
 * Play a video using cpp.
 * Use bitmap to connect to a graphic or use `VideoSprite`.
 */
class VideoHandler extends LibVLCBitmap {
	/////////////////////////////////////////////////////////////////////////////////////

	public var readyCallback:Void->Void;
	public var finishCallback:Void->Void;

	public var canSkip:Bool = true;
	public var canHaveSound:Bool = true;

	var pauseMusic:Bool;

	public function new(width:Float = 320, height:Float = 240, autoResize:Bool = true, smooting:Bool = true) {
		super(width, height, autoResize, smooting);

		onReady = onVLCVideoReady;
		onComplete = onVLCComplete;
		onError = onVLCError;

		FlxG.addChildBelowMouse(this);

		FlxG.stage.addEventListener(Event.ENTER_FRAME, onFrame);

		FlxG.signals.focusGained.add(function() {
			togglePause();
		});
		FlxG.signals.focusLost.add(function() {
			togglePause();
		});
	}

	function onFrame(e:Event) {
		if (canSkip && (FlxG.keys.justPressed.ENTER || FlxG.keys.justPressed.SPACE #if android || FlxG.android.justReleased.BACK #end) && isPlaying)
			onVLCComplete();

		if (FlxG.sound.muted || FlxG.sound.volume <= 0)
			volume = 0;
		else if (canHaveSound)
			volume = FlxG.sound.volume + 0.4;
	}

	/////////////////////////////////////////////////////////////////////////////////////

	function createUrl(fileName:String):String {
		#if android
		var fileUrl:String = AndroidTools.getFileUrl(fileName);
		return fileUrl;
		#else
		var fileUrl:String = 'file:///' + Sys.getCwd() + fileName;
		return fileUrl;
		#end
	}

	/////////////////////////////////////////////////////////////////////////////////////

	function onVLCVideoReady() {
		trace("Video loaded!");

		if (readyCallback != null)
			readyCallback();
	}

	function onVLCError(error:String) {
		throw "VLC caught an error! :" + error;
	}

	public function onVLCComplete() {
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();

		FlxG.stage.removeEventListener(Event.ENTER_FRAME, onFrame);

		dispose();

		if (FlxG.game.contains(this)) {
			FlxG.game.removeChild(this);

			if (finishCallback != null)
				finishCallback();
		}
	}

	/////////////////////////////////////////////////////////////////////////////////////

	/**
	 * Native video support for Flixel & OpenFL
	 * @param path Example: `your/video/here.mp4`
	 * @param repeat Repeat the video.
	 * @param pauseMusic Pause music until done video.
	 */
	public function playVideo(path:String, repeat:Bool = false, pauseMusic:Bool = false):Void {
		this.pauseMusic = pauseMusic;

		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.pause();

		this.repeat = repeat ? -1 : 0;
		play(createUrl(path));
	}

	/////////////////////////////////////////////////////////////////////////////////////
}
