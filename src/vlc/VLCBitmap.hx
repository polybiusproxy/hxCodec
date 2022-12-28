package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us.";
#end
import cpp.Pointer;
import cpp.UInt8;
import cpp.NativeArray;
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
	self->canRender = true;
}

static void callbacks(const libvlc_event_t *event, void *data)
{
	VLCBitmap_obj *self = (VLCBitmap_obj*) data;
}')
class VLCBitmap extends Bitmap
{
	public var videoWidth(default, null):Int = 0;
	public var videoHeight(default, null):Int = 0;
	public var initComplete(default, null):Bool = false;

	private var canRender:Bool = false;
	private var pixels:Pointer<UInt8>;
	private var buffer:BytesData;

	private var instance:LibVLC_Instance;
	private var audioOutput:LibVLC_AudioOutput;
	private var mediaPlayer:LibVLC_MediaPlayer;
	private var mediaItem:LibVLC_Media;
	private var eventManager:LibVLC_EventManager;

	public function new():Void
	{
		super();

		if (instance == null)
			instance = LibVLC.init(0, null);

		if (audioOutput == null)
			audioOutput = LibVLC.audio_output_list_get(instance);

		if (stage != null)
			onAddedToStage();
		else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	public function play(?location:String = null, loop:Bool = false):Void
	{
		final path:String = Path.normalize(location);

		#if HXC_DEBUG_TRACE
		trace("setting path to: " + path);
		#end

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

		LibVLC.media_release(mediaItem);

		if (canRender)
			canRender = false;

		if (buffer == null || (buffer != null && buffer.length > 0))
			buffer = [];

		LibVLC.video_set_format_callbacks(mediaPlayer, untyped __cpp__('format_setup'), untyped __cpp__('format_cleanup'));
		LibVLC.video_set_callbacks(mediaPlayer, untyped __cpp__('lock'), untyped __cpp__('unlock'), untyped __cpp__('display'), untyped __cpp__('this'));

		eventManager = LibVLC.media_player_event_manager(mediaPlayer);

		setupEvents();

		LibVLC.media_player_play(mediaPlayer);
	}

	private function onAddedToStage(?e:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private var currentTime:Float = 0;
	private function onEnterFrame(e:Event):Void
	{
		if (canRender && (videoWidth > 0 && videoHeight > 0) && pixels != null)
		{
			var time:Int = Lib.getTimer();
			var elements:Int = videoWidth * videoHeight * 4;
			renderToTexture(time - currentTime, elements);
		}
	}

	private function renderToTexture(deltaTime:Float, elementsCount:Int):Void
	{
		if (deltaTime > 1000 / (LibVLC.media_player_get_fps(mediaPlayer) * LibVLC.media_player_get_rate(mediaPlayer)))
		{
			currentTime = deltaTime;

			#if HXC_DEBUG_TRACE
			trace("rendering...");
			#end

			NativeArray.setUnmanagedData(buffer, pixels, elementsCount);

			// Initialize the texture if necessary.
			if (texture == null)
				texture = Lib.current.stage.context3D.createRectangleTexture(videoWidth, videoHeight, BGRA, true);

			// Initialize the bitmapData if necessary.
			if (bitmapData == null)
				bitmapData = BitmapData.fromTexture(texture);

			if (texture != null && (buffer != null && buffer.length > 0))
			{
				var bytes:Bytes = Bytes.ofData(buffer);
				if (bytes.length >= elementsCount)
				{
					texture.uploadFromByteArray(bytes, 0);
					width++;
					width--;
				}
			}
		}
	}

	private function setupEvents():Void
	{
		var callback:LibVLC_Event_Callback = untyped __cpp__('callbacks');
		var self:cpp.Star<cpp.Void> = untyped __cpp__('this');

		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPlaying, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerStopped, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerEndReached, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerEncounteredError, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerOpening, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerBuffering, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerForward, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerBackward, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerTimeChanged, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPositionChanged, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerSeekableChanged, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPausableChanged, callback, self);
	}

	private function cleanupEvents():Void
	{
		var callback:LibVLC_Event_Callback = untyped __cpp__('callbacks');
		var self:cpp.Star<cpp.Void> = untyped __cpp__('this');

		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerPlaying, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerStopped, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerEndReached, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerEncounteredError, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerOpening, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerBuffering, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerForward, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerBackward, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerTimeChanged, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerPositionChanged, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerSeekableChanged, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.MediaPlayerPausableChanged, callback, self);
	}
}
