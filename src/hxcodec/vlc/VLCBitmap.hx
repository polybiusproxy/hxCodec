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
#ifndef vasprintf
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

	if (self->__pixels != nullptr)
		free(self->__pixels);

	self->__pixels = new unsigned char[_w *_h * 4];
	return 1;
}

static void *lock(void *data, void **p_pixels)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;
	*p_pixels = self->__pixels;
	return nullptr; // picture identifier, not needed here
}

static void callbacks(const libvlc_event_t *event, void *data)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;

	switch (event->type)
	{
		case libvlc_MediaPlayerOpening:
			self->__flags[0] = true;
			break;
		case libvlc_MediaPlayerPlaying:
			self->__flags[1] = true;
			break;
		case libvlc_MediaPlayerPaused:
			self->__flags[2] = true;
			break;
		case libvlc_MediaPlayerStopped:
			self->__flags[3] = true;
			break;
		case libvlc_MediaPlayerEndReached:
			self->__flags[4] = true;
			break;
		case libvlc_MediaPlayerEncounteredError:
			self->__flags[5] = true;
			break;
		case libvlc_MediaPlayerForward:
			self->__flags[6] = true;
			break;
		case libvlc_MediaPlayerBackward:
			self->__flags[7] = true;
			break;
	}
}

static void logging(void *data, int level, const libvlc_log_t *ctx, const char *fmt, va_list args)
{
	char* msg = { 0 };

	if (vasprintf(&msg, fmt, args) < 0)
		return;

	switch (level)
	{
		case LIBVLC_DEBUG:
			// printf("[ DEBUG ] %s", msg);
			break;
		case LIBVLC_NOTICE:
			// printf("[ INFO ] %s", msg);
			break;
		case LIBVLC_WARNING:
			// printf("[ WARNING ] %s", msg);
			break;
		case LIBVLC_ERROR:
			// printf("[ ERROR ] %s", msg);
			break;
	}
}')
@:keep
class VLCBitmap extends Bitmap
{
	// Variables
	public var videoWidth(default, null):UInt = 0;
	public var videoHeight(default, null):UInt = 0;
	public var texture(default, null):Texture;
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
	public var onOpening(default, null):CallbackVoid;
	public var onPlaying(default, null):Callback<String>;
	public var onPaused(default, null):CallbackVoid;
	public var onStopped(default, null):CallbackVoid;
	public var onEndReached(default, null):CallbackVoid;
	public var onEncounteredError(default, null):Callback<String>;
	public var onForward(default, null):CallbackVoid;
	public var onBackward(default, null):CallbackVoid;

	// Declarations
	private var __oldTime:Int = 0;
	private var __flags:Array<Bool> = [];
	private var __buffer:BytesData = [];
	private var __pixels:cpp.RawPointer<cpp.UInt8>;
	private var __instance:cpp.RawPointer<LibVLC_Instance_T>;
	private var __mediaPlayer:cpp.RawPointer<LibVLC_MediaPlayer_T>;
	private var __mediaItem:cpp.RawPointer<LibVLC_Media_T>;
	private var __eventManager:cpp.RawPointer<LibVLC_EventManager_T>;

	public function new():Void
	{
		super(bitmapData, AUTO, true);

		for (event in 0...7)
			__flags[event] = false;

		onOpening = new CallbackVoid();
		onPlaying = new Callback<String>();
		onStopped = new CallbackVoid();
		onPaused = new CallbackVoid();
		onEndReached = new CallbackVoid();
		onEncounteredError = new Callback<String>();
		onForward = new CallbackVoid();
		onBackward = new CallbackVoid();

		__instance = LibVLC.create(0, null);

		LibVLC.log_set(__instance, untyped __cpp__('logging'), untyped __cpp__('this'));
	}

	// Methods
	public function play(?location:String = null, shouldLoop:Bool = false):Int
	{
		if (location.startsWith('https://') || location.startsWith('file://'))
		{
			#if HXC_DEBUG_TRACE
			trace("setting location to: " + location);
			#end

			__mediaItem = LibVLC.media_new_location(__instance, location);
		}
		else
		{
			final path:String = #if windows Path.normalize(location).split("/").join("\\") #else Path.normalize(location) #end;

			#if HXC_DEBUG_TRACE
			trace("setting path to: " + path);
			#end

			__mediaItem = LibVLC.media_new_path(__instance, path);
		}

		__mediaPlayer = LibVLC.media_player_new_from_media(__mediaItem);

		LibVLC.media_parse(__mediaItem);
		LibVLC.media_add_option(__mediaItem, shouldLoop ? "input-repeat=65535" : "input-repeat=0");
		LibVLC.media_release(__mediaItem);

		if (__buffer != null && __buffer.length > 0)
			__buffer = [];

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

		LibVLC.video_set_format_callbacks(__mediaPlayer, untyped __cpp__('format_setup'), null);
		LibVLC.video_set_callbacks(__mediaPlayer, untyped __cpp__('lock'), null, null, untyped __cpp__('this'));

		__attachEvents();

		return LibVLC.media_player_play(__mediaPlayer);
	}

	public function stop():Void
	{
		if (__mediaPlayer != null)
			LibVLC.media_player_stop(__mediaPlayer);
	}

	public function pause():Void
	{
		if (__mediaPlayer != null)
			LibVLC.media_player_set_pause(__mediaPlayer, 1);
	}

	public function resume():Void
	{
		if (__mediaPlayer != null)
			LibVLC.media_player_set_pause(__mediaPlayer, 0);
	}

	public function togglePaused():Void
	{
		if (__mediaPlayer != null)
			LibVLC.media_player_pause(__mediaPlayer);
	}

	public function dispose():Void
	{
		#if HXC_DEBUG_TRACE
		trace('disposing...');
		#end

		if (isPlaying)
			stop();

		__detachEvents();

		LibVLC.log_unset(__instance);

		if (__buffer != null && __buffer.length > 0)
			__buffer = [];

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

		__instance = null;
		__mediaPlayer = null;
		__mediaItem = null;
		__eventManager = null;

		#if HXC_DEBUG_TRACE
		trace('disposing done!');
		#end
	}

	// Get & Set Methods
	@:noCompletion private function get_time():Int
	{
		if (__mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_player_get_time(__mediaPlayer).toInt();
			#else
			return LibVLC.media_player_get_time(__mediaPlayer);
			#end
		}

		return 0;
	}

	@:noCompletion private function set_time(value:Int):Int
	{
		if (__mediaPlayer != null)
			LibVLC.media_player_set_time(__mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_position():Float
	{
		if (__mediaPlayer != null)
			return LibVLC.media_player_get_position(__mediaPlayer);

		return 0;
	}

	@:noCompletion private function set_position(value:Float):Float
	{
		if (__mediaPlayer != null)
			LibVLC.media_player_set_position(__mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_length():Int
	{
		if (__mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_player_get_length(__mediaPlayer).toInt();
			#else
			return LibVLC.media_player_get_length(__mediaPlayer);
			#end
		}

		return 0;
	}

	@:noCompletion private function get_duration():Int
	{
		if (__mediaItem != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.media_get_duration(__mediaItem).toInt();
			#else
			return LibVLC.media_get_duration(__mediaItem);
			#end
		}

		return 0;
	}

	@:noCompletion private function get_mrl():String
	{
		if (__mediaItem != null)
			return cast(LibVLC.media_get_mrl(__mediaItem), String);

		return null;
	}

	@:noCompletion private function get_volume():Int
	{
		if (__mediaPlayer != null)
			return LibVLC.audio_get_volume(__mediaPlayer);

		return 0;
	}

	@:noCompletion private function set_volume(value:Int):Int
	{
		if (__mediaPlayer != null)
			LibVLC.audio_set_volume(__mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_delay():Int
	{
		if (__mediaPlayer != null)
		{
			#if (haxe >= "4.3.0")
			return LibVLC.audio_get_delay(__mediaPlayer).toInt();
			#else
			return LibVLC.audio_get_delay(__mediaPlayer);
			#end
		}

		return 0;
	}

	@:noCompletion private function set_delay(value:Int):Int
	{
		if (__mediaPlayer != null)
			LibVLC.audio_set_delay(__mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_rate():Float
	{
		if (__mediaPlayer != null)
			return LibVLC.media_player_get_rate(__mediaPlayer);

		return 0;
	}

	@:noCompletion private function set_rate(value:Float):Float
	{
		if (__mediaPlayer != null)
			LibVLC.media_player_set_rate(__mediaPlayer, value);

		return value;
	}

	@:noCompletion private function get_fps():Float
	{
		if (__mediaPlayer != null)
			return LibVLC.media_player_get_fps(__mediaPlayer);

		return 0;
	}

	@:noCompletion private function get_isPlaying():Bool
	{
		if (__mediaPlayer != null)
			return LibVLC.media_player_is_playing(__mediaPlayer);

		return false;
	}

	@:noCompletion private function get_isSeekable():Bool
	{
		if (__mediaPlayer != null)
			return LibVLC.media_player_is_seekable(__mediaPlayer);

		return false;
	}

	@:noCompletion private function get_canPause():Bool
	{
		if (__mediaPlayer != null)
			return LibVLC.media_player_can_pause(__mediaPlayer);

		return false;
	}

	@:noCompletion function get_muteAudio():Bool
	{
		if (__mediaPlayer != null)
			return LibVLC.audio_get_mute(__mediaPlayer) > 0;

		return false;
	}

	@:noCompletion function set_muteAudio(value:Bool):Bool
	{
		if (__mediaPlayer != null)
			LibVLC.audio_set_mute(__mediaPlayer, value);

		return value;
	}

	@:noCompletion function get_playbackRate():Float
	{
		if (__mediaPlayer != null)
			return LibVLC.media_player_get_rate(__mediaPlayer);

		return 0;
	}

	@:noCompletion function set_playbackRate(value:Float):Float
	{
		if (__mediaPlayer != null)
			LibVLC.media_player_set_rate(__mediaPlayer, value);

		return value;
	}

	// Overrides
	@:noCompletion private override function __enterFrame(deltaTime:Int):Void
	{
		if (__bitmapData != null && __bitmapData.image != null && __bitmapData.image.version != __imageVersion)
			__setRenderDirty();

		__checkFlags();

		if (isPlaying && (videoWidth > 0 && videoHeight > 0) && __pixels != null)
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
		if (bitmapData != null)
			scaleY = value / bitmapData.height;
		else if (videoHeight != 0)
			scaleY = value / videoHeight;
		else
			scaleY = 1;

		return value;
	}

	@:noCompletion private override function set_width(value:Float):Float
	{
		if (bitmapData != null)
			scaleX = value / bitmapData.width;
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
		var currentTime:Int = Lib.getTimer();

		if (Math.abs(currentTime - __oldTime) > Std.int(1000 / (fps * rate)))
		{
			__oldTime = currentTime;

			cpp.NativeArray.setUnmanagedData(__buffer, cpp.ConstPointer.fromRaw(__pixels), Std.int(videoWidth * videoHeight * 4));

			if (texture != null && (__buffer != null && __buffer.length > 0))
			{
				var bytes:Bytes = Bytes.ofData(__buffer);
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
			if (__flags[i])
			{
				__flags[i] = false;

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

	@:noCompletion private function __attachEvents():Void
	{
		__eventManager = LibVLC.media_player_event_manager(__mediaPlayer);

		LibVLC.event_attach(__eventManager, LibVLC_MediaPlayerOpening, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(__eventManager, LibVLC_MediaPlayerPlaying, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(__eventManager, LibVLC_MediaPlayerPaused, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(__eventManager, LibVLC_MediaPlayerStopped, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(__eventManager, LibVLC_MediaPlayerEndReached, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(__eventManager, LibVLC_MediaPlayerEncounteredError, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(__eventManager, LibVLC_MediaPlayerForward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(__eventManager, LibVLC_MediaPlayerBackward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
	}

	@:noCompletion private function __detachEvents():Void
	{
		LibVLC.event_detach(__eventManager, LibVLC_MediaPlayerOpening, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(__eventManager, LibVLC_MediaPlayerPlaying, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(__eventManager, LibVLC_MediaPlayerPaused, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(__eventManager, LibVLC_MediaPlayerStopped, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(__eventManager, LibVLC_MediaPlayerEndReached, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(__eventManager, LibVLC_MediaPlayerEncounteredError, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(__eventManager, LibVLC_MediaPlayerForward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_detach(__eventManager, LibVLC_MediaPlayerBackward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
	}
}
