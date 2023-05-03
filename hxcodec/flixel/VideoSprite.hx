package hxcodec.flixel;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import hxcodec.VideoHandler;
import hxcodec.base.Callback;
import hxcodec.base.IVideoPlayer;

class VideoSprite extends FlxSprite implements IVideoPlayer {
	/**
	 * The current position of the video, in milliseconds.
	 * Set this value to seek to a specific position in the video.
	 */
	public var time(get, set):Int;

	function get_time():Int {
		return video.time;
	}

	function set_time(value:Int):Int {
		return video.time = value;
	}

	/**
	 * The current position of the video, as a percentage between 0.0 and 1.0.
	 * Set this value to seek to a specific position in the video.
	 */
	public var position(get, set):Float;

	function get_position():Float {
		return video.position;
	}

	function set_position(value:Float):Float {
		return video.position = value;
	}

	/**
	 * The duration of the video, in seconds.
	 */
	public var duration(get, null):Float;

	function get_duration():Float {
		return video.duration;
	}

	/**
	 * Whether or not the video is playing.
	 */
	public var isPlaying(get, null):Bool;

	function get_isPlaying():Bool {
		return video.isPlaying;
	}

	/**
	 * Whether or not the audio is currently muted.
	 */
	public var muteAudio(get, set):Bool;

	function get_muteAudio():Bool {
		return video.muteAudio;
	}

	function set_muteAudio(value:Bool):Bool {
		return video.muteAudio = value;
	}

	/**
	 * Current playback speed.
	 */
	public var playbackRate(get, set):Float;

	function get_playbackRate():Float {
		return video.playbackRate;
	}

	function set_playbackRate(value:Float):Float {
		return video.playbackRate = value;
	}

	/**
	 * Current volume.
	 */
	public var volume(get, set):Int;

	function get_volume():Int {
		return video.volume;
	}

	function set_volume(value:Int):Int {
		return video.volume = value;
	}

	/**
	 * Set this value to enforce a specific canvas width for the video.
	 */
	public var canvasWidth(default, set):Null<Int> = null;

	function set_canvasWidth(value:Int):Int {
		this.canvasWidth = value;
		if (canvasWidth != null && canvasHeight != null) {
			setGraphicSize(canvasWidth, canvasHeight);
			updateHitbox();
		}
		return this.canvasWidth;
	}

	/**
	 * Set this value to enforce a specific canvas height for the video.
	 */
	public var canvasHeight(default, set):Null<Int> = null;

	function set_canvasHeight(value:Int):Int {
		this.canvasHeight = value;
		if (canvasWidth != null && canvasHeight != null) {
			setGraphicSize(canvasWidth, canvasHeight);
			updateHitbox();
		}
		return this.canvasHeight;
	}

	public var canvasWidth:Null<Int>;
	public var canvasHeight:Null<Int>;

	var videoBitmap:VideoHandler;

	public var openingCallback:Void->Void = null;
	public var graphicLoadedCallback:Void->Void = null;
	public var finishCallback:Void->Void = null;

	public function new(X:Float = 0, Y:Float = 0):Void {
		super(X, Y);

		makeGraphic(1, 1, FlxColor.TRANSPARENT);

		videoBitmap = new VideoHandler();
		videoBitmap.canUseAutoResize = false;
		videoBitmap.visible = false;
		videoBitmap.openingCallback = function() {
			if (openingCallback != null)
				openingCallback();
		}
		videoBitmap.finishCallback = function() {
			oneTime = false;

			if (finishCallback != null)
				finishCallback();

			kill();
		}
	}

	private var oneTime:Bool = false;

	override function update(elapsed:Float):Void {
		super.update(elapsed);

		if ((videoBitmap != null && (videoBitmap.isPlaying && videoBitmap.bitmapData != null)) && !oneTime) {
			var graphic:FlxGraphic = FlxG.videoBitmap.add(videoBitmap.bitmapData, false, videoBitmap.mrl); // mrl usually starts with file:/// but is fine ig
			if (graphic.imageFrame.frame == null) {
				#if HXC_DEBUG_TRACE
				trace('the frame of the image is null?');
				#end
				return;
			}

			loadGraphic(graphic);

			if (canvasWidth != null && canvasHeight != null) {
				setGraphicSize(canvasWidth, canvasHeight);
				updateHitbox();
			}

			if (graphicLoadedCallback != null)
				graphicLoadedCallback();

			oneTime = true;
		}
	}

	override function destroy():Void {
		if (videoBitmap != null && videoBitmap.onEndReached != null)
			videoBitmap.onVLCEndReached();

		super.destroy();
	}

	/**
	 * Native video support for Flixel & OpenFL
	 * @param Path Example: `your/video/here.mp4`
	 * @param Loop Loop the video.
	 * @param PauseMusic Pause music until the video ends if `FLX_SOUND_SYSTEM` is defined.
	 *
	 * @return 0 if playback started (and was already started), or -1 on error.
	 */
	public function playVideo(Path:String, Loop:Bool = false, PauseMusic:Bool = false):Int {
		return videoBitmap.playVideo(Path, Loop, PauseMusic);
	}
}
