package hxcodec.flixel;

import hxcodec.base.IVideoPlayer;
import flixel.FlxState;
import hxcodec.flixel.FlxVideoSprite;
import hxcodec.base.Callback;
import hxcodec.base.Callback.CallbackVoid;

/**
 * An FlxState which displays a video.
 * Includes playback controls functions.
 */
class FlxVideoState extends FlxState implements IVideoPlayer
{
	/**
	 * The current position of the video, in milliseconds.
	 * Set this value to seek to a specific position in the video.
	 */
	public var time(get, set):Int;

	function get_time():Int
	{
		return video.time;
	}

	function set_time(value:Int):Int
	{
		return video.time = value;
	}

	/**
	 * The current position of the video, as a percentage between 0.0 and 1.0.
	 * Set this value to seek to a specific position in the video.
	 */
	public var position(get, set):Float;

	function get_position():Float
	{
		return video.position;
	}

	function set_position(value:Float):Float
	{
		return video.position = value;
	}

	/**
	 * The duration of the video, in seconds.
	 */
	public var duration(get, null):Float;

	function get_duration():Float
	{
		return video.duration;
	}

	/**
	 * Whether or not the video is playing.
	 */
	public var isPlaying(get, null):Bool;

	function get_isPlaying():Bool
	{
		return video.isPlaying;
	}

	/**
	 * Whether or not the audio is currently muted.
	 */
	public var muteAudio(get, set):Bool;

	function get_muteAudio():Bool
	{
		return video.muteAudio;
	}

	function set_muteAudio(value:Bool):Bool
	{
		return video.muteAudio = value;
	}

	/**
	 * Current playback speed.
	 */
	public var rate(get, set):Float;

	function get_rate():Float
	{
		return video.rate;
	}

	function set_rate(value:Float):Float
	{
		return video.rate = value;
	}

	/**
	 * Current volume.
	 */
	public var volume(get, set):Int;

	function get_volume():Int
	{
		return video.volume;
	}

	function set_volume(value:Int):Int
	{
		return video.volume = value;
	}

	/**
	 * Callback for when the media player is opening.
	 * - This callback has no parameters.
	 */
	public var onOpening(get, null):CallbackVoid;

	function get_onOpening():CallbackVoid
	{
		return video.onOpening;
	}

	/**
	 * Callback for when the media player begins playing.
	 * @param path The path of the current media.
	 */
	public var onPlaying(get, null):Callback<String>;

	function get_onPlaying():Callback<String>
	{
		return video.onPlaying;
	}

	/**
	 * Callback for when the media player is paused.
	 * - This callback has no parameters.
	 */
	public var onPaused(get, null):CallbackVoid;

	function get_onPaused():CallbackVoid
	{
		return video.onPaused;
	}

	/**
	 * Callback for when the media player is stopped.
	 * - This callback has no parameters.
	 */
	public var onStopped(get, null):CallbackVoid;

	function get_onStopped():CallbackVoid
	{
		return video.onStopped;
	}

	/**
	 * Callback for when the media player is buffering.
	 * - This callback has no parameters.
	 */
	public var onEndReached(get, null):CallbackVoid;

	function get_onEndReached():CallbackVoid
	{
		return video.onEndReached;
	}

	/**
	 * Callback for when the media player encounters an error.
	 * @param error The error message.
	 */
	public var onEncounteredError(get, null):Callback<String>;

	function get_onEncounteredError():Callback<String>
	{
		return video.onEncounteredError;
	}

	/**
	 * Callback for when the media player is skipped forward.
	 */
	public var onForward(get, null):CallbackVoid;

	function get_onForward():CallbackVoid
	{
		return video.onForward;
	}

	/**
	 * Callback for when the media player is skipped backward.
	 */
	public var onBackward(get, null):CallbackVoid;

	function get_onBackward():CallbackVoid
	{
		return video.onBackward;
	}

	var video:FlxVideoSprite;

	var nextVideo:String;
	var nextVideoLoop:Bool;

	/**
	 * @param path Provide a path to a video file to play it immediately.
	 */
	public function new(?path:String = null, ?loop:Bool = false)
	{
		super();

		// Create the video sprite in the constructor so that
		// callbacks can be assigned before the state is entered.
		video = new FlxVideoSprite(0, 0);

		this.nextVideo = path;
		this.nextVideoLoop = loop;
	}

	public override function create():Void
	{
		super.create();

		// video.autoResize = true;
		add(video);

		// Play the next video if there is one.
		if (nextVideo != null)
		{
			playVideo(nextVideo, nextVideoLoop);
		}

		nextVideo = null;
		nextVideoLoop = false;
	}

	/**
	 * Play a video from a local file path.
	 * @param path The path to the video file.
	 * @param loop Whether or not the video should loop.
	 */
	public function playVideo(path:String, loop:Bool = false):Int
	{
		return video.playVideo(path, loop);
	}

	/**
	 * Stop the video.
	 * This will reset the video to the beginning and stop playback.
	 */
	public function stop():Void
	{
		video.stop();
	}

	/**
	 * Pause the video.
	 */
	public function pause():Void
	{
		video.pause();
	}

	/**
	 * Resume the video, if it is paused.
	 */
	public function resume():Void
	{
		video.resume();
	}

	/**
	 * If the video is playing, it will be paused.
	 * If the video is paused, it will be resumed.
	 */
	public function togglePaused():Void
	{
		video.togglePaused();
	}
}
