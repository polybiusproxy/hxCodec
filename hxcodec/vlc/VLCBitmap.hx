package hxcodec.vlc;

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
import openfl.utils.ByteArray;
import hxcodec.vlc.LibVLC;

/**
 * ...
 * @author Mihai Alexandru (M.A. Jigsaw).
 *
 * This class lets you to use LibVLC externs as a bitmap that you can displaylist along other items.
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

	if (self->pixels != NULL || self->pixels != nullptr)
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
class VLCBitmap extends Bitmap
{
	// Variables
	public var skipStepLimit:Float = 0;
	public var videoWidth(default, null):Int = 0;
	public var videoHeight(default, null):Int = 0;
	public var isDisplaying(default, null):Bool = false;

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

	// Callbacks
	public var onOpening:Void->Void;
	public var onPlaying:Void->Void;
	public var onPaused:Void->Void;
	public var onStopped:Void->Void;
	public var onEndReached:Void->Void;
	public var onEncounteredError:Void->Void;
	public var onForward:Void->Void;
	public var onBackward:Void->Void;

	// Declarations
	private var flags:Array<Bool> = [];
	private var pixels:Pointer<UInt8>;
	private var buffer:BytesData;
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

		for (event in 0...7)
			flags[event] = false;

		instance = LibVLC.init(0, null);
		audioOutput = LibVLC.audio_output_list_get(instance);

		if (stage != null)
			onAddedToStage();
		else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	// Playback Methods
	public function play(?location:String = null, loop:Bool = false):Void
	{
		final path:String = #if windows Path.normalize(location).split("/").join("\\") #else Path.normalize(location) #end;

		#if HXC_DEBUG_TRACE
		trace("setting path to: " + path);
		#end

		mediaItem = LibVLC.media_new_path(instance, path);
		mediaPlayer = LibVLC.media_player_new_from_media(mediaItem);

		LibVLC.media_parse(mediaItem);

		if (loop)
			LibVLC.media_add_option(mediaItem, #if android "input-repeat=65535" #else "input-repeat=-1" #end);
		else
			LibVLC.media_add_option(mediaItem, "input-repeat=0");

		LibVLC.media_release(mediaItem);

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

		if (buffer == null || (buffer != null && buffer.length > 0))
			buffer = [];

		isDisplaying = false;

		LibVLC.video_set_format_callbacks(mediaPlayer, untyped __cpp__('format_setup'), untyped __cpp__('format_cleanup'));
		LibVLC.video_set_callbacks(mediaPlayer, untyped __cpp__('lock'), untyped __cpp__('unlock'), untyped __cpp__('display'), untyped __cpp__('this'));

		eventManager = LibVLC.media_player_event_manager(mediaPlayer);

		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerOpening, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPlaying, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerStopped, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerPaused, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerEndReached, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerEncounteredError, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerForward, untyped __cpp__('callbacks'), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.MediaPlayerBackward, untyped __cpp__('callbacks'), untyped __cpp__('this'));

		LibVLC.media_player_play(mediaPlayer);
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

	public function dispose():Void
	{
		#if HXC_DEBUG_TRACE
		trace('disposing...');
		#end

		if (isPlaying)
			stop();

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

		isDisplaying = false;

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
		checkFlags();

		if ((isPlaying && isDisplaying) && (videoWidth > 0 && videoHeight > 0) && pixels != null)
		{
			var time:Int = Lib.getTimer();
			var elements:Int = videoWidth * videoHeight * 4;
			render(time - currentTime, elements);
		}
	}

	private function checkFlags():Void
	{
		if (flags[0])
		{
			flags[0] = false;
			if (onOpening != null)
				onOpening();
		}

		if (flags[1])
		{
			flags[1] = false;
			if (onPlaying != null)
				onPlaying();
		}

		if (flags[2])
		{
			flags[2] = false;
			if (onPaused != null)
				onPaused();
		}

		if (flags[3])
		{
			flags[3] = false;
			if (onStopped != null)
				onStopped();
		}

		if (flags[4])
		{
			flags[4] = false;
			if (onEndReached != null)
				onEndReached();
		}

		if (flags[5])
		{
			flags[5] = false;
			if (onEncounteredError != null)
				onEncounteredError();
		}

		if (flags[6])
		{
			flags[6] = false;
			if (onForward != null)
				onForward();
		}

		if (flags[7])
		{
			flags[7] = false;
			if (onBackward != null)
				onBackward();
		}
	}

	private function render(deltaTime:Float, elementsCount:Int):Void
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

		if (deltaTime > (1000 / skipStepLimit == 0 ? (fps * rate) : skipStepLimit))
		{
			currentTime = deltaTime;

			#if HXC_DEBUG_TRACE
			trace('rendering...');
			#end

			NativeArray.setUnmanagedData(buffer, pixels, elementsCount);

			if (texture != null && (buffer != null && buffer.length > 0))
			{
				var bytes:Bytes = Bytes.ofData(buffer);
				if (bytes.length >= elementsCount)
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

	@:noCompletion private function get_mrl():String
	{
		if (mediaItem != null)
			return LibVLC.media_get_mrl(mediaItem);

		return '';
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

	@:noCompletion private function get_canPause():Bool
	{
		if (mediaPlayer != null)
			return LibVLC.media_player_can_pause(mediaPlayer);

		return false;
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
}
