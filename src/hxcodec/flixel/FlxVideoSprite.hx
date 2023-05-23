package hxcodec.flixel;

import flixel.FlxG;
import flixel.FlxSprite;
import hxcodec.openfl.VideoBitmap;
import lime.app.Event;
import sys.FileSystem;

/**
 * This class allows you to play videos using sprites (FlxSprite).
 */
class FlxVideoSprite extends FlxSprite
{
	// Variables
	public var bitmap(default, null):VideoBitmap;

	public function new(X:Float = 0, Y:Float = 0):Void
	{
		super(X, Y);

		bitmap = new VideoBitmap();
		bitmap.visible = false;
		bitmap.onTextureSetup.add(() -> loadGraphic(bitmap.bitmapData));
		FlxG.game.addChild(bitmap);
	}

	// Methods
	public function play(?Path:String, Loop:Bool = false):Int
	{
		if (bitmap == null)
			return;

		if (FlxG.autoPause)
		{
			if (!FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.add(resume);

			if (!FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.add(pause);
		}

		// in case if you want to use another dir then the application one.
		// android can already do this, it can't use application's storage.
		if (FileSystem.exists(Sys.getCwd() + Path))
			return bitmap.play(Sys.getCwd() + Path, Loop);
		else
			return bitmap.play(Path, Loop);
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

	public function dispose():Void
	{
		if (bitmap == null)
			return;

		if (FlxG.autoPause)
		{
			if (FlxG.signals.focusGained.has(resume))
				FlxG.signals.focusGained.remove(resume);

			if (FlxG.signals.focusLost.has(pause))
				FlxG.signals.focusLost.remove(pause);
		}

		bitmap.dispose();

		if (FlxG.game.contains(bitmap))
			FlxG.game.removeChild(bitmap);
	}

	// Overrides
	override public function destroy():Void
	{
		if (onEndReached != null) // is this really needed?
			onEndReached.dispatch();

		dispose();

		super.destroy();
	}
}
