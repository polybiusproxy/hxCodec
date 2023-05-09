package hxcodec.openfl;

import openfl.Lib;
import openfl.display.Sprite;
import openfl.events.Event;
import hxcodec.openfl.VideoBitmap;
import hxcodec.base.Callback;
import hxcodec.base.IVideoPlayer;
import sys.FileSystem;

/**
 * This class allows you to play videos using sprites (Sprite).
 */
class VideoSprite extends Sprite implements IVideoPlayer
{
	public var openingCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

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
	public var position(get, set):Float;

	function get_position():Float
	{
		return videoBitmap.position;
	}

	function set_position(value:Float):Float
	{
		videoBitmap.position = value;
		return value;
	}

	/**
	 * The duration of the video, in seconds.
	 */
	public var duration(get, null):Float;

	function get_duration():Float
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
	public var muteAudio(get, set):Bool;

	function get_muteAudio():Bool
	{
		return videoBitmap.muteAudio;
	}

	function set_muteAudio(value:Bool):Bool
	{
		videoBitmap.muteAudio = value;
		return value;
	}

	/**
	 * Current playback speed.
	 */
	public var playbackRate(get, set):Float;

	function get_playbackRate():Float
	{
		return videoBitmap.playbackRate;
	}

	function set_playbackRate(value:Float):Float
	{
		videoBitmap.playbackRate = value;
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
	public var onOpening(get, null):CallbackVoid;

	function get_onOpening():CallbackVoid
	{
		return videoBitmap.onOpening;
	}

	/**
	 * Callback for when the media player begins playing.
	 * @param path The path of the current media.
	 */
	public var onPlaying(get, null):Callback<String>;

	function get_onPlaying():Callback<String>
	{
		return videoBitmap.onPlaying;
	}

	/**
	 * Callback for when the media player is paused.
	 * - This callback has no parameters.
	 */
	public var onPaused(get, null):CallbackVoid;

	function get_onPaused():CallbackVoid
	{
		return videoBitmap.onPaused;
	}

	/**
	 * Callback for when the media player is stopped.
	 * - This callback has no parameters.
	 */
	public var onStopped(get, null):CallbackVoid;

	function get_onStopped():CallbackVoid
	{
		return videoBitmap.onStopped;
	}

	/**
	 * Callback for when the media player is buffering.
	 * - This callback has no parameters.
	 */
	public var onEndReached(get, null):CallbackVoid;

	function get_onEndReached():CallbackVoid
	{
		return videoBitmap.onEndReached;
	}

	/**
	 * Callback for when the media player encounters an error.
	 * @param error The error message.
	 */
	public var onEncounteredError(get, null):Callback<String>;

	function get_onEncounteredError():Callback<String>
	{
		return videoBitmap.onEncounteredError;
	}

	/**
	 * Callback for when the media player is skipped forward.
	 */
	public var onForward(get, null):CallbackVoid;

	function get_onForward():CallbackVoid
	{
		return videoBitmap.onForward;
	}

	/**
	 * Callback for when the media player is skipped backward.
	 */
	public var onBackward(get, null):CallbackVoid;

	function get_onBackward():CallbackVoid
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
		stage.addEventListener(Event.ENTER_FRAME, update);

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
	private function onVLCOpening():Void
	{
		#if HXC_DEBUG_TRACE
		trace("the video is opening!");
		#end

		if (openingCallback != null)
			openingCallback();
	}

	private function onVLCEncounteredError(msg:String):Void
	{
		Lib.application.window.alert(msg, "VLC Error!");
		onVLCEndReached();
	}

	private function onVLCEndReached():Void
	{
		#if HXC_DEBUG_TRACE
		trace("the video reached the end!");
		#end

		if (stage.hasEventListener(Event.ENTER_FRAME))
			stage.removeEventListener(Event.ENTER_FRAME, update);

		videoBitmap.dispose();

		removeChild(this);

		if (finishCallback != null)
			finishCallback();
	}

	private function update(e:Event):Void
	{
		videoBitmap.update(e);

		if (autoResize)
		{
			if (!maintainAspectRatio && (videoBitmap.videoWidth > 0 && videoBitmap.videoHeight > 0))
			{
				width = Lib.current.stage.stageWidth;
				height = Lib.current.stage.stageHeight;
			}
			else if (videoBitmap.videoWidth > 0 && videoBitmap.videoHeight > 0)
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
