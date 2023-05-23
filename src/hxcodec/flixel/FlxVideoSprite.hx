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
	public var time(get, set):Int;
	public var position(get, set):Single;
	public var length(get, never):Int;
	public var duration(get, never):Int;
	public var mrl(get, never):String;
	public var volume(get, set):Int;
	public var channel(get, set):Int;
	public var delay(get, set):Int;
	public var rate(get, set):Single;
	public var role(get, set):Int;
	public var isPlaying(get, never):Bool;
	public var isSeekable(get, never):Bool;
	public var canPause(get, never):Bool;
	public var mute(get, set):Bool;

	// Callbacks
	public var onOpening(get, null):Event<Void->Void>;
	public var onPlaying(get, null):Event<Void->Void>;
	public var onStopped(get, null):Event<Void->Void>;
	public var onPaused(get, null):Event<Void->Void>;
	public var onEndReached(get, null):Event<Void->Void>;
	public var onEncounteredError(get, null):Event<Void->Void>;
	public var onForward(get, null):Event<Void->Void>;
	public var onBackward(get, null):Event<Void->Void>;
	public var onLogMessage(get, null):Event<String->Void>;
	public var onTextureSetup(get, null):Event<Void->Void>;

	// Declarations
	private var bitmap:VideoBitmap;

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
		bitmap.stop();
	}

	public function pause():Void
	{
		bitmap.pause();
	}

	public function resume():Void
	{
		bitmap.resume();
	}

	public function togglePaused():Void
	{
		bitmap.togglePaused();
	}

	public function dispose():Void
	{
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

	// Get & Set Methods
	private function get_time():Int
	{
		return bitmap.time;
	}

	private function set_time(value:Int):Int
	{
		return bitmap.time = value;
	}

	private function get_position():Single
	{
		return bitmap.position;
	}

	private function set_position(value:Single):Single
	{
		return bitmap.position = value;
	}

	private function get_length():Int
	{
		return bitmap.length;
	}

	private function get_duration():Int
	{
		return bitmap.duration;
	}

	private function get_mrl():String
	{
		return bitmap.mrl;
	}

	private function get_volume():Int
	{
		return bitmap.volume;
	}

	private function set_volume(value:Int):Int
	{
		return bitmap.volume = value;
	}

	private function get_channel():Int
	{
	    return bitmap.channel;
	}

	private function set_channel(value:Int):Int
	{
		return bitmap.channel = value;
	}

	private function get_delay():Int
	{
	    return bitmap.delay;
	}

	private function set_delay(value:Int):Int
	{
		return bitmap.delay = value;
	}

	private function get_rate():Single
	{
	    return bitmap.rate;
	}

	private function set_rate(value:Single):Single
	{
		return bitmap.rate = value;
	}

	private function get_role():Int
	{
	    return bitmap.role;
	}

	private function set_role(value:Int):Int
	{
		return bitmap.role = value;
	}

	private function get_isPlaying():Bool
	{
	    return bitmap.isPlaying;
	}

	private function get_isSeekable():Bool
	{
	    return bitmap.isSeekable;
	}

	private function get_canPause():Bool
	{
	    return bitmap.canPause;
	}

	private function get_mute():Bool
	{
	    return bitmap.mute;
	}

	private function set_mute(value:Bool):Bool
	{
		return bitmap.mute = value;
	}

	private function get_onOpening():Event<Void->Void>
	{
		return bitmap.onOpening;
	}

	private function get_onPlaying():Event<Void->Void>
	{
		return bitmap.onPlaying;
	}

	private function get_onStopped():Event<Void->Void>
	{
		return bitmap.onStopped;
	}

	private function get_onPaused():Event<Void->Void>
	{
		return bitmap.onPaused;
	}

	private function get_onEndReached():Event<Void->Void>
	{
		return bitmap.onEndReached;
	}

	private function get_onEncounteredError():Event<Void->Void>
	{
		return bitmap.onEncounteredError;
	}

	private function get_onForward():Event<Void->Void>
	{
		return bitmap.onForward;
	}

	private function get_onBackward():Event<Void->Void>
	{
		return bitmap.onBackward;
	}

	private function get_onLogMessage():Event<String->Void>
	{
		return bitmap.onLogMessage;
	}

	private function get_onTextureSetup():Event<Void->Void>
	{
		return bitmap.onTextureSetup;
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
