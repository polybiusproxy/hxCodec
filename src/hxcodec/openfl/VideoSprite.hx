package hxcodec.openfl;

import openfl.Lib;
import openfl.display.Sprite;
import hxcodec.openfl.VideoBitmap;
import lime.app.Event;
import sys.FileSystem;

/**
 * This class allows you to play videos using sprites (Sprite).
 */
class VideoSprite extends Sprite
{
	// Variables
	public var autoResize:Bool = false;
	public var maintainAspectRatio:Bool = true;
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

	public function new():Void
	{
		super();

		bitmap = new VideoBitmap();
		addChild(bitmap);
	}

	// Methods
	public function play(?Path:String, Loop:Bool = false):Int
	{
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
		bitmap.dispose();

		removeChild(bitmap);
	}

	// Get & Set Methods
	@:noCompletion private function get_time():Int
	{
		return bitmap.time;
	}

	@:noCompletion private function set_time(value:Int):Int
	{
		return bitmap.time = value;
	}

	@:noCompletion private function get_position():Single
	{
		return bitmap.position;
	}

	@:noCompletion private function set_position(value:Single):Single
	{
		return bitmap.position = value;
	}

	@:noCompletion private function get_length():Int
	{
		return bitmap.length;
	}

	@:noCompletion private function get_duration():Int
	{
		return bitmap.duration;
	}

	@:noCompletion private function get_mrl():String
	{
		return bitmap.mrl;
	}

	@:noCompletion private function get_volume():Int
	{
		return bitmap.volume;
	}

	@:noCompletion private function set_volume(value:Int):Int
	{
		return bitmap.volume = value;
	}

	@:noCompletion private function get_channel():Int
	{
	    return bitmap.channel;
	}

	@:noCompletion private function set_channel(value:Int):Int
	{
		return bitmap.channel = value;
	}

	@:noCompletion private function get_delay():Int
	{
	    return bitmap.delay;
	}

	@:noCompletion private function set_delay(value:Int):Int
	{
		return bitmap.delay = value;
	}

	@:noCompletion private function get_rate():Single
	{
	    return bitmap.rate;
	}

	@:noCompletion private function set_rate(value:Single):Single
	{
		return bitmap.rate = value;
	}

	@:noCompletion private function get_role():Int
	{
	    return bitmap.role;
	}

	@:noCompletion private function set_role(value:Int):Int
	{
		return bitmap.role = value;
	}

	@:noCompletion private function get_isPlaying():Bool
	{
	    return bitmap.isPlaying;
	}

	@:noCompletion private function get_isSeekable():Bool
	{
	    return bitmap.isSeekable;
	}

	@:noCompletion private function get_canPause():Bool
	{
	    return bitmap.canPause;
	}

	@:noCompletion private function get_mute():Bool
	{
	    return bitmap.mute;
	}

	@:noCompletion private function set_mute(value:Bool):Bool
	{
		return bitmap.mute = value;
	}

	@:noCompletion private function get_onOpening():Event<Void->Void>
	{
		return bitmap.onOpening;
	}

	@:noCompletion private function get_onPlaying():Event<Void->Void>
	{
		return bitmap.onPlaying;
	}

	@:noCompletion private function get_onStopped():Event<Void->Void>
	{
		return bitmap.onStopped;
	}

	@:noCompletion private function get_onPaused():Event<Void->Void>
	{
		return bitmap.onPaused;
	}

	@:noCompletion private function get_onEndReached():Event<Void->Void>
	{
		return bitmap.onEndReached;
	}

	@:noCompletion private function get_onEncounteredError():Event<Void->Void>
	{
		return bitmap.onEncounteredError;
	}

	@:noCompletion private function get_onForward():Event<Void->Void>
	{
		return bitmap.onForward;
	}

	@:noCompletion private function get_onBackward():Event<Void->Void>
	{
		return bitmap.onBackward;
	}

	@:noCompletion private function get_onLogMessage():Event<String->Void>
	{
		return bitmap.onLogMessage;
	}

	@:noCompletion private function get_onTextureSetup():Event<Void->Void>
	{
		return bitmap.onTextureSetup;
	}

	// Overrides
	@:noCompletion private override function __enterFrame(deltaTime:Int):Void
	{
		for (child in __children)
			child.__enterFrame(deltaTime);

		if (autoResize && contains(bitmap))
		{
			if (!maintainAspectRatio && bitmap.bitmapData != null)
			{
				bitmap.width = Lib.current.stage.stageWidth;
				bitmap.height = Lib.current.stage.stageHeight;
			}
			else if (bitmap.bitmapData != null)
			{
				var aspectRatio:Float = bitmap.videoWidth / bitmap.videoHeight;

				if (Lib.current.stage.stageWidth / Lib.current.stage.stageHeight > aspectRatio)
				{
					// stage is wider than video
					bitmap.width = Lib.current.stage.stageHeight * aspectRatio;
					bitmap.height = Lib.current.stage.stageHeight;
				}
				else
				{
					// stage is taller than video
					bitmap.width = Lib.current.stage.stageWidth;
					bitmap.height = Lib.current.stage.stageWidth * (1 / aspectRatio);
				}
			}
		}
	}
}
