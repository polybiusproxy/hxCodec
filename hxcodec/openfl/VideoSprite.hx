package hxcodec.openfl;

import hxcodec.base.IVideoPlayer;
import hxcodec.base.Callback;
import hxcodec.base.Callback.CallbackVoid;
import openfl.display.Sprite;
import openfl.events.Event;
import openfl.events.KeyboardEvent;
import openfl.Lib;

/**
 * An OpenFL sprite which displays a video.
 */
class VideoSprite extends Sprite implements IVideoPlayer
{
  /**
   * The current position of the video, in milliseconds.
   */
  public var time(get, set):Int;

  function get_time():Int
  {
    return video.time;
  }

  function set_time(value:Int):Int
  {
    video.time = value;
    return value;
  }

  /**
   * The current position of the video, as a percentage between 0.0 and 1.0.
   */
  public var position(get, set):Float;

  function get_position():Float
  {
    return video.position;
  }

  function set_position(value:Float):Float
  {
    video.position = value;
    return value;
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
    video.muteAudio = value;
    return value;
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
    video.playbackRate = value;
    return value;
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
    video.volume = value;
    return value;
  }

  /**
   * Whether to automatically resize the video to fit the stage.
   * If false, the `width` and `height` of the video must be set manually.
   */
  public var autoResize:Bool = false;

  /**
   * Whether to maintain the aspect ratio when automatically resizing the video.
   * If false, the video will be stretched to fit the stage.
   */
  public var maintainAspectRatio:Bool = true;

  /**
   * The bitmap used to display the video internally.
   */
  var video:VideoBitmap;

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

  /**
   * The constructor.
   */
  public function new()
  {
    super();

    video = new VideoBitmap();
    addChild(video);
  }

  /**
   * Play a video from a local file path.
   * @param path The path to the video file.
   * @param loop Whether or not the video should loop.
   */
  public function playVideo(path:String, loop:Bool = false):Void
  {
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

    stage.addEventListener(Event.ENTER_FRAME, update);
  }

  /**
   * Play a video from a URL.
   * @param url The URL to the video file.
   * @param loop Whether or not the video should loop.
   */
  public function playVideoFromUrl(url:String, loop:Bool = false):Void
  {
    video.play(url, loop, true);
  }

  /**
   * Pause the video.
   */
  public function pause():Void
  {
    video.pause();
  }

  /**
   * Resume the video.
   */
  public function resume():Void
  {
    video.resume();
  }

  /**
   * Toggle the video between playing and paused.
   */
  public function togglePaused():Void
  {
    video.togglePaused();
  }

  /**
   * Stop the video.
   */
  public function stop():Void
  {
    video.stop();
  }

  /**
   * Seek to a specific position in the video.
   * @param position The position to seek to, as a percentage between 0.0 and 1.0.
   */
  /**
   * DEBUG function to print the parse status of the video.
   */
  public function printParsedStatus():Void
  {
    video.printParsedStatus();
  }

  /**
   * Update the video sprite.
   * @param e Update event.
   */
  function update(e:Event):Void
  {
    if (autoResize)
    {
      if (!maintainAspectRatio || (video.videoWidth == 0 || video.videoHeight == 0))
      {
        width = Lib.current.stage.stageWidth;
        height = Lib.current.stage.stageHeight;
      }
      else
      {
        var aspectRatio = video.videoWidth / video.videoHeight;

        if (Lib.current.stage.stageWidth / Lib.current.stage.stageHeight > aspectRatio)
        {
          // stage is wider than video
          width = Lib.current.stage.stageHeight * aspectRatio;
          height = Lib.current.stage.stageHeight;
        }
        else
        {
          // stage is taller than video
          width = Lib.current.stage.stageWidth;
          height = Lib.current.stage.stageWidth * (1 / aspectRatio);
        }
      }
    }
  }
}
