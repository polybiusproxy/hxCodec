package hxcodec;

import flixel.FlxG;
import flixel.input.keyboard.FlxKey;
import openfl.Lib;
import openfl.events.Event;
import hxcodec.vlc.VLCBitmap;
import sys.FileSystem;

/**
 * Handles video playback.
 * Use bitmap to connect to a graphic or use `VideoSprite`.
 */
class VideoHandler extends VLCBitmap
{
	#if FLX_KEYBOARD
	public var skipKeys:Array<FlxKey> = [ENTER, SPACE];
	#end

	public var canSkip:Bool = true;
	public var canUseSound:Bool = true;
	public var canUseAutoResize:Bool = true;

	public var openingCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	private var __pauseMusic:Bool = false;

	public function new(AddBelowMouse:Bool = true, IndexModifier:Int = 0):Void
	{
		super();

		onOpening = onVLCOpening;
		onEndReached = onVLCEndReached;
		onEncounteredError = onVLCEncounteredError;

		if (AddBelowMouse)
			FlxG.addChildBelowMouse(this, IndexModifier);
	}

	private function onVLCOpening():Void 
	{        
		#if HXC_DEBUG_TRACE
		trace("the video is opening!");
		#end

		// The Media Player isn't `null at this point...
		volume = Std.int(#if FLX_SOUND_SYSTEM ((FlxG.sound.muted || !canUseSound) ? 0 : 1) * #else (!canUseSound ? 0 : 1) * #end FlxG.sound.volume * 100);

		if (openingCallback != null)
		    openingCallback();
	}

	private function onVLCEncounteredError(msg:String):Void
	{
		Lib.application.window.alert(msg, "VLC Error!");
		onVLCEndReached();
	}

	private function onVLCEndReached():Void
	{
		#if HXC_DEBUG_TRACE
		trace("the video reached the end!");
		#end

		if (FlxG.sound.music != null && __pauseMusic)
			FlxG.sound.music.resume();

		if (FlxG.stage.hasEventListener(Event.ENTER_FRAME))
			FlxG.stage.removeEventListener(Event.ENTER_FRAME, update);

		if (FlxG.autoPause)
		{
			if (FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.remove(resume);

			if (FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.remove(pause);
		}

		dispose();

		FlxG.removeChild(this);

		if (finishCallback != null)
			finishCallback();
	}

	/**
	 * Plays a video.
	 *
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends.
	 *
	 * @return 0 if playback started (and was already started), or -1 on error.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Int
	{
		__pauseMusic = PauseMusic;

		if (FlxG.sound.music != null && PauseMusic)
			FlxG.sound.music.pause();

		FlxG.stage.addEventListener(Event.ENTER_FRAME, update);

		if (FlxG.autoPause)
		{
			FlxG.signals.focusGained.add(resume);
			FlxG.signals.focusLost.add(pause);
		}

		// in case if you want to use another dir then the application one.
		// android can already do this, it can't use application's storage.
		if (FileSystem.exists(Sys.getCwd() + Path))
			return play(Sys.getCwd() + Path, Loop);
		else
			return play(Path, Loop);
	}

	private function update(?E:Event):Void
	{
		#if FLX_KEYBOARD
		if (canSkip && FlxG.keys.anyJustPressed(skipKeys) && isPlaying)
			onVLCEndReached();
		#end

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
			if (canSkip && touch.justPressed && isPlaying)
				onVLCEndReached();
		#end

		if (canUseAutoResize && (videoWidth > 0 && videoHeight > 0))
		{
			width = calcSize(0);
			height = calcSize(1);
		}

		volume = Std.int(#if FLX_SOUND_SYSTEM ((FlxG.sound.muted || !canUseSound) ? 0 : 1) * #else (!canUseSound ? 0 : 1) * #end FlxG.sound.volume * 100);
	}

	public function calcSize(What:Int):Int
	{
		final appliedWidth:Float = Lib.current.stage.stageHeight * (FlxG.width / FlxG.height);
		final appliedHeight:Float = Lib.current.stage.stageWidth * (FlxG.height / FlxG.width);

		if (What == 0)
			return Std.int(appliedWidth > Lib.current.stage.stageWidth ? Lib.current.stage.stageWidth : appliedWidth);
		else if (What == 1)
			return Std.int(appliedHeight > Lib.current.stage.stageHeight ? Lib.current.stage.stageHeight : appliedHeight);

		return 0;
	}
}
