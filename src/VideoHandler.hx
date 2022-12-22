package;

import flixel.FlxG;
import openfl.Lib;
import openfl.events.Event;
import sys.FileSystem;
import vlc.VLCBitmap;

/**
 * Handles video playback.
 * Use bitmap to connect to a graphic or use `VideoSprite`.
 */
class VideoHandler extends VLCBitmap
{
	public var canSkip:Bool = true;
	public var canUseSound:Bool = true;
	public var canUseAutoResize:Bool = true;
	public var isPlaying:Bool = false;

	public var readyCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	private var pauseMusic:Bool = false;

	public function new(?smoothing:Bool = false):Void
	{
		super(smoothing);

		onReady = onVLCReady;
		onComplete = onVLCComplete;
		onError = onVLCError;

		FlxG.addChildBelowMouse(this);
	}

	/**
	 * Plays a video.
	 *
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param hwAccelerated if you want the video to be hardware accelerated.
	 * @param PauseMusic Pause music until the video ends.
	 */
	public function playVideo(Path:String, Loop:Bool = false, hwAccelerated:Bool = true, PauseMusic:Bool = false):Void
	{
		pauseMusic = PauseMusic;

		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.pause();

		if (canUseAutoResize)
		{
			width = calcSize(0);
			height = calcSize(1);
		}

		FlxG.stage.addEventListener(Event.ENTER_FRAME, onUpdate);
		FlxG.stage.addEventListener(Event.ACTIVATE, onFocus);
		FlxG.stage.addEventListener(Event.DEACTIVATE, onFocusLost);
		FlxG.stage.addEventListener(Event.RESIZE, onResize);

		// in case if you want to use another dir then the application one.
		// android can already do this, it can't use the application storage.
		if (FileSystem.exists(Sys.getCwd() + Path))
			play(Sys.getCwd() + Path, Loop, hwAccelerated);
		else
			play(Path, Loop, hwAccelerated);
	}

	private function onVLCReady():Void 
	{        
		trace("video loaded!");
		if (readyCallback != null)
		    readyCallback();
	}

	private function onVLCError(E:String):Void
	{
		Lib.application.window.alert(E, "VLC caught an error!");
		onVLCComplete();
	}

	private function onVLCComplete():Void
	{
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();

		if (FlxG.stage.hasEventListener(Event.ENTER_FRAME))
			FlxG.stage.removeEventListener(Event.ENTER_FRAME, onUpdate);

		if (FlxG.stage.hasEventListener(Event.ACTIVATE))
			FlxG.stage.removeEventListener(Event.ACTIVATE, onFocus);

		if (FlxG.stage.hasEventListener(Event.DEACTIVATE))
			FlxG.stage.removeEventListener(Event.DEACTIVATE, onFocusLost);

		if (FlxG.stage.hasEventListener(Event.RESIZE))
			FlxG.stage.removeEventListener(Event.RESIZE, onResize);

		dispose();

		if (FlxG.game.contains(this))
			FlxG.game.removeChild(this);

		if (finishCallback != null)
			finishCallback();
	}

	private function onUpdate(_):Void
	{
		isPlaying = libvlc.isPlaying();

		if (canSkip
			&& ((FlxG.keys.justPressed.ENTER && !FlxG.keys.pressed.ALT)
				|| FlxG.keys.justPressed.SPACE #if android || FlxG.android.justReleased.BACK #end)
			&& initComplete)
			onVLCComplete();

		if ((FlxG.sound.muted || FlxG.sound.volume <= 0) || !canUseSound)
			volume = 0;
		else if (canUseSound)
			volume = FlxG.sound.volume * 100;
	}

	private function onFocus(_):Void
	{
		if (FlxG.autoPause && !libvlc.isPlaying())
			resume();
	}

	private function onFocusLost(_):Void
	{
		if (FlxG.autoPause && libvlc.isPlaying())
			pause();
	}

	private function onResize(_):Void
	{
		if (canUseAutoResize)
		{
			width = calcSize(0);
			height = calcSize(1);
		}
	}

	private function calcSize(Ind:Int):Float
	{
		var appliedWidth:Float = FlxG.stage.stageHeight * (FlxG.width / FlxG.height);
		var appliedHeight:Float = FlxG.stage.stageWidth * (FlxG.height / FlxG.width);

		if (appliedHeight > FlxG.stage.stageHeight)
			appliedHeight = FlxG.stage.stageHeight;

		if (appliedWidth > FlxG.stage.stageWidth)
			appliedWidth = FlxG.stage.stageWidth;

		switch (Ind)
		{
			case 0:
				return appliedWidth;
			case 1:
				return appliedHeight;
		}

		return 0;
	}
}
