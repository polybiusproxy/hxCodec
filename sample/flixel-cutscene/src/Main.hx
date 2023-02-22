package;

import openfl.display.Sprite;
import flixel.FlxGame;
import flixel.FlxState;

class Main extends Sprite
{
  static final GAME_WIDTH:Int = 1280;
  static final GAME_HEIGHT:Int = 720;
  static final FRAMERATE:Int = 240;

  static final INITIAL_STATE:Class<FlxState> = PlayState;

  static final SKIP_SPLASH:Bool = false;
  static final START_FULLSCREEN:Bool = false;

  public function new():Void {
    super();

    addChild(new FlxGame(GAME_WIDTH, GAME_HEIGHT, INITIAL_STATE, FRAMERATE, FRAMERATE, SKIP_SPLASH, START_FULLSCREEN));
  }
}
