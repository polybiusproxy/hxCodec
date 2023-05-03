package hxcodec.flixel;

import flixel.FlxG;
#if FLX_KEYBOARD
import flixel.input.keyboard.FlxKey;
#end
import hxcodec.openfl.VideoBitmap;
import openfl.Lib;
import openfl.events.Event;
import sys.FileSystem;

enum ScaleType
{
	GAME;
	VIDEO;
}

class VideoHandler extends VideoBitmap
{
	#if FLX_KEYBOARD
	public var skipKeys:Array<FlxKey> = [ENTER, SPACE];
	#end

	#if (FLX_KEYBOARD || FLX_TOUCH)
	public var canSkip:Bool = true;
	#end

	#if FLX_SOUND_SYSTEM
	public var canUseSound:Bool = true;
	#end

	public var canUseAutoResize:Bool = false;
	public var maintainAspectRatio:Bool = true;
	public var useScaleBy:ScaleType = GAME;

	public var openingCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	#if FLX_SOUND_SYSTEM
	private var __pauseMusic:Bool = false;
	#end

	public function new(IndexModifier:Int = 0):Void
	{
		super();

		onOpening = onVLCOpening;
		onEndReached = onVLCEndReached;
		onEncounteredError = onVLCEncounteredError;

		FlxG.addChildBelowMouse(this, IndexModifier);
	}

	private function onVLCOpening():Void
	{
		#if HXC_DEBUG_TRACE
		trace("the video is opening!");
		#end

		#if FLX_SOUND_SYSTEM
		// The Media Player isn't `null at this point...
		volume = Std.int(((FlxG.sound.muted || !canUseSound) ? 0 : 1) * (FlxG.sound.volume * 100));
		#end

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

		#if FLX_SOUND_SYSTEM
		if (FlxG.sound.music != null && __pauseMusic)
			FlxG.sound.music.resume();
		#end

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
	 * @param PauseMusic Pause music until the video ends if `FLX_SOUND_SYSTEM` is defined.
	 *
	 * @return 0 if playback started (and was already started), or -1 on error.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Int
	{
		#if FLX_SOUND_SYSTEM
		__pauseMusic = PauseMusic;

		if (FlxG.sound.music != null && PauseMusic)
			FlxG.sound.music.pause();
		#end

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

		if (canUseAutoResize)
		{
			if (!maintainAspectRatio && (videoWidth > 0 && videoHeight > 0))
			{
				width = FlxG.stage.stageWidth;
				height = FlxG.stage.stageHeight;
			}
			else if (videoWidth > 0 && videoHeight > 0)
			{
				var aspectRatio:Float = useScaleBy == GAME ? (FlxG.width / FlxG.height) : (videoWidth / videoHeight);

				if (FlxG.stage.stageWidth / FlxG.stage.stageHeight > aspectRatio)
				{
					// stage is wider than video
					width = FlxG.stage.stageHeight * aspectRatio;
					height = FlxG.stage.stageHeight;
				}
				else
				{
					// stage is taller than video
					width = FlxG.stage.stageWidth;
					height = FlxG.stage.stageWidth * (1 / aspectRatio);
				}
			}
		}

		#if FLX_SOUND_SYSTEM
		volume = Std.int(((FlxG.sound.muted || !canUseSound) ? 0 : 1) * (FlxG.sound.volume * 100));
		#end
	}
}
