package hxcodec.flixel;

import flixel.FlxG;
import flixel.FlxState;
import flixel.input.keyboard.FlxKey;

/**
 * A simple utility class providing an easy way to play an in-game cutscene.
 * 
 * Example: `FlxG.switchState('assets/video.mp4', new PlayState());`
 */
class FlxCutsceneState extends FlxVideoState
{
  /**
   * Users can press any of these keys to skip the cutscene.
   */
  public var skipKeys:Array<FlxKey> = [FlxKey.SPACE, FlxKey.ENTER, FlxKey.ESCAPE];

  var nextState:FlxState;

  public function new(path:String, nextState:FlxState)
  {
    super(path, false);

    this.nextState = nextState;
  }

  public override function create():Void
  {
    super.create();

    // Move to next state if video finishes.
    this.onEndReached.add(onVideoEnded);

    // Disable default skip behavior.
    #if (FLX_KEYBOARD || FLX_TOUCH)
    this.video.canSkip = false;
    #end
  }

  var skipTimer:Float = 0;

  public override function update(elapsed:Float):Void
  {
    super.update(elapsed);

    // Move to next state if user presses a skip key for 1 second.
    if (FlxG.keys.anyPressed(skipKeys))
    {
        skipTimer += elapsed;
        if (skipTimer > 1.0) {
            onVideoEnded();
        }
    } else {
      skipTimer = 0;
    }
  }

  function onVideoEnded():Void
  {
    this.stop();

    // This null check means that if the next state is null,
    // the game will stay on the cutscene state.
    if (nextState != null) {
      FlxG.switchState(nextState);
    } else {
      trace('[ERROR] FlxCutsceneState has nowhere to go!');
    }
  }
}
