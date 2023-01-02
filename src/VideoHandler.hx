package;

import flixel.FlxG;
import openfl.Lib;
import openfl.events.Event;
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
	public var readyCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	private var pauseMusic:Bool = false;

	public function new():Void
	{
		super();

		onOpening = onVLCOpening;
		onEndReached = onVLCEndReached;
		onEncounteredError = onVLCEncounteredError;

		FlxG.addChildBelowMouse(this);
	}

	private function update(?E:Event):Void
	{
		if (canSkip
			&& ((FlxG.keys.justPressed.ENTER && !FlxG.keys.pressed.ALT)
				|| FlxG.keys.justPressed.SPACE #if android || FlxG.android.justReleased.BACK #end)
			&& initComplete)
			onVLCComplete();

		if ((FlxG.sound.muted || FlxG.sound.volume <= 0) || !canUseSound)
			volume = 0;
		else if (canUseSound)
			volume = FlxG.sound.volume;
	}

	private function resize(?E:Event):Void
	{
		if (canUseAutoResize)
		{
			width = calcSize(0);
			height = calcSize(1);
		}
	}

	private function onVLCOpening():Void 
	{        
		trace("video loaded!");
		if (readyCallback != null)
		    readyCallback();
	}

	private function onVLCError():Void
	{
		Lib.application.window.alert('The Error cannot be specified', "VLC caught an error!");
		onVLCComplete();
	}

	private function onVLCEndReached():Void
	{
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();

		if (FlxG.stage.hasEventListener(Event.ENTER_FRAME))
			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);

		if (FlxG.stage.hasEventListener(Event.RESIZE))
			FlxG.stage.removeEventListener(Event.RESIZE, resize);

		if (FlxG.autoPause)
		{
			if (FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.remove(resume);

			if (FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.remove(pause);
		}

		dispose();

		if (FlxG.game.contains(this))
			FlxG.game.removeChild(this);

		if (finishCallback != null)
			finishCallback();
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

		if (FlxG.sound.music != null && PauseMusic)
			FlxG.sound.music.pause();

		resize();

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);
		FlxG.stage.addEventListener(Event.RESIZE, resize);

		if (FlxG.autoPause)
		{
			FlxG.signals.focusGained.add(resume);
			FlxG.signals.focusLost.add(pause);
		}

		play(#if desktop Sys.getCwd() + #end Path, Loop, hwAccelerated);
	}

	private function calcSize(Ind:Int):Float
	{
		var appliedWidth:Float = Lib.current.stage.stageHeight * (FlxG.width / FlxG.height);
		var appliedHeight:Float = Lib.current.stage.stageWidth * (FlxG.height / FlxG.width);

		if (appliedHeight > Lib.current.stage.stageHeight)
			appliedHeight = Lib.current.stage.stageHeight;

		if (appliedWidth > Lib.current.stage.stageWidth)
			appliedWidth = Lib.current.stage.stageWidth;

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
