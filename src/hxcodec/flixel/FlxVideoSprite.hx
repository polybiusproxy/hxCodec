package hxcodec.flixel;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import hxcodec.flixel.FlxVideoHandler;
import lime.app.Event;

class FlxVideoSprite extends FlxSprite
{
	/**
	 * The current position of the video, in milliseconds.
	 * Set this value to seek to a specific position in the video.
	 */
	public var time(get, set):Int;

	function get_time():Int
	{
		return videoBitmap.time;
	}

	function set_time(value:Int):Int
	{
		return videoBitmap.time = value;
	}

	/**
	 * The current position of the video, as a percentage between 0.0 and 1.0.
	 * Set this value to seek to a specific position in the video.
	 */
	public var position(get, set):Single;

	function get_position():Single
	{
		return videoBitmap.position;
	}

	function set_position(value:Single):Single
	{
		return videoBitmap.position = value;
	}

	/**
	 * The duration of the video, in seconds.
	 */
	public var duration(get, null):Int;

	function get_duration():Int
	{
		return videoBitmap.duration;
	}

	/**
	 * Whether or not the video is playing.
	 */
	public var isPlaying(get, null):Bool;

	function get_isPlaying():Bool
	{
		return videoBitmap.isPlaying;
	}

	/**
	 * Whether or not the audio is currently muted.
	 */
	public var mute(get, set):Bool;

	function get_mute():Bool
	{
		return videoBitmap.mute;
	}

	function set_mute(value:Bool):Bool
	{
		return videoBitmap.mute = value;
	}

	/**
	 * Current playback speed.
	 */
	public var rate(get, set):Single;

	function get_rate():Single
	{
		return videoBitmap.rate;
	}

	function set_rate(value:Single):Single
	{
		return videoBitmap.rate = value;
	}

	/**
	 * Current volume.
	 */
	public var volume(get, set):Int;

	function get_volume():Int
	{
		return videoBitmap.volume;
	}

	function set_volume(value:Int):Int
	{
		return videoBitmap.volume = value;
	}

	#if FLX_KEYBOARD
	public var canSkip(get, set):Bool;

	function get_canSkip():Bool
	{
		return videoBitmap.canSkip;
	}

	function set_canSkip(value:Bool):Bool
	{
		return videoBitmap.canSkip = value;
	}
	#end

	/**
	 * Set this value to enforce a specific canvas width for the video.
	 */
	public var canvasWidth(default, set):Null<Int> = null;

	function set_canvasWidth(value:Int):Int
	{
		this.canvasWidth = value;
		if (canvasWidth != null && canvasHeight != null)
		{
			setGraphicSize(canvasWidth, canvasHeight);
			updateHitbox();
		}
		return this.canvasWidth;
	}

	/**
	 * Set this value to enforce a specific canvas height for the video.
	 */
	public var canvasHeight(default, set):Null<Int> = null;

	function set_canvasHeight(value:Int):Int
	{
		this.canvasHeight = value;
		if (canvasWidth != null && canvasHeight != null)
		{
			setGraphicSize(canvasWidth, canvasHeight);
			updateHitbox();
		}
		return this.canvasHeight;
	}

	var videoBitmap:FlxVideoHandler;

	@:deprecated("Use videoHandler.onOpening.add() instead.")
	public var openingCallback(get, set):Void->Void;

	function get_openingCallback():Void->Void
	{
		return () -> this.onOpening.dispatch();
	}

	function set_openingCallback(input:Void->Void):Void->Void
	{
		this.onOpening.add(input);
		return input;
	}

	@:deprecated("Use videoHandler.onEndReached.add() instead.")
	public var finishCallback(get, set):Void->Void;

	function get_finishCallback():Void->Void
	{
		return () -> this.onEndReached.dispatch();
	}

	function set_finishCallback(input:Void->Void):Void->Void
	{
		this.onEndReached.add(input);
		return input;
	}

	/**
	 * Callback for when the media player is opening.
	 */
	public var onOpening(get, null):Event<Void->Void>;

	function get_onOpening():Event<Void->Void>
	{
		return videoBitmap.onOpening;
	}

	/**
	 * Callback for when the media player begins playing.
	 * @param path The path of the current media.
	 */
	public var onPlaying(get, null):Event<Void->Void>;

	function get_onPlaying():Event<Void->Void>
	{
		return videoBitmap.onPlaying;
	}

	/**
	 * Callback for when the media player is paused.
	 */
	public var onPaused(get, null):Event<Void->Void>;

	function get_onPaused():Event<Void->Void>
	{
		return videoBitmap.onPaused;
	}

	/**
	 * Callback for when the media player is stopped.
	 */
	public var onStopped(get, null):Event<Void->Void>;

	function get_onStopped():Event<Void->Void>
	{
		return videoBitmap.onStopped;
	}

	/**
	 * Callback for when the media player reaches the end.
	 */
	public var onEndReached(get, null):Event<Void->Void>;

	function get_onEndReached():Event<Void->Void>
	{
		return videoBitmap.onEndReached;
	}

	/**
	 * Callback for when the media player encounters an error.
	 */
	public var onEncounteredError(get, null):Event<Void->Void>;

	function get_onEncounteredError():Event<Void->Void>
	{
		return videoBitmap.onEncounteredError;
	}

	/**
	 * Callback for when the media player is skipped forward.
	 */
	public var onForward(get, null):Event<Void->Void>;

	function get_onForward():Event<Void->Void>
	{
		return videoBitmap.onForward;
	}

	/**
	 * Callback for when the media player is skipped backward.
	 */
	public var onBackward(get, null):Event<Void->Void>;

	function get_onBackward():Event<Void->Void>
	{
		return videoBitmap.onBackward;
	}

	public var graphicLoadedCallback:Event<Void->Void> = null;

	public function new(X:Float = 0, Y:Float = 0):Void
	{
		super(X, Y);

		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		videoBitmap = new FlxVideoHandler();
		videoBitmap.canUseAutoResize = false;
		videoBitmap.visible = false;

		videoBitmap.onEndReached.add(function()
		{
			oneTime = false;

			kill();
		});
	}

	private var oneTime:Bool = false;

	override function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if ((videoBitmap != null && (videoBitmap.isPlaying && videoBitmap.bitmapData != null)) && !oneTime)
		{
			var graphic:FlxGraphic = FlxG.bitmap.add(videoBitmap.bitmapData, false, videoBitmap.mrl); // mrl usually starts with file:/// but is fine ig
			if (graphic.imageFrame.frame == null)
			{
				#if HXC_DEBUG_TRACE
				trace('the frame of the image is null?');
				#end
				return;
			}

			loadGraphic(graphic);

			if (canvasWidth != null && canvasHeight != null)
			{
				setGraphicSize(canvasWidth, canvasHeight);
				updateHitbox();
			}

			if (graphicLoadedCallback != null)
				graphicLoadedCallback.dispatch();

			oneTime = true;
		}
	}

	/**
	 * Stop the video.
	 * This will reset the video to the beginning and stop playback.
	 */
	public function stop():Void
	{
		videoBitmap.stop();
	}

	/**
	 * Pause the video.
	 */
	public function pause():Void
	{
		videoBitmap.pause();
	}

	/**
	 * Resume the video, if it is paused.
	 */
	public function resume():Void
	{
		videoBitmap.resume();
	}

	/**
	 * If the video is playing, it will be paused.
	 * If the video is paused, it will be resumed.
	 */
	public function togglePaused():Void
	{
		videoBitmap.togglePaused();
	}

	override function destroy():Void
	{
		if (videoBitmap != null && videoBitmap.onEndReached != null)
			videoBitmap.onEndReached.dispatch();

		super.destroy();
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 *
	 * @return 0 if playback started (and was already started), or -1 on error.
	 */
	public function playVideo(Path:String, Loop:Bool = false):Int
	{
		return videoBitmap.playVideo(Path, Loop);
	}
}
