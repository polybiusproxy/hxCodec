package hxcodec.openfl;

#if (!(desktop || android) && macro)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us."
#end
import haxe.io.Path;
import hxcodec.vlc.LibVLC;
import hxcodec.vlc.Types;
import lime.app.Event;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;

/**
 * @author Mihai Alexandru (M.A. Jigsaw).
 *
 * This class lets you to use LibVLC externs as a bitmap that you can displaylist along other items.
 */
#if android
@:headerInclude('android/log.h')
#end
@:headerInclude('stdint.h')
@:headerInclude('stdio.h')
@:cppNamespaceCode('
static unsigned format_setup(void **data, char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines)
{
	Video_obj *self = reinterpret_cast<Video_obj *>(*data);

	unsigned formatWidth = (*width);
	unsigned formatHeight = (*height);

	(*pitches) = formatWidth * 4;
	(*lines) = formatHeight;

	strcpy(chroma, "RV32");

	self->videoWidth = formatWidth;
	self->videoHeight = formatHeight;

	self->events[9] = true;

	if (self->pixels != NULL)
		delete self->pixels;

	self->pixels = new uint8_t[formatWidth * formatHeight * 4];
	return 1;
}

static void *lock(void *data, void **p_pixels)
{
	Video_obj *self = reinterpret_cast<Video_obj *>(data);
	*p_pixels = self->pixels;
	return NULL; // picture identifier, not needed here
}

static void callbacks(const libvlc_event_t *event, void *data)
{
	Video_obj *self = reinterpret_cast<Video_obj *>(data);

	switch (event->type)
	{
		case libvlc_MediaPlayerOpening:
			self->events[0] = true;
			break;
		case libvlc_MediaPlayerPlaying:
			self->events[1] = true;
			break;
		case libvlc_MediaPlayerStopped:
			self->events[2] = true;
			break;
		case libvlc_MediaPlayerPaused:
			self->events[3] = true;
			break;
		case libvlc_MediaPlayerEndReached:
			self->events[4] = true;
			break;
		case libvlc_MediaPlayerEncounteredError:
			self->events[5] = true;
			break;
		case libvlc_MediaPlayerForward:
			self->events[6] = true;
			break;
		case libvlc_MediaPlayerBackward:
			self->events[7] = true;
			break;
		case libvlc_MediaPlayerMediaChanged:
			self->events[8] = true;
			break;
	}
}

static void logging(void *data, int level, const libvlc_log_t *ctx, const char *fmt, va_list args)
{
	#ifdef __ANDROID__
	switch (level)
	{
		case LIBVLC_DEBUG:
			__android_log_vprint(ANDROID_LOG_DEBUG, "HXCODEC", fmt, args);
			break;
		case LIBVLC_NOTICE:
			__android_log_vprint(ANDROID_LOG_INFO, "HXCODEC", fmt, args);
			break;
		case LIBVLC_WARNING:
			__android_log_vprint(ANDROID_LOG_WARN, "HXCODEC", fmt, args);
			break;
		case LIBVLC_ERROR:
			__android_log_vprint(ANDROID_LOG_ERROR, "HXCODEC", fmt, args);
			break;
	}
	#else
	vprintf(fmt, args);
	#endif
}')
class Video extends Bitmap
{
	// Variables
	public var videoWidth(default, null):Int = 0;
	public var videoHeight(default, null):Int = 0;
	public var time(get, set):Int;
	public var position(get, set):Single;
	public var length(get, never):Int;
	public var duration(get, never):Int;
	public var mrl(get, never):String;
	public var volume(get, set):Int;
	public var channel(get, set):Int;
	public var delay(get, set):Int;
	public var rate(get, set):Single;
	public var isPlaying(get, never):Bool;
	public var isSeekable(get, never):Bool;
	public var canPause(get, never):Bool;
	public var mute(get, set):Bool;

	// Callbacks
	public var onOpening(default, null):Event<Void->Void>;
	public var onPlaying(default, null):Event<Void->Void>;
	public var onStopped(default, null):Event<Void->Void>;
	public var onPaused(default, null):Event<Void->Void>;
	public var onEndReached(default, null):Event<Void->Void>;
	public var onEncounteredError(default, null):Event<Void->Void>;
	public var onForward(default, null):Event<Void->Void>;
	public var onBackward(default, null):Event<Void->Void>;
	public var onMediaChanged(default, null):Event<Void->Void>;
	public var onTextureSetup(default, null):Event<Void->Void>;

	// Declarations
	private var oldTime:Float = 0;
	private var deltaTime:Float = 0;
	private var events:Array<Bool>;
	private var texture:RectangleTexture;
	private var pixels:cpp.RawPointer<cpp.UInt8>;
	private var instance:cpp.RawPointer<LibVLC_Instance_T>;
	private var mediaPlayer:cpp.RawPointer<LibVLC_MediaPlayer_T>;
	private var mediaItem:cpp.RawPointer<LibVLC_Media_T>;
	private var eventManager:cpp.RawPointer<LibVLC_EventManager_T>;

	public function new():Void
	{
		super(bitmapData, AUTO, true);

		events = new Array<Bool>();
		for (i in 0...9)
			events[i] = false;

		onOpening = new Event<Void->Void>();
		onPlaying = new Event<Void->Void>();
		onStopped = new Event<Void->Void>();
		onPaused = new Event<Void->Void>();
		onEndReached = new Event<Void->Void>();
		onEncounteredError = new Event<Void->Void>();
		onForward = new Event<Void->Void>();
		onBackward = new Event<Void->Void>();
		onMediaChanged = new Event<Void->Void>();
		onTextureSetup = new Event<Void->Void>();

		#if mac
		Sys.putEnv("VLC_PLUGIN_PATH", Path.directory(Sys.programPath()) + '/plugins');
		#end

		#if (windows || mac)
		untyped __cpp__('const char *argv[] = { "--reset-config", "--reset-plugins-cache" }');

		instance = LibVLC.create(2, untyped __cpp__('argv'));
		#else
		instance = LibVLC.create(0, untyped __cpp__('NULL'));
		#end

		#if HXC_LIBVLC_LOGGING
		LibVLC.log_set(instance, untyped __cpp__('logging'), untyped __cpp__('NULL'));
		#end
	}

	// Methods
	public function play(location:String, shouldLoop:Bool = false):Int
	{
		if (location != null && location.indexOf('://') != -1)
			mediaItem = LibVLC.media_new_location(instance, location);
		else if (location != null)
		{
			#if windows
			mediaItem = LibVLC.media_new_path(instance, Path.normalize(location).split("/").join("\\"));
			#else
			mediaItem = LibVLC.media_new_path(instance, Path.normalize(location));
			#end
		}
		else
			return -1;

		LibVLC.media_add_option(mediaItem, shouldLoop ? "input-repeat=65535" : "input-repeat=0");

		if (mediaPlayer != null)
			LibVLC.media_player_set_media(mediaPlayer, mediaItem);
		else
			mediaPlayer = LibVLC.media_player_new_from_media(mediaItem);

		LibVLC.media_release(mediaItem);

		LibVLC.video_set_format_callbacks(mediaPlayer, untyped __cpp__('format_setup'), untyped __cpp__('NULL'));
		LibVLC.video_set_callbacks(mediaPlayer, untyped __cpp__('lock'), untyped __cpp__('NULL'), untyped __cpp__('NULL'), untyped __cpp__('this'));

		attachEvents();

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
		detachEvents();

		if (mediaPlayer != null)
		{
			LibVLC.media_player_stop(mediaPlayer);
			LibVLC.media_player_release(mediaPlayer);
		}

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

		videoWidth = 0;
		videoHeight = 0;
		pixels = null;

		events.splice(0, events.length);

		if (instance != null)
		{
			#if HXC_LIBVLC_LOGGING
			LibVLC.log_unset(instance);
			#end
			LibVLC.release(instance);
		}

		eventManager = null;
		mediaPlayer = null;
		mediaItem = null;
		instance = null;
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

		return -1;
	}

	@:noCompletion private function set_time(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_time(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_position():Single
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_position(mediaPlayer);

		return -1;
	}

	@:noCompletion private function set_position(value:Single):Single
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

		return -1;
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

		return -1;
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

		return -1;
	}

	@:noCompletion private function set_volume(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_volume(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_channel():Int
	{
		if (mediaPlayer != null)
			return LibVLC.audio_get_channel(mediaPlayer);

		return -1;
	}

	@:noCompletion private function set_channel(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_channel(mediaPlayer, value);

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

		return -1;
	}

	@:noCompletion private function set_delay(value:Int):Int
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_delay(mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_rate():Single
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_rate(mediaPlayer);

		return -1;
	}

	@:noCompletion private function set_rate(value:Single):Single
	{
		if (mediaPlayer != null)
			LibVLC.media_player_set_rate(mediaPlayer, value);

		return value;
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

	@:noCompletion function get_mute():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.audio_get_mute(mediaPlayer) > 0;

		return false;
	}

	@:noCompletion function set_mute(value:Bool):Bool
	{
		if (mediaPlayer != null)
			LibVLC.audio_set_mute(mediaPlayer, value);

		return value;
	}

	// Overrides
	@:noCompletion private override function __enterFrame(elapsed:Int):Void
	{
		if (events.contains(true))
			checkEvents();

		if (__renderable && isPlaying)
		{
			deltaTime += elapsed;

			if (Math.abs(deltaTime - oldTime) > 8.3) // 8.(3) means 120 fps in milliseconds...
				oldTime = deltaTime;
			else
				return;

			if (texture != null && pixels != null)
				texture.uploadFromByteArray(cpp.Pointer.fromRaw(pixels).toUnmanagedArray(videoWidth * videoHeight * 4), 0);

			__setRenderDirty();
		}
	}

	// Internal Methods
	@:noCompletion private function checkEvents():Void
	{
		// `for` takes much more time comparing to this.
		if (events[0])
		{
			events[0] = false;
			onOpening.dispatch();
		}

		if (events[1])
		{
			events[1] = false;
			onPlaying.dispatch();
		}

		if (events[2])
		{
			events[2] = false;
			onStopped.dispatch();
		}

		if (events[3])
		{
			events[3] = false;
			onPaused.dispatch();
		}

		if (events[4])
		{
			events[4] = false;
			onEndReached.dispatch();
		}

		if (events[5])
		{
			events[5] = false;
			onEncounteredError.dispatch();
		}

		if (events[6])
		{
			events[6] = false;
			onForward.dispatch();
		}

		if (events[7])
		{
			events[7] = false;
			onBackward.dispatch();
		}

		if (events[8])
		{
			events[8] = false;
			onMediaChanged.dispatch();
		}

		if (events[9])
		{
			events[9] = false;

			if ((bitmapData != null && bitmapData.width == videoWidth && bitmapData.height == videoHeight) && texture != null)
				return;

			if (bitmapData != null)
				bitmapData.dispose();

			if (texture != null)
				texture.dispose();

			texture = Lib.current.stage.context3D.createRectangleTexture(videoWidth, videoHeight, BGRA, true);
			bitmapData = BitmapData.fromTexture(texture);
			smoothing = true;

			onTextureSetup.dispatch();
		}
	}

	@:noCompletion private function attachEvents():Void
	{
		if (mediaPlayer == null || eventManager != null)
			return;

		eventManager = LibVLC.media_player_event_manager(mediaPlayer);

		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerOpening, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerPlaying, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerStopped, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerPaused, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerEndReached, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerEncounteredError, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerForward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerBackward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_MediaPlayerMediaChanged, untyped __cpp__('callbacks'), untyped __cpp__('this'));
	}

	@:noCompletion private function detachEvents():Void
	{
		if (eventManager == null)
			return;

		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerOpening, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerPlaying, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerStopped, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerPaused, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerEndReached, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerEncounteredError, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerForward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerBackward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_MediaPlayerMediaChanged, untyped __cpp__('callbacks'), untyped __cpp__('this'));
	}
}
