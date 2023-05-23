package hxcodec.flixel;

import flixel.FlxG;
#if FLX_KEYBOARD
import flixel.input.keyboard.FlxKey;
#end
import hxcodec.flixel.FlxVideoSprite;

/**
 * This class is a addon to the `FlxVideoSprite` class.
 * Mostly adds the ability to skip the video, let `flixel` manage the volume and autoResize it.
 */
class FlxCutsceneSprite extends FlxVideoSprite
{
	// Variables
	public var skippable:Bool = true;
	#if FLX_KEYBOARD
	public var skipKeys:Array<FlxKey> = [SPACE, ENTER, ESCAPE];
	#end
	public var autoResize:Bool = true;
	public var maintainAspectRatio:Bool = true;
	public var scaleBy:ScaleType = GAME;

	// Declarations
	private var pauseMusic:Bool = false;
	private var skipTimer:Float = 0;

	public function new(X:Float = 0, Y:Float = 0):Void
	{
		super(X, Y);

		onOpening.add(function()
		{
			#if FLX_SOUND_SYSTEM
			volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
			#end
		});
		onEndReached.add(dispose);
	}

	// Overrides
	#if FLX_SOUND_SYSTEM
	override public function play(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Void
	#else
	override public function play(Path:String, Loop:Bool = false):Void
	#end
	{
		#if FLX_SOUND_SYSTEM
		pauseMusic = PauseMusic;

		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.pause();
		#end

		super.play(Path, Loop);
	}

	override public function dispose():Void
	{
		#if FLX_SOUND_SYSTEM
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();
		#end

		super.dispose();
	}

	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		#if FLX_KEYBOARD
		if (skippable && FlxG.keys.anyJustPressed(skipKeys) && isPlaying)
		{
			skipTimer += elapsed;
			if (skipTimer > 1.0)
				onEndReached.dispatch();
		}
		else
			skipTimer = 0;
		#end

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (skippable && touch.justPressed && isPlaying)
			{
				skipTimer += elapsed;
				if (skipTimer > 1.0)
					onEndReached.dispatch();
			}
			else
				skipTimer = 0;
		}
		#end

		if (autoResize)
		{
			if (!maintainAspectRatio && bitmap.bitmapData != null && frames != null)
			{
				width = FlxG.stage.stageWidth;
				height = FlxG.stage.stageHeight;
			}
			else if (bitmap.bitmapData != null && frames != null)
			{
				var aspectRatio:Float = scaleBy == GAME ? (FlxG.width / FlxG.height) : (videoWidth / videoHeight);

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
		volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
		#end
	}
}

enum ScaleType
{
	GAME;
	VIDEO;
}
