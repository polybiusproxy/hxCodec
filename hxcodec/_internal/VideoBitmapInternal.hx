package hxcodec._internal;

import hxcodec.base.Callback;
import haxe.io.Path;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.Lib;
import hxcodec._internal.LibVLCMediaPlayer.LibVLCMediaPlayerHelper;
import hxcodec._internal.LibVLCMediaTrack.LibVLCMediaTrackHelper;
import hxcodec._internal.LibVLCLogging.LibVLCLoggingHelper;

/**
 * Utilizes LibVLC externs as a bitmap that can be displayed.
 */
@:cppNamespaceCode('
// This is some additional C++ glue code.

static unsigned format_setup(void **data, char *chroma, unsigned *width, unsigned *height, unsigned *pitches, unsigned *lines)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*)(*data);

	unsigned _w = (*width);
	unsigned _h = (*height);
	unsigned _pitch = _w * 4;
	unsigned _frame = _w *_h * 4;

	(*pitches) = _pitch;
	(*lines) = _h;

	memcpy(chroma, "RV32", 4);

	self->videoWidth = _w;
	self->videoHeight = _h;

	if (self->pixels != nullptr)
		delete self->pixels;

	self->pixels = new unsigned char[_frame];
	return 1;
}

static void format_cleanup(void *data)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;
}

static void *lock(void *data, void **p_pixels)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;
	*p_pixels = self->pixels;
	return NULL; /* picture identifier, not needed here */
}

static void unlock(void *data, void *id, void *const *p_pixels)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;
}

static void display(void *data, void *id)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;
	assert(id == NULL); /* picture identifier, not needed here */
}

static void mediaCallbacks(const libvlc_event_t *event, void *data)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;

	switch (event->type)
	{
    case libvlc_MediaParsedChanged:
      self->flags[8] = true;
      break;
    case libvlc_MediaMetaChanged:
      self->flags[9] = true;
      break;
	}
}

static void playerCallbacks(const libvlc_event_t *event, void *data)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;

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
		case libvlc_MediaPlayerStopping:
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
class VideoBitmapInternal extends Bitmap
{
  /**
   * The current timestamp in the video, in milliseconds.
   * Set this to seek to a specific time in the video.
   */
  public var time(get, set):Int;

  @:noCompletion function get_time():Int
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

  @:noCompletion function set_time(value:Int):Int
  {
    if (mediaPlayer != null) LibVLCMediaPlayer.set_time(mediaPlayer, value, SHOULD_FAST_SEEK);

    return value;
  }

  /**
   * The current position in the video, from 0.0 to 1.0.
   * Set this to seek to a specific position in the video.
   */
  public var position(get, set):Float;

  @:noCompletion function get_position():Float
  {
    if (mediaPlayer != null) return LibVLCMediaPlayer.get_position(mediaPlayer);

    return 0;
  }

  @:noCompletion function set_position(value:Float):Float
  {
    if (mediaPlayer != null) LibVLCMediaPlayer.set_position(mediaPlayer, value, SHOULD_FAST_SEEK);

    return value;
  }

  /**
   * The duration of the media, in milliseconds.
   */
  public var duration(get, never):Int;

  @:noCompletion function get_duration():Int
  {
    if (mediaItem != null) {
      #if (haxe >= "4.3.0")
			return LibVLC.media_get_duration(mediaItem).toInt();
			#else
			return LibVLC.media_get_duration(mediaItem);
			#end
    }

    return 0;
  }

  /**
   * The media resource locator (MRL) of the media.
   * VLC supports a wide variety of MRLs, including local files, network streams, and more.
   */
  public var mrl(get, never):String;

  @:noCompletion function get_mrl():String
  {
		if (mediaItem != null)
			return cast(LibVLC.media_get_mrl(mediaItem), String);

		return null;
  }

  /**
   * The volume of the media's audio.
   */
  public var volume(get, set):Int;

  @:noCompletion function get_volume():Int
  {
    if (mediaPlayer != null) return LibVLCAudio.get_volume(mediaPlayer);

    return 0;
  }

  @:noCompletion function set_volume(value:Int):Int
  {
    if (mediaPlayer != null) LibVLCAudio.set_volume(mediaPlayer, value);

    return value;
  }

  /**
   * Whether the media is muted.
   */
  public var muteAudio(get, set):Bool;

  @:noCompletion function get_muteAudio():Bool
  {
    if (mediaPlayer != null) return LibVLCAudio.get_mute(mediaPlayer) > 0;

    return false;
  }

  @:noCompletion function set_muteAudio(value:Bool):Bool
  {
    if (mediaPlayer != null) LibVLCAudio.set_mute(mediaPlayer, value);

    return value;
  }

  public var delay(get, set):Int;

  @:noCompletion function get_delay():Int
  {
    if (mediaPlayer != null) {
      #if (haxe >= "4.3.0")
			return LibVLC.audio_get_delay(mediaPlayer).toInt();
			#else
			return LibVLC.audio_get_delay(mediaPlayer);
			#end
    }

    return 0;
  }

  @:noCompletion function set_delay(value:Int):Int
  {
    if (mediaPlayer != null) LibVLCAudio.set_delay(mediaPlayer, value);

    return value;
  }

  public var playbackRate(get, set):Float;

  @:noCompletion function get_playbackRate():Float
  {
    if (mediaPlayer != null) return LibVLCMediaPlayer.get_rate(mediaPlayer);

    return 0;
  }

  @:noCompletion function set_playbackRate(value:Float):Float
  {
    if (mediaPlayer != null) LibVLCMediaPlayer.set_rate(mediaPlayer, value);

    return value;
  }

  public var fps(get, never):Float;

  @:noCompletion function get_fps():Float
  {
    if (videoTrack != null) return LibVLCMediaTrackHelper.getFPS(videoTrack);

    return 0;
  }

  public var isPlaying(get, never):Bool;

  @:noCompletion function get_isPlaying():Bool
  {
    if (mediaPlayer != null) return LibVLCMediaPlayer.is_playing(mediaPlayer);

    return false;
  }

  public var isSeekable(get, never):Bool;

  @:noCompletion function get_isSeekable():Bool
  {
    if (mediaPlayer != null) return LibVLCMediaPlayer.is_seekable(mediaPlayer);

    return false;
  }

  public var canPause(get, never):Bool;

  @:noCompletion function get_canPause():Bool
  {
    if (mediaPlayer != null) return LibVLCMediaPlayer.can_pause(mediaPlayer);

    return false;
  }

  var audioTrack(get, null):LibVLC_AudioTrack;

  function get_audioTrack():LibVLC_AudioTrack
  {
    if (mediaPlayer != null)
    {
      var mediaTrack:LibVLC_MediaTrack = LibVLCMediaPlayerHelper.getSelectedAudioMediaTrack(mediaPlayer);
      return LibVLCMediaTrackHelper.getAudioTrack(mediaTrack);
    }

    return null;
  }

  var videoTrack(get, null):LibVLC_VideoTrack;

  function get_videoTrack():LibVLC_VideoTrack
  {
    if (mediaPlayer != null)
    {
      var mediaTrack:LibVLC_MediaTrack = LibVLCMediaPlayerHelper.getSelectedAudioMediaTrack(mediaPlayer);
      return LibVLCMediaTrackHelper.getVideoTrack(mediaTrack);
    }

    return null;
  }

  // Constants

  /**
   * The default timeout for parsing the media, in milliseconds. 
   */
  static final PARSE_TIMEOUT:Int = 10000;

  /**
   * If `true`, will use fast seeking when setting the time or position.
   * If `false`, will use precise seeking when setting the time or position.
   */
  static final SHOULD_FAST_SEEK:Bool = true;

  // Read-Only Properties
  public var videoWidth(default, null):Int = 0;
  public var videoHeight(default, null):Int = 0;
  public var isDisplaying(default, null):Bool = false;

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

  // LibVLC
  var instance:LibVLC_Instance;
  var audioOutput:LibVLC_AudioOutput;
  var mediaPlayer:LibVLC_MediaPlayer;
  var mediaItem:LibVLC_Media;
  var mediaEventManager:LibVLC_EventManager;
  var mediaPlayerEventManager:LibVLC_EventManager;

  // Declarations
  static final FLAG_COUNT = 10;

  var flags:Array<Bool> = [];
  var pixels:cpp.Pointer<cpp.UInt8>;
  var buffer:haxe.io.BytesData;
  var texture:openfl.display3D.textures.RectangleTexture;
  var currentTime:Float = 0;
  var skipStepLimit:Float = 0;

  var logger:LibVLCLoggingHelper;

  static final DEBUG:Bool = #if debug true #else false #end;

  public function new():Void
  {
    super(bitmapData, AUTO, true);

    for (event in 0...FLAG_COUNT)
      flags[event] = false;

    // instance = LibVLCCore.init(0, null);
    instance = LibVLCCore.LibVLCCoreHelper.initialize(DEBUG);
    logger = LibVLCLogging.LibVLCLoggingHelper.logToCallback(instance, onVLCLog);

    audioOutput = LibVLCAudio.output_list_get(instance);

    setupCallbacks();
  }

  function onVLCLog(messsage:String):Void
  {
    Sys.println(messsage); // Don't print posinfos.
  }

  function setupCallbacks():Void
  {
    onOpening = new CallbackVoid();
    onPlaying = new Callback<String>();
    onStopped = new CallbackVoid();
    onPaused = new CallbackVoid();
    onEndReached = new CallbackVoid();
    onEncounteredError = new Callback<String>();
    onForward = new CallbackVoid();
    onBackward = new CallbackVoid();
  }

  public function play(?location:String = null, loop:Bool = false, ?remote:Bool = false):Int
  {
    if (remote)
    {
      mediaItem = LibVLCMedia.new_location(location);
    }
    else
    {
      final path:String = #if windows Path.normalize(location).split("/").join("\\") #else Path.normalize(location) #end;
      if (!sys.FileSystem.exists(path))
      {
        throw "File not found: " + path;
      }
      else
      {
        trace("Media file found: " + path);
      }
      mediaItem = LibVLCMedia.new_path(path);
    }

    #if HXC_DEBUG_TRACE
    trace("setting path to: " + path);
    #end

    mediaPlayer = LibVLCMediaPlayer.new_from_media(instance, mediaItem);

    // Parsing is async, so we need to set the callbacks before we wait for the event to fire.
    setupEventManagers();

    var flag:LibVLC_MediaParseFlag = LibVLC_MediaParseFlag.media_parse_local;
    if (remote) flag = LibVLC_MediaParseFlag.media_parse_network;
    // LibVLCMedia.parse_request(instance, mediaItem, flag, PARSE_TIMEOUT);

    if (loop)
    {
      LibVLCMedia.add_option(mediaItem, #if windows "input-repeat=-1" #else "input-repeat=65535" #end);
    }
    else
    {
      LibVLCMedia.add_option(mediaItem, "input-repeat=0");
    }

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

    if (buffer == null || (buffer != null && buffer.length > 0)) buffer = [];

    isDisplaying = false;

    return LibVLCMediaPlayer.play(mediaPlayer);
  }

  function setupEventManagers():Void
  {
    // These callbacks are used to redirect the video output to the texture.
    LibVLCVideo.set_format_callbacks(mediaPlayer, untyped __cpp__('format_setup'), untyped __cpp__('format_cleanup'));
    LibVLCVideo.set_callbacks(mediaPlayer, untyped __cpp__('lock'), untyped __cpp__('unlock'), untyped __cpp__('display'), untyped __cpp__('this'));

    // These callbacks are used to track the status of the media's parsing.
    mediaEventManager = LibVLCMedia.event_manager(mediaItem);
    LibVLCEvents.attach(mediaEventManager, LibVLC_EventType.MediaMetaChanged, untyped __cpp__('mediaCallbacks'), untyped __cpp__('this'));
    LibVLCEvents.attach(mediaEventManager, LibVLC_EventType.MediaParsedChanged, untyped __cpp__('mediaCallbacks'), untyped __cpp__('this'));

    // These callbacks are used to track the status of the media player's playback.
    mediaPlayerEventManager = LibVLCMediaPlayer.event_manager(mediaPlayer);
    LibVLCEvents.attach(mediaPlayerEventManager, LibVLC_EventType.MediaPlayerOpening, untyped __cpp__('playerCallbacks'), untyped __cpp__('this'));
    LibVLCEvents.attach(mediaPlayerEventManager, LibVLC_EventType.MediaPlayerPlaying, untyped __cpp__('playerCallbacks'), untyped __cpp__('this'));
    LibVLCEvents.attach(mediaPlayerEventManager, LibVLC_EventType.MediaPlayerStopped, untyped __cpp__('playerCallbacks'), untyped __cpp__('this'));
    LibVLCEvents.attach(mediaPlayerEventManager, LibVLC_EventType.MediaPlayerPaused, untyped __cpp__('playerCallbacks'), untyped __cpp__('this'));
    LibVLCEvents.attach(mediaPlayerEventManager, LibVLC_EventType.MediaPlayerEndReached, untyped __cpp__('playerCallbacks'), untyped __cpp__('this'));
    LibVLCEvents.attach(mediaPlayerEventManager, LibVLC_EventType.MediaPlayerEncounteredError, untyped __cpp__('playerCallbacks'), untyped __cpp__('this'));
    LibVLCEvents.attach(mediaPlayerEventManager, LibVLC_EventType.MediaPlayerForward, untyped __cpp__('playerCallbacks'), untyped __cpp__('this'));
    LibVLCEvents.attach(mediaPlayerEventManager, LibVLC_EventType.MediaPlayerBackward, untyped __cpp__('playerCallbacks'), untyped __cpp__('this'));
  }

  public function stop():Void
  {
    // The media player stop function is async.
    if (mediaPlayer != null) LibVLCMediaPlayer.stop_async(mediaPlayer);
  }

  public function pause():Void
  {
    if (mediaPlayer != null) LibVLCMediaPlayer.set_pause(mediaPlayer, 1);
  }

  public function resume():Void
  {
    if (mediaPlayer != null) LibVLCMediaPlayer.set_pause(mediaPlayer, 0);
  }

  public function togglePaused():Void
  {
    if (mediaPlayer != null) LibVLCMediaPlayer.pause(mediaPlayer);
  }

  public function dispose():Void
  {
    #if HXC_DEBUG_TRACE
    trace('disposing...');
    #end

    if (isPlaying) stop();

    if (stage.hasEventListener(Event.ENTER_FRAME)) stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);

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

    if (buffer != null && buffer.length > 0) buffer = [];

    isDisplaying = false;

    #if HXC_DEBUG_TRACE
    trace('disposing done!');
    #end
  }

  public function printParsedStatus():Void
  {
    var currentParsedStatus:LibVLC_MediaParsedStatus = LibVLCMedia.get_parsed_status(mediaItem);
    trace('Parsed status: $currentParsedStatus');
  }

  function onMediaParsedChanged():Void
  {
    var currentParsedStatus:LibVLC_MediaParsedStatus = LibVLCMedia.get_parsed_status(mediaItem);

    switch (currentParsedStatus)
    {
      case media_parsed_status_done:
        trace('Media parsing done!');

        // Try to play the media.
        LibVLCMediaPlayer.play(mediaPlayer);
      case media_parsed_status_failed:
        trace('Media parsing failed!');
      case media_parsed_status_none:
        trace('Media parsing none!');
      case media_parsed_status_pending:
        trace('Media parsing pending!');
      case media_parsed_status_skipped:
        trace('Media parsing skipped!');
      case media_parsed_status_timeout:
        trace('Media parsing timeout!');
    }
  }

  function onMediaMetaChanged():Void
  {
    trace('Media meta changed!');
  }

  /**
   * Must be called every frame.
   * Handles checking video flags and rendering the video to the texture.
   */
  public function onEnterFrame(_:Event):Void
  {
    logger.update();
    checkFlags();

    // If the mediaPlayer is playing, the texture is linked to VLC,
    // the video dimensions are known, and the pixel buffer is not empty,
    // we can render the video.
    if (isPlaying && (videoWidth > 0 && videoHeight > 0) && pixels != null)
    {
      var time:Int = Lib.getTimer();
      var elements:Int = videoWidth * videoHeight * 4;
      render(time, elements);
    }
  }

  /**
   * Must be called every frame. Flags get set to true in the callbacks (in C++)
   * and get checked here to dispatch the appropriate signals.
   */
  function checkFlags():Void
  {
    if (flags[0])
    {
      flags[0] = false;
      onOpening.dispatch();
    }

    if (flags[1])
    {
      flags[1] = false;
      onPlaying.dispatch("Unknown");
    }

    if (flags[2])
    {
      flags[2] = false;
      onPaused.dispatch();
    }

    if (flags[3])
    {
      flags[3] = false;
      onStopped.dispatch();
    }

    if (flags[4])
    {
      flags[4] = false;
      onEndReached.dispatch();
    }

    if (flags[5])
    {
      flags[5] = false;
      trace('Encountered error in the media player!');
      onEncounteredError.dispatch(LibVLCErrorHelper.getErrorMessage());
    }

    if (flags[6])
    {
      flags[6] = false;
      onForward.dispatch();
    }

    if (flags[7])
    {
      flags[7] = false;
      onBackward.dispatch();
    }

    if (flags[8])
    {
      flags[8] = false;
      onMediaParsedChanged();
    }

    if (flags[9])
    {
      flags[9] = false;
      onMediaMetaChanged();
    }
  }
R
  function render(time:Float, elementsCount:Int):Void
  {
    var deltaTime:Float = time - currentTime;

    // Initialize the `texture` if necessary.
    if (texture == null) texture = Lib.current.stage.context3D.createRectangleTexture(videoWidth, videoHeight, BGRA, true);

    // Initialize the `bitmapData` if necessary.
    if (bitmapData == null && texture != null) bitmapData = BitmapData.fromTexture(texture);

    // When you set a `bitmapData`, `smoothing` goes `false` for some reason.
    if (!smoothing) smoothing = true;

    if (deltaTime > (1000 / skipStepLimit == 0 ? (fps * playbackRate) : skipStepLimit))
    {
      currentTime = time;

      #if HXC_DEBUG_TRACE
      trace('rendering...');
      #end

      cpp.NativeArray.setUnmanagedData(buffer, pixels, elementsCount);

      if (texture != null && (buffer != null && buffer.length > 0))
      {
        var bytes:haxe.io.Bytes = haxe.io.Bytes.ofData(buffer);
        if (bytes.length >= elementsCount)
        {
          texture.uploadFromByteArray(openfl.utils.ByteArray.fromBytes(bytes), 0);
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

  @:noCompletion override function set_height(value:Float):Float
  {
    if (__bitmapData != null) scaleY = value / __bitmapData.height;
    else if (videoHeight != 0) scaleY = value / videoHeight;
    else
      scaleY = 1;

    return value;
  }

  @:noCompletion override function set_width(value:Float):Float
  {
    if (__bitmapData != null) scaleX = value / __bitmapData.width;
    else if (videoWidth != 0) scaleX = value / videoWidth;
    else
      scaleX = 1;

    return value;
  }
}
