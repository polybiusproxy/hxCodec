package hxcodecpro.openfl;

import openfl.events.KeyboardEvent;
import openfl.display.Sprite;

/**
 * An OpenFL sprite which displays a video.
 */
class VideoSprite extends Sprite
{
  /**
   * The bitmap used to display the video internally.
   */
  var video:VideoBitmap;

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
}
