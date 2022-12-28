package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us.";
#end
import cpp.ConstPointer;
import cpp.Pointer;
import cpp.RawConstPointer;
import cpp.UInt8;
import openfl.display.Bitmap;
import openfl.events.Event;
import vlc.LibVLC;

@:cppNamespaceCode('
static unsigned format_setup(void **data, char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines)
{
	VLCBitmap_obj *callback = (VLCBitmap_obj*)(*data);

	unsigned _w = (*width);
	unsigned _h = (*height);
	unsigned _pitch = _w * 4;
	unsigned _frame = _w *_h * 4;

	(*pitches) = _pitch;
	(*lines) = _h;

	memcpy(chroma, "RV32", 4);

	callback->videoWidth = _w;
	callback->videoHeight = _h;

	if (callback->pixels != 0)
		delete callback->pixels;

	callback->pixels = new unsigned char[_frame];
	return 1;
}

static void format_cleanup(void *data)
{
	VLCBitmap_obj *callback = (VLCBitmap_obj*) data;
}

static void *lock(void *data, void **p_pixels)
{
	VLCBitmap_obj *callback = (VLCBitmap_obj*) data;
	*p_pixels = callback->pixels;
	return NULL;
}

static void unlock(void *data, void *id, void *const *p_pixels)
{
	VLCBitmap_obj *callback = (VLCBitmap_obj*) data;
}

static void display(void *data, void *picture)
{
	VLCBitmap_obj *callback = (VLCBitmap_obj*) data;
}

static void callbacks(const libvlc_event_t *event, void *data)
{
	VLCBitmap_obj *callback = (VLCBitmap_obj*) data;
	callback->onEventFlag(event);
}')
class VLCBitmap extends Bitmap
{
	public var videoWidth:Int = 0;
	public var videoHeight:Int = 0;

	private var pixels:Pointer<UInt8>;
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

	public function play(?path:String = null, loop:Bool = false, haccelerated:Bool = true):Void
	{
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

		if (haccelerated)
		{
			LibVLC.media_add_option(mediaItem, ":hwdec=vaapi");
			LibVLC.media_add_option(mediaItem, ":ffmpeg-hw");
			LibVLC.media_add_option(mediaItem, ":avcodec-hw=dxva2.lo");
			LibVLC.media_add_option(mediaItem, ":avcodec-hw=any");
			LibVLC.media_add_option(mediaItem, ":avcodec-hw=dxva2");
			LibVLC.media_add_option(mediaItem, "--avcodec-hw=dxva2");
			LibVLC.media_add_option(mediaItem, ":avcodec-hw=vaapi");
		}

		LibVLC.media_release(mediaItem);

		// if (flags == null || (flags != null && flags.length > 0))
		// flags = [];

		LibVLC.video_set_format_callbacks(mediaPlayer, untyped __cpp__('format_setup'), untyped __cpp__('format_cleanup'));
		LibVLC.video_set_callbacks(mediaPlayer, untyped __cpp__('lock'), untyped __cpp__('unlock'), untyped __cpp__('display'), untyped __cpp__('this'));

		setupEvents();

		LibVLC.media_player_play(mediaPlayer);
	}

	private function onAddedToStage(?e:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function onEventFlag(p_event:RawConstPointer<LibVLC_Event_T>):Void
	{
		var event:LibVLC_Event_T = ConstPointer.fromRaw(p_event).value;
		switch (event.type)
		{
			case LibVLC_EventType.MediaPlayerPlaying:
				trace('playing');
			case LibVLC_EventType.MediaPlayerStopped:
				trace('stopped');
			case LibVLC_EventType.MediaPlayerEndReached:
				trace('end reached');
			case LibVLC_EventType.MediaPlayerEncounteredError:
				trace('error');
			case LibVLC_EventType.MediaPlayerOpening:
				trace('opening');
			case LibVLC_EventType.MediaPlayerBuffering:
				trace('buffering');
			case LibVLC_EventType.MediaPlayerForward:
				trace('forward');
			case LibVLC_EventType.MediaPlayerBackward:
				trace('backward');
			case LibVLC_EventType.MediaPlayerTimeChanged:
				trace('time changed');
			case LibVLC_EventType.MediaPlayerPositionChanged:
				trace('position changed');
			case LibVLC_EventType.MediaPlayerSeekableChanged:
				trace('seekable chamged');
			default:
				trace('default');
		}
	}

	private function onEnterFrame(e:Event):Void {}

	private function setupEvents():Void
	{
		if (eventManager == null)
			eventManager = LibVLC.media_player_event_manager(mediaPlayer);

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
	}
}
