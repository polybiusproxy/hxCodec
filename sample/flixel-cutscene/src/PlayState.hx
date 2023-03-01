package;

import flixel.FlxG;
import flixel.text.FlxText;
import flixel.FlxState;
import hxcodec.flixel.FlxCutsceneState;

class PlayState extends FlxState
{
  public override function create()
  {
    super.create();

    var text:FlxText = new FlxText(0, 0, FlxG.width, "");
    text.setFormat(null, 16, 0xFFFFFFFF, "center");

    text.text += "hxCodec Flixel Cutscene Demo";
    text.text += "\nPress SPACE to play the cutscene";

    add(text);
  }

  public override function update(elapsed:Float)
  {
    super.update(elapsed);

    if (FlxG.keys.justPressed.SPACE)
    {
      // First argument is the path to the video file
      // Second argument is the state to transition to after the cutscene is finished
      var cutscene:FlxCutsceneState = new FlxCutsceneState('assets/stressCutscene.mp4', new PlayState());
      FlxG.switchState(cutscene);
    }

    #if mobile
    for (touch in FlxG.touches.list)
    {
      if (touch.justPressed)
      {
        var cutscene:FlxCutsceneState = new FlxCutsceneState('assets/stressCutscene.mp4', new PlayState());
        FlxG.switchState(cutscene);
      }
    }
    #end
  }
}
