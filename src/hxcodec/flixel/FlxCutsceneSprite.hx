package hxcodec.flixel;

import flixel.FlxG;
#if FLX_KEYBOARD
import flixel.input.keyboard.FlxKey;
#end
import hxcodec.flixel.FlxVideoSprite;

/**
 * This class is a addon to the `FlxVideoSprite` class.
 * Mostly adds the ability to skip the video, makes `flixel` to manage the volume and to autoResize it.
 */
class FlxCutsceneSprite extends FlxVideoSprite
{
	// Variables
	public var skippable:Bool = true;
	#if FLX_KEYBOARD
	public var skipKeys:Array<FlxKey> = [SPACE, ENTER, ESCAPE];
	#end

	// Declarations
	private var pauseMusic:Bool = false;
	private var skipTimer:Float = 0;

	public function new(X:Float = 0, Y:Float = 0):Void
	{
		super(X, Y);

		bitmap.onOpening.add(function()
		{
			#if FLX_SOUND_SYSTEM
			bitmap.volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
			#end
		});
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
		if (skippable && FlxG.keys.anyPressed(skipKeys) && bitmap.isPlaying)
		{
			skipTimer += elapsed;
			if (skipTimer > 1.0)
				bitmap.onEndReached.dispatch();
		}
		else
			skipTimer = 0;
		#end

		#if FLX_TOUCH
		for (touch in FlxG.touches.list)
		{
			if (skippable && touch.pressed && bitmap.isPlaying)
			{
				skipTimer += elapsed;
				if (skipTimer > 1.0)
				    bitmap.onEndReached.dispatch();
			}
			else
				skipTimer = 0;
		}
		#end

		#if FLX_SOUND_SYSTEM
		bitmap.volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
		#end
	}
}
