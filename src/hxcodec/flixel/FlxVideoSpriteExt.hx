package hxcodec.flixel;

import flixel.FlxG;
#if FLX_KEYBOARD
import flixel.input.keyboard.FlxKey;
#end
import hxcodec.flixel.FlxVideoSprite;

/**
 * This class is a addon to the `FlxVideoSprite` class.
 * Mostly adds the ability to skip the video and makes `flixel` to manage the volume.
 */
class FlxVideoSpriteExt extends FlxVideoSprite
{
	// Variables
	public var pauseMusic:Bool = false;
	public var skippable:Bool = true;
	public var skipKeys:Array<FlxKey> = [SPACE, ENTER, ESCAPE];

	// Declarations
	private var skipTimer:Float = 0;

	public function new(x:Float = 0, y:Float = 0):Void
	{
		super(x, y);

		bitmap.onOpening.add(function()
		{
			#if FLX_SOUND_SYSTEM
			bitmap.volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
			#end
		});
	}

	// Overrides
	override public function play(?path:String, loop:Bool = false):Int
	{
		#if FLX_SOUND_SYSTEM
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.pause();
		#end

		return super.play(path, loop);
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
			if (skipTimer > 10.0)
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
				if (skipTimer > 10.0)
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
