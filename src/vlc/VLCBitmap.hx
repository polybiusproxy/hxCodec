package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us.";
#end
import cpp.NativeArray;
import cpp.Pointer;
import cpp.UInt8;
import haxe.io.Bytes;
import haxe.io.BytesData;
import haxe.io.Path;
import openfl.Lib;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.events.Event;
import vlc.LibVLC;

/**
 * ...
 * @author Mihai Alexandru (M.A. Jigsaw).
 *
 * This class lets you to use LibVLC externs as a bitmap then you can displaylist along other items.
 */
@:cppNamespaceCode('
static unsigned format_setup(void **data, char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*)(*data);

	unsigned _w = (*width);
	unsigned _h = (*height);
	unsigned _pitch = _w * 4;
	unsigned _frame = _w *_h * 4;

	(*pitches) = _pitch;
	(*lines) = _h;

	memcpy(chroma, "RV32", 4);

	self->videoWidth = _w;
	self->videoHeight = _h;

	if (self->pixels != 0)
		delete self->pixels;

	self->pixels = new unsigned char[_frame];
	return 1;
}

static void format_cleanup(void *data)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;
}

static void *lock(void *data, void **p_pixels)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;
	*p_pixels = self->pixels;
	return NULL;
}

static void unlock(void *data, void *id, void *const *p_pixels)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;
}

static void display(void *data, void *picture)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;
	self->isDisplaying = true;
}

static void callbacks(const libvlc_event_t *event, void *data)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;

	/*switch (event->type)
	{
		case libvlc_MediaPlayerOpening:
			if (self->onOpening != NULL)
				self->onOpening();
			break;
		case libvlc_MediaPlayerPlaying:
			if (self->onPlaying != NULL)
				self->onPlaying();
			break;
		case libvlc_MediaPlayerStopped:
			if (self->onStopped != NULL)
				self->onStopped();
			break;
		case libvlc_MediaPlayerPausableChanged:
			if (self->onPausableChanged != NULL)
				self->onPausableChanged(event->u.media_player_pausable_changed.new_pausable);
			break;
		case libvlc_MediaPlayerEndReached:
			if (self->onEndReached != NULL)
				self->onEndReached();
			break;
		case libvlc_MediaPlayerEncounteredError:
			if (self->onEncounteredError != NULL)
				self->onEncounteredError();
			break;
		case libvlc_MediaPlayerForward:
			if (self->onForward != NULL)
				self->onForward();
			break;
		case libvlc_MediaPlayerBackward:
			if (self->onBackward != NULL)
				self->onBackward();
			break;
		default:
			break;
	}*/
}')
class VLCBitmap extends Bitmap
{
	// Variables
	public var videoWidth(default, null):Int = 0;
	public var videoHeight(default, null):Int = 0;

	public var time(get, set):Int;
	public var position(get, set):Float;
	public var length(get, never):Int;
	public var duration(get, never):Int;
	public var volume(get, set):Int;
	public var delay(get, set):Int;
	public var rate(get, set):Float;
	public var fps(get, never):Float;

	public var isDisplaying(default, null):Bool = false;
	public var isPlaying(get, never):Bool;
	public var isSeekable(get, never):Bool;

	// Callbacks
	public var onOpening:Void->Void;
	public var onPlaying:Void->Void;
	public var onStopped:Void->Void;
	public var onPausableChanged:Int->Void;
	public var onEndReached:Void->Void;
	public var onEncounteredError:Void->Void;
	public var onForward:Void->Void;
	public var onBackward:Void->Void;

	// Declarations
	private var buffer:BytesData;
	private var pixels:Pointer<UInt8>;
	private var texture:RectangleTexture;

	// LibVLC
	private var instance:LibVLC_Instance;
	private var audioOutput:LibVLC_AudioOutput;
	private var mediaPlayer:LibVLC_MediaPlayer;
	private var mediaItem:LibVLC_Media;
	private var eventManager:LibVLC_EventManager;

	public function new():Void
	{
		super(bitmapData, AUTO, true);

		instance = LibVLC.init(0, null);
		audioOutput = LibVLC.audio_output_list_get(instance);

		if (stage != null)
			onAddedToStage();
		else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	// Playback Functions
	public function play(?location:String = null, loop:Bool = false, haccelerated:Bool = true):Void
	{
		final path:String = Path.normalize(location);

		trace("setting path to: " + path);

		mediaItem = LibVLC.media_new_path(instance, path);
		mediaPlayer = LibVLC.media_player_new_from_media(mediaItem);

		LibVLC.media_parse(mediaItem);

		if (loop)
		{
			#if android
			LibVLC.media_add_option(mediaItem, "input-repeat=65535");
			#else
			LibVLC.media_add_option(mediaItem, "input-repeat=-1");
			#end
		}
		else
			LibVLC.media_add_option(mediaItem, "input-repeat=0");

		if (haccelerated)
		{
			LibVLC.media_add_option(mediaItem, ":ffmpeg-hw");
			LibVLC.media_add_option(mediaItem, ":avcodec-hw=any");
		}

		LibVLC.media_release(mediaItem);

		if (isDisplaying)
			isDisplaying = false;

		if (buffer == null || (buffer != null && buffer.length > 0))
			buffer = [];

		LibVLC.video_set_format_callbacks(mediaPlayer, untyped __cpp__('format_setup'), untyped __cpp__('format_cleanup'));
		LibVLC.video_set_callbacks(mediaPlayer, untyped __cpp__('lock'), untyped __cpp__('unlock'), untyped __cpp__('display'), untyped __cpp__('this'));

		eventManager = LibVLC.media_player_event_manager(mediaPlayer);

		setupEvents();

		LibVLC.media_player_play(mediaPlayer);
	}

	public function stop():Void
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_stop(mediaPlayer);
	}

	public function pause():Void
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_set_pause(mediaPlayer, 1);
	}

	public function resume():Void
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_set_pause(mediaPlayer, 0);
	}

	public function release():Void
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_release(mediaPlayer);
	}

	public function dispose():Void
	{
		if (isPlaying)
			stop();

		cleanupEvents();

		if (stage.hasEventListener(Event.ENTER_FRAME))
			stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

		if (texture != null)
		{
			texture.dispose();
			texture = null;
		}

		if (bitmapData != null)
		{
			bitmapData.dispose();
			bitmapData = null;
		}

		if (buffer != null && buffer.length > 0)
			buffer = [];

		if (isDisplaying)
			isDisplaying = false;

		onOpening = null;
		onPlaying = null;
		onStopped = null;
		onPausableChanged = null;
		onEndReached = null;
		onEncounteredError = null;
		onForward = null;
		onBackward = null;
	}

	// Internal Methods
	private function onAddedToStage(?e:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private var currentTime:Float = 0;
	private function onEnterFrame(e:Event):Void
	{
		if (isDisplaying && (videoWidth > 0 && videoHeight > 0) && pixels != null)
		{
			var time:Int = Lib.getTimer();
			var elements:Int = videoWidth * videoHeight * 4;
			renderToTexture(time - currentTime, elements);
		}
	}

	private function renderToTexture(deltaTime:Float, elementsCount:Int):Void
	{
		// Initialize the `texture` if necessary.
		if (texture == null)
			texture = Lib.current.stage.context3D.createRectangleTexture(videoWidth, videoHeight, BGRA, true);

		// Initialize the `bitmapData` if necessary.
		if (bitmapData == null && texture != null)
			bitmapData = BitmapData.fromTexture(texture);

		// When you set a `bitmapData`, `smoothing` goes `false` for some reason.
		if (!smoothing)
			smoothing = true;

		// if (deltaTime > (1000 / (fps * rate)))
		if (deltaTime > 28)
		{
			currentTime = deltaTime;

			NativeArray.setUnmanagedData(buffer, pixels, elementsCount);

			if (texture != null && (buffer != null && buffer.length > 0))
			{
				var bytes:Bytes = Bytes.ofData(buffer);
				if (bytes.length >= elementsCount)
				{
					texture.uploadFromByteArray(bytes, 0);
					width++;
					width--;
				}
				else
					trace("Too small frame, can't render :(");
			}
		}
	}

	private function setupEvents():Void
	{
		var callback:LibVLC_Event_Callback = untyped __cpp__('callbacks');
		var self:cpp.Star<cpp.Void> = untyped __cpp__('this');

		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerOpening, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPlaying, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerStopped, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPausableChanged, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerEndReached, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerEncounteredError, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerForward, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerBackward, callback, self);
	}

	private function cleanupEvents():Void
	{
		var callback:LibVLC_Event_Callback = untyped __cpp__('callbacks');
		var self:cpp.Star<cpp.Void> = untyped __cpp__('this');

		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerOpening, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerPlaying, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerStopped, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerPausableChanged, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerEndReached, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerEncounteredError, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerForward, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerBackward, callback, self);
	}

	// Get & Set Methods
	@:noCompletion private function get_time():Int
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_get_time(mediaPlayer);

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
			return LibVLC.media_player_get_length(mediaPlayer);

		return 0;
	}

	@:noCompletion private function get_duration():Int
	{
		if (mediaItem != null)
			return LibVLC.media_get_duration(mediaItem);

		return 0;
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
			return LibVLC.audio_get_delay(mediaPlayer);

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
}
