package hxcodec.flixel;

#if flixel
#if (!flixel_addons && macro)
#error 'Your project must use flixel-addons in order to use this class.'
#end
	
import flixel.FlxG;
import flixel.util.FlxAxes;
import flixel.addons.display.FlxBackdrop;

import sys.FileSystem;
import hxcodec.openfl.Video;

/**
 * This class allows you to play videos as `FlxBackdrop`s.
 */
class FlxVideoBackdrop extends FlxBackdrop
{
        // Variables
        public var bitmap(default, null):Video;

	public function new(x:Float = 0, y:Float = 0, repeatAxes:FlxAxes = XY):Void
        {
                super(null, repeatAxes);
                setPosition(x, y);
                visible = false;

	        bitmap = new Video();
	        bitmap.alpha = 0;
	        bitmap.onOpening.add(function()
                {
                      visible = true;
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

			return bitmap.play(location, shouldLoop);
		}

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

        override function kill():Void
        {
                pause();
                super.kill();
        }

        override function revive():Void
        {
                super.revive();
                resume();
        }

	override public function destroy():Void
	{
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
#end
