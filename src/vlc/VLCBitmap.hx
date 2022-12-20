package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us.";
#end
import cpp.Function;
import cpp.NativeArray;
import cpp.ConstPointer;
import cpp.RawConstPointer;
import cpp.Pointer;
import cpp.Native;
import cpp.UInt32;
import cpp.UInt8;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.events.Event;
import haxe.io.Bytes;
import haxe.io.BytesData;
import vlc.LibVLC;

class VLCBitmap extends Bitmap
{
	private var pixels:BytesData;
	private var texture:RectangleTexture;

	private var instance:LibVLC_Instance;
	private var audioOutput:LibVLC_AudioOutput;
	private var mediaPlayer:LibVLC_MediaPlayer;
	private var media:LibVLC_Media;
	private var eventManager:LibVLC_EventManager; 

	public function new(?smoothing:Bool = true):Void
	{
		super(bitmapData, AUTO, smoothing);

		if (instance == null)
			instance = LibVLC.init(0, null);

		if (audioOutput == null)
			audioOutput = LibVLC.audio_output_list_get(instance);

		if (stage != null)
			onAddedToStage();
		else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	/* static function format_setup(opaque:cpp.Star<cpp.Star<cpp.Void>>, chroma:cpp.Star<cpp.Char>, width:cpp.Star<UInt32>, height:cpp.Star<UInt32>, pitches:cpp.Star<UInt32>, lines:cpp.Star<UInt32>):UInt32
	{
		var _w:UInt = Pointer.fromStar(width).value;
		var _h:UInt = Pointer.fromStar(height).value;
		var _pitch:UInt = _w * 4;
		var _frame:UInt = _w * _h * 4;

		Pointer.fromStar(pitches).setAt(0, _pitch);
		Pointer.fromStar(lines).setAt(0, _h);

		return 1;
	}

	static function format_cleanup(opaque:cpp.Star<cpp.Void>):Void {} */

	static function lock(data:cpp.Star<cpp.Void>, p_pixels:cpp.Star<cpp.Star<cpp.Void>>):cpp.Star<cpp.Void>
	{
		var self:Pointer<VLCBitmap> = Pointer.fromStar(data).reinterpret();
		return null;
	}

	static function unlock(data:cpp.Star<cpp.Void>, id:cpp.Star<cpp.Void>, p_pixels:cpp.ConstStar<cpp.Star<cpp.Void>>):Void
	{
		var self:Pointer<VLCBitmap> = Pointer.fromStar(data).reinterpret();
	}

	static function display(opaque:cpp.Star<cpp.Void>, picture:cpp.Star<cpp.Void>):Void
	{
		var self:Pointer<VLCBitmap> = Pointer.fromStar(data).reinterpret();
	}

	static function callbacks(p_event:RawConstPointer<LibVLC_Event_T>, p_data:cpp.Star<cpp.Void>):Void
	{
		var event:LibVLC_Event_T = ConstPointer.fromRaw(p_event).value;
		var self:Pointer<VLCBitmap> = Pointer.fromStar(p_data).reinterpret();

		switch (event.type)
		{
			case LibVLC_EventType.PlayerPlaying:
			case LibVLC_EventType.PlayerStopped:
			case LibVLC_EventType.PlayerEndReached:
			case LibVLC_EventType.PlayerEncounteredError:
			case LibVLC_EventType.PlayerOpening:
			case LibVLC_EventType.PlayerBuffering:
			case LibVLC_EventType.PlayerForward:
			case LibVLC_EventType.PlayerBackward:
			case LibVLC_EventType.PlayerTimeChanged:
			case LibVLC_EventType.PlayerPositionChanged:
			case LibVLC_EventType.PlayerSeekableChanged:
			default:
		}
	}

	public function play(?path:String = null, loop:Bool = false, haccelerated:Bool = true):Void
	{
		#if HXC_DEBUG_TRACE
		trace("setting path to: " + path);
		#end

		media = LibVLC.media_new_path(instance, path);
		mediaPlayer = LibVLC.media_player_new_from_media(media);

		LibVLC.media_parse(media);

		if (loop)
		{
			#if android
			LibVLC.media_add_option(media, "input-repeat=65535");
			#else
			LibVLC.media_add_option(media, "input-repeat=-1");
			#end
		}
		else
			LibVLC.media_add_option(media, "input-repeat=0");

		if (haccelerated)
		{
			LibVLC.media_add_option(media, ":hwdec=vaapi");
			LibVLC.media_add_option(media, ":ffmpeg-hw");
			LibVLC.media_add_option(media, ":avcodec-hw=dxva2.lo");
			LibVLC.media_add_option(media, ":avcodec-hw=any");
			LibVLC.media_add_option(media, ":avcodec-hw=dxva2");
			LibVLC.media_add_option(media, "--avcodec-hw=dxva2");
			LibVLC.media_add_option(media, ":avcodec-hw=vaapi");
		}

		LibVLC.media_release(media);

		if (pixels == null || (pixels != null && pixels.length > 0))
			pixels = [];

		// LibVLC.video_set_format_callbacks(mediaPlayer, Function.fromStaticFunction(format_setup), Function.fromStaticFunction(format_cleanup));
		LibVLC.video_set_callbacks(mediaPlayer, Function.fromStaticFunction(lock), Function.fromStaticFunction(unlock), Function.fromStaticFunction(display), getThisPointer());

		// setupEvents();

		LibVLC.media_player_play(mediaPlayer);
	}

	private function onAddedToStage(?e:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function setupEvents():Void
	{
		if (eventManager == null)
			eventManager = LibVLC.media_player_event_manager(mediaPlayer);

		var callback:LibVLC_Event_Callback = Function.fromStaticFunction(callbacks);
		var self:cpp.Star<cpp.Void> = getThisPointer();

		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerPlaying, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerStopped, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerEndReached, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerEncounteredError, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerOpening, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerBuffering, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerForward, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerBackward, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerTimeChanged, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerPositionChanged, callback, self);
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerSeekableChanged, callback, self);
	}

	private function cleanupEvents():Void
	{
		var callback:LibVLC_Event_Callback = Function.fromStaticFunction(callbacks);
		var self:cpp.Star<cpp.Void> = getThisPointer();

		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerPlaying, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerStopped, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerEndReached, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerEncounteredError, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerOpening, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerBuffering, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerForward, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerBackward, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerTimeChanged, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerPositionChanged, callback, self);
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerSeekableChanged, callback, self);

		if (eventManager != null)
			eventManager = null;
	}

	private function onEnterFrame(e:Event):Void
	{
		trace("mmm");
	}

	@:functionCode('return this;')
	private function getThisPointer():cpp.Star<cpp.Void>
		return null;
}
