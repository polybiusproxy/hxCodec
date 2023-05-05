package hxcodec.base;

import hxcodec.base.Callback.CallbackVoid;

/**
 * Lists all the functions that a video playback component must implement.
 * This ensures that all video playback components have the same functions available.
 */
interface IVideoPlayer
{
	/**
	 * The current position of the video, in milliseconds.
	 * Set this value to seek to a specific position in the video.
	 */
	public var time(get, set):Int;

	/**
	 * The current position of the video, as a percentage between 0.0 and 1.0.
	 * Set this value to seek to a specific position in the video.
	 */
	public var position(get, set):Float;

	/**
	 * The duration of the video, in seconds.
	 */
	public var duration(get, null):Float;

	/**
	 * Whether or not the video is playing.
	 */
	public var isPlaying(get, null):Bool;

	/**
	 * Whether or not the audio is currently muted.
	 */
	public var muteAudio(get, set):Bool;

	/**
	 * Current playback speed.
	 */
	public var playbackRate(get, set):Float;

	/**
	 * Current volume.
	 */
	public var volume(get, set):Int;

	// Callbacks

	/**
	 * Callback for when the media player is opening.
	 * - This callback has no parameters.
	 */
	public var onOpening(get, null):CallbackVoid;

	/**
	 * Callback for when the media player begins playing.
	 * @param path The path of the current media.
	 */
	public var onPlaying(get, null):Callback<String>;

	/**
	 * Callback for when the media player is paused.
	 * - This callback has no parameters.
	 */
	public var onPaused(get, null):CallbackVoid;

	/**
	 * Callback for when the media player is stopped.
	 * - This callback has no parameters.
	 */
	public var onStopped(get, null):CallbackVoid;

	/**
	 * Callback for when the media player is buffering.
	 * - This callback has no parameters.
	 */
	public var onEndReached(get, null):CallbackVoid;

	/**
	 * Callback for when the media player encounters an error.
	 * @param error The error message.
	 */
	public var onEncounteredError(get, null):Callback<String>;

	/**
	 * Callback for when the media player is skipped forward.
	 */
	public var onForward(get, null):CallbackVoid;

	/**
	 * Callback for when the media player is skipped backward.
	 */
	public var onBackward(get, null):CallbackVoid;

	/**
	 * Prepare and play a video from a local file path.
	 * 
	 * @param path The path to the video file.
	 * @param loop Whether or not the video should loop.
	 */
	public function playVideo(Path:String, Loop:Bool = false):Int;

	/**
	 * Prepare a video for playback.
	 * This is used to preload a video before it is played.
	 * 
	 * @param path 
	 */
	// public function prepareVideo(path:String):Void;
	/**
	 * Prepare and play a video from a URL.
	 * 
	 * @param url The URL to the video file.
	 * @param loop Whether or not the video should loop.
	 */
	// public function playVideoFromUrl(url:String, loop:Bool = false):Void;
	/**
	 * Prepare a video from a URL for playback.
	 * This is used to preload a video before it is played.
	 * 
	 * @param url The URL to the video file.
	 */
	// public function prepareVideoFromUrl(url:String):Void;
	/**
	 * Play the video.
	 * Only works if the video is already prepared.
	 */
	// public function play():Void;

	/**
	 * Stop the video.
	 * This will reset the video to the beginning and stop playback.
	 */
	public function stop():Void;

	/**
	 * Pause the video.
	 */
	public function pause():Void;

	/**
	 * Resume the video, if it is paused.
	 */
	public function resume():Void;

	/**
	 * If the video is playing, it will be paused.
	 * If the video is paused, it will be resumed.
	 */
	public function togglePaused():Void;
}
