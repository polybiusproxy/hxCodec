package hxcodec.vlc;

#if (!(desktop || android) && macro)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us."
#end
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.Path;
import hxcodec.base.Callback;
import hxcodec.vlc.LibVLC;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display3D.textures.Texture;
import openfl.utils.ByteArray;

using StringTools;

/**
 * ...
 * @author Mihai Alexandru (M.A. Jigsaw).
 *
 * This class lets you to use LibVLC externs as a bitmap that you can displaylist along other items.
 */
@:headerInclude('stdio.h')
@:cppNamespaceCode('
#ifndef vasprintf // https://gist.github.com/cmitu/b67a7ed67b19176f35f1ac06099d02af#file-sdlvlc-cxx-L26
int vasprintf(char **sptr, const char *__restrict fmt, va_list ap)
{
	int count = vsnprintf(NULL, 0, fmt, ap); // Query the buffer size required.

	*sptr = NULL;

	if (count >= 0)
	{
		char* p = static_cast<char*>(malloc(count + 1)); // Allocate memory for it.

		if (p == NULL)
			return -1;

		if (vsnprintf(p, count + 1, fmt, ap) == count) // We should have used exactly what was required.
		{
			*sptr = p;
		}
		else // Otherwise something is wrong, likely a bug in vsnprintf. If so free the memory and report the error.
		{
			free(p);
			return -1;
		}
	}

	return count;
}
#endif // vasprintf

static unsigned format_setup(void **data, char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*)(*data);

	unsigned _w = (*width);
	unsigned _h = (*height);

	(*pitches) = _w * 4;
	(*lines) = _h;

	memcpy(chroma, "RV32", 4);

	self->videoWidth = _w;
	self->videoHeight = _h;

	if (self->pixels != nullptr)
		free(self->pixels);

	self->pixels = new unsigned char[_w *_h * 4];
	return 1;
}

static void *lock(void *data, void **p_pixels)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;
	*p_pixels = self->pixels;
	return nullptr; // picture identifier, not needed here
}

static void callbacks(const libvlc_event_t *event, void *data)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;

	switch (event->type)
	{
		case libvlc_MediaPlayerOpening:
			self->flags[0] = true;
			break;
		case libvlc_MediaPlayerPlaying:
			self->flags[1] = true;
			break;
		case libvlc_MediaPlayerPaused:
			self->flags[2] = true;
			break;
		case libvlc_MediaPlayerStopped:
			self->flags[3] = true;
			break;
		case libvlc_MediaPlayerEndReached:
			self->flags[4] = true;
			break;
		case libvlc_MediaPlayerEncounteredError:
			self->flags[5] = true;
			break;
		case libvlc_MediaPlayerForward:
			self->flags[6] = true;
			break;
		case libvlc_MediaPlayerBackward:
			self->flags[7] = true;
			break;
	}
}')
@:keep
class VLCBitmap extends Bitmap
{
	// LibVLC Static Functions
	private static function logging(data:cpp.RawPointer<cpp.Void>, level:Int, ctx:cpp.RawConstPointer<LibVLC_Log_T>, fmt:cpp.ConstCharStar, args:cpp.VarList):Void
	{
		var msg:cpp.CharStar = "";
		if (untyped __cpp__('vasprintf({0}, {1}, {2})', cpp.RawPointer.addressOf(msg), fmt, args) < 0)
			msg = "Failed to format log message.";

		switch (cast(level, LibVLC_Log_Level))
		{
			case LIBVLC_DEBUG: /* Debug message */
				Sys.println("[ DEBUG ] " + cast(msg, String));
			case LIBVLC_NOTICE: /* Important informational message */
				Sys.println("[ INFO ] " + cast(msg, String));
			case LIBVLC_WARNING: /* Warning (potential error) message */
				Sys.println("[ WARING ] " + cast(msg, String));
			case LIBVLC_ERROR: /* Error message */
				Sys.println("[ ERROR ] " + cast(msg, String));
		}
	}

	// Variables
	public var skipFrameLimit:Int = 0;
	public var videoWidth(default, null):UInt = 0;
	public var videoHeight(default, null):UInt = 0;

	public var time(get, set):Int;
	public var position(get, set):Float;
	public var length(get, never):Int;
	public var duration(get, never):Int;
	public var mrl(get, never):String;
	public var volume(get, set):Int;
	public var delay(get, set):Int;
	public var rate(get, set):Float;
	public var fps(get, never):Float;
	public var isPlaying(get, never):Bool;
	public var isSeekable(get, never):Bool;
	public var canPause(get, never):Bool;
	public var playbackRate(get, set):Float;
	public var muteAudio(get, set):Bool;

	// Callbacks

	/**
	 * Callback for when the media player is opening.
	 */
	public var onOpening(default, null):CallbackVoid;

	/**
	 * Callback for when the media player begins playing.
	 * @param path The path of the current media.
	 */
	public var onPlaying(default, null):Callback<String>;

	/**
	 * Callback for when the media player is paused.
	 */
	public var onPaused(default, null):CallbackVoid;

	/**
	 * Callback for when the media player is stopped.
	 */
	public var onStopped(default, null):CallbackVoid;

	/**
	 * Callback for when the media player reaches the end.
	 */
	public var onEndReached(default, null):CallbackVoid;

	/**
	 * Callback for when the media player encounters an error.
	 * @param error The encountered error.
	 */
	public var onEncounteredError(default, null):Callback<String>;

	/**
	 * Callback for when the media player is skipped forward.
	 */
	public var onForward(default, null):CallbackVoid;

	/**
	 * Callback for when the media player is skipped backward.
	 */
	public var onBackward(default, null):CallbackVoid;

	// Declarations
	private var flags:Array<Bool> = [];
	private var pixels:cpp.RawPointer<cpp.UInt8>;
	private var buffer:BytesData = [];
	private var texture:Texture;
	private var oldTime:Int;

	// LibVLC
	private var instance:cpp.RawPointer<LibVLC_Instance_T>;
	private var mediaPlayer:cpp.RawPointer<LibVLC_MediaPlayer_T>;
	private var mediaItem:cpp.RawPointer<LibVLC_Media_T>;
	private var eventManager:cpp.RawPointer<LibVLC_EventManager_T>;

	public function new():Void
	{
		super(bitmapData, AUTO, true);

		for (event in 0...7)
			flags[event] = false;

		onOpening = new CallbackVoid();
		onPlaying = new Callback<String>();
		onStopped = new CallbackVoid();
		onPaused = new CallbackVoid();
		onEndReached = new CallbackVoid();
		onEncounteredError = new Callback<String>();
		onForward = new CallbackVoid();
		onBackward = new CallbackVoid();

		instance = LibVLC.create(0, null);

		// LibVLC.log_set(instance, cpp.Function.fromStaticFunction(logging), untyped __cpp__('this'));
	}

	// Playback Methods
	public function play(?location:String = null, loop:Bool = false):Int
	{
		if (location.startsWith('https://') || location.startsWith('file://'))
		{
			#if HXC_DEBUG_TRACE
			trace("setting location to: " + location);
			#end

			mediaItem = LibVLC.media_new_location(instance, location);
		}
		else
		{
			final path:String = #if windows Path.normalize(location).split("/").join("\\") #else Path.normalize(location) #end;

			#if HXC_DEBUG_TRACE
			trace("setting path to: " + path);
			#end

			mediaItem = LibVLC.media_new_path(instance, path);
		}

		mediaPlayer = LibVLC.media_player_new_from_media(mediaItem);

		LibVLC.media_parse(mediaItem);
		LibVLC.media_add_option(mediaItem, loop ? "input-repeat=65535" : "input-repeat=0");
		LibVLC.media_release(mediaItem);

		if (buffer != null && buffer.length > 0)
			buffer = [];

		if (bitmapData != null)
		{
			bitmapData.dispose();
			bitmapData = null;
		}

		if (texture != null)
		{
			texture.dispose();
			texture = null;
		}

		LibVLC.video_set_format_callbacks(mediaPlayer, untyped __cpp__('format_setup'), null);
		LibVLC.video_set_callbacks(mediaPlayer, untyped __cpp__('lock'), null, null, untyped __cpp__('this'));

		eventManager = LibVLC.media_player_event_manager(mediaPlayer);

		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerOpening, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPlaying, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPaused, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerStopped, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerEndReached, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerEncounteredError, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerForward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerBackward, untyped __cpp__('callbacks'), untyped __cpp__('this'));

		return LibVLC.media_player_play(mediaPlayer);
	}

	public function stop():Void
	{
		if (mediaPlayer != null)
			LibVLC.media_player_stop(mediaPlayer);
	}

	public function pause():Void
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_pause(mediaPlayer, 1);
	}

	public function resume():Void
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_pause(mediaPlayer, 0);
	}

	public function togglePaused():Void
	{
		if (mediaPlayer != null)
			LibVLC.media_player_pause(mediaPlayer);
	}

	public function dispose():Void
	{
		#if HXC_DEBUG_TRACE
		trace('disposing...');
		#end

		if (isPlaying)
			stop();

		if (buffer != null && buffer.length > 0)
			buffer = [];

		if (bitmapData != null)
		{
			bitmapData.dispose();
			bitmapData = null;
		}

		if (texture != null)
		{
			texture.dispose();
			texture = null;
		}

		onOpening = null;
		onPlaying = null;
		onStopped = null;
		onPaused = null;
		onEndReached = null;
		onEncounteredError = null;
		onForward = null;
		onBackward = null;

		#if HXC_DEBUG_TRACE
		trace('disposing done!');
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_time():Int
	{
		if (mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_player_get_time(mediaPlayer).toInt();
			#else
			return LibVLC.media_player_get_time(mediaPlayer);
			#end
		}

		return 0;
	}

	@:noCompletion private function set_time(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_time(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_position():Float
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_position(mediaPlayer);

		return 0;
	}

	@:noCompletion private function set_position(value:Float):Float
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_position(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_length():Int
	{
		if (mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_player_get_length(mediaPlayer).toInt();
			#else
			return LibVLC.media_player_get_length(mediaPlayer);
			#end
		}

		return 0;
	}

	@:noCompletion private function get_duration():Int
	{
		if (mediaItem != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_get_duration(mediaItem).toInt();
			#else
			return LibVLC.media_get_duration(mediaItem);
			#end
		}

		return 0;
	}

	@:noCompletion private function get_mrl():String
	{
		if (mediaItem != null)
			return cast(LibVLC.media_get_mrl(mediaItem), String);

		return null;
	}

	@:noCompletion private function get_volume():Int
	{
		if (mediaPlayer != null)
			return LibVLC.audio_get_volume(mediaPlayer);

		return 0;
	}

	@:noCompletion private function set_volume(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_volume(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_delay():Int
	{
		if (mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.audio_get_delay(mediaPlayer).toInt();
			#else
			return LibVLC.audio_get_delay(mediaPlayer);
			#end
		}

		return 0;
	}

	@:noCompletion private function set_delay(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_delay(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_rate():Float
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_rate(mediaPlayer);

		return 0;
	}

	@:noCompletion private function set_rate(value:Float):Float
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_rate(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_fps():Float
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_fps(mediaPlayer);

		return 0;
	}

	@:noCompletion private function get_isPlaying():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_is_playing(mediaPlayer);

		return false;
	}

	@:noCompletion private function get_isSeekable():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_is_seekable(mediaPlayer);

		return false;
	}

	@:noCompletion private function get_canPause():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_can_pause(mediaPlayer);

		return false;
	}

	@:noCompletion function get_muteAudio():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.audio_get_mute(mediaPlayer) > 0;

		return false;
	}

	@:noCompletion function set_muteAudio(value:Bool):Bool
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_mute(mediaPlayer, value);

		return value;
	}

	@:noCompletion function get_playbackRate():Float
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_rate(mediaPlayer);

		return 0;
	}

	@:noCompletion function set_playbackRate(value:Float):Float
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_rate(mediaPlayer, value);

		return value;
	}

	// Overrides
	@:noCompletion private override function __enterFrame(deltaTime:Int):Void
	{
		__checkFlags();

		if (__bitmapData != null && __bitmapData.image != null && __bitmapData.image.version != __imageVersion)
			__setRenderDirty();

		if (isPlaying && (videoWidth > 0 && videoHeight > 0) && pixels != null)
		{
			// Initialize the `texture` if necessary.
			if (texture == null)
				texture = Lib.current.stage.context3D.createTexture(videoWidth, videoHeight, BGRA, true);

			// Initialize the `bitmapData` if necessary.
			if (bitmapData == null && texture != null)
				bitmapData = BitmapData.fromTexture(texture);

			__renderVideo();
		}
	}

	@:noCompletion private override function set_height(value:Float):Float
	{
		if (__bitmapData != null)
			scaleY = value / __bitmapData.height;
		else if (videoHeight != 0)
			scaleY = value / videoHeight;
		else
			scaleY = 1;

		return value;
	}

	@:noCompletion private override function set_width(value:Float):Float
	{
		if (__bitmapData != null)
			scaleX = value / __bitmapData.width;
		else if (videoWidth != 0)
			scaleX = value / videoWidth;
		else
			scaleX = 1;

		return value;
	}

	@:noCompletion private override function set_bitmapData(value:BitmapData):BitmapData
	{
		__bitmapData = value;
		__setRenderDirty();
		__imageVersion = -1;
		return __bitmapData;
	}

	// Internal Methods
	@:noCompletion private function __renderVideo():Void
	{
		final currentTime:Int = Lib.getTimer();

		if (Math.abs(currentTime - oldTime) >= (skipFrameLimit != 0 ? skipFrameLimit : ((1000 / (fps * rate)) / 2)))
		{
			oldTime = currentTime;

			cpp.NativeArray.setUnmanagedData(buffer, cpp.ConstPointer.fromRaw(pixels), Std.int(videoWidth * videoHeight * 4));

			if (texture != null && (buffer != null && buffer.length > 0))
			{
				var bytes:Bytes = Bytes.ofData(buffer);
				if (bytes.length >= Std.int(videoWidth * videoHeight * 4))
				{
					texture.uploadFromByteArray(ByteArray.fromBytes(bytes), 0);
					width++;
					width--;
				}
				#if HXC_DEBUG_TRACE
				else
					trace("Too small frame, can't render :(");
				#end
			}
		}
	}

	@:noCompletion private function __checkFlags():Void
	{
		for (i in 0...7)
		{
			if (flags[i])
			{
				flags[i] = false;

				switch (i)
				{
					case 0:
						if (onOpening != null)
							onOpening.dispatch();
					case 1:
						if (onPlaying != null)
							onPlaying.dispatch(mrl);
					case 2:
						if (onPaused != null)
							onPaused.dispatch();
					case 3:
						if (onStopped != null)
							onStopped.dispatch();
					case 4:
						if (onEndReached != null)
							onEndReached.dispatch();
					case 5:
						if (onEncounteredError != null)
							onEncounteredError.dispatch(cast(LibVLC.errmsg(), String));
					case 6:
						if (onForward != null)
							onForward.dispatch();
					case 7:
						if (onBackward != null)
							onBackward.dispatch();
				}
			}
		}
	}
}
