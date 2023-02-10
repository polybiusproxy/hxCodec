package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import hxcodec.flixel.FlxVideoSprite;

class PlayState extends FlxState
{
  var video:FlxVideoSprite;

  public override function create()
  {
    super.create();

    printVersionInfo();

    video = new FlxVideoSprite();
    video.autoResize = true;

    add(video);

    var text:FlxText = new FlxText(0, 0, FlxG.width, "");
    text.setFormat(null, 16, 0xFFFFFFFF, "center");

    text.text += "hxCodec Flixel Sample";
    text.text += "\nPress Q/W/E/R/T/Y to play video";
    text.text += "\n";

    add(text);
  }

  public override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (FlxG.keys.justPressed.Q)
    {
      video.playVideo('assets/earth.webm');
    }
    else if (FlxG.keys.justPressed.W)
    {
      video.playVideo('assets/stressCutscene.mp4');
    }
    else if (FlxG.keys.justPressed.E)
    {
      video.playVideoFromUrl('http://download.blender.org/peach/bigbuckbunny_movies/BigBuckBunny_1080p_h264.mov');
    }
    else if (FlxG.keys.justPressed.R)
    {
      video.playVideoFromUrl('https://upload.wikimedia.org/wikipedia/commons/a/a7/View_of_Planet_Earth_%284K%29.webm');
    }
    else if (FlxG.keys.justPressed.T)
    {
      video.playVideo('assets/earth.mp4');
    }
    else if (FlxG.keys.justPressed.Y)
    {
      video.playVideo('assets/earth.webm');
    }

    if (FlxG.keys.justPressed.Z)
    {
      hxcodec._internal.LibVLCError.LibVLCErrorHelper.printErrorMessage();
    }

    if (FlxG.keys.justPressed.A) {
        video.pause();
    }

    if (FlxG.keys.justPressed.S) {
        video.resume();
    }

    if (FlxG.keys.justPressed.D) {
        video.stop();
    }

    if (FlxG.keys.justPressed.F) {
        video.time -= 5000;
    }

    if (FlxG.keys.justPressed.G) {
        video.time += 5000;
    }

    if (FlxG.keys.justPressed.H) {
        video.position = 0.0;
    }

    if (FlxG.keys.justPressed.J) {
        video.playbackRate = 0.5;
    }

    if (FlxG.keys.justPressed.K) {
        video.playbackRate = 1.5;
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
