package vlc;

#if !(desktop || android)
#error "The current target platform isn't supported by hxCodec. If you're targeting Windows/Mac/Linux/Android and getting this message, please contact us.";
#end
import cpp.Function;
import cpp.NativeArray;
import cpp.ConstStar;
import cpp.Char;
import cpp.Pointer;
import cpp.Native;
import cpp.Star;
import cpp.UInt32;
import cpp.UInt8;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.display3D.textures.RectangleTexture;
import openfl.events.Event;
import haxe.io.Bytes;
import haxe.io.BytesData;
import vlc.LibVLC;

@:headerInclude('vlc/vlc.h')
@:unreflective
@:keep
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

		audioOutput = LibVLC.audio_output_list_get(instance);

		if (stage != null)
			onAddedToStage();
		else
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}

	static function setup(opaque:Star<Star<cpp.Void>>, chroma:Star<Char>, width:Star<UInt32>, height:Star<UInt32>, pitches:Star<UInt32>, lines:Star<UInt32>):UInt32
	{
		var _w:UInt = Pointer.fromStar(width).value;
		var _h:UInt = Pointer.fromStar(height).value;
		var _pitch:UInt = _w * 4;
		var _frame:UInt = _w * _h * 4;

		Pointer.fromStar(pitches).setAt(0, _pitch);
		Pointer.fromStar(lines).setAt(0, _h);

		return 1;
	}

	static function cleanup(opaque:Star<cpp.Void>):Void
	{

	}

	static function lock(data:Star<cpp.Void>, p_pixels:Star<Star<cpp.Void>>):Star<cpp.Void>
	{
		return null;
	}

	static function unlock(data:Star<cpp.Void>, id:Star<cpp.Void>, p_pixels:ConstStar<Star<cpp.Void>>):Void
	{

	}

	static function display(opaque:Star<cpp.Void>, picture:Star<cpp.Void>):Void
	{

	}

	static function callbacks(p_event:ConstStar<LibVLC_Event_T>, p_data:Star<cpp.Void>):Void
	{
		var self:VLCBitmap = untyped __cpp__('reinterpret_cast<VLCBitmap_obj*>(p_data)');

		switch (p_event.type)
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

		// LibVLC.video_set_format_callbacks(mediaPlayer, Function.fromStaticFunction(setup), Function.fromStaticFunction(cleanup));
		// LibVLC.video_set_callbacks(mediaPlayer, Function.fromStaticFunction(lock), Function.fromStaticFunction(unlock), Function.fromStaticFunction(display), untyped __cpp__('this'));

		setupEvents();

		LibVLC.media_player_play(mediaPlayer);
	}

	private function init(?e:Event):Void
	{
		if (hasEventListener(Event.ADDED_TO_STAGE))
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

		stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}

	private function setupEvents():Void
	{
		if (eventManager == null)
			eventManager = LibVLC.media_player_event_manager(mediaPlayer);

		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerPlaying, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerStopped, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerEndReached, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerEncounteredError, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerOpening, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerBuffering, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerForward, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerBackward, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerTimeChanged, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerPositionChanged, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_attach(eventManager, LibVLC_EventType.PlayerSeekableChanged, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
	}

	private function cleanupEvents():Void
	{
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerPlaying, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerStopped, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerEndReached, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerEncounteredError, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerOpening, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerBuffering, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerForward, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerBackward, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerTimeChanged, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerPositionChanged, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));
		LibVLC.event_detach(eventManager, LibVLC_EventType.PlayerSeekableChanged, Function.fromStaticFunction(callbacks), untyped __cpp__('this'));

		if (eventManager != null)
			eventManager = null;
	}

	private function onEnterFrame(e:Event):Void
	{
		trace("mmm");
	}
}
