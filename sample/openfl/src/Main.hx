package;

import openfl.events.KeyboardEvent;
import openfl.events.Event;
import openfl.display.Sprite;
import hxcodecpro.openfl.VideoSprite;

class Main extends Sprite
{
  var video:VideoSprite;

  public function new()
  {
    super();

    printVersionInfo();

    video = new VideoSprite();
    addChild(video);

    stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
  }

  function onKeyDown(event:KeyboardEvent):Void
  {
    trace(event);

    switch(event.keyCode) {
      case 81: // Q
        video.playVideo("assets/earth.webm");
      case 87: // W
        video.playVideo("assets/stressCutscene.mp4");
      case 69: // E
        // Play Big Buck Bunny from network.
        video.playVideoFromUrl("http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_1080p_h264.mov");
      case 82: // R
        video.playVideo("assets/earth.webm");
      case 84: // T
        video.playVideo("assets/earth.webm");
      case 89: // Y
        video.playVideo("assets/earth.webm");

      case 90: // Z
        var err:String = hxcodecpro._internal.LibVLCError.errmsg();
        trace(err);
    }
  }

  public function printVersionInfo():Void
  {
    trace('Welcome to hxCodecPro.');

    var version:String = hxcodecpro._internal.LibVLCCore.get_version();
    trace('LibVLC version: ${version}');
    var compiler:String = hxcodecpro._internal.LibVLCCore.get_compiler();
    trace('LibVLC compiler: ${compiler}');
    var changeset:String = hxcodecpro._internal.LibVLCCore.get_changeset();
    trace('LibVLC changeset: ${changeset}');

    trace('LibVLC clock (us): ${hxcodecpro._internal.LibVLCTime.clock()}');

    // trace('LibVLC last error: ${hxcodecpro._internal.LibVLCError.getErrorMessage()}');

    trace('===========================================================');
  }
}
