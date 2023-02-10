package;

import openfl.events.KeyboardEvent;
import openfl.display.Sprite;
import hxcodec.openfl.VideoSprite;

/**
 * This is a basic example of how to use the VideoSprite class in OpenFL.
 */
class Main extends Sprite
{
  var video:VideoSprite;

  public function new()
  {
    super();

    printVersionInfo();

    video = new VideoSprite();
    video.autoResize = true;
    addChild(video);

    stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
  }

  function onKeyDown(event:KeyboardEvent):Void
  {
    trace(event);

    switch (event.keyCode)
    {
      case 81: // Q
        video.playVideo('assets/earth.webm');
      case 87: // W
        video.playVideo('assets/stressCutscene.mp4');
      case 69: // E
        // Play Big Buck Bunny from network.
        video.playVideoFromUrl('http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_1080p_h264.mov');
      case 82: // R
        video.playVideoFromUrl('https://upload.wikimedia.org/wikipedia/commons/a/a7/View_of_Planet_Earth_%284K%29.webm');
      case 84: // T
        video.playVideo('assets/earth.webm');
      case 89: // Y
        video.playVideo('assets/earth.webm');

      case 65: // A
        video.pause();
      case 83: // S
        video.resume();
      case 68: // D
        video.stop();
      case 70: // F
        video.time -= 5.0;
      case 71: // G
        video.time += 5.0;
      case 72: // H
        video.position = 0.0;
      case 74: // J
        video.playbackRate = 0.5;
      case 75: // K
        video.playbackRate = 1.5;

      case 90: // Z
        hxcodec._internal.LibVLCError.LibVLCErrorHelper.printErrorMessage();
      case 88: // X
        video.printParsedStatus();
    }
  }

  function printVersionInfo():Void
  {
    trace('Welcome to hxcodec.');

    var version:String = hxcodec._internal.LibVLCCore.get_version();
    trace('LibVLC version: ${version}');
    var compiler:String = hxcodec._internal.LibVLCCore.get_compiler();
    trace('LibVLC compiler: ${compiler}');
    var changeset:String = hxcodec._internal.LibVLCCore.get_changeset();
    trace('LibVLC changeset: ${changeset}');

    trace('LibVLC clock (us): ${hxcodec._internal.LibVLCTime.clock()}');

    trace('===========================================================');
  }
}
