package hxcodec.openfl;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import hxcodec.openfl.VideoBitmap;
import lime.app.Event;
import sys.FileSystem;

/**
 * This class allows you to play videos using sprites (Sprite).
 */
class VideoSprite extends Sprite
{
	/**
	 * The current position of the video, in milliseconds.
	 */
	public var time(get, set):Int;

	function get_time():Int
	{
		return videoBitmap.time;
	}

	function set_time(value:Int):Int
	{
		videoBitmap.time = value;
		return value;
	}

	/**
	 * The current position of the video, as a percentage between 0.0 and 1.0.
	 */
	public var position(get, set):Single;

	function get_position():Single
	{
		return videoBitmap.position;
	}

	function set_position(value:Single):Single
	{
		videoBitmap.position = value;
		return value;
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
		videoBitmap.mute = value;
		return value;
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
		videoBitmap.rate = value;
		return value;
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
		videoBitmap.volume = value;
		return value;
	}

	/**
	 * Whether to automatically resize the video to fit the stage.
	 * If false, the `width` and `height` of the video must be set manually.
	 */
	public var autoResize:Bool = false;

	/**
	 * Whether to maintain the aspect ratio when automatically resizing the video.
	 * If false, the video will be stretched to fit the stage.
	 */
	public var maintainAspectRatio:Bool = true;

	/**
	 * The bitmap used to display the video internally.
	 */
	var videoBitmap:VideoBitmap;

	/**
	 * Callback for when the media player is opening.
	 * - This callback has no parameters.
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
	 * - This callback has no parameters.
	 */
	public var onPaused(get, null):Event<Void->Void>;

	function get_onPaused():Event<Void->Void>
	{
		return videoBitmap.onPaused;
	}

	/**
	 * Callback for when the media player is stopped.
	 * - This callback has no parameters.
	 */
	public var onStopped(get, null):Event<Void->Void>;

	function get_onStopped():Event<Void->Void>
	{
		return videoBitmap.onStopped;
	}

	/**
	 * Callback for when the media player is buffering.
	 * - This callback has no parameters.
	 */
	public var onEndReached(get, null):Event<Void->Void>;

	function get_onEndReached():Event<Void->Void>
	{
		return videoBitmap.onEndReached;
	}

	/**
	 * Callback for when the media player encounters an error.
	 * @param error The error message.
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

	public function new():Void
	{
		super();

		videoBitmap = new VideoBitmap();
		videoBitmap.onOpening.add(onVLCOpening);
		videoBitmap.onEndReached.add(onVLCEndReached);
		videoBitmap.onEncounteredError.add(onVLCEncounteredError);
		addChild(videoBitmap);
	}

	/**
	 * Plays a video.
	 *
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 *
	 * @return 0 if playback started (and was already started), or -1 on error.
	 */
	public function playVideo(Path:String, Loop:Bool = false):Int
	{
		// in case if you want to use another dir then the application one.
		// android can already do this, it can't use application's storage.
		if (FileSystem.exists(Sys.getCwd() + Path))
			return videoBitmap.play(Sys.getCwd() + Path, Loop);
		else
			return videoBitmap.play(Path, Loop);
	}

	/**
	 * Pause the video.
	 */
	public function pause():Void
	{
		videoBitmap.pause();
	}

	/**
	 * Resume the video.
	 */
	public function resume():Void
	{
		videoBitmap.resume();
	}

	/**
	 * Toggle the video between playing and paused.
	 */
	public function togglePaused():Void
	{
		videoBitmap.togglePaused();
	}

	/**
	 * Stop the video.
	 */
	public function stop():Void
	{
		videoBitmap.stop();
	}

	// Internal Methods
	@:noCompletion private function onVLCOpening():Void
	{
		#if HXC_DEBUG_TRACE
		trace("the video is opening!");
		#end
	}

	@:noCompletion private function onVLCEncounteredError():Void
	{
		Lib.application.window.alert("error cannot be specified.", "VLC Error!");
	}

	@:noCompletion private function onVLCEndReached():Void
	{
		#if HXC_DEBUG_TRACE
		trace("the video reached the end!");
		#end

		videoBitmap.dispose();

		removeChild(videoBitmap);
	}

	@:noCompletion private override function __enterFrame(deltaTime:Int):Void
	{
		for (child in __children)
			child.__enterFrame(deltaTime);

		if (autoResize && contains(videoBitmap))
		{
			if (!maintainAspectRatio && videoBitmap.texture != null)
			{
				width = Lib.current.stage.stageWidth;
				height = Lib.current.stage.stageHeight;
			}
			else if (videoBitmap.texture != null)
			{
				var aspectRatio:Float = videoBitmap.videoWidth / videoBitmap.videoHeight;

				if (Lib.current.stage.stageWidth / Lib.current.stage.stageHeight > aspectRatio)
				{
					// stage is wider than video
					width = Lib.current.stage.stageHeight * aspectRatio;
					height = Lib.current.stage.stageHeight;
				}
				else
				{
					// stage is taller than video
					width = Lib.current.stage.stageWidth;
					height = Lib.current.stage.stageWidth * (1 / aspectRatio);
				}
			}
		}
	}
}
