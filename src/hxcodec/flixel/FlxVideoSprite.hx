package hxcodec.flixel;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import hxcodec.openfl.VideoBitmap;
import sys.FileSystem;

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */
class FlxVideoSprite extends FlxSprite
{
	// Variables
	public var pauseMusic:Bool = false;
	public var bitmap(default, null):VideoBitmap;

	public function new(x:Float = 0, y:Float = 0):Void
	{
		super(x, y);

		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		bitmap = new VideoBitmap();
		bitmap.alpha = 0;
		bitmap.onOpening.add(function()
		{
			#if FLX_SOUND_SYSTEM
			bitmap.volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
			#end
		});
		bitmap.onTextureSetup.add(() -> loadGraphic(bitmap.bitmapData));
		FlxG.game.addChild(bitmap);
	}

	// Methods
	public function play(location:String, shouldLoop:Bool = false):Int
	{
		#if FLX_SOUND_SYSTEM
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.pause();
		#end

		if (FlxG.autoPause)
		{
			if (!FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.add(resume);

			if (!FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.add(pause);
		}

		if (bitmap != null)
		{
			if (FileSystem.exists(Sys.getCwd() + location))
				return bitmap.play(Sys.getCwd() + location, shouldLoop);
			else
				return bitmap.play(location, shouldLoop);
		}
		else
			return -1;
	}

	public function stop():Void
	{
		if (bitmap != null)
			bitmap.stop();
	}

	public function pause():Void
	{
		if (bitmap != null)
			bitmap.pause();
	}

	public function resume():Void
	{
		if (bitmap != null)
			bitmap.resume();
	}

	public function togglePaused():Void
	{
		if (bitmap != null)
			bitmap.togglePaused();
	}

	// Overrides
	override public function update(elapsed:Float):Void
	{
		#if FLX_SOUND_SYSTEM
		bitmap.volume = Std.int((FlxG.sound.muted ? 0 : 1) * (FlxG.sound.volume * 100));
		#end

		super.update(elapsed);
	}

	override public function destroy():Void
	{
		#if FLX_SOUND_SYSTEM
		if (FlxG.sound.music != null && pauseMusic)
			FlxG.sound.music.resume();
		#end

		if (FlxG.autoPause)
		{
			if (FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.remove(resume);

			if (FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.remove(pause);
		}

		if (bitmap != null)
		{
			bitmap.dispose();

			if (FlxG.game.contains(bitmap))
				FlxG.game.removeChild(bitmap);
		}

		super.destroy();
	}
}
