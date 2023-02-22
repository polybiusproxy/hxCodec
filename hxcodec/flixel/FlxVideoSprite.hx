package hxcodec.flixel;

import hxcodec.base.Callback;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.graphics.FlxGraphic;
import flixel.util.FlxColor;
import flixel.util.FlxSignal;
import flixel.util.FlxSignal.FlxTypedSignal;
import hxcodec.base.IVideoPlayer;
import hxcodec.openfl.VideoBitmap;
import hxcodec.openfl.VideoSprite;

/**
 * An FlxSprite which displays a video.
 */
class FlxVideoSprite extends FlxSprite implements IVideoPlayer
{
  /**
   * The current position of the video, in milliseconds.
   * Set this value to seek to a specific position in the video.
   */
  public var time(get, set):Int;

  function get_time():Int
  {
    return video.time;
  }

  function set_time(value:Int):Int
  {
    return video.time = value;
  }

  /**
   * The current position of the video, as a percentage between 0.0 and 1.0.
   * Set this value to seek to a specific position in the video.
   */
  public var position(get, set):Float;

  function get_position():Float
  {
    return video.position;
  }

  function set_position(value:Float):Float
  {
    return video.position = value;
  }

  /**
   * The duration of the video, in seconds.
   */
  public var duration(get, null):Float;

  function get_duration():Float
  {
    return video.duration;
  }

  /**
   * Whether or not the video is playing.
   */
  public var isPlaying(get, null):Bool;

  function get_isPlaying():Bool
  {
    return video.isPlaying;
  }

  /**
   * Whether or not the audio is currently muted.
   */
  public var muteAudio(get, set):Bool;

  function get_muteAudio():Bool
  {
    return video.muteAudio;
  }

  function set_muteAudio(value:Bool):Bool
  {
    return video.muteAudio = value;
  }

  /**
   * Current playback speed.
   */
  public var playbackRate(get, set):Float;

  function get_playbackRate():Float
  {
    return video.playbackRate;
  }

  function set_playbackRate(value:Float):Float
  {
    return video.playbackRate = value;
  }

  /**
   * Current volume.
   */
  public var volume(get, set):Int;

  function get_volume():Int
  {
    return video.volume;
  }

  function set_volume(value:Int):Int
  {
    return video.volume = value;
  }

  /**
   * Set this value to enforce a specific canvas width for the video.
   */
  public var canvasWidth(default, set):Null<Int> = null;

  function set_canvasWidth(value:Int):Int
  {
    this.canvasWidth = value;
    if (canvasWidth != null && canvasHeight != null)
    {
      setGraphicSize(canvasWidth, canvasHeight);
      updateHitbox();
    }
    return this.canvasWidth;
  }

  /**
   * Set this value to enforce a specific canvas height for the video.
   */
  public var canvasHeight(default, set):Null<Int> = null;

  function set_canvasHeight(value:Int):Int
  {
    this.canvasHeight = value;
    if (canvasWidth != null && canvasHeight != null)
    {
      setGraphicSize(canvasWidth, canvasHeight);
      updateHitbox();
    }
    return this.canvasHeight;
  }

  /**
   * Whether to automatically resize the video to fit the stage.
   * If false, the `width` and `height` of the video must be set manually.
   */
  public var autoResize:Bool = false;

  /**
   * Callback for when the media player is opening.
   * - This callback has no parameters.
   */
  public var onOpening(get, null):CallbackVoid;

  function get_onOpening():CallbackVoid
  {
    return video.onOpening;
  }

  /**
   * Callback for when the media player begins playing.
   * @param path The path of the current media.
   */
  public var onPlaying(get, null):Callback<String>;

  function get_onPlaying():Callback<String>
  {
    return video.onPlaying;
  }

  /**
   * Callback for when the media player is paused.
   * - This callback has no parameters.
   */
  public var onPaused(get, null):CallbackVoid;

  function get_onPaused():CallbackVoid
  {
    return video.onPaused;
  }

  /**
   * Callback for when the media player is stopped.
   * - This callback has no parameters.
   */
  public var onStopped(get, null):CallbackVoid;

  function get_onStopped():CallbackVoid
  {
    return video.onStopped;
  }

  /**
   * Callback for when the media player is buffering.
   * - This callback has no parameters.
   */
  public var onEndReached(get, null):CallbackVoid;

  function get_onEndReached():CallbackVoid
  {
    return video.onEndReached;
  }

  /**
   * Callback for when the media player encounters an error.
   * @param error The error message.
   */
  public var onEncounteredError(get, null):Callback<String>;

  function get_onEncounteredError():Callback<String>
  {
    return video.onEncounteredError;
  }

  /**
   * Callback for when the media player is skipped forward.
   */
  public var onForward(get, null):CallbackVoid;

  function get_onForward():CallbackVoid
  {
    return video.onForward;
  }

  /**
   * Callback for when the media player is skipped backward.
   */
  public var onBackward(get, null):CallbackVoid;

  function get_onBackward():CallbackVoid
  {
    return video.onBackward;
  }

  public var onGraphicLoaded(default, null):CallbackVoid;

  /**
   * The bitmap used to display the video internally.
   */
  var video:VideoBitmap;

  var videoInitialized:Bool;

  public function new(X:Float = 0, Y:Float = 0)
  {
    super(X, Y);

    // Create a placeholder graphic.
    makeGraphic(1, 1, FlxColor.TRANSPARENT);

    onGraphicLoaded = new CallbackVoid();

    video = new VideoBitmap();
    video.visible = false;

    onEndReached.add(() -> {
      videoInitialized = false;
    });
  }

  /**
   * Play a video from a local file path.
   * @param path The path to the video file.
   * @param loop Whether or not the video should loop.
   */
  public function playVideo(path:String, loop:Bool = false):Void
  {
    if (isPlaying)
    {
      stop();
      // Wait for the video to stop asynchonously before playing the next one.
      onStopped.addOnce(() -> {
        playVideo(path, loop);
      });
      return;
    }

    // in case if you want to use another dir then the application one.
    // android can already do this, it can't use application's storage.
    if (sys.FileSystem.exists(Sys.getCwd() + path))
    {
      video.play(Sys.getCwd() + path, loop, false);
    }
    else
    {
      video.play(path, loop, false);
    }
  }

  /**
   * Play a video from a URL.
   * @param url The URL to the video file.
   * @param loop Whether or not the video should loop.
   */
  public function playVideoFromUrl(url:String, loop:Bool = false):Void
  {
    if (isPlaying)
    {
      stop();
    }

    video.play(url, loop, true);
  }

  /**
   * Stop the video.
   * This will reset the video to the beginning and stop playback.
   */
  public function stop():Void
  {
    video.stop();
  }

  /**
   * Pause the video.
   */
  public function pause():Void
  {
    video.pause();
  }

  /**
   * Resume the video, if it is paused.
   */
  public function resume():Void
  {
    video.resume();
  }

  /**
   * If the video is playing, it will be paused.
   * If the video is paused, it will be resumed.
   */
  public function togglePaused():Void
  {
    video.togglePaused();
  }

  public override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    video.onEnterFrame(null);

    if (!videoInitialized && video.isPlaying && video.isDisplaying && video.bitmapData != null)
    {
      var graphic:FlxGraphic = FlxG.bitmap.add(video.bitmapData, false, video.mrl);
      if (graphic.imageFrame.frame == null)
      {
        return;
      }

      loadGraphic(graphic);

      if (autoResize)
      {
        // If the user has set to auto-resize...
        if (canvasWidth == null && canvasHeight == null)
        {
          // If the user has not set the width or height,
          // set the width and height to the stage size.
          canvasWidth = FlxG.width;
          canvasHeight = FlxG.height;
        }
        else
        {
          // If the user has set the width or height,
          // set the other dimension to maintain the aspect ratio.

          var aspectRatio = FlxG.width / FlxG.height;

          if (canvasWidth == null)
          {
            canvasWidth = Std.int(canvasHeight * aspectRatio);
          }
          else if (canvasHeight == null)
          {
            canvasHeight = Std.int(canvasWidth / aspectRatio);
          }
        }
      }

      if (canvasWidth != null && canvasHeight != null)
      {
        setGraphicSize(canvasWidth, canvasHeight);
        updateHitbox();
      }

      onGraphicLoaded.dispatch();

      videoInitialized = true;
    }
  }
}
