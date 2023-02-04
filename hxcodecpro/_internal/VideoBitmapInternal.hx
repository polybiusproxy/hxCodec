package hxcodecpro._internal;

import haxe.io.Path;
import openfl.display.Bitmap;
import openfl.display.BitmapData;
import openfl.events.Event;
import openfl.Lib;
import hxcodecpro._internal.LibVLCMediaPlayer.LibVLCMediaPlayerHelper;
import hxcodecpro._internal.LibVLCMediaTrack.LibVLCMediaTrackHelper;

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

	if (self->pixels != NULL || self->pixels != nullptr)
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
	return NULL;
}

static void unlock(void *data, void *id, void *const *p_pixels)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;
}

static void display(void *data, void *picture)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;
	self->isDisplaying = true;
}

static void mediaCallbacks(const libvlc_event_t *event, void *data)
{
	VideoBitmapInternal_obj *self = (VideoBitmapInternal_obj*) data;

	switch (event->type)
	{
    case libvlc_MediaParsedChanged:
      self->flags[8] = true;
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
   * The current timestamp in the video.
   * Set this to seek to a specific time in the video.
   */
  public var time(get, set):Int;

  @:noCompletion function get_time():Int
  {
    if (mediaPlayer != null) return LibVLCMediaPlayer.get_time(mediaPlayer);

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
   * The length of the video, in milliseconds.
   */
  public var length(get, never):Int;

  @:noCompletion function get_length():Int
  {
    if (mediaPlayer != null) return LibVLCMediaPlayer.get_length(mediaPlayer);

    return 0;
  }

  /**
   * The duration of the media, in milliseconds.
   */
  public var duration(get, never):Int;

  @:noCompletion function get_duration():Int
  {
    if (mediaItem != null) return LibVLCMedia.get_duration(mediaItem);

    return 0;
  }

  /**
   * The media resource locator (MRL) of the media.
   * VLC supports a wide variety of MRLs, including local files, network streams, and more.
   */
  public var mrl(get, never):String;

  @:noCompletion function get_mrl():String
  {
    if (mediaItem != null) return LibVLCMedia.get_mrl(mediaItem);

    return '';
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

  public var delay(get, set):Int;

  @:noCompletion function get_delay():Int
  {
    if (mediaPlayer != null) return LibVLCAudio.get_delay(mediaPlayer);

    return 0;
  }

  @:noCompletion function set_delay(value:Int):Int
  {
    if (mediaPlayer != null) LibVLCAudio.set_delay(mediaPlayer, value);

    return value;
  }

  public var rate(get, set):Float;

  @:noCompletion function get_rate():Float
  {
    if (mediaPlayer != null) return LibVLCMediaPlayer.get_rate(mediaPlayer);

    return 0;
  }

  @:noCompletion function set_rate(value:Float):Float
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
  public var onOpening:Void->Void;
  public var onPlaying:Void->Void;
  public var onPaused:Void->Void;
  public var onStopped:Void->Void;
  public var onEndReached:Void->Void;
  public var onEncounteredError:Void->Void;
  public var onForward:Void->Void;
  public var onBackward:Void->Void;

  // LibVLC
  var instance:LibVLC_Instance;
  var audioOutput:LibVLC_AudioOutput;
  var mediaPlayer:LibVLC_MediaPlayer;
  var mediaItem:LibVLC_Media;
  var mediaEventManager:LibVLC_EventManager;
  var mediaPlayerEventManager:LibVLC_EventManager;

  // Declarations
  var flags:Array<Bool> = [];
  var pixels:cpp.Pointer<cpp.UInt8>;
  var buffer:haxe.io.BytesData;
  var texture:openfl.display3D.textures.RectangleTexture;
  var currentTime:Float = 0;
  var skipStepLimit:Float = 0;

  public function new():Void
  {
    super(bitmapData, AUTO, true);

    for (event in 0...7)
      flags[event] = false;

    instance = LibVLCCore.init(0, null);
    audioOutput = LibVLCAudio.output_list_get(instance);
  }

  public function play(?location:String = null, loop:Bool = false, ?remote:Bool = false):Void
  {
    final path:String = #if windows Path.normalize(location).split("/").join("\\") #else Path.normalize(location) #end;

    #if HXC_DEBUG_TRACE
    trace("setting path to: " + path);
    #end

    mediaItem = LibVLCMedia.new_path(path);
    mediaPlayer = LibVLCMediaPlayer.new_from_media(instance, mediaItem);

    // TODO: This is async, so we need to wait for the event to fire before we can set the callbacks.
    var flag:LibVLC_MediaParseFlag = LibVLC_MediaParseFlag.media_parse_local;
    if (remote) flag = LibVLC_MediaParseFlag.media_parse_network;
    LibVLCMedia.parse_request(instance, mediaItem, flag, PARSE_TIMEOUT);

    if (loop)
    {
      LibVLCMedia.add_option(mediaItem, #if android "input-repeat=65535" #else "input-repeat=-1" #end);
    }
    else
    {
      LibVLCMedia.add_option(mediaItem, "input-repeat=0");
    }

    // LibVLCMedia.release(mediaItem);

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

    // These callbacks are used to redirect the video output to the texture.
    LibVLCVideo.set_format_callbacks(mediaPlayer, untyped __cpp__('format_setup'), untyped __cpp__('format_cleanup'));
    LibVLCVideo.set_callbacks(mediaPlayer, untyped __cpp__('lock'), untyped __cpp__('unlock'), untyped __cpp__('display'), untyped __cpp__('this'));

    mediaEventManager = LibVLCMedia.event_manager(mediaItem);

    LibVLCEvents.attach(mediaEventManager, LibVLC_EventType.MediaParsedChanged, untyped __cpp__('mediaCallbacks'), untyped __cpp__('this'));

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
    // if (mediaPlayer != null) LibVLCMediaPlayer.stop(mediaPlayer);
  }

  public function pause():Void
  {
    // if (mediaPlayer != null) LibVLCMediaPlayer.set_pause(mediaPlayer, 1);
  }

  public function resume():Void
  {
    // if (mediaPlayer != null) LibVLCMediaPlayer.set_pause(mediaPlayer, 0);
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

  function onEnterFrame(e:Event):Void
  {
    checkFlags();

    // If the mediaPlayer is playing, the texture is linked to VLC,
    // the video dimensions are known, and the pixel buffer is not empty,
    // we can render the video.
    if ((isPlaying && isDisplaying) && (videoWidth > 0 && videoHeight > 0) && pixels != null)
    {
      var time:Int = Lib.getTimer();
      var elements:Int = videoWidth * videoHeight * 4;
      render(time - currentTime, elements);
    }
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

  function checkFlags():Void
  {
    if (flags[0])
    {
      flags[0] = false;
      if (onOpening != null) onOpening();
    }

    if (flags[1])
    {
      flags[1] = false;
      if (onPlaying != null) onPlaying();
    }

    if (flags[2])
    {
      flags[2] = false;
      if (onPaused != null) onPaused();
    }

    if (flags[3])
    {
      flags[3] = false;
      if (onStopped != null) onStopped();
    }

    if (flags[4])
    {
      flags[4] = false;
      if (onEndReached != null) onEndReached();
    }

    if (flags[5])
    {
      flags[5] = false;
      if (onEncounteredError != null) onEncounteredError();
    }

    if (flags[6])
    {
      flags[6] = false;
      if (onForward != null) onForward();
    }

    if (flags[7])
    {
      flags[7] = false;
      if (onBackward != null) onBackward();
    }

    if (flags[8])
    {
      flags[8] = false;
      onMediaParsedChanged();
    }
  }

  function render(deltaTime:Float, elementsCount:Int):Void
  {
    // Initialize the `texture` if necessary.
    if (texture == null) texture = Lib.current.stage.context3D.createRectangleTexture(videoWidth, videoHeight, BGRA, true);

    // Initialize the `bitmapData` if necessary.
    if (bitmapData == null && texture != null) bitmapData = BitmapData.fromTexture(texture);

    // When you set a `bitmapData`, `smoothing` goes `false` for some reason.
    if (!smoothing) smoothing = true;

    if (deltaTime > (1000 / skipStepLimit == 0 ? (fps * rate) : skipStepLimit))
    {
      currentTime = deltaTime;

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
