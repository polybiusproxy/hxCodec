package hxcodecpro.flixel;

#if flixel
import flixel.FlxSubState;

/**
 * A standard cutscene playback substate, with basic playback controls.
 */
class FlxCutsceneSubState extends FlxSubState {
    public function new() {
        super();
    }

    public override function create():Void {
        super.create();
    }
}
#else
/**
 * Stub class used to prevent compilation errors when flixel is not installed.
 */
class FlxCutsceneSubState {
    public function new() {
        throw "flixel is not installed";
    }
}
#end